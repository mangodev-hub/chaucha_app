SET local check_function_bodies = off;

CREATE EXTENSION "postgis" SCHEMA "public";

CREATE TABLE "public"."auditoria" (
  "id"               bigint                   GENERATED ALWAYS AS IDENTITY NOT NULL,
  "tabla"            text                     NOT NULL,
  "registro_id"      text                     NOT NULL,
  "accion"           text                     NOT NULL,
  "datos_anteriores" jsonb,
  "datos_nuevos"     jsonb,
  "cambiado_por"     uuid,
  "cambiado_en"      timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT "auditoria_accion_check" CHECK ((accion = ANY (ARRAY['UPDATE'::text, 'DELETE'::text]))),
  CONSTRAINT "auditoria_pkey" PRIMARY KEY (id)
);

ALTER TABLE "public"."auditoria"
  ENABLE ROW LEVEL SECURITY;

REVOKE ALL ON TABLE "public"."auditoria" FROM "anon";

CREATE TABLE "public"."comisiones" (
  "id"                  uuid                     NOT NULL DEFAULT gen_random_uuid(),
  "cotizacion_id"       uuid                     NOT NULL,
  "base_calculo"        numeric(10,2)            NOT NULL,
  "porcentaje_aplicado" numeric(5,2)             NOT NULL,
  "valor"               numeric(10,2)            NOT NULL,
  "estado"              text                     NOT NULL DEFAULT 'pendiente'::text,
  "creado_en"           timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT "ck_comisiones_estado" CHECK ((estado = ANY (ARRAY['pendiente'::text, 'pagada'::text]))),
  CONSTRAINT "pk_comisiones" PRIMARY KEY (id),
  CONSTRAINT "uq_comisiones_cotizacion" UNIQUE (cotizacion_id)
);

ALTER TABLE "public"."comisiones"
  ENABLE ROW LEVEL SECURITY;

REVOKE ALL ON TABLE "public"."comisiones" FROM "anon";

CREATE TABLE "public"."conversaciones" (
  "id"           uuid                     NOT NULL DEFAULT gen_random_uuid(),
  "solicitud_id" uuid                     NOT NULL,
  "tecnico_id"   uuid                     NOT NULL,
  "creado_en"    timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT "pk_conversaciones" PRIMARY KEY (id),
  CONSTRAINT "uq_conversaciones_solicitud_tecnico" UNIQUE (solicitud_id, tecnico_id)
);

ALTER TABLE "public"."conversaciones"
  ENABLE ROW LEVEL SECURITY;

REVOKE ALL ON TABLE "public"."conversaciones" FROM "anon";

CREATE TABLE "public"."cotizaciones" (
  "id"           uuid                     NOT NULL DEFAULT gen_random_uuid(),
  "solicitud_id" uuid                     NOT NULL,
  "tecnico_id"   uuid                     NOT NULL,
  "mano_obra"    numeric(10,2)            NOT NULL,
  "detalle"      text,
  "materiales"   numeric(10,2)            NOT NULL DEFAULT 0,
  "total"        numeric(10,2)            GENERATED ALWAYS AS ((mano_obra + materiales)) STORED,
  "estado"       text                     NOT NULL DEFAULT 'pendiente'::text,
  "creado_en"    timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT "ck_cotizaciones_estado" CHECK ((estado = ANY (ARRAY['pendiente'::text, 'aceptada'::text, 'rechazada'::text]))),
  CONSTRAINT "ck_cotizaciones_mano_obra" CHECK ((mano_obra >= (0)::numeric)),
  CONSTRAINT "ck_cotizaciones_materiales" CHECK ((materiales >= (0)::numeric)),
  CONSTRAINT "pk_cotizaciones" PRIMARY KEY (id),
  CONSTRAINT "uq_cotizaciones_solicitud_tecnico" UNIQUE (solicitud_id, tecnico_id)
);

ALTER TABLE "public"."cotizaciones"
  ENABLE ROW LEVEL SECURITY;

REVOKE ALL ON TABLE "public"."cotizaciones" FROM "anon";

CREATE TABLE "public"."documentos_historial" (
  "id"              uuid                     NOT NULL DEFAULT gen_random_uuid(),
  "documento_id"    uuid                     NOT NULL,
  "tecnico_id"      uuid                     NOT NULL,
  "tipo"            text                     NOT NULL,
  "estado_anterior" text,
  "estado_nuevo"    text                     NOT NULL,
  "ruta_anterior"   text,
  "ruta_nueva"      text                     NOT NULL,
  "cambiado_por"    uuid,
  "cambiado_en"     timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT "documentos_historial_pkey" PRIMARY KEY (id)
);

ALTER TABLE "public"."documentos_historial"
  ENABLE ROW LEVEL SECURITY;

REVOKE ALL ON TABLE "public"."documentos_historial" FROM "anon";

CREATE TABLE "public"."documentos_tecnico" (
  "id"           uuid                     NOT NULL DEFAULT gen_random_uuid(),
  "tecnico_id"   uuid                     NOT NULL,
  "tipo"         text                     NOT NULL,
  "ruta_archivo" text                     NOT NULL,
  "estado"       text                     NOT NULL DEFAULT 'pendiente'::text,
  "revisado_por" uuid,
  "revisado_en"  timestamp with time zone,
  CONSTRAINT "ck_documentos_estado" CHECK ((estado = ANY (ARRAY['pendiente'::text, 'aprobada'::text, 'rechazada'::text]))),
  CONSTRAINT "ck_documentos_tipo" CHECK ((tipo = ANY (ARRAY['cedula_frontal'::text, 'cedula_posterior'::text, 'selfie'::text]))),
  CONSTRAINT "pk_documentos_tecnico" PRIMARY KEY (id),
  CONSTRAINT "uq_documentos_tecnico_tipo" UNIQUE (tecnico_id, tipo)
);

ALTER TABLE "public"."documentos_tecnico"
  ENABLE ROW LEVEL SECURITY;

REVOKE ALL ON TABLE "public"."documentos_tecnico" FROM "anon";

CREATE TABLE "public"."eventos" (
  "id"           uuid                     NOT NULL DEFAULT gen_random_uuid(),
  "tipo"         text                     NOT NULL,
  "payload"      jsonb                    NOT NULL DEFAULT '{}'::jsonb,
  "creado_en"    timestamp with time zone NOT NULL DEFAULT now(),
  "publicado_en" timestamp with time zone,
  CONSTRAINT "pk_eventos" PRIMARY KEY (id)
);

ALTER TABLE "public"."eventos"
  ENABLE ROW LEVEL SECURITY;

REVOKE ALL ON TABLE "public"."eventos" FROM "anon";

CREATE TABLE "public"."historial_puntos" (
  "id"           uuid                     NOT NULL DEFAULT gen_random_uuid(),
  "tecnico_id"   uuid                     NOT NULL,
  "solicitud_id" uuid,
  "puntos"       integer                  NOT NULL,
  "motivo"       text                     NOT NULL,
  "creado_en"    timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT "ck_historial_puntos" CHECK ((puntos <> 0)),
  CONSTRAINT "pk_historial_puntos" PRIMARY KEY (id)
);

ALTER TABLE "public"."historial_puntos"
  ENABLE ROW LEVEL SECURITY;

REVOKE ALL ON TABLE "public"."historial_puntos" FROM "anon";

CREATE TABLE "public"."identidades" (
  "usuario_id" uuid                     NOT NULL,
  "cedula"     text                     NOT NULL,
  "creado_en"  timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT "pk_identidades" PRIMARY KEY (usuario_id),
  CONSTRAINT "uq_identidades_cedula" UNIQUE (cedula)
);

ALTER TABLE "public"."identidades"
  ENABLE ROW LEVEL SECURITY;

REVOKE ALL ON TABLE "public"."identidades" FROM "anon";

CREATE TABLE "public"."mensajes" (
  "id"              uuid                     NOT NULL DEFAULT gen_random_uuid(),
  "conversacion_id" uuid                     NOT NULL,
  "autor_id"        uuid                     NOT NULL,
  "contenido"       text                     NOT NULL,
  "enviado_en"      timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT "ck_mensajes_contenido" CHECK ((length(TRIM(BOTH FROM contenido)) > 0)),
  CONSTRAINT "pk_mensajes" PRIMARY KEY (id)
);

ALTER TABLE "public"."mensajes"
  ENABLE ROW LEVEL SECURITY;

REVOKE ALL ON TABLE "public"."mensajes" FROM "anon";

CREATE TABLE "public"."niveles_gamificacion" (
  "id"                  integer      GENERATED ALWAYS AS IDENTITY NOT NULL,
  "nombre"              text         NOT NULL,
  "puntos_minimos"      integer      NOT NULL,
  "comision_porcentaje" numeric(5,2) NOT NULL,
  "prioridad"           integer      NOT NULL,
  CONSTRAINT "ck_niveles_comision" CHECK (((comision_porcentaje >= (0)::numeric) AND (comision_porcentaje <= (100)::numeric))),
  CONSTRAINT "pk_niveles_gamificacion" PRIMARY KEY (id),
  CONSTRAINT "uq_niveles_puntos_minimos" UNIQUE (puntos_minimos)
);

ALTER TABLE "public"."niveles_gamificacion"
  ENABLE ROW LEVEL SECURITY;

REVOKE ALL ON TABLE "public"."niveles_gamificacion" FROM "anon";

CREATE TABLE "public"."notificaciones" (
  "id"            uuid                     NOT NULL DEFAULT gen_random_uuid(),
  "usuario_id"    uuid                     NOT NULL,
  "tipo"          text                     NOT NULL,
  "referencia_id" uuid,
  "contenido"     text,
  "leida"         boolean                  NOT NULL DEFAULT false,
  "creada_en"     timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT "pk_notificaciones" PRIMARY KEY (id)
);

ALTER TABLE "public"."notificaciones"
  ENABLE ROW LEVEL SECURITY;

REVOKE ALL ON TABLE "public"."notificaciones" FROM "anon";

