SET local check_function_bodies = off;

DROP POLICY "cotizaciones_update_cliente" ON "public"."cotizaciones";

DROP POLICY "mensajes_insert" ON "public"."mensajes";

DROP FUNCTION "public"."tecnicos_cercanos"(double precision, double precision, integer, integer, integer);

CREATE TABLE "public"."favoritos" (
  "cliente_id" uuid                     NOT NULL,
  "tecnico_id" uuid                     NOT NULL,
  "creado_en"  timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT "pk_favoritos" PRIMARY KEY (cliente_id, tecnico_id)
);

ALTER TABLE "public"."favoritos"
  ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."cotizaciones"
  ADD COLUMN "precio_base" numeric(10,2) NOT NULL;

ALTER TABLE "public"."mensajes"
  ADD COLUMN "tipo" text NOT NULL DEFAULT 'texto'::text;

ALTER TABLE "public"."mensajes"
  ADD COLUMN "datos" jsonb;

ALTER TABLE "public"."cotizaciones"
  ALTER COLUMN "mano_obra" DROP NOT NULL;

ALTER TABLE "public"."cotizaciones"
  ADD COLUMN "tarifa_enviada" boolean GENERATED ALWAYS AS ((mano_obra IS NOT NULL)) STORED;

ALTER TABLE "public"."cotizaciones"
  ADD COLUMN "fecha_servicio" timestamp WITH time zone;

CREATE OR REPLACE FUNCTION public.aceptar_cotizacion (
  p_cotizacion_id uuid
)
  RETURNS void
  LANGUAGE plpgsql
  SECURITY DEFINER
  SET search_path TO 'public'
  AS $function$
declare
  v_uid        uuid := auth.uid();
  v_cot        cotizaciones%rowtype;
  v_estado_sol text;
begin
  if v_uid is null then raise exception 'Sesion requerida'; end if;

  select * into v_cot from cotizaciones where id = p_cotizacion_id for update;
  if not found then raise exception 'La propuesta no existe.'; end if;

  select estado into v_estado_sol from solicitudes_servicio
   where id = v_cot.solicitud_id and cliente_id = v_uid for update;
  if not found then raise exception 'No tienes permiso sobre esta solicitud.'; end if;

  if v_estado_sol <> 'cotizada' then raise exception 'Esta solicitud ya no acepta propuestas.'; end if;
  if v_cot.estado <> 'pendiente' then raise exception 'Esta propuesta ya no esta disponible.'; end if;
  if not v_cot.tarifa_enviada or v_cot.fecha_servicio is null then
    raise exception 'El tecnico aun no envio el ticket del servicio.';
  end if;

  update cotizaciones set estado = 'aceptada' where id = p_cotizacion_id;
end $function$;

CREATE OR REPLACE FUNCTION public.admin_eliminar_usuario (
  p_id uuid
)
  RETURNS void
  LANGUAGE plpgsql
  SECURITY DEFINER
  SET search_path TO 'public'
  AS $function$
begin
  perform public.exigir_admin();
  perform public.exigir_no_admin(p_id);
  if exists (select 1 from solicitudes_servicio where cliente_id = p_id)
     or exists (select 1 from cotizaciones where tecnico_id = p_id)
     or exists (select 1 from conversaciones where tecnico_id = p_id)
     or exists (select 1 from mensajes where autor_id = p_id)
     or exists (select 1 from resenas where autor_id = p_id or destinatario_id = p_id)
     or exists (select 1 from historial_puntos where tecnico_id = p_id) then
    raise exception 'Este usuario tiene solicitudes, ofertas o reseñas. Suspéndelo en lugar de eliminarlo.';
  end if;
  delete from auth.users where id = p_id;
exception
  when foreign_key_violation then
    raise exception 'Este usuario tiene datos relacionados. Suspéndelo en lugar de eliminarlo.';
end $function$;

CREATE OR REPLACE FUNCTION public.cancelar_tarifa (
  p_cotizacion_id uuid
)
  RETURNS void
  LANGUAGE plpgsql
  SECURITY DEFINER
  SET search_path TO 'public'
  AS $function$
declare
  v_uid        uuid := auth.uid();
  v_cot        cotizaciones%rowtype;
  v_estado_sol text;
