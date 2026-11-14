-- Motivo que ve la persona cuando un documento se rechaza.
alter table public.documentos_tecnico
  add column if not exists observacion text;

-- Resultado de cada validación.
alter table public.comparaciones_rostro
  add column if not exists similitud numeric(5, 2),
  add column if not exists decision text
    check (decision in ('aprobada', 'revision', 'rechazada', 'datos')),
  add column if not exists datos jsonb;

-- Al reenviar un documento rechazado, el motivo anterior ya no aplica.
create or replace function public.fn_limpiar_observacion()
returns trigger
language plpgsql
set search_path to 'public'
as $$
begin
  if new.estado = 'pendiente' and old.estado is distinct from 'pendiente' then
    new.observacion := null;
  end if;
  return new;
end $$;

drop trigger if exists trg_documentos_observacion on public.documentos_tecnico;
create trigger trg_documentos_observacion
  before update on public.documentos_tecnico
  for each row execute function public.fn_limpiar_observacion();

drop policy if exists comparaciones_lectura_admin on public.comparaciones_rostro;
drop policy if exists comparaciones_lectura on public.comparaciones_rostro;
create policy comparaciones_lectura on public.comparaciones_rostro
  for select to authenticated
  using (usuario_id = (select auth.uid()) or public.mi_rol() = 'admin');

-- Corrige los datos del registro que no coincidieron con la cédula.
create or replace function public.corregir_datos_identidad(
  p_nombres text,
  p_apellidos text,
  p_cedula text,
  p_codigo_dactilar text
) returns void
language plpgsql
security definer
set search_path to 'public'
as $$
declare
  v_uid uuid := auth.uid();
  v_cedula text := trim(p_cedula);
  v_dactilar text := upper(nullif(trim(p_codigo_dactilar), ''));
begin
  if v_uid is null then raise exception 'Sesión requerida.'; end if;
  if not exists (select 1 from identidades where usuario_id = v_uid) then
    raise exception 'Primero completa tu perfil.';
  end if;
  if exists (select 1 from usuarios where id = v_uid and verificado) then
    raise exception 'Tu identidad ya está verificada; estos datos ya no se pueden cambiar.';
  end if;
  if coalesce(trim(p_nombres), '') = '' or coalesce(trim(p_apellidos), '') = '' then
    raise exception 'Ingresa tus nombres y apellidos.';
  end if;
  if v_cedula is null or not validar_cedula(v_cedula) then
    raise exception 'La cédula no es válida. Revisa los dígitos.';
  end if;
  if v_dactilar is not null and v_dactilar !~ '^[A-Z][0-9]{4}[A-Z][0-9]{4}$' then
    raise exception 'El código dactilar no es válido.';
  end if;
  if exists (select 1 from identidades where cedula = v_cedula and usuario_id <> v_uid) then
    raise exception 'Esa cédula ya está registrada en otra cuenta.';
  end if;

  update usuarios
     set nombres = trim(p_nombres), apellidos = trim(p_apellidos)
   where id = v_uid;
  update identidades
     set cedula = v_cedula, codigo_dactilar = v_dactilar
   where usuario_id = v_uid;
end $$;

revoke all on function public.corregir_datos_identidad(text, text, text, text) from public, anon;
grant execute on function public.corregir_datos_identidad(text, text, text, text) to authenticated;
