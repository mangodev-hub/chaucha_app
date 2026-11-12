begin;
with vip as (
  select sv.cliente_id
  from public.solicitudes_servicio sv
  join auth.users a on a.id = sv.cliente_id and a.email like '%@semilla.chaucha.app'
  where sv.estado = 'completada'
  group by 1 having count(*) >= 5
)
update public.resenas r
set calificacion = 3, valoracion = 'neutro', etiquetas = '{}', comentario = 'Trabajo cumplido.'
where r.destinatario_id in (select cliente_id from vip) and r.valoracion = 'malo';
select public.recalcular_reputacion_reciente();
commit;