begin
  if v_uid is null then raise exception 'Sesion requerida'; end if;

  select * into v_cot from cotizaciones where id = p_cotizacion_id for update;
  if not found then raise exception 'La propuesta no existe.'; end if;

  select estado into v_estado_sol from solicitudes_servicio
   where id = v_cot.solicitud_id and cliente_id = v_uid for update;
  if not found then raise exception 'No tienes permiso sobre esta solicitud.'; end if;

  if v_cot.estado <> 'aceptada' or v_estado_sol <> 'aceptada' then
    raise exception 'No hay una tarifa aceptada que cancelar.';
  end if;

  update cotizaciones
     set estado = 'pendiente', mano_obra = null, materiales = 0, fecha_servicio = null,
         tarifa_enviada = false
   where id = p_cotizacion_id;
  update solicitudes_servicio set estado = 'cotizada' where id = v_cot.solicitud_id;

  insert into mensajes (conversacion_id, autor_id, contenido, tipo, datos)
  select c.id, v_uid, 'El cliente cancelo la confirmacion del ticket. Pueden seguir hablando en el chat.',
         'sistema', jsonb_build_object('accion', 'tarifa_cancelada', 'cotizacion_id', p_cotizacion_id)
  from conversaciones c
  where c.solicitud_id = v_cot.solicitud_id and c.tecnico_id = v_cot.tecnico_id;

  insert into notificaciones (usuario_id, tipo, referencia_id, contenido)
  values (v_cot.tecnico_id, 'tarifa_cancelada', p_cotizacion_id, 'El cliente cancelo la confirmacion del ticket');
end $function$;

REVOKE ALL ON FUNCTION "public"."cancelar_tarifa"(uuid) FROM PUBLIC, "anon";

CREATE OR REPLACE FUNCTION public.editar_solicitud (
  p_id          uuid,
  p_descripcion text,
  p_oficio_id   integer,
  p_direccion   text
)
  RETURNS void
  LANGUAGE plpgsql
  SECURITY DEFINER
  SET search_path TO 'public'
  AS $function$
declare
  v_estado text;
begin
  select estado into v_estado
  from solicitudes_servicio
  where id = p_id and cliente_id = auth.uid()
  for update;

  if not found then
    raise exception 'Solicitud no encontrada';
  end if;

  if v_estado not in ('abierta','cotizada')
     or exists (select 1 from cotizaciones where solicitud_id = p_id and estado = 'aceptada') then
    raise exception 'La solicitud ya tiene un trabajo aceptado y no se puede editar';
  end if;

  if length(trim(coalesce(p_descripcion,''))) < 10 then
    raise exception 'Describe el problema con al menos 10 caracteres';
  end if;

  update solicitudes_servicio
  set descripcion = trim(p_descripcion),
      oficio_id = p_oficio_id,
      direccion_referencia = nullif(trim(coalesce(p_direccion,'')), '')
  where id = p_id;
end $function$;

REVOKE ALL ON FUNCTION "public"."editar_solicitud"(uuid, text, integer, text) FROM PUBLIC, "anon";

CREATE OR REPLACE FUNCTION public.eliminar_solicitud (
  p_id uuid
)
  RETURNS void
  LANGUAGE plpgsql
  SECURITY DEFINER
  SET search_path TO 'public'
  AS $function$
declare
  v_estado text;
begin
  select estado into v_estado
  from solicitudes_servicio
  where id = p_id and cliente_id = auth.uid()
  for update;

  if not found then
    raise exception 'Solicitud no encontrada';
  end if;

  if v_estado not in ('abierta','cotizada')
     or exists (select 1 from cotizaciones where solicitud_id = p_id and estado = 'aceptada') then
    raise exception 'No puedes eliminar una solicitud con un trabajo aceptado o finalizado';
  end if;

  delete from solicitudes_servicio where id = p_id;
end $function$;

REVOKE ALL ON FUNCTION "public"."eliminar_solicitud"(uuid) FROM PUBLIC, "anon";

CREATE OR REPLACE FUNCTION public.enviar_tarifa (
  p_cotizacion_id  uuid,
  p_mano_obra      numeric,
  p_materiales     numeric,
  p_fecha_servicio timestamp with time zone
)
  RETURNS void
  LANGUAGE plpgsql
  SECURITY DEFINER
  SET search_path TO 'public'
  AS $function$
declare
  v_uid     uuid := auth.uid();
  v_cot     cotizaciones%rowtype;
  v_estado  text;
  v_conv    uuid;
  v_cliente uuid;
  v_mat     numeric := coalesce(p_materiales, 0);
  v_fecha   text;
