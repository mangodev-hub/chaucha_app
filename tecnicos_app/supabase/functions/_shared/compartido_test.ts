// deno test supabase/functions/_shared
import { assertEquals } from 'jsr:@std/assert@1';
import { puntoDeEwkb } from './geo.ts';
import { limitar, limitarTodas, respuesta429 } from './limite.ts';
import { clave, conRedis, fijarRedis, obtenerRedis } from './redis.ts';

Deno.test('sin secretos de Upstash no hay Redis y todo sigue (fail-open)', async () => {
  Deno.env.delete('UPSTASH_REDIS_REST_URL');
  Deno.env.delete('UPSTASH_REDIS_REST_TOKEN');
  fijarRedis(undefined);
  assertEquals(obtenerRedis(), null);
  assertEquals(await conRedis(() => Promise.resolve('x'), 'por defecto'), 'por defecto');
  assertEquals(await limitar('selfie', 'u1'), { permitido: true, reintentarEnSeg: 0 });
  assertEquals(await limitarTodas(['selfie', 'selfieDia'], 'u1'), {
    permitido: true,
    reintentarEnSeg: 0,
  });
});

Deno.test('un error de Redis devuelve el valor por defecto', async () => {
  // deno-lint-ignore no-explicit-any
  fijarRedis({} as any);
  const v = await conRedis(() => Promise.reject(new Error('caído')), 7);
  assertEquals(v, 7);
  fijarRedis(undefined);
});

Deno.test('respuesta 429 con Retry-After y el tiempo de espera', async () => {
  const r = respuesta429(12);
  assertEquals(r.status, 429);
  assertEquals(r.headers.get('Retry-After'), '12');
  assertEquals((await r.json()).reintentar_en, 12);
});

Deno.test('claves con prefijo', () => {
  assertEquals(clave('cache', 'sector', '-0.180,-78.480'), 'chaucha:cache:sector:-0.180,-78.480');
});

Deno.test('lee un POINT EWKB con SRID 4326', () => {
  // SELECT 'SRID=4326;POINT(-78.48 -0.18)'::geography  (como lo devuelve PostgREST)
  const hex = '0101000020E61000001F85EB51B89E53C00AD7A3703D0AC7BF';
  const p = puntoDeEwkb(hex)!;
  assertEquals(Math.round(p.lng * 100) / 100, -78.48);
  assertEquals(Math.round(p.lat * 100) / 100, -0.18);
  assertEquals(puntoDeEwkb(null), null);
  assertEquals(puntoDeEwkb('00'), null);
});
