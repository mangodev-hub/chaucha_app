-- Garantía de 30 días y reclamos por ticket.
-- La garantía corre desde `completada_en`. Reportan el cliente o el técnico
-- del servicio; la otra parte no ve el reclamo. Todo se escribe por RPC.

alter table solicitudes_servicio add column if not exists completada_en timestamptz;

update solicitudes_servicio s set completada_en = coalesce(
  (select max(c.fin_visita) from cotizaciones c where c.solicitud_id = s.id and c.estado = 'aceptada'),
  s.creado_en)
where s.estado = 'completada' and s.completada_en is null;

create or replace function marcar_completada_en() returns trigger
language plpgsql set search_path = public as $$
begin
  if new.estado = 'completada' and old.estado is distinct from 'completada' then
    new.completada_en := now();
  end if;
  return new;
end $$;

drop trigger if exists trg_completada_en on solicitudes_servicio;
create trigger trg_completada_en before update of estado on solicitudes_servicio
for each row execute function marcar_completada_en();

create table reclamos (
  id uuid primary key default gen_random_uuid(),
  numero bigint generated always as identity unique,
  solicitud_id uuid not null references solicitudes_servicio(id) on delete cascade,
  cotizacion_id uuid references cotizaciones(id) on delete set null,
  autor_id uuid not null references usuarios(id) on delete cascade,
  contra_id uuid references usuarios(id) on delete set null,
  categoria text not null check (categoria in ('falla_trabajo','no_se_presento','trato','cobro_indebido','otro')),
  descripcion text not null check (length(trim(descripcion)) >= 20),
  evidencias text[] not null default '{}' check (cardinality(evidencias) <= 3),
  estado text not null default 'recibido' check (estado in ('recibido','en_revision','necesita_info','resuelto','rechazado')),
  resolucion text,
  asesor_id uuid references usuarios(id) on delete set null,
  creado_en timestamptz not null default now(),
  actualizado_en timestamptz not null default now(),
  cerrado_en timestamptz
);
create unique index reclamo_abierto_unico on reclamos (solicitud_id, autor_id)
  where estado not in ('resuelto','rechazado');
create index reclamos_estado_idx on reclamos (estado, creado_en);

create table reclamo_mensajes (
  id uuid primary key default gen_random_uuid(),
  reclamo_id uuid not null references reclamos(id) on delete cascade,
  autor_id uuid references usuarios(id) on delete set null,
  es_asesor boolean not null default false,
  texto text not null,
  creado_en timestamptz not null default now()
);
create index reclamo_mensajes_idx on reclamo_mensajes (reclamo_id, creado_en);

alter table reclamos enable row level security;
alter table reclamo_mensajes enable row level security;

create policy reclamos_ver on reclamos for select to authenticated
  using (autor_id = (select auth.uid()) or (select mi_rol()) = 'admin');

create policy reclamo_mensajes_ver on reclamo_mensajes for select to authenticated
  using (exists (select 1 from reclamos r where r.id = reclamo_id
    and (r.autor_id = (select auth.uid()) or (select mi_rol()) = 'admin')));

-- Solo lectura directa: escribir va siempre por los RPC.
revoke insert, update, delete on reclamos, reclamo_mensajes from anon, authenticated;

-- Las respuestas del asesor y los cambios de estado llegan solos a la app.
alter publication supabase_realtime add table reclamos, reclamo_mensajes;

create or replace function crear_reclamo(
  p_solicitud_id uuid, p_categoria text, p_descripcion text, p_evidencias text[] default '{}')
returns reclamos language plpgsql security definer set search_path = public as $$
declare
  yo uuid := auth.uid();
  s solicitudes_servicio;
  c cotizaciones;
  r reclamos;
  codigo text;
  ruta text;
