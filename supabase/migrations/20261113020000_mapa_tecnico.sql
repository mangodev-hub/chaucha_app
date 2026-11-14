-- Mapa del inicio del técnico.

-- Solicitudes abiertas de mis oficios dentro de mi radio (más el bonus del nivel, tope 50 km).
create or replace function public.solicitudes_en_mapa()
returns table (
  solicitud_id uuid, descripcion text, oficio_id integer, metros integer,
  lat double precision, lng double precision, creado_en timestamptz
)
language sql stable set search_path to 'public' as $$
  select s.id, s.descripcion, s.oficio_id,
         round(st_distance(s.ubicacion, p.ubicacion_actual))::int,
         st_y(s.ubicacion::geometry), st_x(s.ubicacion::geometry), s.creado_en
  from perfiles_tecnicos p
  join tecnico_oficios t on t.tecnico_id = p.usuario_id
  join solicitudes_servicio s on s.oficio_id = t.oficio_id
  where p.usuario_id = auth.uid()
    and p.verificado
    and s.estado = 'abierta'
    and st_dwithin(s.ubicacion, p.ubicacion_actual, least(p.rango_cobertura_m + p.rango_bonus_m, 50000))
  order by 4;
$$;

-- Guarda mi radio de cobertura (1 a 30 km).
create or replace function public.actualizar_mi_radio(p_metros integer)
returns void language plpgsql security definer set search_path to 'public' as $$
begin
  if p_metros not between 1000 and 30000 then
    raise exception 'El radio debe estar entre 1 y 30 km.';
  end if;
  update perfiles_tecnicos set rango_cobertura_m = p_metros where usuario_id = auth.uid();
  if not found then raise exception 'Solo los técnicos pueden ajustar su radio.'; end if;
end $$;

revoke all on function public.solicitudes_en_mapa() from public, anon;
revoke all on function public.actualizar_mi_radio(integer) from public, anon;
grant execute on function public.solicitudes_en_mapa() to authenticated;
grant execute on function public.actualizar_mi_radio(integer) to authenticated;
