// Upstash Redis (REST) para caché, presencia y límites de uso.
//
// Regla: Redis acelera y protege, pero nunca es la fuente de verdad. Si faltan
// los secretos o Upstash falla, cada función sigue como antes (fail-open).
//
// Secretos: UPSTASH_REDIS_REST_URL y UPSTASH_REDIS_REST_TOKEN.
import { Redis } from 'npm:@upstash/redis@1.34.3';

export const PREFIJO = 'chaucha:';

export const TTL = {
  sector: 60 * 60 * 24 * 30, // 30 días: los barrios no cambian
  anuncios: 60 * 5, // 5 min, y el trigger de `anuncios` lo invalida antes
  selfie: 60 * 60 * 24 * 7, // 7 días: mismo archivo, mismo veredicto
  presencia: 90, // 3 latidos de 30 s
} as const;

export const clave = (...partes: (string | number)[]) => PREFIJO + partes.join(':');

let instancia: Redis | null | undefined;

/** null si Upstash no está configurado. */
export function obtenerRedis(): Redis | null {
  if (instancia !== undefined) return instancia;
  const url = Deno.env.get('UPSTASH_REDIS_REST_URL');
  const token = Deno.env.get('UPSTASH_REDIS_REST_TOKEN');
  instancia = url && token ? new Redis({ url, token }) : null;
  if (!instancia) console.warn('Upstash Redis sin configurar: caché y límites desactivados');
  return instancia;
}

/** Solo para pruebas. */
export function fijarRedis(r: Redis | null | undefined): void {
  instancia = r;
}

/** Ejecuta `fn` con Redis; si no hay Redis o falla, devuelve `porDefecto`. */
export async function conRedis<T>(fn: (r: Redis) => Promise<T>, porDefecto: T): Promise<T> {
  const r = obtenerRedis();
  if (!r) return porDefecto;
  try {
    return await fn(r);
  } catch (e) {
    console.error('redis', String(e));
    return porDefecto;
  }
}

/**
 * Comando crudo por la API REST (para lo que la librería no expone con
 * comodidad, como GEOSEARCH). Lanza si falla: usarlo dentro de `conRedis`.
 */
export async function comando(args: (string | number)[]): Promise<unknown> {
  const url = Deno.env.get('UPSTASH_REDIS_REST_URL');
  const token = Deno.env.get('UPSTASH_REDIS_REST_TOKEN');
  if (!url || !token) throw new Error('Redis sin configurar');
  const r = await fetch(url, {
    method: 'POST',
    headers: { Authorization: `Bearer ${token}`, 'Content-Type': 'application/json' },
    body: JSON.stringify(args.map(String)),
  });
  const j = await r.json();
  if (!r.ok || j.error) throw new Error(j.error ?? `Upstash ${r.status}`);
  return j.result;
}
