// Confirmación de identidad del técnico al enviar una oferta, cuando su
// celular no tiene biometría (o en web): su rostro en vivo contra la foto de
// perfil validada. Si coincide, deja registrada la confirmación que exige el
// trigger de cotizaciones.
//
// Cuerpo: los bytes de la foto (JPEG o PNG). Respuesta: { verificado, motivo? }
import { clienteAdmin, usuarioDe } from '../_shared/auth.ts';
import { preflight, responder } from '../_shared/cors.ts';
import { limitar, respuesta429 } from '../_shared/limite.ts';
import {
  compararRostros,
  esJpeg,
  esPng,
  MAX_BYTES_REKOGNITION,
  rekognitionConfigurado,
} from '../_shared/rekognition.ts';

const UMBRAL = Number(Deno.env.get('ROSTRO_UMBRAL_SIMILITUD') ?? '90');

Deno.serve(async (req) => {
  const pre = preflight(req);
  if (pre) return pre;
  if (req.method !== 'POST') return responder({ error: 'Método no permitido.' }, 405);

  try {
    if (!rekognitionConfigurado()) {
      return responder({ error: 'La verificación facial no está configurada.' }, 503);
    }
    const user = await usuarioDe(req);
    if (!user) return responder({ error: 'Sesión requerida.' }, 401);

    const limite = await limitar('rostroPostulacion', user.id);
    if (!limite.permitido) return respuesta429(limite.reintentarEnSeg);

    const foto = new Uint8Array(await req.arrayBuffer());
    if (foto.length === 0 || foto.length > MAX_BYTES_REKOGNITION) {
      return responder({ error: 'La foto no es válida o es muy pesada.' }, 400);
    }
    if (!esJpeg(foto) && !esPng(foto)) {
      return responder({ error: 'La foto debe ser JPG o PNG.' }, 400);
    }

    const admin = clienteAdmin();
    const { data: perfil } = await admin
      .from('usuarios')
      .select('rol, foto_perfil_ruta, foto_rostro_validada')
      .eq('id', user.id)
      .single();
    if (perfil?.rol !== 'tecnico') {
      return responder({ error: 'Solo los técnicos confirman su identidad para ofertar.' }, 403);
    }
    const ruta = perfil.foto_perfil_ruta as string | null;
    if (!ruta || !perfil.foto_rostro_validada) {
      return responder({ error: 'Primero registra tu foto de perfil.' }, 400);
    }

    const { data: archivo, error } = await admin.storage
      .from('perfiles')
      .download(ruta.replace(/^perfiles\//, ''));
    if (error || !archivo) {
      console.error('descarga perfil', ruta, error?.message);
      return responder({ error: 'No se pudo leer tu foto de perfil.' }, 503);
    }

    const r = await compararRostros(new Uint8Array(await archivo.arrayBuffer()), foto);
    if (r.tipo === 'falla') {
      return responder({ error: 'No pudimos verificar tu rostro. Inténtalo de nuevo.' }, 503);
    }
    if (r.tipo === 'sin_rostro') {
      return responder({
        verificado: false,
        motivo: 'No detectamos tu rostro. Mira de frente a la cámara, con buena luz.',
      });
    }
    if (r.rostros > 1) {
      return responder({ verificado: false, motivo: 'Debe aparecer solo tu rostro.' });
    }
    if (r.similitud < UMBRAL) {
      return responder({ verificado: false, motivo: 'Tu rostro no coincide con tu foto de perfil.' });
    }

    await admin.from('verificaciones_postulacion').insert({
      usuario_id: user.id,
      metodo: 'rostro',
      similitud: r.similitud,
    });
    return responder({ verificado: true });
  } catch (e) {
    console.error('excepcion', String(e));
    return responder({ error: 'No pudimos verificar tu rostro. Inténtalo de nuevo.' }, 503);
  }
});
