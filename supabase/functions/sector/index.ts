import { preflight, responder } from '../_shared/cors.ts';
import { usuarioDe } from '../_shared/auth.ts';
import { limitar, respuesta429 } from '../_shared/limite.ts';
import { clave, conRedis, TTL } from '../_shared/redis.ts';

const CAMPOS = ['neighbourhood', 'suburb', 'quarter', 'city_district', 'village', 'town', 'city'];

/** Igual que `SectorService.clave` en la app: 3 decimales (~110 m). */
const redondear = (x: number) => (Math.sign(x) * Math.round(Math.abs(x) * 1000)) / 1000;

const pausa = (ms: number) => new Promise((r) => setTimeout(r, ms));

async function consultarNominatim(lat: number, lng: number): Promise<string | null> {
  const url = new URL('https://nominatim.openstreetmap.org/reverse');
  url.search = new URLSearchParams({
    lat: String(lat),
    lon: String(lng),
    format: 'jsonv2',
    zoom: '16',
    addressdetails: '1',
    'accept-language': 'es',
  }).toString();
  const r = await fetch(url, {
    headers: { 'User-Agent': 'ChauchaApp/1.0 (servidor de geocodificacion)' },
    signal: AbortSignal.timeout(8000),
  });
  if (!r.ok) throw new Error(`Nominatim ${r.status}`);
  const j = await r.json();
  const direccion = j?.address;
  if (!direccion || typeof direccion !== 'object') return null;
  for (const campo of CAMPOS) {
    const v = direccion[campo];
    if (typeof v === 'string' && v.trim()) return v.trim();
  }
  return null;
}

Deno.serve(async (req) => {
  const pre = preflight(req);
  if (pre) return pre;
  if (req.method !== 'POST') return responder({ error: 'Método no permitido' }, 405);

  const user = await usuarioDe(req);
  if (!user) return responder({ error: 'Sesión requerida.' }, 401);

  const porUsuario = await limitar('sector', user.id);
  if (!porUsuario.permitido) return respuesta429(porUsuario.reintentarEnSeg);

  let lat: number, lng: number;
  try {
    const cuerpo = await req.json();
    lat = Number(cuerpo.lat);
    lng = Number(cuerpo.lng);
  } catch {
    return responder({ error: 'Cuerpo inválido' }, 400);
  }
  if (!Number.isFinite(lat) || !Number.isFinite(lng) || Math.abs(lat) > 90 || Math.abs(lng) > 180) {
    return responder({ error: 'Coordenadas inválidas' }, 400);
  }
  lat = redondear(lat);
  lng = redondear(lng);
  const llave = clave('cache', 'sector', `${lat.toFixed(3)},${lng.toFixed(3)}`);

  // "" en caché = Nominatim no tiene barrio para ese punto (también se guarda).
  const guardado = await conRedis((r) => r.get<string>(llave), null);
  if (guardado !== null) return responder({ sector: guardado || null, cache: true });

  // Turno global hacia Nominatim (1/s): se espera un poco antes de rendirse.
  for (let intento = 0; intento < 3; intento++) {
    const turno = await limitar('nominatim', 'global');
    if (turno.permitido) break;
    if (intento === 2) return responder({ error: 'Geocodificación ocupada' }, 503, { 'Retry-After': '1' });
    await pausa(400 + 300 * intento);
  }

  try {
    const sector = await consultarNominatim(lat, lng);
    await conRedis((r) => r.set(llave, sector ?? '', { ex: TTL.sector }), null);
    return responder({ sector, cache: false });
  } catch (e) {
    console.error('nominatim', String(e));
    return responder({ error: 'No se pudo consultar el barrio' }, 502);
  }
});
