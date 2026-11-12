-- Propuesta pendiente de reagendado (una a la vez por cotización)
alter table cotizaciones
  add column if not exists fecha_propuesta timestamptz,
  add column if not exists propuesta_por uuid references usuarios(id);

-- ¿La fecha choca con otra visita del técnico o del cliente? (visita = 1 hora)
create or replace function public._visita_choca(p_cot uuid, p_fecha timestamptz)
returns boolean language sql stable security definer set search_path = public as $$
  with c as (
    select c.tecnico_id, s.cliente_id
    from cotizaciones c join solicitudes_servicio s on s.id = c.solicitud_id
    where c.id = p_cot
  )
  select exists (
    select 1
    from c cross join cotizaciones o
    join solicitudes_servicio so on so.id = o.solicitud_id
    where o.id <> p_cot
      and o.estado = 'aceptada'
      and so.estado in ('aceptada','por_confirmar')
      and o.fecha_servicio is not null
      and (o.tecnico_id = c.tecnico_id or so.cliente_id = c.cliente_id)
      and abs(extract(epoch from (o.fecha_servicio - p_fecha))) < 3600
  );
$$;

-- Aviso por chat + notificación
create or replace function public._avisar_visita(
  p_solicitud uuid, p_tecnico uuid, p_autor uuid, p_destino uuid,
  p_tipo text, p_texto text)
returns void language plpgsql security definer set search_path = public as $$
declare v_conv uuid;
begin
  select id into v_conv from conversaciones
   where solicitud_id = p_solicitud and tecnico_id = p_tecnico;
  if v_conv is not null then
    insert into mensajes (conversacion_id, autor_id, contenido)
    values (v_conv, p_autor, p_texto);
  end if;
  insert into notificaciones (usuario_id, tipo, referencia_id, contenido)
  values (p_destino, p_tipo, p_solicitud, p_texto);
end $$;

-- 1) Proponer nueva fecha
create or replace function public.reagendar_visita(p_cotizacion uuid, p_nueva_fecha timestamptz)
returns void language plpgsql security definer set search_path = public as $$
declare
  v record;
  v_yo uuid := auth.uid();
  v_otro uuid;
begin
  select c.estado, c.fecha_servicio, c.tecnico_id, c.solicitud_id,
         c.propuesta_por, c.fecha_propuesta,
         s.cliente_id, s.estado as sol_estado
    into v
    from cotizaciones c join solicitudes_servicio s on s.id = c.solicitud_id
   where c.id = p_cotizacion;

  if not found then raise exception 'La cotización no existe'; end if;
  if v_yo is null or v_yo not in (v.tecnico_id, v.cliente_id) then
    raise exception 'No participas en esta visita'; end if;
  if v.estado <> 'aceptada' or v.sol_estado <> 'aceptada' then
    raise exception 'La visita ya no se puede reagendar'; end if;
  if v.fecha_servicio - now() < interval '2 hours' then
    raise exception 'Falta muy poco para la visita'; end if;
  if p_nueva_fecha <= now() then
    raise exception 'La nueva fecha debe ser futura'; end if;
  if v.propuesta_por is not null and v.propuesta_por <> v_yo
     and v.fecha_propuesta > now() then
    raise exception 'Primero responde la propuesta pendiente'; end if;
  if _visita_choca(p_cotizacion, p_nueva_fecha) then
    raise exception 'Ese horario choca con otra visita'; end if;

  v_otro := case when v_yo = v.tecnico_id then v.cliente_id else v.tecnico_id end;

  update cotizaciones
     set fecha_propuesta = p_nueva_fecha, propuesta_por = v_yo
   where id = p_cotizacion;

  perform _avisar_visita(v.solicitud_id, v.tecnico_id, v_yo, v_otro,
    'reagendado_propuesto',
    'Propuse reagendar la visita para el ' ||
    to_char(p_nueva_fecha at time zone 'America/Guayaquil', 'DD/MM HH24:MI') ||
    '. ¿Aceptas?');
