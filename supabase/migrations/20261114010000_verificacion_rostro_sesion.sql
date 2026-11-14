-- Verificación del rostro en cada inicio de sesión.

create table if not exists public.verificaciones_rostro_sesion (
  session_id uuid primary key references auth.sessions (id) on delete cascade,
  usuario_id uuid not null references public.usuarios (id) on delete cascade,
  intentos smallint not null default 0,
  ultima_similitud real,
  verificado_en timestamptz,
  creado_en timestamptz not null default now()
);

create index if not exists verificaciones_rostro_sesion_usuario_idx
  on public.verificaciones_rostro_sesion (usuario_id);

comment on table public.verificaciones_rostro_sesion is
  'Resultado de la verificación facial por sesión de login. Solo la escriben '
  'las Edge Functions con service role.';

-- Sin políticas: nadie la lee ni la escribe directo desde la app.
alter table public.verificaciones_rostro_sesion enable row level security;

-- ¿La sesión del JWT actual ya confirmó el rostro?
create or replace function public.rostro_sesion_verificado()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
      from verificaciones_rostro_sesion v
     where v.session_id = nullif(auth.jwt() ->> 'session_id', '')::uuid
       and v.usuario_id = (select auth.uid())
       and v.verificado_en is not null
  );
$$;

revoke execute on function public.rostro_sesion_verificado() from public, anon;
grant execute on function public.rostro_sesion_verificado() to authenticated;
