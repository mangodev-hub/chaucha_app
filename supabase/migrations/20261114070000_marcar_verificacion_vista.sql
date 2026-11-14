-- usuarios tiene permisos de UPDATE por columna: la marca se pone con una
-- función en lugar de abrir la columna.
create or replace function public.marcar_verificacion_vista()
returns void
language sql
security definer
set search_path to 'public'
as $$
  update usuarios set verificacion_vista = true where id = auth.uid();
$$;

revoke all on function public.marcar_verificacion_vista() from public, anon;
grant execute on function public.marcar_verificacion_vista() to authenticated;
