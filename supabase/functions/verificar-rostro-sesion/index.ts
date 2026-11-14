import { clienteAdmin, sesionDe, usuarioDe } from '../_shared/auth.ts';
import { preflight, responder } from '../_shared/cors.ts';
import { limitar, respuesta429 } from '../_shared/limite.ts';
import {
  compararRostros,
  esJpeg,
  esPng,
  MAX_BYTES_REKOGNITION as MAX_BYTES,
  rekognitionConfigurado,
} from '../_shared/rekognition.ts';

const MAX_INTENTOS = 3;
const UMBRAL = Number(Deno.env.get('ROSTRO_UMBRAL_SIMILITUD') ?? '90');

Deno.serve(async (req) => {
  const pre = preflight(req);
  if (pre) return pre;
  if (req.method !== 'POST') return responder({ error: 'Método no permitido.' }, 405);

  try {
    if (!rekognitionConfigurado()) {
      console.error('Faltan los secrets AWS_ACCESS_KEY_ID / AWS_SECRET_ACCESS_KEY');
      return responder({ error: 'La verificación facial no está configurada.' }, 503);
    }

    const user = await usuarioDe(req);
    if (!user) return responder({ error: 'Sesión requerida.' }, 401);
    const sesion = sesionDe(req);
    if (!sesion) return responder({ error: 'Sesión inválida, vuelve a iniciar sesión.' }, 401);

    const admin = clienteAdmin();

    // Fila de esta sesión (se crea en el primer intento).
    await admin
      .from('verificaciones_rostro_sesion')
      .upsert({ session_id: sesion, usuario_id: user.id }, {
        onConflict: 'session_id',
        ignoreDuplicates: true,
      });
    const { data: fila, error: errFila } = await admin
      .from('verificaciones_rostro_sesion')
      .select('usuario_id, intentos, verificado_en')
      .eq('session_id', sesion)
      .single();
    if (errFila || !fila || fila.usuario_id !== user.id) {
      console.error('fila sesion', errFila?.message);
      return responder({ error: 'Sesión inválida, vuelve a iniciar sesión.' }, 401);
    }
    if (fila.verificado_en) return responder({ verificado: true });
    if (fila.intentos >= MAX_INTENTOS) {
      return responder({
        verificado: false,
        bloqueado: true,
        intentos_restantes: 0,
        motivo: 'Agotaste los intentos. Vuelve a iniciar sesión.',
      });
    }

    const limite = await limitar('rostroSesion', user.id);
    if (!limite.permitido) return respuesta429(limite.reintentarEnSeg);

    const selfie = new Uint8Array(await req.arrayBuffer());
    if (selfie.length === 0 || selfie.length > MAX_BYTES) {
      return responder({ error: 'La foto no es válida o es muy pesada.' }, 400);
    }
    if (!esJpeg(selfie) && !esPng(selfie)) {
      return responder({ error: 'La foto debe ser JPG o PNG.' }, 400);
    }

    const { data: perfil } = await admin
      .from('usuarios')
      .select('foto_perfil_ruta, foto_rostro_validada')
      .eq('id', user.id)
      .single();
    const ruta = perfil?.foto_perfil_ruta as string | null | undefined;
    if (!ruta || !perfil?.foto_rostro_validada) {
      return responder({ error: 'Primero registra tu foto de perfil.' }, 400);
    }

    const { data: archivo, error: errArchivo } = await admin.storage
      .from('perfiles')
      .download(ruta.replace(/^perfiles\//, ''));
    if (errArchivo || !archivo) {
      console.error('descarga perfil', ruta, errArchivo?.message);
      return responder({ error: 'No se pudo leer tu foto de perfil.' }, 503);
    }
    const fotoPerfil = new Uint8Array(await archivo.arrayBuffer());

    const resultado = await compararRostros(fotoPerfil, selfie);
    if (resultado.tipo === 'falla') {
      return responder(
        { error: 'No pudimos verificar tu rostro en este momento. Inténtalo de nuevo.' },
        503,
      );
    }
    // Sin rostro no gasta intento: no es una suplantación, es una mala foto.
    if (resultado.tipo === 'sin_rostro') {
      return responder({
        verificado: false,
        bloqueado: false,
        intentos_restantes: MAX_INTENTOS - fila.intentos,
        motivo: 'No detectamos tu rostro. Mira de frente a la cámara, con buena luz.',
      });
    }

    const verificado = resultado.rostros === 1 && resultado.similitud >= UMBRAL;
    const intentos = verificado ? fila.intentos : fila.intentos + 1;
    await admin
      .from('verificaciones_rostro_sesion')
      .update({
        intentos,
        ultima_similitud: resultado.similitud,
        verificado_en: verificado ? new Date().toISOString() : null,
      })
      .eq('session_id', sesion);

    if (verificado) return responder({ verificado: true });

    const restantes = Math.max(0, MAX_INTENTOS - intentos);
    return responder({
      verificado: false,
      bloqueado: restantes === 0,
      intentos_restantes: restantes,
      motivo: resultado.rostros > 1
        ? 'Debe aparecer solo tu rostro en la foto.'
        : 'Tu rostro no coincide con tu foto de perfil.',
    });
  } catch (e) {
    console.error('excepcion', String(e));
    return responder({ error: 'No pudimos verificar tu rostro. Inténtalo de nuevo.' }, 503);
  }
});
