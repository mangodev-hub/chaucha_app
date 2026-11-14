alter table public.usuarios
  add column if not exists verificacion_vista boolean not null default false;

-- Quienes ya estaban verificados no ven la celebración de golpe.
update public.usuarios set verificacion_vista = true where verificado;

create or replace function public.fn_reiniciar_verificacion_vista()
returns trigger
language plpgsql
set search_path to 'public'
as $$
begin
  if not new.verificado and old.verificado then
    new.verificacion_vista := false;
  end if;
  return new;
end $$;

drop trigger if exists trg_usuario_verificacion_vista on public.usuarios;
create trigger trg_usuario_verificacion_vista
  before update on public.usuarios
  for each row execute function public.fn_reiniciar_verificacion_vista();