begin
  if v_uid is null then raise exception 'Sesion requerida'; end if;

  select * into v_cot from cotizaciones
   where id = p_cotizacion_id and tecnico_id = v_uid for update;
  if not found then raise exception 'No tienes permiso sobre esta propuesta.'; end if;
  if v_cot.estado <> 'pendiente' then raise exception 'Esta propuesta ya no esta disponible.'; end if;

  select estado, cliente_id into v_estado, v_cliente from solicitudes_servicio
   where id = v_cot.solicitud_id for update;
  if v_estado <> 'cotizada' then raise exception 'Esta solicitud ya no acepta tarifas.'; end if;

  select id into v_conv from conversaciones
   where solicitud_id = v_cot.solicitud_id and tecnico_id = v_uid;
  if not found then raise exception 'El cliente aun no inicio el chat contigo.'; end if;

  if p_mano_obra is null or p_mano_obra <= 0 then
    raise exception 'La mano de obra debe ser mayor a 0.';
  end if;
  if v_mat < 0 then raise exception 'Los materiales no pueden ser negativos.'; end if;
  if p_fecha_servicio is null or p_fecha_servicio <= now() then
    raise exception 'Indica una fecha futura para el servicio.';
  end if;

  update cotizaciones
     set mano_obra = p_mano_obra, materiales = v_mat, fecha_servicio = p_fecha_servicio,
         tarifa_enviada = true
   where id = p_cotizacion_id;

  v_fecha := to_char(p_fecha_servicio at time zone 'America/Guayaquil', 'DD/MM/YYYY "a las" HH24:MI');

  insert into mensajes (conversacion_id, autor_id, contenido, tipo, datos)
  values (
    v_conv, v_uid,
    format('El tecnico envio el ticket del servicio: mano de obra $%s + materiales $%s = total $%s, para el %s. Revisalo y confirmalo si estas de acuerdo.',
           to_char(p_mano_obra, 'FM999990.00'), to_char(v_mat, 'FM999990.00'),
           to_char(p_mano_obra + v_mat, 'FM999990.00'), v_fecha),
    'sistema',
    jsonb_build_object('accion', 'tarifa_enviada', 'cotizacion_id', p_cotizacion_id,
                       'solicitud_id', v_cot.solicitud_id,
                       'precio_base', v_cot.precio_base, 'mano_obra', p_mano_obra,
                       'materiales', v_mat, 'total', p_mano_obra + v_mat,
                       'fecha_servicio', p_fecha_servicio)
  );
  insert into notificaciones (usuario_id, tipo, referencia_id, contenido)
  values (v_cliente, 'tarifa', p_cotizacion_id, 'El tecnico te envio el ticket del servicio para confirmar');
end $function$;

REVOKE ALL ON FUNCTION "public"."enviar_tarifa"(uuid, numeric, numeric, timestamp WITH time zone) FROM PUBLIC, "anon";

CREATE OR REPLACE FUNCTION public.fn_cerrar_propuestas()
  RETURNS TRIGGER
  LANGUAGE plpgsql
  SECURITY DEFINER
  SET search_path TO 'public'
  AS $function$
begin
  update cotizaciones set estado = 'rechazada'
  where solicitud_id = new.id and estado = 'pendiente';
  return new;
end $function$;

CREATE OR REPLACE FUNCTION public.fn_cliente_no_edita_ticket()
  RETURNS TRIGGER
  LANGUAGE plpgsql
  SET search_path TO 'public'
  AS $function$
begin
  if auth.uid() is not null and current_user = 'authenticated'
     and auth.uid() <> old.tecnico_id and (
       new.mano_obra is distinct from old.mano_obra
    or new.materiales is distinct from old.materiales
    or new.fecha_servicio is distinct from old.fecha_servicio) then
    raise exception 'Solo el técnico puede cambiar el ticket.';
  end if;
  return new;
end $function$;

CREATE OR REPLACE FUNCTION public.fn_cotizacion_aceptada()
  RETURNS TRIGGER
  LANGUAGE plpgsql
  SECURITY DEFINER
  SET search_path TO 'public'
  AS $function$
begin
  update solicitudes_servicio set estado = 'aceptada' where id = new.solicitud_id;
  insert into notificaciones (usuario_id, tipo, referencia_id, contenido)
  values (new.tecnico_id, 'cotizacion_aceptada', new.id, 'El cliente confirmo tu ticket del servicio');
  insert into mensajes (conversacion_id, autor_id, contenido, tipo, datos)
  select c.id, s.cliente_id,
         format('El cliente confirmo el servicio para el %s por un total de $%s. Ya pueden coordinar los detalles.',
                to_char(new.fecha_servicio at time zone 'America/Guayaquil', 'DD/MM/YYYY "a las" HH24:MI'),
                to_char(new.total, 'FM999990.00')),
         'sistema',
         jsonb_build_object('accion', 'tarifa_aceptada', 'cotizacion_id', new.id,
                            'solicitud_id', new.solicitud_id, 'total', new.total,
                            'fecha_servicio', new.fecha_servicio)
  from conversaciones c join solicitudes_servicio s on s.id = c.solicitud_id
  where c.solicitud_id = new.solicitud_id and c.tecnico_id = new.tecnico_id;
  return new;
end $function$;

CREATE OR REPLACE FUNCTION public.fn_notificar_mensaje()
  RETURNS TRIGGER
  LANGUAGE plpgsql
  SECURITY DEFINER
  SET search_path TO 'public'
  AS $function$
declare
  v_tecnico uuid;
  v_cliente uuid;
  v_destino uuid;
begin
  if new.tipo is distinct from 'texto' then
    return new;
  end if;

  select c.tecnico_id, s.cliente_id into v_tecnico, v_cliente
  from conversaciones c
  join solicitudes_servicio s on s.id = c.solicitud_id
  where c.id = new.conversacion_id;

  v_destino := case when new.autor_id = v_tecnico then v_cliente else v_tecnico end;
  if v_destino is null or v_destino = new.autor_id then
    return new;
  end if;

  insert into notificaciones (usuario_id, tipo, referencia_id, contenido)
  values (v_destino, 'mensaje', new.conversacion_id, left(new.contenido, 80));
  return new;
