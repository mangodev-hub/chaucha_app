// Usuario de la petición a partir de su JWT (el mismo que usa RLS).
import { createClient, type SupabaseClient, type User } from 'npm:@supabase/supabase-js@2';

export function clienteDelUsuario(req: Request): SupabaseClient {
  return createClient(Deno.env.get('SUPABASE_URL')!, Deno.env.get('SUPABASE_ANON_KEY')!, {
    global: { headers: { Authorization: req.headers.get('Authorization') ?? '' } },
  });
}

export function clienteAdmin(): SupabaseClient {
  return createClient(Deno.env.get('SUPABASE_URL')!, Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!);
}

export async function usuarioDe(req: Request): Promise<User | null> {
  const { data: { user } } = await clienteDelUsuario(req).auth.getUser();
  return user ?? null;
}
