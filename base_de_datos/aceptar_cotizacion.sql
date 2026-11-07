-- Función RPC aceptar_cotizacion.
--
-- Acepta una cotización, rechaza las demás pendientes de la misma solicitud y
-- marca la solicitud como aceptada, todo en una sola transacción. Solo puede
-- llamarla el cliente dueño de la solicitud (cliente_id = auth.uid()).
--
-- Corre con los permisos del usuario que la llama (SECURITY INVOKER, el valor
-- por defecto de Postgres), así que también respeta las políticas RLS.
--
-- Es una copia de lo que está desplegado en Supabase, extraída de
-- tecnicos_app/supabase/migrations/20261107204355_remote_schema.sql.
-- La usa SupabaseCotizacionRepository.aceptar en la app.

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

GRANT EXECUTE ON FUNCTION "public"."aceptar_cotizacion"(uuid) TO "authenticated";