CREATE TABLE "public"."oficios" (
  "id"     integer GENERATED ALWAYS AS IDENTITY NOT NULL,
  "nombre" text    NOT NULL,
  CONSTRAINT "pk_oficios" PRIMARY KEY (id),
  CONSTRAINT "uq_oficios_nombre" UNIQUE (nombre)
);

ALTER TABLE "public"."oficios"
  ENABLE ROW LEVEL SECURITY;

CREATE TABLE "public"."perfiles_tecnicos" (
  "usuario_id"            uuid                         NOT NULL,
  "nivel_id"              integer                      NOT NULL DEFAULT 1,
  "tarifa_base"           numeric(10,2)                NOT NULL DEFAULT 0,
  "rango_cobertura_m"     integer                      NOT NULL DEFAULT 5000,
  "ubicacion_actual"      public.geography(Point,4326),
  "puntos"                integer                      NOT NULL DEFAULT 0,
  "calificacion_promedio" numeric(3,2)                 NOT NULL DEFAULT 0,
  "total_resenas"         integer                      NOT NULL DEFAULT 0,
  "verificado"            boolean                      NOT NULL DEFAULT false,
  CONSTRAINT "ck_perfiles_calificacion" CHECK (((calificacion_promedio >= (0)::numeric) AND (calificacion_promedio <= (5)::numeric))),
  CONSTRAINT "ck_perfiles_puntos" CHECK ((puntos >= 0)),
  CONSTRAINT "ck_perfiles_rango" CHECK ((rango_cobertura_m > 0)),
  CONSTRAINT "ck_perfiles_tarifa" CHECK ((tarifa_base >= (0)::numeric)),
  CONSTRAINT "pk_perfiles_tecnicos" PRIMARY KEY (usuario_id)
);

ALTER TABLE "public"."perfiles_tecnicos"
  ENABLE ROW LEVEL SECURITY;

REVOKE ALL ON TABLE "public"."perfiles_tecnicos" FROM "anon";

CREATE TABLE "public"."resenas" (
  "id"              uuid                     NOT NULL DEFAULT gen_random_uuid(),
  "solicitud_id"    uuid                     NOT NULL,
  "autor_id"        uuid                     NOT NULL,
  "destinatario_id" uuid                     NOT NULL,
  "calificacion"    integer                  NOT NULL,
  "comentario"      text,
  "creado_en"       timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT "ck_resenas_autor_distinto" CHECK ((autor_id <> destinatario_id)),
  CONSTRAINT "ck_resenas_calificacion" CHECK (((calificacion >= 1) AND (calificacion <= 5))),
  CONSTRAINT "pk_resenas" PRIMARY KEY (id),
  CONSTRAINT "uq_resenas_solicitud_autor" UNIQUE (solicitud_id, autor_id)
);

ALTER TABLE "public"."resenas"
  ENABLE ROW LEVEL SECURITY;

REVOKE ALL ON TABLE "public"."resenas" FROM "anon";

CREATE TABLE "public"."solicitud_archivos" (
  "id"           uuid                     NOT NULL DEFAULT gen_random_uuid(),
  "solicitud_id" uuid                     NOT NULL,
  "tipo"         text                     NOT NULL,
  "ruta"         text                     NOT NULL,
  "creado_en"    timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT "ck_archivos_tipo" CHECK ((tipo = ANY (ARRAY['problema'::text, 'evidencia'::text]))),
  CONSTRAINT "pk_solicitud_archivos" PRIMARY KEY (id)
);

ALTER TABLE "public"."solicitud_archivos"
  ENABLE ROW LEVEL SECURITY;

REVOKE ALL ON TABLE "public"."solicitud_archivos" FROM "anon";

CREATE TABLE "public"."solicitudes_servicio" (
  "id"                   uuid                         NOT NULL DEFAULT gen_random_uuid(),
  "cliente_id"           uuid                         NOT NULL,
  "oficio_id"            integer                      NOT NULL,
  "descripcion"          text                         NOT NULL,
  "ubicacion"            public.geography(Point,4326) NOT NULL,
  "direccion_referencia" text,
  "estado"               text                         NOT NULL DEFAULT 'abierta'::text,
  "creado_en"            timestamp with time zone     NOT NULL DEFAULT now(),
  CONSTRAINT "ck_solicitudes_estado"
    CHECK ((estado = ANY (ARRAY['abierta'::text, 'cotizada'::text, 'aceptada'::text, 'por_confirmar'::text, 'completada'::text, 'cancelada'::text]))),
  CONSTRAINT "pk_solicitudes" PRIMARY KEY (id)
);

ALTER TABLE "public"."solicitudes_servicio"
  ENABLE ROW LEVEL SECURITY;

REVOKE ALL ON TABLE "public"."solicitudes_servicio" FROM "anon";

CREATE TABLE "public"."tecnico_oficios" (
  "tecnico_id" uuid    NOT NULL,
  "oficio_id"  integer NOT NULL,
  CONSTRAINT "pk_tecnico_oficios" PRIMARY KEY (tecnico_id, oficio_id)
);

ALTER TABLE "public"."tecnico_oficios"
  ENABLE ROW LEVEL SECURITY;

REVOKE ALL ON TABLE "public"."tecnico_oficios" FROM "anon";

CREATE TABLE "public"."usuarios" (
  "id"                 uuid                         NOT NULL,
  "rol"                text                         NOT NULL DEFAULT 'cliente'::text,
  "nombres"            text                         NOT NULL,
  "apellidos"          text                         NOT NULL DEFAULT ''::text,
  "foto_perfil_ruta"   text,
  "ubicacion_registro" public.geography(Point,4326),
  "creado_en"          timestamp with time zone     NOT NULL DEFAULT now(),
  CONSTRAINT "ck_usuarios_rol" CHECK ((rol = ANY (ARRAY['cliente'::text, 'tecnico'::text, 'admin'::text]))),
  CONSTRAINT "pk_usuarios" PRIMARY KEY (id)
);

ALTER TABLE "public"."usuarios"
  ENABLE ROW LEVEL SECURITY;

REVOKE ALL ON TABLE "public"."usuarios" FROM "anon";

CREATE OR REPLACE FUNCTION public.aceptar_cotizacion (
  p_cotizacion_id uuid
)
  RETURNS void
  LANGUAGE plpgsql
  SET search_path TO 'public'
  AS $function$
declare
  v_solicitud_id      uuid;
  v_estado_cotizacion text;
  v_estado_solicitud  text;
  v_filas             int;
begin
  select solicitud_id, estado
    into v_solicitud_id, v_estado_cotizacion
    from cotizaciones
   where id = p_cotizacion_id;
  if not found then
    raise exception 'La cotización no existe.';
  end if;

  select estado
    into v_estado_solicitud
    from solicitudes_servicio
   where id = v_solicitud_id
     and cliente_id = auth.uid()
     for update;
  if not found then
    raise exception 'No tienes permiso sobre esta solicitud.';
  end if;

  if v_estado_solicitud not in ('abierta', 'cotizada') then
    raise exception 'Esta solicitud ya no acepta cotizaciones.';
  end if;
  if v_estado_cotizacion <> 'pendiente' then
    raise exception 'Esta cotización ya no está pendiente.';
  end if;

  update cotizaciones set estado = 'aceptada' where id = p_cotizacion_id;
  get diagnostics v_filas = row_count;
  if v_filas = 0 then
    raise exception 'No tienes permiso para aceptar esta cotización.';
  end if;

  update cotizaciones
     set estado = 'rechazada'
   where solicitud_id = v_solicitud_id
     and id <> p_cotizacion_id
     and estado = 'pendiente';

  if exists (select 1 from cotizaciones
              where solicitud_id = v_solicitud_id
                and id <> p_cotizacion_id
                and estado = 'pendiente') then
    raise exception 'No se pudieron rechazar las demás cotizaciones.';
  end if;

  update solicitudes_servicio set estado = 'aceptada' where id = v_solicitud_id;
  get diagnostics v_filas = row_count;
  if v_filas = 0 then
    raise exception 'No tienes permiso para actualizar esta solicitud.';
  end if;
end;
$function$;

REVOKE ALL ON FUNCTION "public"."aceptar_cotizacion"(uuid) FROM PUBLIC, "anon";

CREATE OR REPLACE FUNCTION public.es_cliente_solicitud (
  p_sol uuid
)
  RETURNS boolean
  LANGUAGE sql
  STABLE
  SECURITY DEFINER
  SET search_path TO 'public'
  AS $function$
  select exists (select 1 from public.solicitudes_servicio where id = p_sol and cliente_id = (select auth.uid()))
$function$;

REVOKE ALL ON FUNCTION "public"."es_cliente_solicitud"(uuid) FROM PUBLIC, "anon";

CREATE OR REPLACE FUNCTION public.es_tecnico_asignado (
  p_sol uuid
)
  RETURNS boolean
  LANGUAGE sql
  STABLE
  SECURITY DEFINER
  SET search_path TO 'public'
  AS $function$
  select exists (select 1 from public.cotizaciones where solicitud_id = p_sol and tecnico_id = (select auth.uid()) and estado = 'aceptada')
$function$;

REVOKE ALL ON FUNCTION "public"."es_tecnico_asignado"(uuid) FROM PUBLIC, "anon";

CREATE OR REPLACE FUNCTION public.es_tecnico_cotizante (
  p_sol uuid
)
  RETURNS boolean
  LANGUAGE sql
  STABLE
  SECURITY DEFINER
  SET search_path TO 'public'
  AS $function$
  select exists (select 1 from public.cotizaciones where solicitud_id = p_sol and tecnico_id = (select auth.uid()))
$function$;

REVOKE ALL ON FUNCTION "public"."es_tecnico_cotizante"(uuid) FROM PUBLIC, "anon";

CREATE OR REPLACE FUNCTION public.fn_auditoria()
  RETURNS TRIGGER
  LANGUAGE plpgsql
  SECURITY DEFINER
  SET search_path TO 'public'
  AS $function$
declare
  v_old jsonb;
  v_new jsonb;
  v_id text;
