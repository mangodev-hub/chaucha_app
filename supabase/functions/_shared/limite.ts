import { Ratelimit } from 'npm:@upstash/ratelimit@2.0.5';
import { responder } from './cors.ts';
import { obtenerRedis, PREFIJO } from './redis.ts';

type Ventana = Parameters<typeof Ratelimit.slidingWindow>[1];

export const REGLAS = {
  /** validar-foto-rostro: reintentos razonables de una selfie. */
  selfie: { pedidos: 5, ventana: '10 m' as Ventana },
  selfieDia: { pedidos: 20, ventana: '1 d' as Ventana },
  /** comparar-rostro-cedula: una por envío de documentos o corrección de datos. */
  comparar: { pedidos: 6, ventana: '1 h' as Ventana },
  rostroSesion: { pedidos: 10, ventana: '1 h' as Ventana },
  /** sector: por usuario. */
  sector: { pedidos: 30, ventana: '1 m' as Ventana },
  /** Nominatim permite 1 consulta por segundo para TODA la app. */
  nominatim: { pedidos: 1, ventana: '1 s' as Ventana },
  /** presencia: un latido cada 30 s, con holgura. */
  latido: { pedidos: 6, ventana: '1 m' as Ventana },
} as const;

export type Regla = keyof typeof REGLAS;

export type Resultado = { permitido: boolean; reintentarEnSeg: number };

const limitadores = new Map<Regla, Ratelimit>();

function limitador(regla: Regla): Ratelimit | null {
  const redis = obtenerRedis();
  if (!redis) return null;
  let l = limitadores.get(regla);
  if (!l) {
    const { pedidos, ventana } = REGLAS[regla];
    l = new Ratelimit({
      redis,
      limiter: Ratelimit.slidingWindow(pedidos, ventana),
      prefix: `${PREFIJO}rl:${regla}`,
    });
    limitadores.set(regla, l);
  }
  return l;
}

/** ¿Puede `id` (usuario o 'global') hacer otro pedido según `regla`? */
export async function limitar(regla: Regla, id: string): Promise<Resultado> {
  const l = limitador(regla);
  if (!l) return { permitido: true, reintentarEnSeg: 0 };
  try {
    const { success, reset } = await l.limit(id);
    return {
      permitido: success,
      reintentarEnSeg: success ? 0 : Math.max(1, Math.ceil((reset - Date.now()) / 1000)),
    };
  } catch (e) {
    console.error('ratelimit', regla, String(e));
    return { permitido: true, reintentarEnSeg: 0 };
  }
}

/** Aplica varias reglas; devuelve la primera que no permite. */
export async function limitarTodas(reglas: Regla[], id: string): Promise<Resultado> {
  for (const regla of reglas) {
    const r = await limitar(regla, id);
    if (!r.permitido) return r;
  }
  return { permitido: true, reintentarEnSeg: 0 };
}

export function respuesta429(segundos: number): Response {
  return responder(
    {
      error: 'Hiciste muchos intentos seguidos. Espera un momento e inténtalo de nuevo.',
      reintentar_en: segundos,
    },
    429,
    { 'Retry-After': String(segundos) },
  );
}
