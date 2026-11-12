-- Tareas programadas (pg_cron): expiración automática de solicitudes.
--
-- Cada noche se cancelan las solicitudes que llevan más de 30 días sin
-- técnico asignado (estado `abierta` o `cotizada`, es decir, sin cotización
-- aceptada). Al pasar a `cancelada`:
--   - trg_solicitud_cierra_propuestas rechaza las cotizaciones pendientes;
--   - se avisa al cliente con una notificación (y por push, vía trg_notificacion_push).
-- Las solicitudes con visita agendada (`aceptada`, `por_confirmar`) no se tocan.

create extension if not exists pg_cron;

create or replace function public.expirar_solicitudes_viejas(p_dias integer default 30)
  returns integer
  language plpgsql
  security definer
  set search_path to 'public'
as $$
declare
  v_total integer;
begin
  with expiradas as (
    update solicitudes_servicio
    set estado = 'cancelada'
    where estado in ('abierta', 'cotizada')
      and creado_en < now() - make_interval(days => p_dias)
    returning id, cliente_id, descripcion
  ), avisos as (
    insert into notificaciones (usuario_id, tipo, referencia_id, contenido)
    select cliente_id, 'solicitud_expirada', id,
           'Tu solicitud "' || left(descripcion, 40) || '" expiró tras '
             || p_dias || ' días sin técnico asignado'
    from expiradas
    returning 1
  )
  select count(*) into v_total from avisos;

  if v_total > 0 then
    insert into eventos (tipo, payload)
    values ('solicitudes_expiradas', jsonb_build_object('total', v_total, 'dias', p_dias));
  end if;
  return v_total;
end $$;

-- Solo la ejecuta el cron (rol postgres) o un admin desde el SQL editor.
revoke all on function public.expirar_solicitudes_viejas(integer) from public, anon, authenticated;

-- 05:00 UTC = 00:00 en Ecuador. Reprogramar con el mismo nombre lo reemplaza.
select cron.schedule(
  'expirar-solicitudes',
  '0 5 * * *',
  $$select public.expirar_solicitudes_viejas(30)$$
);
