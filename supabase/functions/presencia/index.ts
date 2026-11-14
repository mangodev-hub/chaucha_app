import { preflight, responder } from '../_shared/cors.ts';
import { clienteAdmin, usuarioDe } from '../_shared/auth.ts';
import { limitar, respuesta429 } from '../_shared/limite.ts';
import { puntoDeEwkb } from '../_shared/geo.ts';
import { clave, comando, conRedis, obtenerRedis, TTL } from '../_shared/redis.ts';

const VISTO = clave('pres', 'visto'); // zset uid -> ms del último latido (30 días)
const TECNICOS = clave('pres', 'tecnicos'); // GEO de técnicos en línea
const LATIDO_TECNICOS = clave('pres', 'tecnicos', 'latido'); // zset uid -> ms
const REFRESCO_UBICACION_MS = 10 * 60 * 1000;
const VENCIDO_MS = TTL.presencia * 1000;
const UUID = /^[0-9a-f-]{36}$/i;

async function limpiarTecnicosVencidos(): Promise<void> {
  await conRedis(async (r) => {
    const vencidos = await r.zrange<string[]>(LATIDO_TECNICOS, 0, Date.now() - VENCIDO_MS, {
      byScore: true,
    });
    if (vencidos.length) {
      const p = r.pipeline();
      p.zrem(LATIDO_TECNICOS, ...vencidos);
      p.zrem(TECNICOS, ...vencidos);
      await p.exec();
    }
  }, undefined);
}

async function latido(uid: string, conversacion: string | null): Promise<Response> {
  const r = obtenerRedis();
  if (!r) return responder({ ok: false, motivo: 'sin_redis' });
  const llave = clave('pres', uid);
  const ahora = Date.now();

  try {
    const previo = (await r.hgetall<Record<string, string | number>>(llave)) ?? {};
    let rol = previo.rol ? String(previo.rol) : '';
    let ubic = previo.ubic ? String(previo.ubic) : '';
    let ubicEn = Number(previo.ubic_en ?? 0);
    const db = clienteAdmin();

    if (!rol) {
      const { data } = await db.from('usuarios').select('rol').eq('id', uid).maybeSingle();
      rol = (data?.rol as string | undefined) ?? 'cliente';
    }
    if (rol === 'tecnico' && ahora - ubicEn > REFRESCO_UBICACION_MS) {
      const { data } = await db
        .from('perfiles_tecnicos')
        .select('verificado, ubicacion_actual')
        .eq('usuario_id', uid)
        .maybeSingle();
      const punto = data?.verificado ? puntoDeEwkb(data.ubicacion_actual as string) : null;
      ubic = punto ? `${punto.lng},${punto.lat}` : '';
      ubicEn = ahora;
    }

    const p = r.pipeline();
    p.hset(llave, { rol, visto: ahora, conversacion: conversacion ?? '', ubic, ubic_en: ubicEn });
    p.expire(llave, TTL.presencia);
    p.zadd(VISTO, { score: ahora, member: uid });
    if (rol === 'tecnico' && ubic) {
      const [lng, lat] = ubic.split(',').map(Number);
      p.geoadd(TECNICOS, { longitude: lng, latitude: lat, member: uid });
      p.zadd(LATIDO_TECNICOS, { score: ahora, member: uid });
    }
    // "Activo hace X" se guarda 30 días como máximo.
    p.zremrangebyscore(VISTO, 0, ahora - 30 * 24 * 3600 * 1000);
    await p.exec();
    await limpiarTecnicosVencidos();
    return responder({ ok: true });
  } catch (e) {
    console.error('latido', String(e));
    return responder({ ok: false });
  }
}

async function salir(uid: string): Promise<Response> {
  await conRedis(async (r) => {
    const p = r.pipeline();
    p.del(clave('pres', uid));
    p.zrem(TECNICOS, uid);
    p.zrem(LATIDO_TECNICOS, uid);
    p.zadd(VISTO, { score: Date.now(), member: uid });
    await p.exec();
  }, undefined);
  return responder({ ok: true });
}

async function estados(ids: string[]): Promise<Response> {
  const vacio = Object.fromEntries(ids.map((id) => [id, { en_linea: false, visto: null }]));
  const resultado = await conRedis(async (r) => {
    const p = r.pipeline();
    for (const id of ids) {
      p.exists(clave('pres', id));
      p.zscore(VISTO, id);
    }
    const filas = await p.exec<(number | null)[]>();
    return Object.fromEntries(
      ids.map((id, i) => {
        const visto = filas[i * 2 + 1];
        return [id, {
          en_linea: filas[i * 2] === 1,
          visto: visto == null ? null : new Date(Number(visto)).toISOString(),
        }];
      }),
    );
  }, vacio);
  return responder({ estados: resultado });
}

async function tecnicosCerca(lat: number, lng: number, radio: number, oficio: number | null) {
  await limpiarTecnicosVencidos();
  const ids = await conRedis(
    async () =>
      (await comando([
        'GEOSEARCH', TECNICOS, 'FROMLONLAT', lng, lat, 'BYRADIUS', radio, 'm', 'ASC', 'COUNT', 200,
      ])) as string[],
    [] as string[],
  );
  let filtrados = ids;
  if (oficio !== null && ids.length) {
    const { data } = await clienteAdmin()
      .from('tecnico_oficios')
      .select('tecnico_id')
      .eq('oficio_id', oficio)
      .in('tecnico_id', ids);
    const con = new Set((data ?? []).map((f) => f.tecnico_id as string));
    filtrados = ids.filter((id) => con.has(id));
  }
  return responder({ total: filtrados.length, ids: filtrados });
}

Deno.serve(async (req) => {
  const pre = preflight(req);
  if (pre) return pre;

  const user = await usuarioDe(req);
  if (!user) return responder({ error: 'Sesión requerida.' }, 401);

  if (req.method === 'POST') {
    const limite = await limitar('latido', user.id);
    if (!limite.permitido) return respuesta429(limite.reintentarEnSeg);
    const cuerpo = await req.json().catch(() => ({}));
    if (cuerpo?.salir === true) return salir(user.id);
    const conv = typeof cuerpo?.conversacion_id === 'string' && UUID.test(cuerpo.conversacion_id)
      ? cuerpo.conversacion_id
      : null;
    return latido(user.id, conv);
  }

  if (req.method !== 'GET') return responder({ error: 'Método no permitido' }, 405);
  const url = new URL(req.url);

  const idsTexto = url.searchParams.get('ids');
  if (idsTexto !== null) {
    const ids = [...new Set(idsTexto.split(',').map((x) => x.trim()).filter((x) => UUID.test(x)))]
      .slice(0, 50);
    return estados(ids);
  }

  const lat = Number(url.searchParams.get('lat'));
  const lng = Number(url.searchParams.get('lng'));
  if (!Number.isFinite(lat) || !Number.isFinite(lng)) {
    return responder({ error: 'Parámetros inválidos' }, 400);
  }
  const radio = Math.min(Math.max(Number(url.searchParams.get('radio') ?? 5000) || 5000, 100), 50000);
  const oficioTexto = url.searchParams.get('oficio');
  const oficio = oficioTexto && /^\d+$/.test(oficioTexto) ? Number(oficioTexto) : null;
  return tecnicosCerca(lat, lng, radio, oficio);
});
