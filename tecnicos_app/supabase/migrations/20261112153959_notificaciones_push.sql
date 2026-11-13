-- Notificaciones push (FCM).
--
-- Todos los eventos de la app (mensaje, cotización, tarifa, cierre...) ya
-- terminan en un INSERT sobre `notificaciones`. Por eso hay UN solo webhook:
-- cada fila nueva llama a la Edge Function `enviar-push`, que la despacha por
-- FCM a los dispositivos del destinatario. Así el aviso llega aunque la app
-- esté cerrada o el navegador minimizado (Realtime solo sirve con la app abierta).
--
-- Además, guardar en Vault (una sola vez, desde el SQL editor):
--   select vault.create_secret('https://<proyecto>.supabase.co/functions/v1/enviar-push', 'push_url');
--   select vault.create_secret(encode(extensions.gen_random_bytes(32), 'hex'), 'push_secreto');
-- La función valida el header con `push_secreto_valido` (20261112154019_push_secreto_en_vault).

create extension if not exists pg_net with schema extensions;

-- Tokens FCM por dispositivo. Un usuario puede tener varios (móvil + web).
create table public.dispositivos_push (
  token          text                     not null,
  usuario_id     uuid                     not null,
  plataforma     text                     not null,
  actualizado_en timestamp with time zone not null default now(),
  constraint pk_dispositivos_push primary key (token),
  constraint fk_dispositivos_push_usuario foreign key (usuario_id)
    references public.usuarios(id) on delete cascade,
  constraint ck_dispositivos_push_plataforma
    check (plataforma = any (array['android', 'ios', 'web']))
);

create index idx_dispositivos_push_usuario on public.dispositivos_push (usuario_id);

alter table public.dispositivos_push enable row level security;
revoke all on table public.dispositivos_push from anon;

-- Cada usuario solo ve y maneja sus propios tokens.
create policy dispositivos_push_propios on public.dispositivos_push
  for all to authenticated
  using (usuario_id = auth.uid())
  with check (usuario_id = auth.uid());

-- Registrar el token. Si el mismo dispositivo cambia de cuenta, el token pasa
-- al usuario nuevo (la política de UPDATE no lo permitiría desde el cliente).
create or replace function public.registrar_dispositivo_push(p_token text, p_plataforma text)
  returns void
  language plpgsql
  security definer
  set search_path to 'public'
as $$
begin
  if auth.uid() is null then
    raise exception 'No autenticado';
  end if;
  insert into dispositivos_push (token, usuario_id, plataforma)
  values (p_token, auth.uid(), p_plataforma)
  on conflict (token) do update
    set usuario_id = excluded.usuario_id,
        plataforma = excluded.plataforma,
        actualizado_en = now();
end $$;

revoke all on function public.registrar_dispositivo_push(text, text) from public, anon;
grant execute on function public.registrar_dispositivo_push(text, text) to authenticated;

-- Webhook: manda la notificación nueva a la Edge Function (asíncrono, pg_net
-- no bloquea el INSERT). Si faltan los secretos, no hace nada.
create or replace function public.fn_notificacion_push()
  returns trigger
  language plpgsql
  security definer
  set search_path to 'public'
as $$
declare
  v_url     text;
  v_secreto text;
begin
  select decrypted_secret into v_url from vault.decrypted_secrets where name = 'push_url';
  select decrypted_secret into v_secreto from vault.decrypted_secrets where name = 'push_secreto';
  if v_url is null or v_secreto is null then
    return new;
  end if;

  perform net.http_post(
    url := v_url,
    body := jsonb_build_object('record', to_jsonb(new)),
    headers := jsonb_build_object(
      'Content-Type', 'application/json',
      'x-push-secreto', v_secreto
    ),
    timeout_milliseconds := 5000
  );
  return new;
end $$;

create trigger trg_notificacion_push
  after insert on public.notificaciones
  for each row
  execute function public.fn_notificacion_push();