end $function$;

CREATE OR REPLACE FUNCTION public.fn_nueva_cotizacion()
  RETURNS TRIGGER
  LANGUAGE plpgsql
  SECURITY DEFINER
  SET search_path TO 'public'
  AS $function$
begin
  update solicitudes_servicio set estado = 'cotizada' where id = new.solicitud_id and estado = 'abierta';
  insert into notificaciones (usuario_id, tipo, referencia_id, contenido)
  select cliente_id, 'cotizacion', new.id, 'Un técnico respondió tu solicitud'
  from solicitudes_servicio where id = new.solicitud_id;
  return new;
end $function$;

CREATE OR REPLACE FUNCTION public.fn_precio_base_fijo()
  RETURNS TRIGGER
  LANGUAGE plpgsql
  AS $function$
begin
  if new.precio_base is distinct from old.precio_base then
    raise exception 'El precio base no se puede modificar';
  end if;
  return new;
end $function$;

CREATE OR REPLACE FUNCTION public.fn_transicion_estado()
  RETURNS TRIGGER
  LANGUAGE plpgsql
  SECURITY DEFINER
  SET search_path TO 'public'
  AS $function$
begin
  if old.estado = new.estado then return new; end if;
  if not (
    (old.estado = 'abierta' and new.estado in ('cotizada', 'cancelada')) or
    (old.estado = 'cotizada' and new.estado in ('aceptada', 'cancelada')) or
    (old.estado = 'aceptada' and new.estado in ('cotizada', 'por_confirmar', 'cancelada')) or
    (old.estado = 'por_confirmar' and new.estado in ('completada', 'cancelada'))
  ) then
    raise exception 'Transicion de estado invalida: % a %', old.estado, new.estado;
  end if;
  if new.estado = 'aceptada'
     and not exists (select 1 from public.cotizaciones where solicitud_id = new.id and estado = 'aceptada') then
    raise exception 'No se puede aceptar una solicitud sin una cotizacion aceptada';
  end if;
  if old.estado = 'aceptada' and new.estado = 'cotizada'
     and exists (select 1 from public.cotizaciones where solicitud_id = new.id and estado = 'aceptada') then
    raise exception 'Para volver atras cancela la tarifa aceptada';
  end if;
  return new;
end $function$;

CREATE OR REPLACE FUNCTION public.fn_validar_cotizacion()
  RETURNS TRIGGER
  LANGUAGE plpgsql
  SECURITY DEFINER
  SET search_path TO 'public'
  AS $function$
begin
  if (select estado from solicitudes_servicio where id = new.solicitud_id) not in ('abierta', 'cotizada') then
    raise exception 'La solicitud ya no recibe propuestas';
  end if;
  -- Compatibilidad: si el cliente HTTP manda mano_obra, se toma como precio base.
  new.precio_base := coalesce(
    new.precio_base,
    new.mano_obra,
    (select tarifa_base from perfiles_tecnicos where usuario_id = new.tecnico_id)
  );
  if new.precio_base is null or new.precio_base <= 0 then
    raise exception 'Indica tu precio base';
  end if;
  if new.precio_base > 25 then
    raise exception 'El precio base maximo es $25.';
  end if;
  new.mano_obra := null;
  new.materiales := 0;
  new.estado := 'pendiente';
  return new;
end $function$;

CREATE OR REPLACE FUNCTION public.fn_validar_foto_perfil()
  RETURNS TRIGGER
  LANGUAGE plpgsql
  SET search_path TO 'public'
  AS $function$
begin
  if new.foto_perfil_ruta is distinct from old.foto_perfil_ruta
     and new.foto_perfil_ruta is not null
     and current_user = 'authenticated'
     and public.mi_rol() is distinct from 'admin'
     and new.foto_perfil_ruta not like new.id::text || '/%'
     and new.foto_perfil_ruta not like 'perfiles/' || new.id::text || '/%' then
    raise exception 'La foto de perfil debe estar en tu propia carpeta.';
  end if;
  return new;
end $function$;

CREATE OR REPLACE FUNCTION public.iniciar_chat (
  p_solicitud_id uuid,
  p_tecnico_id   uuid
)
  RETURNS uuid
  LANGUAGE plpgsql
  SECURITY DEFINER
  SET search_path TO 'public'
  AS $function$
declare
  v_uid    uuid := auth.uid();
  v_estado text;
  v_conv   uuid;