end $$;

-- 2) Aceptar o rechazar la propuesta (solo la otra persona)
create or replace function public.responder_reagendado(p_cotizacion uuid, p_acepta boolean)
returns void language plpgsql security definer set search_path = public as $$
declare
  v record;
  v_yo uuid := auth.uid();
begin
  select c.estado, c.fecha_servicio, c.tecnico_id, c.solicitud_id,
         c.propuesta_por, c.fecha_propuesta, s.cliente_id
    into v
    from cotizaciones c join solicitudes_servicio s on s.id = c.solicitud_id
   where c.id = p_cotizacion;

  if not found then raise exception 'La cotización no existe'; end if;
  if v.propuesta_por is null then raise exception 'No hay propuesta pendiente'; end if;
  if v_yo is null or v_yo not in (v.tecnico_id, v.cliente_id)
     or v_yo = v.propuesta_por then
    raise exception 'Solo la otra persona puede responder'; end if;
  if v.estado <> 'aceptada' then raise exception 'La visita ya no está activa'; end if;

  if p_acepta then
    if v.fecha_propuesta <= now() then raise exception 'La propuesta ya venció'; end if;
    if _visita_choca(p_cotizacion, v.fecha_propuesta) then
      raise exception 'Ese horario ya no está disponible'; end if;
    update cotizaciones
       set fecha_servicio = v.fecha_propuesta,
           fecha_propuesta = null, propuesta_por = null
     where id = p_cotizacion;
  else
    update cotizaciones
       set fecha_propuesta = null, propuesta_por = null
     where id = p_cotizacion;
  end if;

  perform _avisar_visita(v.solicitud_id, v.tecnico_id, v_yo, v.propuesta_por,
    case when p_acepta then 'reagendado_aceptado' else 'reagendado_rechazado' end,
    case when p_acepta then 'Acepté el nuevo horario de la visita.'
         else 'No puedo en ese horario; la visita se mantiene como estaba.' end);
end $$;

-- 3) El técnico cancela la visita
create or replace function public.cancelar_visita(p_cotizacion uuid)
returns void language plpgsql security definer set search_path = public as $$
declare
  v record;
  v_yo uuid := auth.uid();
  v_nuevo text;
begin
  select c.estado, c.tecnico_id, c.solicitud_id, s.cliente_id, s.estado as sol_estado
    into v
    from cotizaciones c join solicitudes_servicio s on s.id = c.solicitud_id
   where c.id = p_cotizacion;

  if not found then raise exception 'La cotización no existe'; end if;
  if v_yo is distinct from v.tecnico_id then
    raise exception 'Solo el técnico puede cancelar así'; end if;
  if v.estado <> 'aceptada' or v.sol_estado <> 'aceptada' then
    raise exception 'La visita ya no se puede cancelar'; end if;

  update cotizaciones
     set estado = 'rechazada', fecha_propuesta = null, propuesta_por = null
   where id = p_cotizacion;

  -- si ya no queda ninguna oferta pendiente, vuelve a abierta para recibir nuevas
  select case when exists (
           select 1 from cotizaciones
            where solicitud_id = v.solicitud_id and estado = 'pendiente')
         then 'cotizada' else 'abierta' end
    into v_nuevo;

  update solicitudes_servicio set estado = v_nuevo where id = v.solicitud_id;

  perform _avisar_visita(v.solicitud_id, v.tecnico_id, v_yo, v.cliente_id,
    'visita_cancelada',
    'Tuve que cancelar la visita. Tu solicitud sigue publicada para que elijas a otro técnico.');
end $$;

revoke all on function public._visita_choca(uuid, timestamptz) from public, anon, authenticated;
revoke all on function public._avisar_visita(uuid, uuid, uuid, uuid, text, text) from public, anon, authenticated;
grant execute on function public.reagendar_visita(uuid, timestamptz) to authenticated;
grant execute on function public.responder_reagendado(uuid, boolean) to authenticated;
grant execute on function public.cancelar_visita(uuid) to authenticated;