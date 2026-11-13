create or replace function public.enviar_tarifa(
  p_cotizacion_id uuid, p_mano_obra numeric, p_materiales numeric,
  p_fecha_servicio timestamptz
) returns void language plpgsql security definer set search_path to 'public' as $$
declare
  v_uid uuid := auth.uid();
  v_cot cotizaciones%rowtype;
  v_estado text;
  v_conv uuid;
  v_cliente uuid;
  v_mat numeric := coalesce(p_materiales, 0);
  v_fecha text;
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
     set mano_obra = p_mano_obra, materiales = v_mat, fecha_servicio = p_fecha_servicio
   where id = p_cotizacion_id;

  v_fecha := to_char(p_fecha_servicio at time zone 'America/Guayaquil', 'DD/MM/YYYY "a las" HH24:MI');

  insert into mensajes (conversacion_id, autor_id, contenido, tipo, datos)
  values (
    v_conv, v_uid,
    format('Ticket enviado: mano de obra $%s + materiales $%s = total $%s, para el %s.',
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
end $$;

create or replace function public.cancelar_tarifa(p_cotizacion_id uuid)
returns void language plpgsql security definer set search_path to 'public' as $$
declare
  v_uid uuid := auth.uid();
  v_cot cotizaciones%rowtype;
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
     set estado = 'pendiente', mano_obra = null, materiales = 0, fecha_servicio = null
   where id = p_cotizacion_id;
  update solicitudes_servicio set estado = 'cotizada' where id = v_cot.solicitud_id;

  insert into mensajes (conversacion_id, autor_id, contenido, tipo, datos)
  select c.id, v_uid, 'El cliente cancelo la confirmacion del ticket. Pueden seguir hablando en el chat.',
         'sistema', jsonb_build_object('accion', 'tarifa_cancelada', 'cotizacion_id', p_cotizacion_id)
  from conversaciones c
  where c.solicitud_id = v_cot.solicitud_id and c.tecnico_id = v_cot.tecnico_id;

  insert into notificaciones (usuario_id, tipo, referencia_id, contenido)
  values (v_cot.tecnico_id, 'tarifa_cancelada', p_cotizacion_id, 'El cliente cancelo la confirmacion del ticket');
end $$;

create or replace function public.rechazar_tarifa(p_cotizacion_id uuid)
returns void language plpgsql security definer set search_path to 'public' as $$
declare
  v_uid uuid := auth.uid();
  v_cot cotizaciones%rowtype;
begin
  if v_uid is null then raise exception 'Sesion requerida'; end if;

  select * into v_cot from cotizaciones where id = p_cotizacion_id for update;
  if not found then raise exception 'La propuesta no existe.'; end if;

  perform 1 from solicitudes_servicio
   where id = v_cot.solicitud_id and cliente_id = v_uid for update;
  if not found then raise exception 'No tienes permiso sobre esta solicitud.'; end if;

  if v_cot.estado <> 'pendiente' or not v_cot.tarifa_enviada then
    raise exception 'No hay un ticket pendiente que rechazar.';
  end if;

  update cotizaciones
     set mano_obra = null, materiales = 0, fecha_servicio = null
   where id = p_cotizacion_id;

  insert into mensajes (conversacion_id, autor_id, contenido, tipo, datos)
  select c.id, v_uid, 'El cliente rechazo el ticket. Pueden seguir hablando para acordar el precio.',
         'sistema', jsonb_build_object('accion', 'tarifa_rechazada', 'cotizacion_id', p_cotizacion_id)
  from conversaciones c
  where c.solicitud_id = v_cot.solicitud_id and c.tecnico_id = v_cot.tecnico_id;

  insert into notificaciones (usuario_id, tipo, referencia_id, contenido)
  values (v_cot.tecnico_id, 'tarifa_cancelada', p_cotizacion_id, 'El cliente rechazo el ticket');
end $$;

revoke all on function public.rechazar_tarifa(uuid) from public, anon;
grant execute on function public.rechazar_tarifa(uuid) to authenticated;