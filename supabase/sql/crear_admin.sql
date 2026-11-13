-- Crea la cuenta del administrador (una sola vez).
--
-- Requiere haber aplicado antes la migración
-- `supabase/migrations/20261109150000_panel_admin.sql`.
--
-- Cómo usarlo: copia este archivo en el editor SQL de Supabase, reemplaza
-- CORREO_DEL_ADMIN y CONTRASEÑA_DEL_ADMIN y ejecútalo. No guardes la
-- contraseña real en este archivo: el repositorio la expondría.
--
-- La cuenta queda con el correo confirmado y `raw_app_meta_data.rol = admin`,
-- así que entra por el login normal, sin cédula ni verificación, y la app la
-- lleva a /admin. Nadie puede crear una cuenta así desde la app: signUp no
-- puede escribir `raw_app_meta_data`.
do $$
declare
  v_email text := 'CORREO_DEL_ADMIN';
  v_password text := 'CONTRASEÑA_DEL_ADMIN';
  v_id uuid := gen_random_uuid();
begin
  if exists (select 1 from auth.users where email = v_email) then
    raise exception 'Ya existe una cuenta con el correo %', v_email;
  end if;

  insert into auth.users (
    instance_id, id, aud, role, email, encrypted_password,
    email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
    created_at, updated_at,
    confirmation_token, recovery_token, email_change, email_change_token_new
  ) values (
    '00000000-0000-0000-0000-000000000000', v_id, 'authenticated',
    'authenticated', v_email,
    extensions.crypt(v_password, extensions.gen_salt('bf')),
    now(),
    jsonb_build_object('provider', 'email', 'providers', jsonb_build_array('email'), 'rol', 'admin'),
    jsonb_build_object('nombres', 'Administrador', 'apellidos', 'ChauchaApp'),
    now(), now(),
    '', '', '', ''
  );

  insert into auth.identities (
    id, user_id, provider_id, provider, identity_data,
    last_sign_in_at, created_at, updated_at
  ) values (
    gen_random_uuid(), v_id, v_id::text, 'email',
    jsonb_build_object('sub', v_id::text, 'email', v_email, 'email_verified', true),
    now(), now(), now()
  );
end $$;

-- Comprobación: debe devolver una fila con rol 'admin'.
-- select u.id, a.email, u.rol from public.usuarios u
-- join auth.users a on a.id = u.id where u.rol = 'admin';
