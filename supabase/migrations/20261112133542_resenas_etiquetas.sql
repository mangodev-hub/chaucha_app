alter table public.resenas add column etiquetas text[] not null default '{}';
alter table public.resenas add constraint ck_resenas_etiquetas
  check (cardinality(etiquetas) <= 6);

create or replace function public.fn_resena_normalizar()
returns trigger language plpgsql as $$
begin
  if new.calificacion is null then
    if new.valoracion is null then
      raise exception 'Falta la valoración';
    end if;
    new.calificacion := case new.valoracion when 'excelente' then 5 when 'neutro' then 3 else 1 end;
  end if;
  new.valoracion := case when new.calificacion >= 4 then 'excelente'
                         when new.calificacion = 3 then 'neutro' else 'malo' end;
  return new;
end $$;