begin
  if v_uid is null then raise exception 'Sesion requerida'; end if;

  select estado into v_estado from solicitudes_servicio
   where id = p_solicitud_id and cliente_id = v_uid;
  if not found then raise exception 'No tienes permiso sobre esta solicitud.'; end if;

  select id into v_conv from conversaciones
   where solicitud_id = p_solicitud_id and tecnico_id = p_tecnico_id;
  if found then return v_conv; end if;

  if v_estado <> 'cotizada' then
    raise exception 'Esta solicitud ya no admite nuevos chats.';
  end if;
  if not exists (select 1 from cotizaciones
                  where solicitud_id = p_solicitud_id and tecnico_id = p_tecnico_id
                    and estado = 'pendiente') then
    raise exception 'Ese tecnico no tiene una propuesta activa en tu solicitud.';
  end if;

  insert into conversaciones (solicitud_id, tecnico_id)
  values (p_solicitud_id, p_tecnico_id)
  on conflict (solicitud_id, tecnico_id) do update set solicitud_id = excluded.solicitud_id
  returning id into v_conv;

  insert into notificaciones (usuario_id, tipo, referencia_id, contenido)
  values (p_tecnico_id, 'chat', v_conv, 'Un cliente quiere hablar contigo sobre su solicitud');
  return v_conv;
end $function$;

REVOKE ALL ON FUNCTION "public"."iniciar_chat"(uuid, uuid) FROM PUBLIC, "anon";

CREATE OR REPLACE FUNCTION public.iniciar_conversacion (
  p_solicitud uuid,
  p_tecnico   uuid
)
  RETURNS uuid
  LANGUAGE plpgsql
  SECURITY DEFINER
  SET search_path TO 'public'
  AS $function$
declare
  v_uid uuid := (select auth.uid());
  v_cliente uuid;
  v_estado text;
  v_id uuid;
begin
  select cliente_id, estado into v_cliente, v_estado
    from solicitudes_servicio where id = p_solicitud;
  if v_cliente is null then
    raise exception 'La solicitud no existe.' using errcode = 'P0001';
  end if;
  if v_uid is distinct from v_cliente and v_uid is distinct from p_tecnico then
    raise exception 'No tienes permiso para esta conversación.' using errcode = 'P0001';
  end if;

  select id into v_id from conversaciones
   where solicitud_id = p_solicitud and tecnico_id = p_tecnico;
  if v_id is not null then return v_id; end if;

  if v_uid is distinct from v_cliente then
    raise exception 'Solo el cliente puede iniciar la conversación.' using errcode = 'P0001';
  end if;
  if v_estado not in ('abierta', 'cotizada') then
    raise exception 'Esta solicitud ya no recibe contactos.' using errcode = 'P0001';
  end if;
  if not exists (
    select 1 from perfiles_tecnicos p
      join tecnico_oficios t on t.tecnico_id = p.usuario_id
      join solicitudes_servicio s on s.oficio_id = t.oficio_id
     where p.usuario_id = p_tecnico and p.verificado and s.id = p_solicitud
  ) then
    raise exception 'Este técnico no está verificado o no atiende ese oficio.' using errcode = 'P0001';
  end if;

  insert into conversaciones (solicitud_id, tecnico_id)
  values (p_solicitud, p_tecnico) returning id into v_id;

  insert into notificaciones (usuario_id, tipo, referencia_id, contenido)
  values (p_tecnico, 'chat', v_id, 'Un cliente quiere hablar contigo sobre su solicitud');

  return v_id;
end $function$;

REVOKE ALL ON FUNCTION "public"."iniciar_conversacion"(uuid, uuid) FROM PUBLIC, "anon";

CREATE OR REPLACE FUNCTION public.propuestas_solicitud (
  p_solicitud_id uuid
)
  RETURNS TABLE (
    cotizacion_id   uuid,
    tecnico_id      uuid,
    nombres         text,
    apellidos       text,
    calificacion    numeric,
    total_resenas   integer,
    nivel           text,
    precio_base     numeric,
    solucion        text,
    estado          text,
    tarifa_enviada  boolean,
    mano_obra       numeric,
    materiales      numeric,
    total           numeric,
    conversacion_id uuid,
    creado_en       timestamp with time zone,
    fecha_servicio  timestamp with time zone
  )
  LANGUAGE sql
  STABLE
  SECURITY DEFINER
  SET search_path TO 'public'
  AS $function$
  select c.id, c.tecnico_id, u.nombres, u.apellidos, p.calificacion_promedio, p.total_resenas,
         n.nombre, c.precio_base, c.detalle, c.estado, c.tarifa_enviada, c.mano_obra,
         c.materiales, c.total, v.id, c.creado_en, c.fecha_servicio
  from cotizaciones c
  join usuarios u on u.id = c.tecnico_id
  join perfiles_tecnicos p on p.usuario_id = c.tecnico_id
  join niveles_gamificacion n on n.id = p.nivel_id
  left join conversaciones v on v.solicitud_id = c.solicitud_id and v.tecnico_id = c.tecnico_id
  where c.solicitud_id = p_solicitud_id
    and es_cliente_solicitud(p_solicitud_id)
  order by (c.estado = 'aceptada') desc, p.calificacion_promedio desc, c.creado_en
$function$;

