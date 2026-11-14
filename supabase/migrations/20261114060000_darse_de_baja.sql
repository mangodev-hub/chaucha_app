alter table public.usuarios
  add column if not exists dado_de_baja_en timestamptz;

-- Una cuenta dada de baja nunca queda verificada (ni por documentos ni a mano).
create or replace function public.recalcular_verificacion(p_tecnico uuid)
returns void
language plpgsql
security definer
set search_path to 'public'
as $$
declare ok boolean;
begin
  select (select count(distinct tipo) = 3 from documentos_tecnico
           where tecnico_id = p_tecnico and estado = 'aprobada')
         and exists (select 1 from usuarios
                      where id = p_tecnico
                        and foto_rostro_validada
                        and foto_perfil_ruta is not null)
    into ok;
  ok := coalesce(ok, false)
        or coalesce((select verificado_manual from usuarios where id = p_tecnico), false);
  ok := ok and not exists (
    select 1 from usuarios where id = p_tecnico and dado_de_baja_en is not null
  );
  update usuarios set verificado = ok
   where id = p_tecnico and verificado is distinct from ok;
  update perfiles_tecnicos set verificado = ok
   where usuario_id = p_tecnico and verificado is distinct from ok;
end $$;

create or replace function public.darse_de_baja()
returns void
language plpgsql
security definer
set search_path to 'public'
as $$
declare
  v_uid uuid := auth.uid();
  v_cot cotizaciones%rowtype;
  v_cliente uuid;
begin
  if v_uid is null then raise exception 'Sesión requerida.'; end if;
  if public.mi_rol() = 'admin' then
    raise exception 'La cuenta de administrador no se puede dar de baja desde la app.';
  end if;
  if exists (select 1 from usuarios where id = v_uid and dado_de_baja_en is not null) then
    return;
  end if;

  -- Como cliente: visitas aceptadas (se avisa al técnico) y luego el resto de solicitudes activas.
  for v_cot in
    select c.* from cotizaciones c
      join solicitudes_servicio s on s.id = c.solicitud_id
     where s.cliente_id = v_uid and s.estado = 'aceptada' and c.estado = 'aceptada'
  loop
    update cotizaciones
       set estado = 'rechazada', mano_obra = null, materiales = 0,
           fecha_servicio = null, inicio_visita = null, fin_visita = null,
           reagenda_inicio = null, reagenda_por = null
     where id = v_cot.id;
    perform fn_aviso_visita(v_cot, v_uid, v_cot.tecnico_id, 'tarifa_cancelada',
      'El cliente se dio de baja y canceló la visita.', 'visita_cancelada');
  end loop;
  update solicitudes_servicio set estado = 'cancelada'
   where cliente_id = v_uid and estado in ('abierta', 'cotizada', 'aceptada');

  -- Como técnico: sus visitas aceptadas vuelven a recibir ofertas.
  for v_cot in
    select c.* from cotizaciones c
      join solicitudes_servicio s on s.id = c.solicitud_id
     where c.tecnico_id = v_uid and c.estado = 'aceptada' and s.estado = 'aceptada'
  loop
    select cliente_id into v_cliente from solicitudes_servicio where id = v_cot.solicitud_id;
    update cotizaciones
       set estado = 'rechazada', mano_obra = null, materiales = 0,
           fecha_servicio = null, inicio_visita = null, fin_visita = null,
           reagenda_inicio = null, reagenda_por = null
     where id = v_cot.id;
    update solicitudes_servicio set estado = 'cotizada' where id = v_cot.solicitud_id;
    perform fn_aviso_visita(v_cot, v_uid, v_cliente, 'tarifa_cancelada',
      'El técnico se dio de baja. Puedes elegir a otro técnico.', 'visita_cancelada');
  end loop;
  -- Y sus ofertas pendientes se retiran.
  update cotizaciones set estado = 'rechazada'
   where tecnico_id = v_uid and estado = 'pendiente';

  update usuarios set dado_de_baja_en = now() where id = v_uid;
  perform public.recalcular_verificacion(v_uid);
end $$;

revoke all on function public.darse_de_baja() from public, anon;
grant execute on function public.darse_de_baja() to authenticated;
