import { createClient, type SupabaseClient, type User } from 'npm:@supabase/supabase-js@2';

export function clienteDelUsuario(req: Request): SupabaseClient {
  return createClient(Deno.env.get('SUPABASE_URL')!, Deno.env.get('SUPABASE_ANON_KEY')!, {
    global: { headers: { Authorization: req.headers.get('Authorization') ?? '' } },
  });
}

export function clienteAdmin(): SupabaseClient {
  return createClient(Deno.env.get('SUPABASE_URL')!, Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!);
}

/** `session_id` del JWT (la sesión de login en auth.sessions). */
export function sesionDe(req: Request): string | null {
  const token = (req.headers.get('Authorization') ?? '').replace(/^Bearer\s+/i, '');
  const carga = token.split('.')[1];
  if (!carga) return null;
  try {
    const json = atob(carga.replace(/-/g, '+').replace(/_/g, '/').padEnd(Math.ceil(carga.length / 4) * 4, '='));
    const id = JSON.parse(json)?.session_id;
    return typeof id === 'string' && id.length > 0 ? id : null;
  } catch {
    return null;
  }
}

export async function usuarioDe(req: Request): Promise<User | null> {
  const { data: { user } } = await clienteDelUsuario(req).auth.getUser();
  return user ?? null;
}