REVOKE ALL ON FUNCTION "public"."propuestas_solicitud"(uuid) FROM PUBLIC, "anon";

CREATE OR REPLACE FUNCTION public.tecnicos_cercanos (
  p_lat       double precision,
  p_lng       double precision,
  p_oficio_id integer          DEFAULT NULL::integer,
  p_radio_m   integer          DEFAULT 10000,
  p_limite    integer          DEFAULT 20
)
  RETURNS TABLE (
    tecnico_id       uuid,
    nombres          text,
    apellidos        text,
    foto_perfil_ruta text,
    oficios          text[],
    calificacion     numeric,
    total_resenas    integer,
    metros           integer,
    lat              double precision,
    lng              double precision,
    tarifa_base      numeric,
    nivel            text
  )
  LANGUAGE sql
  STABLE
  SECURITY DEFINER
  SET search_path TO 'public'
  AS $function$
  with centro as (select st_setsrid(st_makepoint(p_lng, p_lat), 4326)::geography as g)
  select p.usuario_id, u.nombres, u.apellidos, u.foto_perfil_ruta,
         array(select o.nombre from tecnico_oficios t
               join oficios o on o.id = t.oficio_id
               where t.tecnico_id = p.usuario_id order by o.nombre),
         p.calificacion_promedio, p.total_resenas,
         round(st_distance(p.ubicacion_actual, c.g))::int,
         st_y(st_snaptogrid(p.ubicacion_actual::geometry, 0.005)),
         st_x(st_snaptogrid(p.ubicacion_actual::geometry, 0.005)),
         p.tarifa_base, n.nombre
  from perfiles_tecnicos p
  join usuarios u on u.id = p.usuario_id
  join niveles_gamificacion n on n.id = p.nivel_id
  cross join centro c
  where p.verificado
    and p.ubicacion_actual is not null
    and st_dwithin(p.ubicacion_actual, c.g, p_radio_m)
    and (p_oficio_id is null or exists (
          select 1 from tecnico_oficios t
          where t.tecnico_id = p.usuario_id and t.oficio_id = p_oficio_id))
  order by n.prioridad desc, p.calificacion_promedio desc, 8
  limit p_limite;
$function$;

REVOKE ALL ON FUNCTION "public"."tecnicos_cercanos"(double precision, double precision, integer, integer, integer) FROM PUBLIC, "anon";

ALTER TABLE "public"."cotizaciones"
  ADD CONSTRAINT "ck_cotizaciones_aceptada_con_tarifa" CHECK (((estado <> 'aceptada'::text) OR (mano_obra IS NOT NULL)));

ALTER TABLE "public"."cotizaciones"
  ADD CONSTRAINT "ck_cotizaciones_fecha_con_tarifa" CHECK (((fecha_servicio IS NULL) OR (mano_obra IS NOT NULL)));

ALTER TABLE "public"."cotizaciones"
  ADD CONSTRAINT "ck_cotizaciones_precio_base_max" CHECK ((precio_base <= (25)::numeric));

ALTER TABLE "public"."cotizaciones"
  ADD CONSTRAINT "ck_cotizaciones_precio_base" CHECK ((precio_base >= (0)::numeric));

ALTER TABLE "public"."favoritos"
  ADD CONSTRAINT "fk_favoritos_cliente" FOREIGN KEY (cliente_id) REFERENCES public.usuarios(id) ON DELETE CASCADE;

ALTER TABLE "public"."favoritos"
  ADD CONSTRAINT "fk_favoritos_tecnico" FOREIGN KEY (tecnico_id) REFERENCES public.perfiles_tecnicos(usuario_id) ON DELETE CASCADE;

ALTER TABLE "public"."mensajes"
  ADD CONSTRAINT "ck_mensajes_tipo" CHECK ((tipo = ANY (ARRAY['texto'::text, 'sistema'::text])));

CREATE INDEX idx_favoritos_tecnico ON public.favoritos USING btree (tecnico_id);

CREATE TRIGGER trg_cotizacion_precio_base
  BEFORE UPDATE OF precio_base ON public.cotizaciones
  FOR EACH ROW
  EXECUTE FUNCTION public.fn_precio_base_fijo();

CREATE TRIGGER trg_cotizacion_ticket_cliente
  BEFORE UPDATE OF mano_obra, materiales, fecha_servicio ON public.cotizaciones
  FOR EACH ROW
  EXECUTE FUNCTION public.fn_cliente_no_edita_ticket();

CREATE TRIGGER trg_mensaje_notificar
  AFTER INSERT ON public.mensajes
  FOR EACH ROW
  EXECUTE FUNCTION public.fn_notificar_mensaje();

CREATE TRIGGER trg_solicitud_cierra_propuestas
  AFTER UPDATE OF estado ON public.solicitudes_servicio
  FOR EACH ROW
  WHEN (((new.estado = ANY (ARRAY['por_confirmar'::text, 'completada'::text, 'cancelada'::text])) AND (old.estado IS DISTINCT FROM new.estado)))
  EXECUTE FUNCTION public.fn_cerrar_propuestas();

