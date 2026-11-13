-- Panel de administrador.
--
-- Todo lo que el admin hace sobre otros usuarios pasa por funciones
-- `security definer` que primero comprueban `mi_rol() = 'admin'`. Ninguna
-- puede tocar a otro administrador. Los errores se lanzan con `raise
-- exception` (P0001) y la app muestra su mensaje tal cual.
--
-- Ya existían (esquema inicial): el admin lee todas las solicitudes, revisa
-- documentos (`documentos_revision_admin`) y lee las cédulas del bucket
-- privado. `fn_verificar_tecnico` marca al técnico como verificado cuando
-- sus 3 documentos quedan aprobados.

-- 1. Registro: una cuenta creada por SQL con `raw_app_meta_data.rol = admin`
--    queda como administrador y sin cédula. `raw_app_meta_data` no se puede
--    escribir desde la app (signUp solo escribe `raw_user_meta_data`), así
--    que nadie puede registrarse como admin.
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
  if new.raw_app_meta_data->>'rol' = 'admin' then
    insert into usuarios (id, rol, nombres, apellidos)
    values (new.id, 'admin', v_nombres, coalesce(v_meta->>'apellidos', ''));
    return new;
  end if;

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

-- 2. Comprobación común.
create or replace function public.exigir_admin()
returns void language plpgsql stable security definer set search_path to 'public' as $$
begin
  if public.mi_rol() is distinct from 'admin' then
    raise exception 'Solo el administrador puede hacer esto.';
  end if;
end $$;

create or replace function public.exigir_no_admin(p_id uuid)
returns void language plpgsql stable security definer set search_path to 'public' as $$
begin
  if not exists (select 1 from usuarios where id = p_id) then
    raise exception 'El usuario no existe.';
  end if;
  if exists (select 1 from usuarios where id = p_id and rol = 'admin') then
    raise exception 'No se puede modificar a un administrador.';
  end if;
end $$;

-- 3. Resumen del panel.
create or replace function public.admin_resumen()
returns jsonb language plpgsql stable security definer set search_path to 'public' as $$
begin
  perform public.exigir_admin();
  return jsonb_build_object(
    'clientes', (select count(*) from usuarios where rol = 'cliente'),
    'tecnicos', (select count(*) from usuarios where rol = 'tecnico'),
    'tecnicos_verificados', (select count(*) from perfiles_tecnicos where verificado),
    'solicitudes', (select count(*) from solicitudes_servicio),
    'solicitudes_abiertas',
      (select count(*) from solicitudes_servicio where estado in ('abierta', 'cotizada')),
    'verificaciones_pendientes',
      (select count(distinct tecnico_id) from documentos_tecnico where estado = 'pendiente')
  );
end $$;

-- 4. Usuarios con su correo y estado de acceso (están en auth.users, que la
--    app no puede leer directamente).
create or replace function public.admin_usuarios()
returns table (
  id uuid,
  email text,
  rol text,
  nombres text,
  apellidos text,
  ciudad text,
  cedula text,
  verificado boolean,
  suspendido boolean,
  creado_en timestamptz
) language plpgsql stable security definer set search_path to 'public' as $$
begin
  perform public.exigir_admin();
  return query
    select u.id, a.email::text, u.rol, u.nombres, u.apellidos, u.ciudad,
           i.cedula, p.verificado,
           coalesce(a.banned_until > now(), false),
           u.creado_en
    from usuarios u
    join auth.users a on a.id = u.id
    left join identidades i on i.usuario_id = u.id
    left join perfiles_tecnicos p on p.usuario_id = u.id
    order by u.creado_en desc;
end $$;

-- 5. Editar datos básicos.
create or replace function public.admin_actualizar_usuario(
  p_id uuid, p_nombres text, p_apellidos text, p_ciudad text
) returns void language plpgsql security definer set search_path to 'public' as $$
begin
  perform public.exigir_admin();
  perform public.exigir_no_admin(p_id);
  if nullif(trim(p_nombres), '') is null then
    raise exception 'Los nombres son obligatorios.';
  end if;
  update usuarios
  set nombres = trim(p_nombres),
      apellidos = coalesce(trim(p_apellidos), ''),
      ciudad = coalesce(nullif(trim(p_ciudad), ''), ciudad)
  where id = p_id;
end $$;

-- 6. Suspender o reactivar el acceso (Supabase rechaza el login de una
--    cuenta con `banned_until` en el futuro).
create or replace function public.admin_suspender_usuario(p_id uuid, p_suspendido boolean)
returns void language plpgsql security definer set search_path to 'public' as $$
begin
  perform public.exigir_admin();
  perform public.exigir_no_admin(p_id);
  update auth.users
  set banned_until = case when p_suspendido then 'infinity'::timestamptz else null end
  where id = p_id;
end $$;

-- 7. Eliminar: solo cuentas sin historial. Las que tienen solicitudes,
--    ofertas, chats o reseñas se suspenden (borrarlas rompería ese historial).
create or replace function public.admin_eliminar_usuario(p_id uuid)
returns void language plpgsql security definer set search_path to 'public' as $$
begin
  perform public.exigir_admin();
  perform public.exigir_no_admin(p_id);
  if exists (select 1 from solicitudes_servicio where cliente_id = p_id)
     or exists (select 1 from cotizaciones where tecnico_id = p_id)
     or exists (select 1 from conversaciones where tecnico_id = p_id)
     or exists (select 1 from mensajes where autor_id = p_id)
     or exists (select 1 from resenas where autor_id = p_id or destinatario_id = p_id)
     or exists (select 1 from historial_puntos where tecnico_id = p_id) then
    raise exception 'Este usuario tiene solicitudes, ofertas o reseñas. Suspéndelo en lugar de eliminarlo.';
  end if;
  -- Borra en cascada usuarios, identidades, perfil y documentos.
  delete from auth.users where id = p_id;
exception
  when foreign_key_violation then
    raise exception 'Este usuario tiene datos relacionados. Suspéndelo en lugar de eliminarlo.';
end $$;

-- 8. Permisos: solo usuarios conectados (las funciones exigen además el rol).
revoke all on function public.exigir_admin() from public, anon;
revoke all on function public.exigir_no_admin(uuid) from public, anon, authenticated;
revoke all on function public.admin_resumen() from public, anon;
revoke all on function public.admin_usuarios() from public, anon;
revoke all on function public.admin_actualizar_usuario(uuid, text, text, text) from public, anon;
revoke all on function public.admin_suspender_usuario(uuid, boolean) from public, anon;
revoke all on function public.admin_eliminar_usuario(uuid) from public, anon;

grant execute on function public.exigir_admin() to authenticated;
grant execute on function public.admin_resumen() to authenticated;
grant execute on function public.admin_usuarios() to authenticated;
grant execute on function public.admin_actualizar_usuario(uuid, text, text, text) to authenticated;
grant execute on function public.admin_suspender_usuario(uuid, boolean) to authenticated;
grant execute on function public.admin_eliminar_usuario(uuid) to authenticated;
