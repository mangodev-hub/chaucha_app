-- La Edge Function `enviar-push` valida el header x-push-secreto contra Vault;
-- el secreto nunca sale de la base. Solo la puede llamar el service_role.
create or replace function public.push_secreto_valido(p_secreto text)
  returns boolean
  language sql
  stable
  security definer
  set search_path to 'public'
as $$
  select exists (
    select 1 from vault.decrypted_secrets
    where name = 'push_secreto' and decrypted_secret = p_secreto
  );
$$;

revoke all on function public.push_secreto_valido(text) from public, anon, authenticated;
grant execute on function public.push_secreto_valido(text) to service_role;
