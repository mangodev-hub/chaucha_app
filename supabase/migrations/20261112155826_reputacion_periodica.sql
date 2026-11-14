-- Tareas programadas (pg_cron): reputación reciente.

alter table public.perfiles_tecnicos
  add column rango_bonus_m integer not null default 0,
  add constraint ck_perfiles_rango_bonus check (rango_bonus_m between 0 and 5000);

alter table public.usuarios
  add column es_vip boolean not null default false;

-- Búsquedas por distancia con el rango efectivo (mismas firmas que antes).
create or replace function public.solicitudes_cercanas(p_tecnico uuid)
  returns table(solicitud_id uuid, descripcion text, metros integer, creado_en timestamp with time zone)
  language sql
  stable
as $$
  select s.id, s.descripcion, round(st_distance(s.ubicacion, p.ubicacion_actual))::int, s.creado_en
  from perfiles_tecnicos p
  join tecnico_oficios t on t.tecnico_id = p.usuario_id
  join solicitudes_servicio s on s.oficio_id = t.oficio_id
  where p.usuario_id = p_tecnico
    and s.estado = 'abierta'
    and st_dwithin(s.ubicacion, p.ubicacion_actual, least(p.rango_cobertura_m + p.rango_bonus_m, 50000))
  order by 3;
$$;

create or replace function public.tecnicos_elegibles(p_solicitud uuid)
  returns table(tecnico_id uuid, nombre text, nivel text, prioridad integer, calificacion numeric, metros integer)
  language sql
  stable
as $$
  select p.usuario_id, trim(u.nombres || ' ' || u.apellidos), n.nombre, n.prioridad, p.calificacion_promedio,
         round(st_distance(s.ubicacion, p.ubicacion_actual))::int
  from solicitudes_servicio s
  join tecnico_oficios t on t.oficio_id = s.oficio_id
  join perfiles_tecnicos p on p.usuario_id = t.tecnico_id
  join usuarios u on u.id = p.usuario_id
  join niveles_gamificacion n on n.id = p.nivel_id
  where s.id = p_solicitud
    and st_dwithin(s.ubicacion, p.ubicacion_actual, least(p.rango_cobertura_m + p.rango_bonus_m, 50000))
  order by n.prioridad desc, 6;
$$;

-- Recalcula ambos indicadores.
create or replace function public.recalcular_reputacion_reciente()
  returns jsonb
  language plpgsql
  security definer
  set search_path to 'public'
as $$
declare
  v_rangos integer;
  v_vip    integer;
begin
  with calculo as (
    select p.usuario_id,
           least(5000, 500 * count(r.id))::int as bono
    from perfiles_tecnicos p
    left join resenas r
      on r.destinatario_id = p.usuario_id
     and r.valoracion = 'excelente'
     and r.creado_en > now() - interval '90 days'
    group by p.usuario_id
  )
  update perfiles_tecnicos p
  set rango_bonus_m = c.bono
  from calculo c
  where c.usuario_id = p.usuario_id
    and p.rango_bonus_m is distinct from c.bono;
  get diagnostics v_rangos = row_count;

  with cerrados as (
    select s.cliente_id, count(*) as total
    from eventos e
    join solicitudes_servicio s on s.id = (e.payload->>'solicitud_id')::uuid
    where e.tipo = 'negocio_cerrado'
      and e.creado_en > now() - interval '90 days'
    group by s.cliente_id
  ), calculo as (
    select u.id,
           coalesce(c.total, 0) >= 5
           and not exists (
             select 1 from resenas r
             where r.destinatario_id = u.id
               and r.valoracion = 'malo'
               and r.creado_en > now() - interval '90 days'
           ) as vip
    from usuarios u
    left join cerrados c on c.cliente_id = u.id
    where u.rol = 'cliente'
  )
  update usuarios u
  set es_vip = c.vip
  from calculo c
  where c.id = u.id
    and u.es_vip is distinct from c.vip;
  get diagnostics v_vip = row_count;

  insert into eventos (tipo, payload)
  values ('reputacion_recalculada', jsonb_build_object('rangos', v_rangos, 'vip', v_vip));
  return jsonb_build_object('rangos', v_rangos, 'vip', v_vip);
end $$;

revoke all on function public.recalcular_reputacion_reciente() from public, anon, authenticated;

-- 05:30 UTC = 00:30 en Ecuador, después de la expiración de solicitudes.
select cron.schedule(
  'recalcular-reputacion',
  '30 5 * * *',
  $$select public.recalcular_reputacion_reciente()$$
);

-- Primera pasada para no esperar a la noche.
select public.recalcular_reputacion_reciente();