CREATE TRIGGER trg_usuario_foto
  BEFORE UPDATE OF foto_perfil_ruta ON public.usuarios
  FOR EACH ROW
  EXECUTE FUNCTION public.fn_validar_foto_perfil();

CREATE POLICY "cotizaciones_update_cliente" ON "public"."cotizaciones"
  FOR UPDATE
  TO "authenticated"
  USING ((public.es_cliente_solicitud(solicitud_id) AND (estado = 'pendiente'::text)))
  WITH
    CHECK
    ((public.es_cliente_solicitud(solicitud_id) AND (((estado = 'aceptada'::text) AND (tarifa_enviada IS TRUE)) OR (estado = 'rechazada'::text) OR ((estado = 'pendiente'::text) AND
    (tarifa_enviada IS FALSE)))));

CREATE POLICY "cotizaciones_update_tecnico" ON "public"."cotizaciones"
  FOR UPDATE
  TO "authenticated"
  USING (((tecnico_id = ( SELECT auth.uid() AS uid)) AND (public.mi_rol() = 'tecnico'::text) AND public.es_tecnico_verificado() AND (estado = 'pendiente'::text)))
  WITH CHECK (((tecnico_id = ( SELECT auth.uid() AS uid)) AND (estado = 'pendiente'::text)));

CREATE POLICY "favoritos_delete" ON "public"."favoritos"
  FOR DELETE
  TO "authenticated"
  USING ((cliente_id = ( SELECT auth.uid() AS uid)));

CREATE POLICY "favoritos_insert" ON "public"."favoritos"
  FOR INSERT
  TO "authenticated"
  WITH CHECK (((cliente_id = ( SELECT auth.uid() AS uid)) AND (public.mi_rol() = 'cliente'::text)));

CREATE POLICY "favoritos_lectura" ON "public"."favoritos"
  FOR SELECT
  TO "authenticated"
  USING ((cliente_id = ( SELECT auth.uid() AS uid)));

CREATE POLICY "mensajes_insert" ON "public"."mensajes"
  FOR INSERT
  TO "authenticated"
  WITH CHECK (((autor_id = ( SELECT auth.uid() AS uid)) AND (tipo = 'texto'::text) AND (datos IS NULL) AND (EXISTS ( SELECT 1
   FROM public.conversaciones c
  WHERE (c.id = mensajes.conversacion_id)))));

GRANT EXECUTE ON FUNCTION "public"."cancelar_tarifa"(uuid) TO "authenticated";

REVOKE ALL ON FUNCTION "public"."cancelar_tarifa"(uuid) FROM "postgres";

GRANT EXECUTE ON FUNCTION "public"."cancelar_tarifa"(uuid) TO "postgres";

GRANT EXECUTE ON FUNCTION "public"."cancelar_tarifa"(uuid) TO "service_role";

GRANT EXECUTE ON FUNCTION "public"."editar_solicitud"(uuid, text, integer, text) TO "authenticated";

REVOKE ALL ON FUNCTION "public"."editar_solicitud"(uuid, text, integer, text) FROM "postgres";

GRANT EXECUTE ON FUNCTION "public"."editar_solicitud"(uuid, text, integer, text) TO "postgres";

GRANT EXECUTE ON FUNCTION "public"."editar_solicitud"(uuid, text, integer, text) TO "service_role";

GRANT EXECUTE ON FUNCTION "public"."eliminar_solicitud"(uuid) TO "authenticated";

REVOKE ALL ON FUNCTION "public"."eliminar_solicitud"(uuid) FROM "postgres";

GRANT EXECUTE ON FUNCTION "public"."eliminar_solicitud"(uuid) TO "postgres";

GRANT EXECUTE ON FUNCTION "public"."eliminar_solicitud"(uuid) TO "service_role";

GRANT EXECUTE ON FUNCTION "public"."enviar_tarifa"(uuid, numeric, numeric, timestamp WITH time zone) TO "authenticated";

REVOKE ALL ON FUNCTION "public"."enviar_tarifa"(uuid, numeric, numeric, timestamp WITH time zone) FROM "postgres";

GRANT EXECUTE ON FUNCTION "public"."enviar_tarifa"(uuid, numeric, numeric, timestamp WITH time zone) TO "postgres";

GRANT EXECUTE ON FUNCTION "public"."enviar_tarifa"(uuid, numeric, numeric, timestamp WITH time zone) TO "service_role";

GRANT EXECUTE ON FUNCTION "public"."fn_cerrar_propuestas"() TO PUBLIC, "anon", "authenticated";

REVOKE ALL ON FUNCTION "public"."fn_cerrar_propuestas"() FROM "postgres";

GRANT EXECUTE ON FUNCTION "public"."fn_cerrar_propuestas"() TO "postgres";

GRANT EXECUTE ON FUNCTION "public"."fn_cerrar_propuestas"() TO "service_role";

