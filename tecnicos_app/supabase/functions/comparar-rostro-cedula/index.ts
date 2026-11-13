import { createClient } from 'npm:@supabase/supabase-js@2';
import { encodeBase64 } from 'jsr:@std/encoding@1/base64';
import { limitar, respuesta429 } from '../_shared/limite.ts';

const cors = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
};

const responder = (cuerpo: unknown, estado = 200) =>
  new Response(JSON.stringify(cuerpo), {
    status: estado,
    headers: { ...cors, 'Content-Type': 'application/json' },
  });

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') return new Response('ok', { headers: cors });

  try {
    const url = Deno.env.get('SUPABASE_URL')!;
    const cliente = createClient(url, Deno.env.get('SUPABASE_ANON_KEY')!, {
      global: { headers: { Authorization: req.headers.get('Authorization') ?? '' } },
    });

    const { data: { user } } = await cliente.auth.getUser();
    if (!user) return responder({ error: 'No autorizado' }, 401);

    // Una llamada a Gemini por comparación: límite por usuario.
    const limite = await limitar('comparar', user.id);
    if (!limite.permitido) return respuesta429(limite.reintentarEnSeg);

    const { selfie_ruta, cedula_ruta } = await req.json();
    if (!selfie_ruta?.startsWith(`${user.id}/`) || !cedula_ruta?.startsWith(`${user.id}/`)) {
      return responder({ error: 'Rutas inválidas' }, 400);
    }

    const selfie = await cliente.storage.from('perfiles').download(selfie_ruta);
    const cedula = await cliente.storage.from('cedulas').download(cedula_ruta);
    if (selfie.error || cedula.error) return responder({ error: 'No se pudo leer las imágenes' }, 400);

    const aParte = async (b: Blob) => ({
      inline_data: {
        mime_type: b.type || 'image/jpeg',
        data: encodeBase64(new Uint8Array(await b.arrayBuffer())),
      },
    });

    const respuesta = await fetch(
      `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=${Deno.env.get('GEMINI_API_KEY')}`,
      {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          contents: [{
            parts: [
              {
                text:
                  'La primera imagen es una selfie y la segunda es la foto de una cédula. ' +
                  'Compara solo el rostro de la selfie con la foto impresa en la cédula y dime si parecen ser la misma persona. ' +
                  'Si la cédula es ilegible o no se ve un rostro, responde misma_persona=false y explica el motivo. ' +
                  'Motivo en español, máximo 15 palabras.',
              },
              await aParte(selfie.data),
              await aParte(cedula.data),
            ],
          }],
          generationConfig: {
            responseMimeType: 'application/json',
            responseSchema: {
              type: 'OBJECT',
              properties: {
                misma_persona: { type: 'BOOLEAN' },
                confianza: { type: 'INTEGER' },
                motivo: { type: 'STRING' },
              },
              required: ['misma_persona', 'confianza', 'motivo'],
            },
          },
        }),
      },
    );

    if (!respuesta.ok) return responder({ disponible: false });

    const datos = await respuesta.json();
    const texto = datos?.candidates?.[0]?.content?.parts?.[0]?.text;
    if (!texto) return responder({ disponible: false });

    const resultado = JSON.parse(texto);

    const admin = createClient(url, Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!);
    await admin.from('comparaciones_rostro').insert({
      usuario_id: user.id,
      misma_persona: resultado.misma_persona,
      confianza: resultado.confianza,
      motivo: resultado.motivo,
    });

    return responder({ disponible: true, ...resultado });
  } catch (_) {
    return responder({ disponible: false });
  }
});