begin
  if tg_op = 'UPDATE' then
    select coalesce(jsonb_object_agg(o.key, o.value), '{}'::jsonb),
           coalesce(jsonb_object_agg(n.key, n.value), '{}'::jsonb)
      into v_old, v_new
    from jsonb_each(to_jsonb(old)) o
    join jsonb_each(to_jsonb(new)) n on n.key = o.key
    where o.value is distinct from n.value;

    if v_new = '{}'::jsonb then
      return new;
    end if;
    v_id := coalesce(to_jsonb(new)->>'id', to_jsonb(new)->>'usuario_id');
  else
    v_old := to_jsonb(old);
    v_new := null;
    v_id := coalesce(to_jsonb(old)->>'id', to_jsonb(old)->>'usuario_id');
  end if;

  insert into auditoria (tabla, registro_id, accion, datos_anteriores, datos_nuevos, cambiado_por)
  values (tg_table_name, v_id, tg_op, v_old, v_new, (select auth.uid()));

  if tg_op = 'DELETE' then return old; end if;
  return new;
end $function$;

CREATE OR REPLACE FUNCTION public.fn_cierre_negocio()
  RETURNS TRIGGER
  LANGUAGE plpgsql
  SECURITY DEFINER
  SET search_path TO 'public'
  AS $function$
declare
  v_cot cotizaciones%rowtype;
  v_pct numeric;
  v_previos int;
begin
  select * into v_cot from cotizaciones where solicitud_id = new.id and estado = 'aceptada';
  if not found then return new; end if;

  select n.comision_porcentaje into v_pct
  from perfiles_tecnicos p join niveles_gamificacion n on n.id = p.nivel_id
  where p.usuario_id = v_cot.tecnico_id;

  insert into comisiones (cotizacion_id, base_calculo, porcentaje_aplicado, valor)
  values (v_cot.id, v_cot.mano_obra, v_pct, round(v_cot.mano_obra * v_pct / 100, 2));

  select count(*) into v_previos
  from historial_puntos h join solicitudes_servicio s on s.id = h.solicitud_id
  where h.tecnico_id = v_cot.tecnico_id and s.cliente_id = new.cliente_id
    and h.motivo = 'trabajo completado' and h.creado_en >= date_trunc('month', now());
  if v_previos < 3 then
    insert into historial_puntos (tecnico_id, solicitud_id, puntos, motivo)
    values (v_cot.tecnico_id, new.id, 10, 'trabajo completado');
  end if;

  insert into eventos (tipo, payload)
  values ('negocio_cerrado', jsonb_build_object('solicitud_id', new.id, 'cotizacion_id', v_cot.id, 'tecnico_id', v_cot.tecnico_id));
  insert into notificaciones (usuario_id, tipo, referencia_id, contenido)
  values (v_cot.tecnico_id, 'cierre', new.id, 'El cliente confirmo el cierre del trabajo');
  return new;
end $function$;

CREATE OR REPLACE FUNCTION public.fn_cotizacion_aceptada()
  RETURNS TRIGGER
  LANGUAGE plpgsql
  SECURITY DEFINER
  SET search_path TO 'public'
  AS $function$
begin
  update cotizaciones set estado = 'rechazada'
  where solicitud_id = new.solicitud_id and id <> new.id and estado = 'pendiente';
  update solicitudes_servicio set estado = 'aceptada' where id = new.solicitud_id;
  insert into notificaciones (usuario_id, tipo, referencia_id, contenido)
  values (new.tecnico_id, 'cotizacion_aceptada', new.id, 'Tu cotizacion fue aceptada');
  return new;
end $function$;

CREATE OR REPLACE FUNCTION public.fn_historial_documento()
  RETURNS TRIGGER
  LANGUAGE plpgsql
  SECURITY DEFINER
  SET search_path TO 'public'
  AS $function$
begin
  if tg_op = 'INSERT' then
    insert into documentos_historial (documento_id, tecnico_id, tipo, estado_anterior, estado_nuevo, ruta_anterior, ruta_nueva, cambiado_por)
    values (new.id, new.tecnico_id, new.tipo, null, new.estado, null, new.ruta_archivo, (select auth.uid()));
  elsif new.estado is distinct from old.estado or new.ruta_archivo is distinct from old.ruta_archivo then
    insert into documentos_historial (documento_id, tecnico_id, tipo, estado_anterior, estado_nuevo, ruta_anterior, ruta_nueva, cambiado_por)
    values (new.id, new.tecnico_id, new.tipo, old.estado, new.estado, old.ruta_archivo, new.ruta_archivo, (select auth.uid()));
  end if;
  return new;
end $function$;

CREATE OR REPLACE FUNCTION public.fn_limite_archivos()
  RETURNS TRIGGER
  LANGUAGE plpgsql
  SECURITY DEFINER
  SET search_path TO 'public'
  AS $function$
begin
  if new.tipo = 'evidencia'
     and (select estado from solicitudes_servicio where id = new.solicitud_id) not in ('aceptada','por_confirmar') then
    raise exception 'La evidencia solo se sube cuando la solicitud esta aceptada o por confirmar';
  end if;
  if (select count(*) from solicitud_archivos where solicitud_id = new.solicitud_id and tipo = new.tipo) >= 5 then
    raise exception 'Maximo 5 fotos por tipo en cada solicitud';
  end if;
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
  insert into conversaciones (solicitud_id, tecnico_id)
  values (new.solicitud_id, new.tecnico_id)
  on conflict (solicitud_id, tecnico_id) do nothing;
  insert into notificaciones (usuario_id, tipo, referencia_id, contenido)
  select cliente_id, 'cotizacion', new.id, 'Recibiste una nueva cotizacion'
  from solicitudes_servicio where id = new.solicitud_id;
  return new;
end $function$;

CREATE OR REPLACE FUNCTION public.fn_nuevo_usuario()
  RETURNS TRIGGER
  LANGUAGE plpgsql
  SECURITY DEFINER
  SET search_path TO 'public'
  AS $function$
declare
  v_rol text := case when new.raw_user_meta_data->>'rol' = 'tecnico' then 'tecnico' else 'cliente' end;
  v_cedula text := new.raw_user_meta_data->>'cedula';
begin
  if v_cedula is null or not validar_cedula(v_cedula) then
    raise exception 'La cedula es obligatoria y debe ser valida';
  end if;
  insert into usuarios (id, rol, nombres, apellidos)
  values (new.id, v_rol,
          coalesce(new.raw_user_meta_data->>'nombres', split_part(new.email, '@', 1)),
          coalesce(new.raw_user_meta_data->>'apellidos', ''));
  insert into identidades (usuario_id, cedula) values (new.id, v_cedula);
  if v_rol = 'tecnico' then
    insert into perfiles_tecnicos (usuario_id) values (new.id);
  end if;
  return new;
end $function$;

CREATE OR REPLACE FUNCTION public.fn_reputacion()
  RETURNS TRIGGER
  LANGUAGE plpgsql
  SECURITY DEFINER
  SET search_path TO 'public'
  AS $function$
begin
  update perfiles_tecnicos
  set calificacion_promedio = (select round(avg(calificacion), 2) from resenas where destinatario_id = new.destinatario_id),
      total_resenas = (select count(*) from resenas where destinatario_id = new.destinatario_id)
  where usuario_id = new.destinatario_id;
  return new;
end $function$;

CREATE OR REPLACE FUNCTION public.fn_solicitud_creada()
  RETURNS TRIGGER
  LANGUAGE plpgsql
  SECURITY DEFINER
  SET search_path TO 'public'
  AS $function$
begin
  insert into eventos (tipo, payload)
  values ('solicitud_creada', jsonb_build_object('solicitud_id', new.id, 'oficio_id', new.oficio_id));
  return new;
end $function$;

CREATE OR REPLACE FUNCTION public.fn_sync_puntos()
  RETURNS TRIGGER
  LANGUAGE plpgsql
  SECURITY DEFINER
  SET search_path TO 'public'
  AS $function$
begin
  update perfiles_tecnicos p
  set puntos = p.puntos + new.puntos,
      nivel_id = coalesce((select n.id from niveles_gamificacion n
                           where n.puntos_minimos <= p.puntos + new.puntos
                           order by n.puntos_minimos desc limit 1), p.nivel_id)
  where p.usuario_id = new.tecnico_id;
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
    (old.estado = 'abierta' and new.estado in ('cotizada','cancelada')) or
    (old.estado = 'cotizada' and new.estado in ('aceptada','cancelada')) or
    (old.estado = 'aceptada' and new.estado in ('por_confirmar','cancelada')) or
    (old.estado = 'por_confirmar' and new.estado in ('completada','cancelada'))
  ) then
    raise exception 'Transicion de estado invalida: % a %', old.estado, new.estado;
  end if;
  if new.estado = 'aceptada'
     and not exists (select 1 from public.cotizaciones where solicitud_id = new.id and estado = 'aceptada') then
    raise exception 'No se puede aceptar una solicitud sin una cotizacion aceptada';
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
  if (select estado from solicitudes_servicio where id = new.solicitud_id) not in ('abierta','cotizada') then
    raise exception 'La solicitud ya no recibe cotizaciones';
  end if;
  return new;
end $function$;

CREATE OR REPLACE FUNCTION public.fn_validar_resena()
  RETURNS TRIGGER
  LANGUAGE plpgsql
  SECURITY DEFINER
  SET search_path TO 'public'
  AS $function$
declare
  v_cliente uuid;
  v_estado text;
  v_tecnico uuid;
begin
  select cliente_id, estado into v_cliente, v_estado from solicitudes_servicio where id = new.solicitud_id;
  if v_estado is distinct from 'completada' then
    raise exception 'Solo se puede resenar una solicitud completada';
  end if;
  select tecnico_id into v_tecnico from cotizaciones where solicitud_id = new.solicitud_id and estado = 'aceptada';
  if not ((new.autor_id = v_cliente and new.destinatario_id = v_tecnico)
       or (new.autor_id = v_tecnico and new.destinatario_id = v_cliente)) then
    raise exception 'Autor y destinatario deben ser el cliente y el tecnico de la solicitud';
  end if;
  return new;
end $function$;

