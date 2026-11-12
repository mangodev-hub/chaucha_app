-- Sanciones: 3 reseñas "malo" en 30 días suspenden la cuenta 7 días.
-- Aplica igual a clientes y técnicos (cuenta las reseñas que RECIBE cada uno).
--
-- Cambios respecto a la versión anterior (5 días):
--   * Duración: 7 días.
--   * Reincidencia: antes, al terminar la suspensión las mismas 3 malas seguían
--     dentro de la ventana de 30 días y UNA mala más volvía a suspender.
--     Ahora solo cuentan las malas recibidas DESPUÉS del inicio de la última
--     suspensión (`suspendido_desde`).
--   * Avisos (notificación + push):
--       sancion_aviso  al llegar a 2 malas: "una más y se suspende".
--       sancion        al suspender, con la fecha de fin y qué queda bloqueado.
--       sancion_fin    al terminar (job horario de pg_cron).
--
-- Qué bloquea la suspensión (ya existía):
--   cliente  -> no puede publicar solicitudes (fn_validar_suspension_cliente)
--   técnico  -> no puede enviar propuestas    (fn_validar_cotizacion)

alter table public.usuarios
  add column suspendido_desde timestamp with time zone;

-- Igual que antes + suspendido_desde tampoco lo puede tocar el usuario.
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
    if new.verificado is distinct from old.verificado
       or new.verificado_manual is distinct from old.verificado_manual then
      raise exception 'La verificación la hace el equipo de revisión.';
    end if;
    if new.suspendido_hasta is distinct from old.suspendido_hasta
       or new.suspendido_desde is distinct from old.suspendido_desde then
      raise exception 'La suspensión la gestiona el sistema.';
    end if;
  end if;
  return new;
end $$;

create or replace function public.fn_resena_puntos()
  returns trigger
  language plpgsql
  security definer
  set search_path to 'public'
as $$
declare
  v_malas   int;
  v_desde   timestamptz;
  v_hasta   timestamptz;
  v_rol     text;
  v_bloqueo text;
begin
  if exists (select 1 from perfiles_tecnicos where usuario_id = new.destinatario_id) then
    insert into historial_puntos (tecnico_id, solicitud_id, puntos, motivo)
    values (new.destinatario_id, new.solicitud_id,
            case new.valoracion when 'excelente' then 15 when 'neutro' then 5 else -15 end,
            'resena_' || new.valoracion);
  end if;

  if new.valoracion is distinct from 'malo' then
    return new;
  end if;

  select rol, suspendido_desde, suspendido_hasta into v_rol, v_desde, v_hasta
  from usuarios where id = new.destinatario_id;

  -- Ya está suspendido: la mala cuenta para la próxima, no alarga esta.
  if v_hasta > now() then
    return new;
  end if;

  -- Malas de los últimos 30 días que no se usaron en una sanción anterior.
  select count(*) into v_malas from resenas
  where destinatario_id = new.destinatario_id
    and valoracion = 'malo'
    and creado_en >= now() - interval '30 days'
    and creado_en > coalesce(v_desde, '-infinity'::timestamptz);

  v_bloqueo := case v_rol
    when 'tecnico' then 'no podrás enviar propuestas'
    else 'no podrás publicar solicitudes' end;

  if v_malas >= 3 then
    update usuarios
    set suspendido_desde = now(),
        suspendido_hasta = now() + interval '7 days'
    where id = new.destinatario_id;

    insert into notificaciones (usuario_id, tipo, referencia_id, contenido)
    values (new.destinatario_id, 'sancion', new.solicitud_id,
            'Tu cuenta quedó suspendida 7 días por recibir 3 reseñas negativas en 30 días. '
            || 'Hasta el ' || to_char((now() + interval '7 days') at time zone 'America/Guayaquil', 'DD/MM "a las" HH24:MI')
            || ' ' || v_bloqueo || '.');
  elsif v_malas = 2 then
    insert into notificaciones (usuario_id, tipo, referencia_id, contenido)
    values (new.destinatario_id, 'sancion_aviso', new.solicitud_id,
            'Recibiste 2 reseñas negativas en los últimos 30 días. '
            || 'Con una más tu cuenta se suspenderá 7 días.');
  end if;
  return new;
end $$;

-- Avisa a quienes terminaron su suspensión en la última hora. Corre cada
-- hora en punto; la ventana [hora anterior, hora actual) evita avisos dobles.
create or replace function public.avisar_fin_sanciones()
  returns integer
  language plpgsql
  security definer
  set search_path to 'public'
as $$
declare
  v_total integer;
begin
  insert into notificaciones (usuario_id, tipo, referencia_id, contenido)
  select id, 'sancion_fin', null,
         'Terminó tu suspensión. Ya puedes usar ChauchaApp con normalidad.'
  from usuarios
  where suspendido_hasta >= date_trunc('hour', now()) - interval '1 hour'
    and suspendido_hasta <  date_trunc('hour', now());
  get diagnostics v_total = row_count;
  return v_total;
end $$;

revoke all on function public.avisar_fin_sanciones() from public, anon, authenticated;

select cron.schedule('avisar-fin-sanciones', '0 * * * *', $$select public.avisar_fin_sanciones()$$);

-- Quien esté suspendido ahora (con la regla vieja de 5 días) conserva su
-- fecha; se marca el inicio para que sus malas no se vuelvan a contar.
update usuarios
set suspendido_desde = suspendido_hasta - interval '5 days'
where suspendido_hasta > now() and suspendido_desde is null;
