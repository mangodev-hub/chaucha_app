alter table public.anuncios add column if not exists anunciante text;
alter table public.anuncios add column if not exists categoria text not null default 'otro';

do $$
begin
  if not exists (
    select 1 from pg_constraint
    where conrelid = 'public.anuncios'::regclass and contype = 'c'
      and pg_get_constraintdef(oid) like '%categoria%'
  ) then
    alter table public.anuncios add constraint anuncios_categoria_check
      check (categoria in ('ferreteria','restaurante','cafeteria','pinturas',
                           'lavanderia','materiales','otro'));
  end if;
end $$;