CREATE OR REPLACE FUNCTION public.fn_verificar_tecnico()
  RETURNS TRIGGER
  LANGUAGE plpgsql
  SECURITY DEFINER
  SET search_path TO 'public'
  AS $function$
begin
  update perfiles_tecnicos
  set verificado = (select count(distinct tipo) = 3 from documentos_tecnico
                    where tecnico_id = new.tecnico_id and estado = 'aprobada')
  where usuario_id = new.tecnico_id;
  return new;
end $function$;

CREATE OR REPLACE FUNCTION public.mi_rol()
  RETURNS text
  LANGUAGE sql
  STABLE
  SECURITY DEFINER
  SET search_path TO 'public'
  AS $function$
  select rol from public.usuarios where id = (select auth.uid())
$function$;

REVOKE ALL ON FUNCTION "public"."mi_rol"() FROM PUBLIC, "anon";

CREATE OR REPLACE FUNCTION public.rls_auto_enable()
  RETURNS event_trigger
  LANGUAGE plpgsql
  SECURITY DEFINER
  SET search_path TO 'pg_catalog'
  AS $function$
DECLARE
  cmd record;
  tbl name;
BEGIN
  FOR cmd IN
    SELECT *
    FROM pg_event_trigger_ddl_commands()
    WHERE command_tag IN ('CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO')
      AND object_type IN ('table','partitioned table')
  LOOP
     IF cmd.schema_name IS NOT NULL AND cmd.schema_name IN ('public') AND cmd.schema_name NOT IN ('pg_catalog','information_schema') AND cmd.schema_name NOT LIKE 'pg_toast%' AND cmd.schema_name NOT LIKE 'pg_temp%' THEN
      BEGIN
        SELECT c.relname INTO tbl FROM pg_catalog.pg_class c WHERE c.oid = cmd.objid;
        EXECUTE format('alter table if exists %I.%I enable row level security', cmd.schema_name, tbl);
        RAISE LOG 'rls_auto_enable: enabled RLS on %', cmd.object_identity;
      EXCEPTION
        WHEN OTHERS THEN
          RAISE LOG 'rls_auto_enable: failed to enable RLS on %', cmd.object_identity;
      END;
     ELSE
        RAISE LOG 'rls_auto_enable: skip % (either system schema or not in enforced list: %.)', cmd.object_identity, cmd.schema_name;
     END IF;
  END LOOP;
END;
$function$;

CREATE OR REPLACE FUNCTION public.solicitudes_cercanas (
  p_tecnico uuid
)
  RETURNS TABLE (
    solicitud_id uuid,
    descripcion  text,
    metros       integer,
    creado_en    timestamp with time zone
  )
  LANGUAGE sql
  STABLE
  AS $function$
  select s.id, s.descripcion, round(st_distance(s.ubicacion, p.ubicacion_actual))::int, s.creado_en
  from perfiles_tecnicos p
  join tecnico_oficios t on t.tecnico_id = p.usuario_id
  join solicitudes_servicio s on s.oficio_id = t.oficio_id
  where p.usuario_id = p_tecnico
    and s.estado = 'abierta'
    and st_dwithin(s.ubicacion, p.ubicacion_actual, p.rango_cobertura_m)
  order by 3;
$function$;

CREATE OR REPLACE FUNCTION public.tecnicos_elegibles (
  p_solicitud uuid
)
  RETURNS TABLE (
    tecnico_id   uuid,
    nombre       text,
    nivel        text,
    prioridad    integer,
    calificacion numeric,
    metros       integer
  )
  LANGUAGE sql
  STABLE
  AS $function$
  select p.usuario_id, trim(u.nombres || ' ' || u.apellidos), n.nombre, n.prioridad, p.calificacion_promedio,
         round(st_distance(s.ubicacion, p.ubicacion_actual))::int
  from solicitudes_servicio s
  join tecnico_oficios t on t.oficio_id = s.oficio_id
  join perfiles_tecnicos p on p.usuario_id = t.tecnico_id
  join usuarios u on u.id = p.usuario_id
  join niveles_gamificacion n on n.id = p.nivel_id
  where s.id = p_solicitud
    and st_dwithin(s.ubicacion, p.ubicacion_actual, p.rango_cobertura_m)
  order by n.prioridad desc, 6;
$function$;

CREATE OR REPLACE FUNCTION public.validar_cedula (
  c text
)
  RETURNS boolean
  LANGUAGE plpgsql
  IMMUTABLE
  AS $function$
declare suma int := 0; d int; prov int;
begin
  if c !~ '^\d{10}$' then return false; end if;
  prov := substr(c,1,2)::int;
  if (prov not between 1 and 24) and prov <> 30 then return false; end if;
  if substr(c,3,1)::int > 5 then return false; end if;
  for i in 1..9 loop
    d := substr(c,i,1)::int * case when i % 2 = 1 then 2 else 1 end;
    if d > 9 then d := d - 9; end if;
    suma := suma + d;
  end loop;
  return (10 - suma % 10) % 10 = substr(c,10,1)::int;
end $function$;

ALTER TABLE "public"."comisiones"
  ADD CONSTRAINT "fk_comisiones_cotizacion" FOREIGN KEY (cotizacion_id) REFERENCES public.cotizaciones(id);

ALTER TABLE "public"."mensajes"
  ADD CONSTRAINT "fk_mensajes_conversacion" FOREIGN KEY (conversacion_id) REFERENCES public.conversaciones(id) ON DELETE CASCADE;

ALTER TABLE "public"."perfiles_tecnicos"
  ADD CONSTRAINT "fk_perfiles_nivel" FOREIGN KEY (nivel_id) REFERENCES public.niveles_gamificacion(id);

ALTER TABLE "public"."conversaciones"
  ADD CONSTRAINT "fk_conversaciones_tecnico" FOREIGN KEY (tecnico_id) REFERENCES public.perfiles_tecnicos(usuario_id);

ALTER TABLE "public"."cotizaciones"
  ADD CONSTRAINT "fk_cotizaciones_tecnico" FOREIGN KEY (tecnico_id) REFERENCES public.perfiles_tecnicos(usuario_id);

ALTER TABLE "public"."documentos_historial"
  ADD CONSTRAINT "documentos_historial_tecnico_id_fkey" FOREIGN KEY (tecnico_id) REFERENCES public.perfiles_tecnicos(usuario_id) ON DELETE CASCADE;

ALTER TABLE "public"."documentos_tecnico"
  ADD CONSTRAINT "fk_documentos_tecnico" FOREIGN KEY (tecnico_id) REFERENCES public.perfiles_tecnicos(usuario_id) ON DELETE CASCADE;

ALTER TABLE "public"."historial_puntos"
  ADD CONSTRAINT "fk_historial_tecnico" FOREIGN KEY (tecnico_id) REFERENCES public.perfiles_tecnicos(usuario_id);

ALTER TABLE "public"."solicitudes_servicio"
  ADD CONSTRAINT "fk_solicitudes_oficio" FOREIGN KEY (oficio_id) REFERENCES public.oficios(id);

ALTER TABLE "public"."conversaciones"
  ADD CONSTRAINT "fk_conversaciones_solicitud" FOREIGN KEY (solicitud_id) REFERENCES public.solicitudes_servicio(id) ON DELETE CASCADE;

ALTER TABLE "public"."cotizaciones"
  ADD CONSTRAINT "fk_cotizaciones_solicitud" FOREIGN KEY (solicitud_id) REFERENCES public.solicitudes_servicio(id) ON DELETE CASCADE;

ALTER TABLE "public"."historial_puntos"
  ADD CONSTRAINT "fk_historial_solicitud" FOREIGN KEY (solicitud_id) REFERENCES public.solicitudes_servicio(id) ON DELETE SET NULL;

ALTER TABLE "public"."resenas"
  ADD CONSTRAINT "fk_resenas_solicitud" FOREIGN KEY (solicitud_id) REFERENCES public.solicitudes_servicio(id);

ALTER TABLE "public"."solicitud_archivos"
  ADD CONSTRAINT "fk_archivos_solicitud" FOREIGN KEY (solicitud_id) REFERENCES public.solicitudes_servicio(id) ON DELETE CASCADE;

ALTER TABLE "public"."tecnico_oficios"
  ADD CONSTRAINT "fk_tecnico_oficios_oficio" FOREIGN KEY (oficio_id) REFERENCES public.oficios(id);

ALTER TABLE "public"."tecnico_oficios"
  ADD CONSTRAINT "fk_tecnico_oficios_tecnico" FOREIGN KEY (tecnico_id) REFERENCES public.perfiles_tecnicos(usuario_id) ON DELETE CASCADE;

ALTER TABLE "public"."usuarios"
  ADD CONSTRAINT "fk_usuarios_auth" FOREIGN KEY (id) REFERENCES auth.users(id) ON DELETE CASCADE;

ALTER TABLE "public"."documentos_tecnico"
  ADD CONSTRAINT "fk_documentos_revisor" FOREIGN KEY (revisado_por) REFERENCES public.usuarios(id) ON DELETE SET NULL;

ALTER TABLE "public"."identidades"
  ADD CONSTRAINT "fk_identidades_usuario" FOREIGN KEY (usuario_id) REFERENCES public.usuarios(id) ON DELETE CASCADE;

ALTER TABLE "public"."mensajes"
  ADD CONSTRAINT "fk_mensajes_autor" FOREIGN KEY (autor_id) REFERENCES public.usuarios(id);

ALTER TABLE "public"."notificaciones"
  ADD CONSTRAINT "fk_notificaciones_usuario" FOREIGN KEY (usuario_id) REFERENCES public.usuarios(id) ON DELETE CASCADE;

ALTER TABLE "public"."perfiles_tecnicos"
  ADD CONSTRAINT "fk_perfiles_usuario" FOREIGN KEY (usuario_id) REFERENCES public.usuarios(id) ON DELETE CASCADE;

ALTER TABLE "public"."resenas"
  ADD CONSTRAINT "fk_resenas_autor" FOREIGN KEY (autor_id) REFERENCES public.usuarios(id);

