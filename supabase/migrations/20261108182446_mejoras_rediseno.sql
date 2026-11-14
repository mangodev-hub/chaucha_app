create or replace function public.fn_proteger_perfil_tecnico()
returns trigger language plpgsql as $$
begin
  if current_user = 'authenticated' and public.mi_rol() is distinct from 'admin'
     and (new.verificado is distinct from old.verificado
       or new.puntos is distinct from old.puntos
       or new.nivel_id is distinct from old.nivel_id
       or new.calificacion_promedio is distinct from old.calificacion_promedio
       or new.total_resenas is distinct from old.total_resenas) then
    raise exception 'No puedes modificar esos campos del perfil';
  end if;
  return new;
end $$;

create trigger trg_perfil_tecnico_proteger
  before update on public.perfiles_tecnicos
  for each row execute function public.fn_proteger_perfil_tecnico();

create or replace function public.fn_proteger_usuario()
returns trigger language plpgsql as $$
begin
  if current_user = 'authenticated' and public.mi_rol() is distinct from 'admin'
     and (new.rol is distinct from old.rol or new.id is distinct from old.id) then
    raise exception 'No puedes cambiar tu rol';
  end if;
  return new;
end $$;

create trigger trg_usuario_proteger
  before update on public.usuarios
  for each row execute function public.fn_proteger_usuario();

-- 2. Columnas nuevas
alter table public.usuarios add column ciudad text not null default 'Quito';
alter table public.usuarios add constraint ck_usuarios_ciudad
  check (char_length(ciudad) between 2 and 60);

alter table public.identidades add column codigo_dactilar text;
alter table public.identidades add constraint ck_identidades_dactilar
  check (codigo_dactilar is null or codigo_dactilar ~ '^[A-Z][0-9]{4}[A-Z][0-9]{4}$');

alter table public.perfiles_tecnicos drop constraint ck_perfiles_rango;
alter table public.perfiles_tecnicos add constraint ck_perfiles_rango
  check (rango_cobertura_m between 500 and 50000) not valid;

-- 3. Alta de usuario: acepta Google (sin cédula) y guarda código dactilar y ciudad
create or replace function public.fn_nuevo_usuario()
returns trigger language plpgsql security definer set search_path to 'public' as $function$
declare
  v_meta jsonb := coalesce(new.raw_user_meta_data, '{}'::jsonb);
  v_rol text := case when v_meta->>'rol' = 'tecnico' then 'tecnico' else 'cliente' end;
  v_cedula text := nullif(trim(v_meta->>'cedula'), '');
  v_dactilar text := nullif(upper(trim(v_meta->>'codigo_dactilar')), '');
  v_nombres text := coalesce(nullif(trim(v_meta->>'nombres'), ''),
                             nullif(trim(v_meta->>'full_name'), ''),
                             nullif(trim(v_meta->>'name'), ''),
                             split_part(new.email, '@', 1));
begin
  if v_cedula is null and coalesce(new.raw_app_meta_data->>'provider', 'email') = 'email' then
    raise exception 'La cedula es obligatoria y debe ser valida';
  end if;
  if v_cedula is not null and not validar_cedula(v_cedula) then
    raise exception 'La cedula es obligatoria y debe ser valida';
  end if;

  insert into usuarios (id, rol, nombres, apellidos, ciudad)
  values (new.id, v_rol, v_nombres, coalesce(v_meta->>'apellidos', ''),
          coalesce(nullif(trim(v_meta->>'ciudad'), ''), 'Quito'));

  if v_cedula is not null then
    insert into identidades (usuario_id, cedula, codigo_dactilar)
    values (new.id, v_cedula, v_dactilar);
    if v_rol = 'tecnico' then
      insert into perfiles_tecnicos (usuario_id) values (new.id);
    end if;
  end if;
  return new;
end $function$;

-- 4. Completar perfil (usuarios que entraron con Google)
create or replace function public.completar_perfil(
  p_cedula text, p_codigo_dactilar text, p_rol text, p_ciudad text default 'Quito'
) returns void language plpgsql security definer set search_path to 'public' as $$
declare v_uid uuid := auth.uid();
begin
  if v_uid is null then raise exception 'Sesion requerida'; end if;
  if p_rol not in ('cliente', 'tecnico') then raise exception 'Rol no permitido'; end if;
  if p_cedula is null or not validar_cedula(p_cedula) then
    raise exception 'La cedula es obligatoria y debe ser valida';
  end if;
  if exists (select 1 from identidades where usuario_id = v_uid) then
    raise exception 'El perfil ya esta completo';
  end if;

  insert into identidades (usuario_id, cedula, codigo_dactilar)
  values (v_uid, p_cedula, upper(nullif(trim(p_codigo_dactilar), '')));
  update usuarios set rol = p_rol, ciudad = coalesce(nullif(trim(p_ciudad), ''), 'Quito')
  where id = v_uid;
  if p_rol = 'tecnico' then
    insert into perfiles_tecnicos (usuario_id) values (v_uid) on conflict do nothing;
  end if;
