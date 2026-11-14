-- El técnico confirma su identidad cada vez que envía una oferta: con la
-- biometría del celular (Face ID o huella) o, si no tiene, con su rostro
-- contra la foto de perfil (Edge Function verificar-rostro-postulacion).
create table public.verificaciones_postulacion (
  id uuid primary key default gen_random_uuid(),
  usuario_id uuid not null references public.usuarios(id) on delete cascade,
  metodo text not null check (metodo in ('biometria', 'rostro')),
  similitud numeric(5, 2),
  creado_en timestamptz not null default now(),
  usada_en timestamptz,
  cotizacion_id uuid
);

create index verificaciones_postulacion_usuario_idx
  on public.verificaciones_postulacion (usuario_id, creado_en desc);

alter table public.verificaciones_postulacion enable row level security;

create policy verificaciones_postulacion_lectura on public.verificaciones_postulacion
  for select to authenticated
  using (usuario_id = (select auth.uid()) or public.mi_rol() = 'admin');

-- Confirmación con la biometría del celular. El servidor no puede comprobarla:
-- la cadena de confianza es el rostro al iniciar sesión más el celular en
-- manos del técnico.
create or replace function public.registrar_verificacion_postulacion()
returns void
language plpgsql
security definer
set search_path to 'public'
as $$
begin
  if auth.uid() is null then raise exception 'Sesión requerida.'; end if;
  if public.mi_rol() is distinct from 'tecnico' then
    raise exception 'Solo los técnicos confirman su identidad para ofertar.';
  end if;
  insert into verificaciones_postulacion (usuario_id, metodo)
  values (auth.uid(), 'biometria');
end $$;

revoke all on function public.registrar_verificacion_postulacion() from public, anon;
grant execute on function public.registrar_verificacion_postulacion() to authenticated;

-- Cada oferta nueva consume una confirmación de los últimos 10 minutos.
create or replace function public.fn_exigir_verificacion_postulacion()
returns trigger
language plpgsql
security definer
set search_path to 'public'
as $$
declare v_id uuid;
begin
  if auth.uid() is null then
    return new;
  end if;
  select id into v_id
    from verificaciones_postulacion
   where usuario_id = new.tecnico_id
     and usada_en is null
     and creado_en > now() - interval '10 minutes'
   order by creado_en desc
   limit 1
   for update skip locked;
  if v_id is null then
    raise exception 'Confirma tu identidad para enviar la oferta.';
  end if;
  update verificaciones_postulacion
     set usada_en = now(), cotizacion_id = new.id
   where id = v_id;
  return new;
end $$;

drop trigger if exists trg_cotizacion_verificacion on public.cotizaciones;
create trigger trg_cotizacion_verificacion
  before insert on public.cotizaciones
  for each row execute function public.fn_exigir_verificacion_postulacion();