ALTER TABLE "public"."resenas"
  ADD CONSTRAINT "fk_resenas_destinatario" FOREIGN KEY (destinatario_id) REFERENCES public.usuarios(id);

ALTER TABLE "public"."solicitudes_servicio"
  ADD CONSTRAINT "fk_solicitudes_cliente" FOREIGN KEY (cliente_id) REFERENCES public.usuarios(id);

CREATE INDEX idx_archivos_solicitud ON public.solicitud_archivos USING btree (solicitud_id);

CREATE INDEX idx_conversaciones_tecnico ON public.conversaciones USING btree (tecnico_id);

CREATE INDEX idx_cotizaciones_tecnico ON public.cotizaciones USING btree (tecnico_id);

CREATE INDEX idx_documentos_tecnico ON public.documentos_tecnico USING btree (tecnico_id);

CREATE INDEX idx_eventos_pendientes ON public.eventos USING btree (creado_en)
  WHERE (publicado_en IS NULL);

CREATE INDEX idx_historial_tecnico ON public.historial_puntos USING btree (tecnico_id);

CREATE INDEX idx_mensajes_autor ON public.mensajes USING btree (autor_id);

CREATE INDEX idx_mensajes_conversacion_fecha ON public.mensajes USING btree (conversacion_id, enviado_en);

CREATE INDEX idx_notificaciones_usuario ON public.notificaciones USING btree (usuario_id, leida);

CREATE INDEX idx_perfiles_nivel ON public.perfiles_tecnicos USING btree (nivel_id);

CREATE INDEX idx_perfiles_ubicacion ON public.perfiles_tecnicos USING gist (ubicacion_actual);

CREATE INDEX idx_resenas_destinatario ON public.resenas USING btree (destinatario_id);

CREATE INDEX idx_solicitudes_abiertas_ubicacion ON public.solicitudes_servicio USING gist (ubicacion)
  WHERE (estado = 'abierta'::text);

CREATE INDEX idx_solicitudes_cliente ON public.solicitudes_servicio USING btree (cliente_id);

CREATE INDEX idx_solicitudes_oficio ON public.solicitudes_servicio USING btree (oficio_id);

CREATE INDEX idx_tecnico_oficios_oficio ON public.tecnico_oficios USING btree (oficio_id);

CREATE INDEX ix_auditoria_autor ON public.auditoria USING btree (cambiado_por, cambiado_en DESC);

CREATE INDEX ix_auditoria_registro ON public.auditoria USING btree (tabla, registro_id, cambiado_en DESC);

CREATE INDEX ix_documentos_historial_tecnico ON public.documentos_historial USING btree (tecnico_id, cambiado_en DESC);

CREATE UNIQUE INDEX uq_cotizacion_aceptada ON public.cotizaciones USING btree (solicitud_id)
  WHERE (estado = 'aceptada'::text);

CREATE TRIGGER trg_auth_nuevo_usuario
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.fn_nuevo_usuario();

CREATE TRIGGER trg_auditoria
  AFTER DELETE OR UPDATE ON public.cotizaciones
  FOR EACH ROW
  EXECUTE FUNCTION public.fn_auditoria();

CREATE TRIGGER trg_cotizacion_aceptada
  AFTER UPDATE OF estado ON public.cotizaciones
  FOR EACH ROW
  WHEN (((new.estado = 'aceptada'::text) AND (old.estado IS DISTINCT FROM new.estado)))
  EXECUTE FUNCTION public.fn_cotizacion_aceptada();

CREATE TRIGGER trg_cotizacion_nueva
  AFTER INSERT ON public.cotizaciones
  FOR EACH ROW
  EXECUTE FUNCTION public.fn_nueva_cotizacion();

CREATE TRIGGER trg_cotizacion_validar
  BEFORE INSERT ON public.cotizaciones
  FOR EACH ROW
  EXECUTE FUNCTION public.fn_validar_cotizacion();

CREATE TRIGGER trg_auditoria
  AFTER DELETE OR UPDATE ON public.documentos_tecnico
  FOR EACH ROW
  EXECUTE FUNCTION public.fn_auditoria();

CREATE TRIGGER trg_documentos_historial
  AFTER INSERT OR UPDATE ON public.documentos_tecnico
  FOR EACH ROW
  EXECUTE FUNCTION public.fn_historial_documento();

CREATE TRIGGER trg_documentos_verificar
  AFTER INSERT OR UPDATE OF estado ON public.documentos_tecnico
  FOR EACH ROW
  EXECUTE FUNCTION public.fn_verificar_tecnico();

CREATE TRIGGER trg_historial_puntos_sync
  AFTER INSERT ON public.historial_puntos
  FOR EACH ROW
  EXECUTE FUNCTION public.fn_sync_puntos();

CREATE TRIGGER trg_auditoria
  AFTER DELETE OR UPDATE ON public.identidades
  FOR EACH ROW
  EXECUTE FUNCTION public.fn_auditoria();

CREATE TRIGGER trg_auditoria
  AFTER DELETE OR UPDATE ON public.perfiles_tecnicos
  FOR EACH ROW
  EXECUTE FUNCTION public.fn_auditoria();

CREATE TRIGGER trg_resena_reputacion
  AFTER INSERT ON public.resenas
  FOR EACH ROW
  EXECUTE FUNCTION public.fn_reputacion();

CREATE TRIGGER trg_resena_validar
  BEFORE INSERT ON public.resenas
  FOR EACH ROW
  EXECUTE FUNCTION public.fn_validar_resena();

CREATE TRIGGER trg_archivos_limite
  BEFORE INSERT ON public.solicitud_archivos
  FOR EACH ROW
  EXECUTE FUNCTION public.fn_limite_archivos();

CREATE TRIGGER trg_auditoria
  AFTER DELETE OR UPDATE ON public.solicitudes_servicio
  FOR EACH ROW
  EXECUTE FUNCTION public.fn_auditoria();

CREATE TRIGGER trg_solicitud_completada
  AFTER UPDATE OF estado ON public.solicitudes_servicio
  FOR EACH ROW
  WHEN (((new.estado = 'completada'::text) AND (old.estado IS DISTINCT FROM new.estado)))
  EXECUTE FUNCTION public.fn_cierre_negocio();

CREATE TRIGGER trg_solicitud_creada
  AFTER INSERT ON public.solicitudes_servicio
  FOR EACH ROW
  EXECUTE FUNCTION public.fn_solicitud_creada();

CREATE TRIGGER trg_solicitud_transicion
  BEFORE UPDATE OF estado ON public.solicitudes_servicio
  FOR EACH ROW
  EXECUTE FUNCTION public.fn_transicion_estado();

CREATE TRIGGER trg_auditoria
  AFTER DELETE OR UPDATE ON public.usuarios
  FOR EACH ROW
  EXECUTE FUNCTION public.fn_auditoria();

CREATE POLICY "auditoria_lectura" ON "public"."auditoria"
  FOR SELECT
  TO "authenticated"
  USING (((public.mi_rol() = 'admin'::text) OR (cambiado_por = ( SELECT auth.uid() AS uid))));

CREATE POLICY "comisiones_lectura" ON "public"."comisiones"
  FOR SELECT
  TO "authenticated"
  USING ((EXISTS ( SELECT 1
   FROM public.cotizaciones c
  WHERE (c.id = comisiones.cotizacion_id))));

CREATE POLICY "conversaciones_lectura" ON "public"."conversaciones"
  FOR SELECT
  TO "authenticated"
  USING (((tecnico_id = ( SELECT auth.uid() AS uid)) OR public.es_cliente_solicitud(solicitud_id) OR (public.mi_rol() = 'admin'::text)));

CREATE POLICY "cotizaciones_insert" ON "public"."cotizaciones"
  FOR INSERT
  TO "authenticated"
  WITH CHECK (((tecnico_id = ( SELECT auth.uid() AS uid)) AND (public.mi_rol() = 'tecnico'::text) AND (estado = 'pendiente'::text)));

CREATE POLICY "cotizaciones_lectura" ON "public"."cotizaciones"
  FOR SELECT
  TO "authenticated"
  USING (((tecnico_id = ( SELECT auth.uid() AS uid)) OR public.es_cliente_solicitud(solicitud_id) OR (public.mi_rol() = 'admin'::text)));

CREATE POLICY "cotizaciones_update_cliente" ON "public"."cotizaciones"
  FOR UPDATE
  TO "authenticated"
  USING (public.es_cliente_solicitud(solicitud_id))
  WITH CHECK ((public.es_cliente_solicitud(solicitud_id) AND (estado = ANY (ARRAY['aceptada'::text, 'rechazada'::text]))));

CREATE POLICY "historial_docs_lectura" ON "public"."documentos_historial"
  FOR SELECT
  TO "authenticated"
  USING (((tecnico_id = ( SELECT auth.uid() AS uid)) OR (public.mi_rol() = 'admin'::text)));

CREATE POLICY "documentos_insert" ON "public"."documentos_tecnico"
  FOR INSERT
  TO "authenticated"
  WITH CHECK (((tecnico_id = ( SELECT auth.uid() AS uid)) AND (estado = 'pendiente'::text) AND (revisado_por IS NULL)));

CREATE POLICY "documentos_lectura" ON "public"."documentos_tecnico"
  FOR SELECT
  TO "authenticated"
  USING (((tecnico_id = ( SELECT auth.uid() AS uid)) OR (public.mi_rol() = 'admin'::text)));

CREATE POLICY "documentos_reenvio_tecnico" ON "public"."documentos_tecnico"
  FOR UPDATE
  TO "authenticated"
  USING (((tecnico_id = ( SELECT auth.uid() AS uid)) AND (estado = 'rechazada'::text)))
  WITH CHECK (((tecnico_id = ( SELECT auth.uid() AS uid)) AND (estado = 'pendiente'::text) AND (revisado_por IS NULL) AND (revisado_en IS NULL)));

CREATE POLICY "documentos_revision_admin" ON "public"."documentos_tecnico"
  FOR UPDATE
  TO "authenticated"
  USING ((public.mi_rol() = 'admin'::text))
  WITH CHECK ((public.mi_rol() = 'admin'::text));

