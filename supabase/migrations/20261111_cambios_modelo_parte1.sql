begin;

create extension if not exists btree_gist;

-- 1. Visita: inicio y fin (duración fija de 1 hora por ahora)
alter table cotizaciones
  add column if not exists inicio_visita timestamptz,
  add column if not exists fin_visita timestamptz;

update cotizaciones
set inicio_visita = fecha_servicio,
    fin_visita = fecha_servicio + interval '1 hour'
where fecha_servicio is not null and inicio_visita is null;

alter table cotizaciones
  add constraint ck_cotizaciones_visita
  check (fin_visita is null or (inicio_visita is not null and fin_visita > inicio_visita));

-- Imposible solapar dos citas aceptadas del mismo técnico
alter table cotizaciones
  add constraint ex_cotizaciones_sin_choque
  exclude using gist (
    tecnico_id with =,
    tstzrange(inicio_visita, fin_visita) with &&
  ) where (estado = 'aceptada' and inicio_visita is not null);

-- 2. Materiales obsoleto (no se borra: total generado depende de él)
update cotizaciones set materiales = 0 where materiales <> 0;
comment on column cotizaciones.materiales is 'OBSOLETA: el flujo nuevo cobra solo la visita. Eliminar en migración posterior.';

-- 3. Calificación de 3 niveles
alter table resenas
  add column if not exists valoracion text;

update resenas
set valoracion = case
  when calificacion >= 4 then 'excelente'
  when calificacion = 3 then 'neutro'
  else 'malo'
end
where valoracion is null;

alter table resenas
  add constraint ck_resenas_valoracion
  check (valoracion in ('excelente','neutro','malo'));

-- 4. Suspensión por faltas (técnicos y clientes)
alter table usuarios
  add column if not exists suspendido_hasta timestamptz;

commit;