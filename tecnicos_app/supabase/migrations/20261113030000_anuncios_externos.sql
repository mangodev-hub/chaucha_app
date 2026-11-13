-- Publicidad solo de negocios externos: nombre del anunciante y categoría
-- (para el ícono de la pieza). Ya aplicado directo en la base (2026-11-13);
-- este archivo lo deja registrado. `ubicacion = 'general'` sale en todas las
-- pantallas.
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