CREATE POLICY "puntos_lectura" ON "public"."historial_puntos"
  FOR SELECT
  TO "authenticated"
  USING (((tecnico_id = ( SELECT auth.uid() AS uid)) OR (public.mi_rol() = 'admin'::text)));

CREATE POLICY "identidades_insercion" ON "public"."identidades"
  FOR INSERT
  TO "authenticated"
  WITH CHECK ((usuario_id = auth.uid()));

CREATE POLICY "identidades_lectura" ON "public"."identidades"
  FOR SELECT
  TO "authenticated"
  USING (((usuario_id = auth.uid()) OR (EXISTS ( SELECT 1
   FROM public.usuarios
  WHERE ((usuarios.id = auth.uid()) AND (usuarios.rol = 'admin'::text))))));

CREATE POLICY "mensajes_insert" ON "public"."mensajes"
  FOR INSERT
  TO "authenticated"
  WITH CHECK (((autor_id = ( SELECT auth.uid() AS uid)) AND (EXISTS ( SELECT 1
   FROM public.conversaciones c
  WHERE (c.id = mensajes.conversacion_id)))));

CREATE POLICY "mensajes_lectura" ON "public"."mensajes"
  FOR SELECT
  TO "authenticated"
  USING ((EXISTS ( SELECT 1
   FROM public.conversaciones c
  WHERE (c.id = mensajes.conversacion_id))));

CREATE POLICY "niveles_lectura" ON "public"."niveles_gamificacion"
  FOR SELECT
  TO "authenticated"
  USING (true);

CREATE POLICY "notificaciones_lectura" ON "public"."notificaciones"
  FOR SELECT
  TO "authenticated"
  USING ((usuario_id = ( SELECT auth.uid() AS uid)));

CREATE POLICY "notificaciones_update_propia" ON "public"."notificaciones"
  FOR UPDATE
  TO "authenticated"
  USING ((usuario_id = ( SELECT auth.uid() AS uid)))
  WITH CHECK ((usuario_id = ( SELECT auth.uid() AS uid)));

CREATE POLICY "oficios_lectura" ON "public"."oficios"
  FOR SELECT
  TO "anon", "authenticated"
  USING (true);

CREATE POLICY "perfiles_tec_lectura" ON "public"."perfiles_tecnicos"
  FOR SELECT
  TO "authenticated"
  USING (true);

CREATE POLICY "perfiles_tec_update_propio" ON "public"."perfiles_tecnicos"
  FOR UPDATE
  TO "authenticated"
  USING ((usuario_id = ( SELECT auth.uid() AS uid)))
  WITH CHECK ((usuario_id = ( SELECT auth.uid() AS uid)));

CREATE POLICY "resenas_insert" ON "public"."resenas"
  FOR INSERT
  TO "authenticated"
  WITH CHECK ((autor_id = ( SELECT auth.uid() AS uid)));

CREATE POLICY "resenas_lectura" ON "public"."resenas"
  FOR SELECT
  TO "authenticated"
  USING (((autor_id = ( SELECT auth.uid() AS uid)) OR (destinatario_id = ( SELECT auth.uid() AS uid)) OR (public.mi_rol() = 'admin'::text) OR (EXISTS ( SELECT 1
   FROM public.perfiles_tecnicos p
  WHERE (p.usuario_id = resenas.destinatario_id)))));

CREATE POLICY "archivos_delete" ON "public"."solicitud_archivos"
  FOR DELETE
  TO "authenticated"
  USING ((((tipo = 'problema'::text) AND public.es_cliente_solicitud(solicitud_id)) OR ((tipo = 'evidencia'::text) AND public.es_tecnico_asignado(solicitud_id))));

CREATE POLICY "archivos_insert" ON "public"."solicitud_archivos"
  FOR INSERT
  TO "authenticated"
  WITH CHECK ((((tipo = 'problema'::text) AND public.es_cliente_solicitud(solicitud_id)) OR ((tipo = 'evidencia'::text) AND public.es_tecnico_asignado(solicitud_id))));

CREATE POLICY "archivos_lectura" ON "public"."solicitud_archivos"
  FOR SELECT
  TO "authenticated"
  USING ((EXISTS ( SELECT 1
   FROM public.solicitudes_servicio s
  WHERE (s.id = solicitud_archivos.solicitud_id))));

CREATE POLICY "solicitudes_insert" ON "public"."solicitudes_servicio"
  FOR INSERT
  TO "authenticated"
  WITH CHECK (((cliente_id = ( SELECT auth.uid() AS uid)) AND (public.mi_rol() = 'cliente'::text) AND (estado = 'abierta'::text)));

CREATE POLICY "solicitudes_lectura" ON "public"."solicitudes_servicio"
  FOR SELECT
  TO "authenticated"
  USING
    (((cliente_id = ( SELECT auth.uid() AS uid)) OR (public.mi_rol() = 'admin'::text) OR public.es_tecnico_cotizante(id) OR ((public.mi_rol() = 'tecnico'::text) AND (estado = ANY
    (ARRAY['abierta'::text, 'cotizada'::text])) AND (EXISTS ( SELECT 1
   FROM public.tecnico_oficios t
  WHERE ((t.tecnico_id = ( SELECT auth.uid() AS uid)) AND (t.oficio_id = solicitudes_servicio.oficio_id)))))));

CREATE POLICY "solicitudes_update_cliente" ON "public"."solicitudes_servicio"
  FOR UPDATE
  TO "authenticated"
  USING ((cliente_id = ( SELECT auth.uid() AS uid)))
  WITH CHECK (((cliente_id = ( SELECT auth.uid() AS uid)) AND (estado = ANY (ARRAY['aceptada'::text, 'cancelada'::text, 'completada'::text]))));

CREATE POLICY "solicitudes_update_tecnico" ON "public"."solicitudes_servicio"
  FOR UPDATE
  TO "authenticated"
  USING (public.es_tecnico_asignado(id))
  WITH CHECK ((public.es_tecnico_asignado(id) AND (estado = 'por_confirmar'::text)));

CREATE POLICY "tec_oficios_delete" ON "public"."tecnico_oficios"
  FOR DELETE
  TO "authenticated"
  USING ((tecnico_id = ( SELECT auth.uid() AS uid)));

CREATE POLICY "tec_oficios_insert" ON "public"."tecnico_oficios"
  FOR INSERT
  TO "authenticated"
  WITH CHECK ((tecnico_id = ( SELECT auth.uid() AS uid)));

CREATE POLICY "tec_oficios_lectura" ON "public"."tecnico_oficios"
  FOR SELECT
  TO "authenticated"
  USING (true);

CREATE POLICY "usuarios_lectura" ON "public"."usuarios"
  FOR SELECT
  TO "authenticated"
  USING (true);

CREATE POLICY "usuarios_update_propio" ON "public"."usuarios"
  FOR UPDATE
  TO "authenticated"
  USING ((id = ( SELECT auth.uid() AS uid)))
  WITH CHECK ((id = ( SELECT auth.uid() AS uid)));

CREATE POLICY "cedulas_lectura" ON "storage"."objects"
  FOR SELECT
  TO "authenticated"
  USING (((bucket_id = 'cedulas'::text) AND (((storage.foldername(name))[1] = (auth.uid())::text) OR (EXISTS ( SELECT 1
   FROM public.usuarios
  WHERE ((usuarios.id = auth.uid()) AND (usuarios.rol = 'admin'::text)))))));

CREATE POLICY "cedulas_subida_propia" ON "storage"."objects"
  FOR INSERT
  TO "authenticated"
  WITH CHECK (((bucket_id = 'cedulas'::text) AND ((storage.foldername(name))[1] = (auth.uid())::text)));

CREATE POLICY "perfiles_evidencias_lectura" ON "storage"."objects"
  FOR SELECT
  TO "authenticated"
  USING ((bucket_id = ANY (ARRAY['perfiles'::text, 'evidencias'::text])));

CREATE POLICY "perfiles_evidencias_subida" ON "storage"."objects"
  FOR INSERT
  TO "authenticated"
  WITH CHECK ((bucket_id = ANY (ARRAY['perfiles'::text, 'evidencias'::text])));

CREATE POLICY "solicitudes_lectura" ON "storage"."objects"
  FOR SELECT
  TO "authenticated"
  USING ((bucket_id = 'solicitudes'::text));

CREATE POLICY "solicitudes_subida" ON "storage"."objects"
  FOR INSERT
  TO "authenticated"
  WITH CHECK ((bucket_id = 'solicitudes'::text));

CREATE POLICY "storage_update_propio" ON "storage"."objects"
  FOR UPDATE
  TO "authenticated"
  USING (((bucket_id = ANY (ARRAY['perfiles'::text, 'cedulas'::text])) AND ((storage.foldername(name))[1] = (( SELECT auth.uid() AS uid))::text)))
  WITH CHECK (((bucket_id = ANY (ARRAY['perfiles'::text, 'cedulas'::text])) AND ((storage.foldername(name))[1] = (( SELECT auth.uid() AS uid))::text)));

CREATE EVENT TRIGGER "ensure_rls"
  ON ddl_command_end
  WHEN TAG IN ('CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO')
  EXECUTE FUNCTION "public"."rls_auto_enable"();

ALTER PUBLICATION "supabase_realtime" ADD TABLE "public"."cotizaciones";

ALTER PUBLICATION "supabase_realtime" ADD TABLE "public"."mensajes";

ALTER PUBLICATION "supabase_realtime" ADD TABLE "public"."notificaciones";

COMMENT ON EXTENSION "postgis" IS 'PostGIS geometry and geography spatial types and functions';

GRANT EXECUTE ON FUNCTION "public"."aceptar_cotizacion"(uuid) TO "authenticated";

REVOKE ALL ON FUNCTION "public"."aceptar_cotizacion"(uuid) FROM "postgres";

GRANT EXECUTE ON FUNCTION "public"."aceptar_cotizacion"(uuid) TO "postgres";

GRANT EXECUTE ON FUNCTION "public"."aceptar_cotizacion"(uuid) TO "service_role";

GRANT EXECUTE ON FUNCTION "public"."es_cliente_solicitud"(uuid) TO "authenticated";

