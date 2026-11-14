import { createClient } from 'npm:@supabase/supabase-js@2';
import { importPKCS8, SignJWT } from 'npm:jose@5';
import { clave, conRedis } from '../_shared/redis.ts';

type Notificacion = {
  id: string;
  usuario_id: string;
  tipo: string;
  referencia_id: string | null;
  contenido: string | null;
};

type CuentaServicio = { project_id: string; client_email: string; private_key: string };

const TITULOS: Record<string, string> = {
  mensaje: 'Nuevo mensaje',
  chat: 'Te abrieron un chat',
  cotizacion: 'Nueva postulación',
  cotizacion_aceptada: 'Postulación aceptada',
  tarifa: 'Nueva tarifa',
  tarifa_cancelada: 'Tarifa cancelada',
  cierre: 'Servicio cerrado',
  solicitud_expirada: 'Solicitud expirada',
  sancion: 'Cuenta suspendida',
  sancion_aviso: 'Cuidado con tus reseñas',
  sancion_fin: 'Suspensión terminada',
};

const responder = (cuerpo: unknown, estado = 200) =>
  new Response(JSON.stringify(cuerpo), {
    status: estado,
    headers: { 'Content-Type': 'application/json' },
  });

// El token de Google dura 1 h; se reutiliza mientras la instancia siga viva.
let tokenGoogle: { valor: string; vence: number } | null = null;

async function accesoGoogle(cuenta: CuentaServicio): Promise<string> {
  const ahora = Math.floor(Date.now() / 1000);
  if (tokenGoogle && tokenGoogle.vence - 60 > ahora) return tokenGoogle.valor;

  const llave = await importPKCS8(cuenta.private_key, 'RS256');
  const asercion = await new SignJWT({
    scope: 'https://www.googleapis.com/auth/firebase.messaging',
  })
    .setProtectedHeader({ alg: 'RS256', typ: 'JWT' })
    .setIssuer(cuenta.client_email)
    .setAudience('https://oauth2.googleapis.com/token')
    .setIssuedAt(ahora)
    .setExpirationTime(ahora + 3600)
    .sign(llave);

  const r = await fetch('https://oauth2.googleapis.com/token', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: new URLSearchParams({
      grant_type: 'urn:ietf:params:oauth:grant-type:jwt-bearer',
      assertion: asercion,
    }),
  });
  if (!r.ok) throw new Error(`OAuth de Google falló: ${r.status} ${await r.text()}`);
  const { access_token, expires_in } = await r.json();
  tokenGoogle = { valor: access_token, vence: ahora + expires_in };
  return access_token;
}

Deno.serve(async (req) => {
  if (req.method !== 'POST') return responder({ error: 'Método no permitido' }, 405);

  const db = createClient(
    Deno.env.get('SUPABASE_URL')!,
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!,
  );

  const secreto = req.headers.get('x-push-secreto');
  if (!secreto) return responder({ error: 'No autorizado' }, 401);
  const { data: valido } = await db.rpc('push_secreto_valido', { p_secreto: secreto });
  if (valido !== true) return responder({ error: 'No autorizado' }, 401);

  try {
    const { record } = (await req.json()) as { record?: Notificacion };
    if (!record?.usuario_id) return responder({ error: 'Falta record' }, 400);

    if (record.tipo === 'mensaje' && record.referencia_id) {
      const abierta = await conRedis(
        (r) => r.hget<string>(clave('pres', record.usuario_id), 'conversacion'),
        null,
      );
      if (abierta === record.referencia_id) {
        return responder({ enviados: 0, omitido: 'viendo_chat' });
      }
    }

    const { data: dispositivos, error } = await db
      .from('dispositivos_push')
      .select('token')
      .eq('usuario_id', record.usuario_id);
    if (error) throw error;
    if (!dispositivos?.length) return responder({ enviados: 0 });

    const cuenta = JSON.parse(Deno.env.get('FIREBASE_SERVICE_ACCOUNT')!) as CuentaServicio;
    const acceso = await accesoGoogle(cuenta);
    const titulo = TITULOS[record.tipo] ?? 'ChauchaApp';
    const cuerpo = record.contenido ?? '';
    const appUrl = Deno.env.get('APP_URL');

    const resultados = await Promise.all(
      dispositivos.map(async ({ token }) => {
        const r = await fetch(
          `https://fcm.googleapis.com/v1/projects/${cuenta.project_id}/messages:send`,
          {
            method: 'POST',
            headers: {
              Authorization: `Bearer ${acceso}`,
              'Content-Type': 'application/json',
            },
            body: JSON.stringify({
              message: {
                token,
                notification: { title: titulo, body: cuerpo },
                // Solo strings en `data`. La app los usa al tocar el aviso.
                data: {
                  notificacion_id: record.id,
                  tipo: record.tipo,
                  referencia_id: record.referencia_id ?? '',
                },
                android: { priority: 'HIGH', notification: { tag: record.tipo } },
                apns: { payload: { aps: { sound: 'default' } } },
                webpush: {
                  notification: { icon: '/icons/Icon-192.png', tag: record.tipo },
                  ...(appUrl ? { fcm_options: { link: appUrl } } : {}),
                },
              },
            }),
          },
        );
        if (r.ok) return { token, ok: true };
        const detalle = await r.text();
        // Token desinstalado o caducado: se borra para no reintentar siempre.
        const muerto = r.status === 404 || detalle.includes('UNREGISTERED');
        return { token, ok: false, muerto, detalle };
      }),
    );

    const muertos = resultados.filter((x) => x.muerto).map((x) => x.token);
    if (muertos.length) await db.from('dispositivos_push').delete().in('token', muertos);

    for (const x of resultados.filter((x) => !x.ok && !x.muerto)) {
      console.error('FCM rechazó el envío:', x.detalle);
    }

    return responder({
      enviados: resultados.filter((x) => x.ok).length,
      borrados: muertos.length,
    });
  } catch (e) {
    console.error(e);
    return responder({ error: String(e) }, 500);
  }
});
