create table public.comparaciones_rostro (
  id uuid primary key default gen_random_uuid(),
  usuario_id uuid not null references public.usuarios(id) on delete cascade,
  misma_persona boolean,
  confianza int,
  motivo text,
  creado_en timestamptz not null default now()
);

create index comparaciones_rostro_usuario_idx on public.comparaciones_rostro (usuario_id, creado_en desc);

alter table public.comparaciones_rostro enable row level security;