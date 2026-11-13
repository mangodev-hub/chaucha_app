alter table public.usuarios
  add column if not exists verificado boolean not null default false;

update public.usuarios u
set verificado = true
from public.perfiles_tecnicos p
where p.usuario_id = u.id and p.verificado;

alter table public.documentos_tecnico drop constraint fk_documentos_tecnico;
alter table public.documentos_tecnico
  add constraint fk_documentos_tecnico
  foreign key (tecnico_id) references public.usuarios(id) on delete cascade;

alter table public.documentos_historial drop constraint documentos_historial_tecnico_id_fkey;
alter table public.documentos_historial
  add constraint documentos_historial_tecnico_id_fkey
  foreign key (tecnico_id) references public.usuarios(id) on delete cascade;

create or replace function public.recalcular_verificacion(p_tecnico uuid)
returns void
language plpgsql
security definer
set search_path to 'public'
as $$
declare ok boolean;
begin
  select (select count(distinct tipo) = 3 from documentos_tecnico
           where tecnico_id = p_tecnico and estado = 'aprobada')
         and exists (select 1 from usuarios
                      where id = p_tecnico
                        and foto_rostro_validada
                        and foto_perfil_ruta is not null)
    into ok;
  ok := coalesce(ok, false);
  update usuarios set verificado = ok
   where id = p_tecnico and verificado is distinct from ok;
  update perfiles_tecnicos set verificado = ok
   where usuario_id = p_tecnico and verificado is distinct from ok;
end $$;

create or replace function public.fn_proteger_usuario()
returns trigger
language plpgsql
set search_path to 'public'
as $$
begin
  if current_user = 'authenticated' and public.mi_rol() is distinct from 'admin' then
    if new.rol is distinct from old.rol or new.id is distinct from old.id then
      raise exception 'No puedes cambiar tu rol';
    end if;
    if new.foto_rostro_validada and not old.foto_rostro_validada then
      raise exception 'La validación de la foto la hace el sistema.';
    end if;
    if new.verificado is distinct from old.verificado then
      raise exception 'La verificación la hace el equipo de revisión.';
    end if;
  end if;
  return new;
end $$;

alter policy solicitudes_insert on public.solicitudes_servicio
  with check (
    cliente_id = (select auth.uid())
    and mi_rol() = 'cliente'
    and estado = 'abierta'
    and exists (select 1 from public.usuarios
                where id = (select auth.uid()) and verificado)
  );