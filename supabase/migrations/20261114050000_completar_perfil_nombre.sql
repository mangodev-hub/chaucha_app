drop function if exists public.completar_perfil(text, text, text, text);

create or replace function public.completar_perfil(
  p_cedula text,
  p_codigo_dactilar text,
  p_rol text,
  p_ciudad text default 'Quito',
  p_nombres text default null,
  p_apellidos text default null
) returns void
language plpgsql
security definer
set search_path to 'public'
as $$
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
  if p_nombres is not null and trim(p_nombres) = '' then
    raise exception 'Ingresa tus nombres como aparecen en tu cédula.';
  end if;
  if p_apellidos is not null and trim(p_apellidos) = '' then
    raise exception 'Ingresa tus apellidos como aparecen en tu cédula.';
  end if;
  if exists (select 1 from identidades where cedula = trim(p_cedula)) then
    raise exception 'Esa cédula ya está registrada en otra cuenta.';
  end if;

  insert into identidades (usuario_id, cedula, codigo_dactilar)
  values (v_uid, trim(p_cedula), upper(nullif(trim(p_codigo_dactilar), '')));
  update usuarios
     set rol = p_rol,
         ciudad = coalesce(nullif(trim(p_ciudad), ''), 'Quito'),
         nombres = coalesce(nullif(trim(p_nombres), ''), nombres),
         apellidos = coalesce(nullif(trim(p_apellidos), ''), apellidos)
   where id = v_uid;
  if p_rol = 'tecnico' then
    insert into perfiles_tecnicos (usuario_id) values (v_uid) on conflict do nothing;
  end if;
end $$;

revoke all on function public.completar_perfil(text, text, text, text, text, text) from public, anon;
grant execute on function public.completar_perfil(text, text, text, text, text, text) to authenticated;
