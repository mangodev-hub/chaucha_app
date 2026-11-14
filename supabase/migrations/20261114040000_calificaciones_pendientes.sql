create or replace function public.mis_calificaciones_pendientes()
returns table (
  solicitud_id uuid,
  destinatario_id uuid,
  nombre text,
  para_tecnico boolean,
  oficio text,
  completada_en timestamptz
)
language sql
stable
security definer
set search_path to 'public'
as $$
  -- Soy el cliente: califico al técnico de la cotización aceptada.
  select s.id, c.tecnico_id,
         trim(coalesce(u.nombres, '') || ' ' || coalesce(u.apellidos, '')),
         true, o.nombre, s.completada_en
    from solicitudes_servicio s
    join cotizaciones c on c.solicitud_id = s.id and c.estado = 'aceptada'
    join usuarios u on u.id = c.tecnico_id
    left join oficios o on o.id = s.oficio_id
   where s.cliente_id = (select auth.uid())
     and s.estado = 'completada'
     and s.completada_en > now() - interval '14 days'
     and not exists (
       select 1 from resenas r
        where r.solicitud_id = s.id and r.autor_id = (select auth.uid())
     )
  union all
  -- Soy el técnico: califico al cliente (nombre corto, como en las tarjetas).
  select s.id, s.cliente_id,
         trim(split_part(coalesce(u.nombres, ''), ' ', 1) || ' ' ||
              coalesce(left(u.apellidos, 1) || '.', '')),
         false, o.nombre, s.completada_en
    from solicitudes_servicio s
    join cotizaciones c on c.solicitud_id = s.id and c.estado = 'aceptada'
    join usuarios u on u.id = s.cliente_id
    left join oficios o on o.id = s.oficio_id
   where c.tecnico_id = (select auth.uid())
     and s.estado = 'completada'
     and s.completada_en > now() - interval '14 days'
     and not exists (
       select 1 from resenas r
        where r.solicitud_id = s.id and r.autor_id = (select auth.uid())
     )
  order by completada_en desc
$$;

revoke all on function public.mis_calificaciones_pendientes() from public, anon;
grant execute on function public.mis_calificaciones_pendientes() to authenticated;