begin
  select * into s from solicitudes_servicio where id = p_solicitud_id;
  select * into c from cotizaciones where solicitud_id = p_solicitud_id and estado = 'aceptada' limit 1;
  if s.id is null or c.id is null then raise exception 'No encontramos ese servicio.'; end if;
  if yo is null or (yo is distinct from s.cliente_id and yo is distinct from c.tecnico_id) then
    raise exception 'Este servicio no es tuyo.';
  end if;
  if s.estado <> 'completada' or s.completada_en is null then
    raise exception 'Solo puedes reportar servicios terminados.';
  end if;
  if now() > s.completada_en + interval '30 days' then
    raise exception 'La garantía de 30 días de este servicio ya terminó.';
  end if;
  if p_categoria not in ('falla_trabajo','no_se_presento','trato','cobro_indebido','otro') then
    raise exception 'Elige el tipo de problema.';
  end if;
  if p_categoria = 'falla_trabajo' and yo = c.tecnico_id then
    raise exception 'Elige otro tipo de problema.';
  end if;
  if length(trim(coalesce(p_descripcion, ''))) < 20 then
    raise exception 'Cuéntanos qué pasó con al menos 20 caracteres.';
  end if;
  -- Las fotos tienen que estar en la carpeta de quien reporta.
  foreach ruta in array coalesce(p_evidencias, '{}') loop
    if split_part(ruta, '/', 1) <> yo::text then
      raise exception 'Una de las fotos no es válida.';
    end if;
  end loop;

  begin
    insert into reclamos (solicitud_id, cotizacion_id, autor_id, contra_id, categoria, descripcion, evidencias)
    values (s.id, c.id, yo,
      case when yo = s.cliente_id then c.tecnico_id else s.cliente_id end,
      p_categoria, trim(p_descripcion), coalesce(p_evidencias, '{}'))
    returning * into r;
  exception when unique_violation then
    raise exception 'Ya tienes un reclamo abierto para este servicio.';
  end;

  codigo := 'REC-' || lpad(r.numero::text, 4, '0');
  insert into reclamo_mensajes (reclamo_id, texto) values (r.id,
    'Recibimos tu reclamo ' || codigo || '. Un asesor de ChauchaApp lo está evaluando y te escribirá por aquí. También te avisaremos con una notificación.');
  insert into notificaciones (usuario_id, tipo, referencia_id, contenido)
  values (yo, 'reclamo', r.id, 'Tu reclamo ' || codigo || ' lo está evaluando un asesor.');
  return r;
end $$;

create or replace function responder_reclamo(p_reclamo_id uuid, p_texto text)
returns void language plpgsql security definer set search_path = public as $$
begin
  if nullif(trim(p_texto), '') is null then raise exception 'Escribe tu mensaje.'; end if;
  update reclamos
  set estado = case when estado = 'necesita_info' then 'en_revision' else estado end,
      actualizado_en = now()
  where id = p_reclamo_id and autor_id = auth.uid() and estado not in ('resuelto','rechazado');
  if not found then raise exception 'No puedes escribir en este reclamo.'; end if;
  insert into reclamo_mensajes (reclamo_id, autor_id, texto) values (p_reclamo_id, auth.uid(), trim(p_texto));
end $$;

create or replace function admin_gestionar_reclamo(p_reclamo_id uuid, p_estado text, p_mensaje text default null)
returns void language plpgsql security definer set search_path = public as $$
declare
  r reclamos;
  cerrar boolean := p_estado in ('resuelto','rechazado');
begin
  perform exigir_admin();
  if p_estado not in ('en_revision','necesita_info','resuelto','rechazado') then
    raise exception 'Estado no válido.';
  end if;
  if (cerrar or p_estado = 'necesita_info') and nullif(trim(p_mensaje), '') is null then
    raise exception 'Escribe el mensaje para el usuario.';
  end if;
  update reclamos
  set estado = p_estado, asesor_id = auth.uid(), actualizado_en = now(),
      resolucion = case when cerrar then trim(p_mensaje) else resolucion end,
      cerrado_en = case when cerrar then now() end
  where id = p_reclamo_id returning * into r;
  if r.id is null then raise exception 'Reclamo no encontrado.'; end if;

  if nullif(trim(p_mensaje), '') is not null then
    insert into reclamo_mensajes (reclamo_id, autor_id, es_asesor, texto)
    values (r.id, auth.uid(), true, trim(p_mensaje));
  end if;
  insert into notificaciones (usuario_id, tipo, referencia_id, contenido)
  values (r.autor_id, 'reclamo', r.id, 'REC-' || lpad(r.numero::text, 4, '0') || ': ' ||
    case p_estado
      when 'en_revision' then 'un asesor está revisando tu caso.'
      when 'necesita_info' then 'el asesor necesita más información.'
      when 'resuelto' then 'tu reclamo fue resuelto.'
      when 'rechazado' then 'tu reclamo fue revisado y cerrado.'
      else 'hay novedades en tu reclamo.'
    end);
end $$;

revoke all on function crear_reclamo(uuid, text, text, text[]) from public, anon;
revoke all on function responder_reclamo(uuid, text) from public, anon;
revoke all on function admin_gestionar_reclamo(uuid, text, text) from public, anon;
grant execute on function crear_reclamo(uuid, text, text, text[]) to authenticated;
grant execute on function responder_reclamo(uuid, text) to authenticated;
grant execute on function admin_gestionar_reclamo(uuid, text, text) to authenticated;

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('reclamos', 'reclamos', false, 5242880, array['image/jpeg','image/png','image/webp'])
on conflict (id) do nothing;

create policy reclamos_subir on storage.objects for insert to authenticated
  with check (bucket_id = 'reclamos' and (storage.foldername(name))[1] = (select auth.uid())::text);

create policy reclamos_ver_archivos on storage.objects for select to authenticated
  using (bucket_id = 'reclamos' and ((storage.foldername(name))[1] = (select auth.uid())::text
    or (select public.mi_rol()) = 'admin'));
