-- Sube de nivel a los mejores técnicos sembrados (3 a Oro, 6 a Plata).
-- fn_sync_puntos actualiza puntos y nivel_id al insertar en historial_puntos.
begin;
with ranking as (
  select p.usuario_id, p.puntos,
         row_number() over (order by p.calificacion_promedio desc, p.total_resenas desc, p.usuario_id) as pos
  from public.perfiles_tecnicos p
  join auth.users a on a.id = p.usuario_id
  where a.email like '%@semilla.chaucha.app' and p.total_resenas > 0
), meta as (
  select usuario_id, puntos,
         case when pos <= 3 then 480 + pos * 45      -- Oro (>= 450)
              when pos <= 9 then 160 + pos * 22      -- Plata (150-449)
         end as objetivo
  from ranking
)
insert into public.historial_puntos (tecnico_id, puntos, motivo, creado_en)
select usuario_id, objetivo - puntos, 'trayectoria_demo', now() - interval '60 days'
from meta where objetivo is not null and objetivo > puntos;
commit;