end $$;

revoke all on function public.completar_perfil(text, text, text, text) from public, anon;
grant execute on function public.completar_perfil(text, text, text, text) to authenticated;

-- 5. Sin verificación no hay solicitudes ni cotizaciones
create or replace function public.es_tecnico_verificado()
returns boolean language sql stable security definer set search_path to 'public' as $$
  select exists (select 1 from perfiles_tecnicos
                 where usuario_id = (select auth.uid()) and verificado)
$$;
revoke all on function public.es_tecnico_verificado() from public, anon;
grant execute on function public.es_tecnico_verificado() to authenticated;

drop policy "solicitudes_lectura" on public.solicitudes_servicio;
create policy "solicitudes_lectura" on public.solicitudes_servicio
  for select to authenticated
  using (
    cliente_id = (select auth.uid())
    or public.mi_rol() = 'admin'
    or public.es_tecnico_cotizante(id)
    or (public.mi_rol() = 'tecnico'
        and public.es_tecnico_verificado()
        and estado in ('abierta', 'cotizada')
        and exists (select 1 from tecnico_oficios t
                    where t.tecnico_id = (select auth.uid())
                      and t.oficio_id = solicitudes_servicio.oficio_id))
  );

drop policy "cotizaciones_insert" on public.cotizaciones;
create policy "cotizaciones_insert" on public.cotizaciones
  for insert to authenticated
  with check (tecnico_id = (select auth.uid())
              and public.mi_rol() = 'tecnico'
              and public.es_tecnico_verificado()
              and estado = 'pendiente');

-- 6. Foto de perfil: solo en tu propia carpeta (perfiles/<uid>/...)
drop policy "perfiles_evidencias_subida" on storage.objects;
create policy "perfiles_subida_propia" on storage.objects
  for insert to authenticated
  with check (bucket_id = 'perfiles'
              and (storage.foldername(name))[1] = (select auth.uid())::text);
create policy "evidencias_subida" on storage.objects
  for insert to authenticated
  with check (bucket_id = 'evidencias');

-- 7. Home general: técnicos verificados cerca, con ubicación aproximada (~500 m)
create or replace function public.tecnicos_cercanos(
  p_lat double precision, p_lng double precision,
  p_oficio_id integer default null,
  p_radio_m integer default 10000,
  p_limite integer default 20
) returns table (
  tecnico_id uuid, nombres text, apellidos text, foto_perfil_ruta text,
  oficios text[], calificacion numeric, total_resenas integer,
  metros integer, lat double precision, lng double precision
) language sql stable security definer set search_path to 'public' as $$
  with centro as (select st_setsrid(st_makepoint(p_lng, p_lat), 4326)::geography as g)
  select p.usuario_id, u.nombres, u.apellidos, u.foto_perfil_ruta,
         array(select o.nombre from tecnico_oficios t
               join oficios o on o.id = t.oficio_id
               where t.tecnico_id = p.usuario_id order by o.nombre),
         p.calificacion_promedio, p.total_resenas,
         round(st_distance(p.ubicacion_actual, c.g))::int,
         st_y(st_snaptogrid(p.ubicacion_actual::geometry, 0.005)),
         st_x(st_snaptogrid(p.ubicacion_actual::geometry, 0.005))
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
$$;
revoke all on function public.tecnicos_cercanos(double precision, double precision, integer, integer, integer) from public, anon;
grant execute on function public.tecnicos_cercanos(double precision, double precision, integer, integer, integer) to authenticated;

-- 8. Reputación del solicitante (y de cualquiera) para mostrarla en las tarjetas
create or replace function public.reputaciones(p_ids uuid[])
returns table (usuario_id uuid, promedio numeric, total integer)
language sql stable security definer set search_path to 'public' as $$
  select destinatario_id, round(avg(calificacion), 2), count(*)::int
  from resenas where destinatario_id = any(p_ids)
  group by destinatario_id
$$;
revoke all on function public.reputaciones(uuid[]) from public, anon;
grant execute on function public.reputaciones(uuid[]) to authenticated;