REVOKE ALL ON FUNCTION "public"."es_cliente_solicitud"(uuid) FROM "postgres";

GRANT EXECUTE ON FUNCTION "public"."es_cliente_solicitud"(uuid) TO "postgres";

GRANT EXECUTE ON FUNCTION "public"."es_cliente_solicitud"(uuid) TO "service_role";

GRANT EXECUTE ON FUNCTION "public"."es_tecnico_asignado"(uuid) TO "authenticated";

REVOKE ALL ON FUNCTION "public"."es_tecnico_asignado"(uuid) FROM "postgres";

GRANT EXECUTE ON FUNCTION "public"."es_tecnico_asignado"(uuid) TO "postgres";

GRANT EXECUTE ON FUNCTION "public"."es_tecnico_asignado"(uuid) TO "service_role";

GRANT EXECUTE ON FUNCTION "public"."es_tecnico_cotizante"(uuid) TO "authenticated";

REVOKE ALL ON FUNCTION "public"."es_tecnico_cotizante"(uuid) FROM "postgres";

GRANT EXECUTE ON FUNCTION "public"."es_tecnico_cotizante"(uuid) TO "postgres";

GRANT EXECUTE ON FUNCTION "public"."es_tecnico_cotizante"(uuid) TO "service_role";

GRANT EXECUTE ON FUNCTION "public"."fn_auditoria"() TO PUBLIC, "anon", "authenticated";

REVOKE ALL ON FUNCTION "public"."fn_auditoria"() FROM "postgres";

GRANT EXECUTE ON FUNCTION "public"."fn_auditoria"() TO "postgres";

GRANT EXECUTE ON FUNCTION "public"."fn_auditoria"() TO "service_role";

GRANT EXECUTE ON FUNCTION "public"."fn_cierre_negocio"() TO PUBLIC, "anon", "authenticated";

REVOKE ALL ON FUNCTION "public"."fn_cierre_negocio"() FROM "postgres";

GRANT EXECUTE ON FUNCTION "public"."fn_cierre_negocio"() TO "postgres";

GRANT EXECUTE ON FUNCTION "public"."fn_cierre_negocio"() TO "service_role";

GRANT EXECUTE ON FUNCTION "public"."fn_cotizacion_aceptada"() TO PUBLIC, "anon", "authenticated";

REVOKE ALL ON FUNCTION "public"."fn_cotizacion_aceptada"() FROM "postgres";

GRANT EXECUTE ON FUNCTION "public"."fn_cotizacion_aceptada"() TO "postgres";

GRANT EXECUTE ON FUNCTION "public"."fn_cotizacion_aceptada"() TO "service_role";

GRANT EXECUTE ON FUNCTION "public"."fn_historial_documento"() TO PUBLIC, "anon", "authenticated";

REVOKE ALL ON FUNCTION "public"."fn_historial_documento"() FROM "postgres";

GRANT EXECUTE ON FUNCTION "public"."fn_historial_documento"() TO "postgres";

GRANT EXECUTE ON FUNCTION "public"."fn_historial_documento"() TO "service_role";

GRANT EXECUTE ON FUNCTION "public"."fn_limite_archivos"() TO PUBLIC, "anon", "authenticated";

REVOKE ALL ON FUNCTION "public"."fn_limite_archivos"() FROM "postgres";

GRANT EXECUTE ON FUNCTION "public"."fn_limite_archivos"() TO "postgres";

GRANT EXECUTE ON FUNCTION "public"."fn_limite_archivos"() TO "service_role";

GRANT EXECUTE ON FUNCTION "public"."fn_nueva_cotizacion"() TO PUBLIC, "anon", "authenticated";

REVOKE ALL ON FUNCTION "public"."fn_nueva_cotizacion"() FROM "postgres";

GRANT EXECUTE ON FUNCTION "public"."fn_nueva_cotizacion"() TO "postgres";

GRANT EXECUTE ON FUNCTION "public"."fn_nueva_cotizacion"() TO "service_role";

GRANT EXECUTE ON FUNCTION "public"."fn_nuevo_usuario"() TO PUBLIC, "anon", "authenticated";

REVOKE ALL ON FUNCTION "public"."fn_nuevo_usuario"() FROM "postgres";

GRANT EXECUTE ON FUNCTION "public"."fn_nuevo_usuario"() TO "postgres";

GRANT EXECUTE ON FUNCTION "public"."fn_nuevo_usuario"() TO "service_role";

GRANT EXECUTE ON FUNCTION "public"."fn_reputacion"() TO PUBLIC, "anon", "authenticated";

REVOKE ALL ON FUNCTION "public"."fn_reputacion"() FROM "postgres";

GRANT EXECUTE ON FUNCTION "public"."fn_reputacion"() TO "postgres";

GRANT EXECUTE ON FUNCTION "public"."fn_reputacion"() TO "service_role";

GRANT EXECUTE ON FUNCTION "public"."fn_solicitud_creada"() TO PUBLIC, "anon", "authenticated";

REVOKE ALL ON FUNCTION "public"."fn_solicitud_creada"() FROM "postgres";

GRANT EXECUTE ON FUNCTION "public"."fn_solicitud_creada"() TO "postgres";

GRANT EXECUTE ON FUNCTION "public"."fn_solicitud_creada"() TO "service_role";

GRANT EXECUTE ON FUNCTION "public"."fn_sync_puntos"() TO PUBLIC, "anon", "authenticated";

REVOKE ALL ON FUNCTION "public"."fn_sync_puntos"() FROM "postgres";

GRANT EXECUTE ON FUNCTION "public"."fn_sync_puntos"() TO "postgres";

GRANT EXECUTE ON FUNCTION "public"."fn_sync_puntos"() TO "service_role";

GRANT EXECUTE ON FUNCTION "public"."fn_transicion_estado"() TO PUBLIC, "anon", "authenticated";

REVOKE ALL ON FUNCTION "public"."fn_transicion_estado"() FROM "postgres";

GRANT EXECUTE ON FUNCTION "public"."fn_transicion_estado"() TO "postgres";

GRANT EXECUTE ON FUNCTION "public"."fn_transicion_estado"() TO "service_role";

GRANT EXECUTE ON FUNCTION "public"."fn_validar_cotizacion"() TO PUBLIC, "anon", "authenticated";

REVOKE ALL ON FUNCTION "public"."fn_validar_cotizacion"() FROM "postgres";

GRANT EXECUTE ON FUNCTION "public"."fn_validar_cotizacion"() TO "postgres";

GRANT EXECUTE ON FUNCTION "public"."fn_validar_cotizacion"() TO "service_role";

GRANT EXECUTE ON FUNCTION "public"."fn_validar_resena"() TO PUBLIC, "anon", "authenticated";

REVOKE ALL ON FUNCTION "public"."fn_validar_resena"() FROM "postgres";

GRANT EXECUTE ON FUNCTION "public"."fn_validar_resena"() TO "postgres";

GRANT EXECUTE ON FUNCTION "public"."fn_validar_resena"() TO "service_role";

GRANT EXECUTE ON FUNCTION "public"."fn_verificar_tecnico"() TO PUBLIC, "anon", "authenticated";

REVOKE ALL ON FUNCTION "public"."fn_verificar_tecnico"() FROM "postgres";

GRANT EXECUTE ON FUNCTION "public"."fn_verificar_tecnico"() TO "postgres";

GRANT EXECUTE ON FUNCTION "public"."fn_verificar_tecnico"() TO "service_role";

GRANT EXECUTE ON FUNCTION "public"."mi_rol"() TO "authenticated";

REVOKE ALL ON FUNCTION "public"."mi_rol"() FROM "postgres";

GRANT EXECUTE ON FUNCTION "public"."mi_rol"() TO "postgres";

GRANT EXECUTE ON FUNCTION "public"."mi_rol"() TO "service_role";

GRANT EXECUTE ON FUNCTION "public"."rls_auto_enable"() TO PUBLIC, "anon", "authenticated";

REVOKE ALL ON FUNCTION "public"."rls_auto_enable"() FROM "postgres";

GRANT EXECUTE ON FUNCTION "public"."rls_auto_enable"() TO "postgres";

GRANT EXECUTE ON FUNCTION "public"."rls_auto_enable"() TO "service_role";

GRANT EXECUTE ON FUNCTION "public"."solicitudes_cercanas"(uuid) TO PUBLIC, "anon", "authenticated";

REVOKE ALL ON FUNCTION "public"."solicitudes_cercanas"(uuid) FROM "postgres";

GRANT EXECUTE ON FUNCTION "public"."solicitudes_cercanas"(uuid) TO "postgres";

GRANT EXECUTE ON FUNCTION "public"."solicitudes_cercanas"(uuid) TO "service_role";

GRANT EXECUTE ON FUNCTION "public"."tecnicos_elegibles"(uuid) TO PUBLIC, "anon", "authenticated";

REVOKE ALL ON FUNCTION "public"."tecnicos_elegibles"(uuid) FROM "postgres";

GRANT EXECUTE ON FUNCTION "public"."tecnicos_elegibles"(uuid) TO "postgres";

GRANT EXECUTE ON FUNCTION "public"."tecnicos_elegibles"(uuid) TO "service_role";

GRANT EXECUTE ON FUNCTION "public"."validar_cedula"(text) TO PUBLIC, "anon", "authenticated";

REVOKE ALL ON FUNCTION "public"."validar_cedula"(text) FROM "postgres";

GRANT EXECUTE ON FUNCTION "public"."validar_cedula"(text) TO "postgres";

GRANT EXECUTE ON FUNCTION "public"."validar_cedula"(text) TO "service_role";

REVOKE ALL ON SEQUENCE "public"."auditoria_id_seq" FROM "anon";

GRANT SELECT, UPDATE, USAGE ON SEQUENCE "public"."auditoria_id_seq" TO "anon";

REVOKE ALL ON SEQUENCE "public"."auditoria_id_seq" FROM "authenticated";

GRANT SELECT, UPDATE, USAGE ON SEQUENCE "public"."auditoria_id_seq" TO "authenticated";

