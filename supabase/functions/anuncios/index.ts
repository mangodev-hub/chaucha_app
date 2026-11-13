// Anuncios vigentes por ubicación, con caché compartida en Redis.
//
// Son los mismos para todos los usuarios y se piden en cada carga del inicio:
// se leen de Postgres una vez cada 5 minutos como máximo. Cuando el admin
// crea, edita o borra un anuncio, el trigger `trg_anuncios_cache` llama a
// esta función con `?invalidar=1` y la caché se vacía al instante.
//
// GET ?ubicacion=home_cliente|home_tecnico -> {anuncios: fila[], cache: bool}
// POST ?invalidar=1 (header x-push-secreto) -> {invalidadas: n}
//
// Se despliega con --no-verify-jwt (el trigger no tiene JWT); el GET exige
// sesión a mano, igual que la RLS de `anuncios` (solo authenticated).
import { preflight, responder } from '../_shared/cors.ts';
import { clienteAdmin, usuarioDe } from '../_shared/auth.ts';
import { clave, conRedis, TTL } from '../_shared/redis.ts';

const UBICACIONES = ['home_cliente', 'home_tecnico'];
const COLUMNAS =
  'id, titulo, descripcion, anunciante, categoria, imagen_ruta, url_destino, fecha_inicio, fecha_fin';

Deno.serve(async (req) => {
  const pre = preflight(req);
  if (pre) return pre;
  const url = new URL(req.url);

  if (url.searchParams.get('invalidar') === '1') {
    const secreto = req.headers.get('x-push-secreto');
    if (!secreto) return responder({ error: 'No autorizado' }, 401);
    const { data: valido } = await clienteAdmin().rpc('push_secreto_valido', { p_secreto: secreto });
    if (valido !== true) return responder({ error: 'No autorizado' }, 401);
    const n = await conRedis(
      (r) => r.del(...UBICACIONES.map((u) => clave('cache', 'anuncios', u))),
      0,
    );
    return responder({ invalidadas: n });
  }

  if (req.method !== 'GET') return responder({ error: 'Método no permitido' }, 405);
  const user = await usuarioDe(req);
  if (!user) return responder({ error: 'Sesión requerida.' }, 401);

  const ubicacion = url.searchParams.get('ubicacion') ?? '';
  if (!UBICACIONES.includes(ubicacion)) return responder({ error: 'Ubicación inválida' }, 400);
  const llave = clave('cache', 'anuncios', ubicacion);

  const guardados = await conRedis((r) => r.get<unknown[]>(llave), null);
  if (guardados) return responder({ anuncios: guardados, cache: true });

  const ahora = new Date().toISOString();
  const { data, error } = await clienteAdmin()
    .from('anuncios')
    .select(COLUMNAS)
    .in('ubicacion', [ubicacion, 'general'])
    .eq('activo', true)
    .or(`fecha_inicio.is.null,fecha_inicio.lte.${ahora}`)
    .or(`fecha_fin.is.null,fecha_fin.gte.${ahora}`)
    .limit(50);
  if (error) {
    console.error('anuncios', error.message);
    return responder({ error: 'No se pudieron leer los anuncios' }, 502);
  }
  await conRedis((r) => r.set(llave, data ?? [], { ex: TTL.anuncios }), null);
  return responder({ anuncios: data ?? [], cache: false });
});