GRANT EXECUTE ON FUNCTION "public"."fn_cliente_no_edita_ticket"() TO PUBLIC, "anon", "authenticated";

REVOKE ALL ON FUNCTION "public"."fn_cliente_no_edita_ticket"() FROM "postgres";

GRANT EXECUTE ON FUNCTION "public"."fn_cliente_no_edita_ticket"() TO "postgres";

GRANT EXECUTE ON FUNCTION "public"."fn_cliente_no_edita_ticket"() TO "service_role";

GRANT EXECUTE ON FUNCTION "public"."fn_notificar_mensaje"() TO PUBLIC, "anon", "authenticated";

REVOKE ALL ON FUNCTION "public"."fn_notificar_mensaje"() FROM "postgres";

GRANT EXECUTE ON FUNCTION "public"."fn_notificar_mensaje"() TO "postgres";

GRANT EXECUTE ON FUNCTION "public"."fn_notificar_mensaje"() TO "service_role";

GRANT EXECUTE ON FUNCTION "public"."fn_precio_base_fijo"() TO PUBLIC, "anon", "authenticated";

REVOKE ALL ON FUNCTION "public"."fn_precio_base_fijo"() FROM "postgres";

GRANT EXECUTE ON FUNCTION "public"."fn_precio_base_fijo"() TO "postgres";

GRANT EXECUTE ON FUNCTION "public"."fn_precio_base_fijo"() TO "service_role";

GRANT EXECUTE ON FUNCTION "public"."fn_validar_foto_perfil"() TO PUBLIC, "anon", "authenticated";

REVOKE ALL ON FUNCTION "public"."fn_validar_foto_perfil"() FROM "postgres";

GRANT EXECUTE ON FUNCTION "public"."fn_validar_foto_perfil"() TO "postgres";

GRANT EXECUTE ON FUNCTION "public"."fn_validar_foto_perfil"() TO "service_role";

GRANT EXECUTE ON FUNCTION "public"."iniciar_chat"(uuid, uuid) TO "authenticated";

REVOKE ALL ON FUNCTION "public"."iniciar_chat"(uuid, uuid) FROM "postgres";

GRANT EXECUTE ON FUNCTION "public"."iniciar_chat"(uuid, uuid) TO "postgres";

GRANT EXECUTE ON FUNCTION "public"."iniciar_chat"(uuid, uuid) TO "service_role";

GRANT EXECUTE ON FUNCTION "public"."iniciar_conversacion"(uuid, uuid) TO "authenticated";

REVOKE ALL ON FUNCTION "public"."iniciar_conversacion"(uuid, uuid) FROM "postgres";

GRANT EXECUTE ON FUNCTION "public"."iniciar_conversacion"(uuid, uuid) TO "postgres";

GRANT EXECUTE ON FUNCTION "public"."iniciar_conversacion"(uuid, uuid) TO "service_role";

GRANT EXECUTE ON FUNCTION "public"."propuestas_solicitud"(uuid) TO "authenticated";

REVOKE ALL ON FUNCTION "public"."propuestas_solicitud"(uuid) FROM "postgres";

GRANT EXECUTE ON FUNCTION "public"."propuestas_solicitud"(uuid) TO "postgres";

GRANT EXECUTE ON FUNCTION "public"."propuestas_solicitud"(uuid) TO "service_role";

GRANT EXECUTE ON FUNCTION "public"."tecnicos_cercanos"(double precision, double precision, integer, integer, integer) TO "authenticated";

REVOKE ALL ON FUNCTION "public"."tecnicos_cercanos"(double precision, double precision, integer, integer, integer) FROM "postgres";

GRANT EXECUTE ON FUNCTION "public"."tecnicos_cercanos"(double precision, double precision, integer, integer, integer) TO "postgres";

GRANT EXECUTE ON FUNCTION "public"."tecnicos_cercanos"(double precision, double precision, integer, integer, integer) TO "service_role";

REVOKE ALL ("fecha_servicio") ON TABLE "public"."cotizaciones" FROM "authenticated";

GRANT UPDATE ("fecha_servicio") ON TABLE "public"."cotizaciones" TO "authenticated";

REVOKE ALL ("mano_obra") ON TABLE "public"."cotizaciones" FROM "authenticated";

GRANT UPDATE ("mano_obra") ON TABLE "public"."cotizaciones" TO "authenticated";

REVOKE ALL ("materiales") ON TABLE "public"."cotizaciones" FROM "authenticated";

GRANT UPDATE ("materiales") ON TABLE "public"."cotizaciones" TO "authenticated";

REVOKE ALL ("tarifa_enviada") ON TABLE "public"."cotizaciones" FROM "authenticated";

GRANT UPDATE ("tarifa_enviada") ON TABLE "public"."cotizaciones" TO "authenticated";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."favoritos" TO "anon", "authenticated";

REVOKE ALL ON TABLE "public"."favoritos" FROM "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."favoritos" TO "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."favoritos" TO "service_role";