REVOKE ALL ON SEQUENCE "public"."auditoria_id_seq" FROM "postgres";

GRANT SELECT, UPDATE, USAGE ON SEQUENCE "public"."auditoria_id_seq" TO "postgres";

REVOKE ALL ON SEQUENCE "public"."auditoria_id_seq" FROM "service_role";

GRANT SELECT, UPDATE, USAGE ON SEQUENCE "public"."auditoria_id_seq" TO "service_role";

REVOKE ALL ON SEQUENCE "public"."niveles_gamificacion_id_seq" FROM "anon";

GRANT SELECT, UPDATE, USAGE ON SEQUENCE "public"."niveles_gamificacion_id_seq" TO "anon";

REVOKE ALL ON SEQUENCE "public"."niveles_gamificacion_id_seq" FROM "authenticated";

GRANT SELECT, UPDATE, USAGE ON SEQUENCE "public"."niveles_gamificacion_id_seq" TO "authenticated";

REVOKE ALL ON SEQUENCE "public"."niveles_gamificacion_id_seq" FROM "postgres";

GRANT SELECT, UPDATE, USAGE ON SEQUENCE "public"."niveles_gamificacion_id_seq" TO "postgres";

REVOKE ALL ON SEQUENCE "public"."niveles_gamificacion_id_seq" FROM "service_role";

GRANT SELECT, UPDATE, USAGE ON SEQUENCE "public"."niveles_gamificacion_id_seq" TO "service_role";

REVOKE ALL ON SEQUENCE "public"."oficios_id_seq" FROM "anon";

GRANT SELECT, UPDATE, USAGE ON SEQUENCE "public"."oficios_id_seq" TO "anon";

REVOKE ALL ON SEQUENCE "public"."oficios_id_seq" FROM "authenticated";

GRANT SELECT, UPDATE, USAGE ON SEQUENCE "public"."oficios_id_seq" TO "authenticated";

REVOKE ALL ON SEQUENCE "public"."oficios_id_seq" FROM "postgres";

GRANT SELECT, UPDATE, USAGE ON SEQUENCE "public"."oficios_id_seq" TO "postgres";

REVOKE ALL ON SEQUENCE "public"."oficios_id_seq" FROM "service_role";

GRANT SELECT, UPDATE, USAGE ON SEQUENCE "public"."oficios_id_seq" TO "service_role";

REVOKE ALL ON TABLE "public"."auditoria" FROM "authenticated";

GRANT SELECT ON TABLE "public"."auditoria" TO "authenticated";

REVOKE ALL ON TABLE "public"."auditoria" FROM "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."auditoria" TO "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."auditoria" TO "service_role";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."comisiones" TO "authenticated";

REVOKE ALL ON TABLE "public"."comisiones" FROM "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."comisiones" TO "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."comisiones" TO "service_role";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."conversaciones" TO "authenticated";

REVOKE ALL ON TABLE "public"."conversaciones" FROM "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."conversaciones" TO "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."conversaciones" TO "service_role";

REVOKE ALL ON TABLE "public"."cotizaciones" FROM "authenticated";

REVOKE ALL ("estado") ON TABLE "public"."cotizaciones" FROM "authenticated";

GRANT UPDATE ("estado") ON TABLE "public"."cotizaciones" TO "authenticated";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE ON TABLE "public"."cotizaciones" TO "authenticated";

REVOKE ALL ON TABLE "public"."cotizaciones" FROM "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."cotizaciones" TO "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."cotizaciones" TO "service_role";

REVOKE ALL ON TABLE "public"."documentos_historial" FROM "authenticated";

GRANT SELECT ON TABLE "public"."documentos_historial" TO "authenticated";

REVOKE ALL ON TABLE "public"."documentos_historial" FROM "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."documentos_historial" TO "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."documentos_historial" TO "service_role";

REVOKE ALL ON TABLE "public"."documentos_tecnico" FROM "authenticated";

REVOKE ALL ("estado") ON TABLE "public"."documentos_tecnico" FROM "authenticated";

GRANT UPDATE ("estado") ON TABLE "public"."documentos_tecnico" TO "authenticated";

REVOKE ALL ("revisado_en") ON TABLE "public"."documentos_tecnico" FROM "authenticated";

GRANT UPDATE ("revisado_en") ON TABLE "public"."documentos_tecnico" TO "authenticated";

REVOKE ALL ("revisado_por") ON TABLE "public"."documentos_tecnico" FROM "authenticated";

GRANT UPDATE ("revisado_por") ON TABLE "public"."documentos_tecnico" TO "authenticated";

REVOKE ALL ("ruta_archivo") ON TABLE "public"."documentos_tecnico" FROM "authenticated";

GRANT UPDATE ("ruta_archivo") ON TABLE "public"."documentos_tecnico" TO "authenticated";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE ON TABLE "public"."documentos_tecnico" TO "authenticated";

REVOKE ALL ON TABLE "public"."documentos_tecnico" FROM "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."documentos_tecnico" TO "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."documentos_tecnico" TO "service_role";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."eventos" TO "authenticated";

REVOKE ALL ON TABLE "public"."eventos" FROM "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."eventos" TO "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."eventos" TO "service_role";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."historial_puntos" TO "authenticated";

REVOKE ALL ON TABLE "public"."historial_puntos" FROM "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."historial_puntos" TO "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."historial_puntos" TO "service_role";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."identidades" TO "authenticated";

REVOKE ALL ON TABLE "public"."identidades" FROM "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."identidades" TO "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."identidades" TO "service_role";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."mensajes" TO "authenticated";

REVOKE ALL ON TABLE "public"."mensajes" FROM "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."mensajes" TO "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."mensajes" TO "service_role";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."niveles_gamificacion" TO "authenticated";

REVOKE ALL ON TABLE "public"."niveles_gamificacion" FROM "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."niveles_gamificacion" TO "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."niveles_gamificacion" TO "service_role";

REVOKE ALL ON TABLE "public"."notificaciones" FROM "authenticated";

REVOKE ALL ("leida") ON TABLE "public"."notificaciones" FROM "authenticated";

GRANT UPDATE ("leida") ON TABLE "public"."notificaciones" TO "authenticated";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE ON TABLE "public"."notificaciones" TO "authenticated";

REVOKE ALL ON TABLE "public"."notificaciones" FROM "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."notificaciones" TO "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."notificaciones" TO "service_role";

REVOKE ALL ON TABLE "public"."oficios" FROM "anon";

GRANT SELECT ON TABLE "public"."oficios" TO "anon";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."oficios" TO "authenticated";

REVOKE ALL ON TABLE "public"."oficios" FROM "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."oficios" TO "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."oficios" TO "service_role";

REVOKE ALL ON TABLE "public"."perfiles_tecnicos" FROM "authenticated";

REVOKE ALL ("rango_cobertura_m") ON TABLE "public"."perfiles_tecnicos" FROM "authenticated";

GRANT UPDATE ("rango_cobertura_m") ON TABLE "public"."perfiles_tecnicos" TO "authenticated";

REVOKE ALL ("tarifa_base") ON TABLE "public"."perfiles_tecnicos" FROM "authenticated";

GRANT UPDATE ("tarifa_base") ON TABLE "public"."perfiles_tecnicos" TO "authenticated";

REVOKE ALL ("ubicacion_actual") ON TABLE "public"."perfiles_tecnicos" FROM "authenticated";

GRANT UPDATE ("ubicacion_actual") ON TABLE "public"."perfiles_tecnicos" TO "authenticated";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE ON TABLE "public"."perfiles_tecnicos" TO "authenticated";

REVOKE ALL ON TABLE "public"."perfiles_tecnicos" FROM "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."perfiles_tecnicos" TO "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."perfiles_tecnicos" TO "service_role";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."resenas" TO "authenticated";

REVOKE ALL ON TABLE "public"."resenas" FROM "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."resenas" TO "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."resenas" TO "service_role";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."solicitud_archivos" TO "authenticated";

REVOKE ALL ON TABLE "public"."solicitud_archivos" FROM "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."solicitud_archivos" TO "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."solicitud_archivos" TO "service_role";

REVOKE ALL ON TABLE "public"."solicitudes_servicio" FROM "authenticated";

REVOKE ALL ("estado") ON TABLE "public"."solicitudes_servicio" FROM "authenticated";

GRANT UPDATE ("estado") ON TABLE "public"."solicitudes_servicio" TO "authenticated";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE ON TABLE "public"."solicitudes_servicio" TO "authenticated";

REVOKE ALL ON TABLE "public"."solicitudes_servicio" FROM "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."solicitudes_servicio" TO "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."solicitudes_servicio" TO "service_role";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."tecnico_oficios" TO "authenticated";

REVOKE ALL ON TABLE "public"."tecnico_oficios" FROM "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."tecnico_oficios" TO "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."tecnico_oficios" TO "service_role";

REVOKE ALL ON TABLE "public"."usuarios" FROM "authenticated";

REVOKE ALL ("apellidos") ON TABLE "public"."usuarios" FROM "authenticated";

GRANT UPDATE ("apellidos") ON TABLE "public"."usuarios" TO "authenticated";

REVOKE ALL ("foto_perfil_ruta") ON TABLE "public"."usuarios" FROM "authenticated";

GRANT UPDATE ("foto_perfil_ruta") ON TABLE "public"."usuarios" TO "authenticated";

REVOKE ALL ("nombres") ON TABLE "public"."usuarios" FROM "authenticated";

GRANT UPDATE ("nombres") ON TABLE "public"."usuarios" TO "authenticated";

REVOKE ALL ("ubicacion_registro") ON TABLE "public"."usuarios" FROM "authenticated";

GRANT UPDATE ("ubicacion_registro") ON TABLE "public"."usuarios" TO "authenticated";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE ON TABLE "public"."usuarios" TO "authenticated";

REVOKE ALL ON TABLE "public"."usuarios" FROM "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."usuarios" TO "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."usuarios" TO "service_role";

ALTER TABLE "public"."identidades"
  ADD CONSTRAINT "ck_identidades_cedula" CHECK (public.validar_cedula(cedula));

