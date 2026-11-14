-- Caché de anuncios en Redis (Edge Function `anuncios`).

create or replace function public.fn_anuncios_cache()
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
    return null;
  end if;

  perform net.http_post(
    url := regexp_replace(v_url, '/enviar-push/?$', '/anuncios') || '?invalidar=1',
    body := '{}'::jsonb,
    headers := jsonb_build_object(
      'Content-Type', 'application/json',
      'x-push-secreto', v_secreto
    ),
    timeout_milliseconds := 5000
  );
  return null;
end $$;

revoke all on function public.fn_anuncios_cache() from public, anon, authenticated;

-- Una vez por sentencia: un cambio masivo dispara una sola invalidación.
create trigger trg_anuncios_cache
  after insert or update or delete on public.anuncios
  for each statement
  execute function public.fn_anuncios_cache();
