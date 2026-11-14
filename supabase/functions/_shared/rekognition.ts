import { AwsClient } from 'npm:aws4fetch@1.0.20';
import { encodeBase64 } from 'jsr:@std/encoding@1/base64';

/** Límite de Rekognition para imágenes enviadas como Bytes. */
export const MAX_BYTES_REKOGNITION = 5 * 1024 * 1024;

export type Comparacion =
  | { tipo: 'ok'; similitud: number; rostros: number }
  | { tipo: 'sin_rostro' }
  | { tipo: 'falla' };

export const rekognitionConfigurado = () =>
  !!Deno.env.get('AWS_ACCESS_KEY_ID') && !!Deno.env.get('AWS_SECRET_ACCESS_KEY');

export const esJpeg = (b: Uint8Array) => b[0] === 0xff && b[1] === 0xd8 && b[2] === 0xff;
export const esPng = (b: Uint8Array) =>
  b[0] === 0x89 && b[1] === 0x50 && b[2] === 0x4e && b[3] === 0x47;

/** Busca el rostro de [origen] en [destino]. */
export async function compararRostros(
  origen: Uint8Array,
  destino: Uint8Array,
): Promise<Comparacion> {
  const region = Deno.env.get('AWS_REGION') ?? 'us-east-1';
  const aws = new AwsClient({
    accessKeyId: Deno.env.get('AWS_ACCESS_KEY_ID')!,
    secretAccessKey: Deno.env.get('AWS_SECRET_ACCESS_KEY')!,
    region,
    service: 'rekognition',
  });

  let r: Response;
  try {
    r = await aws.fetch(`https://rekognition.${region}.amazonaws.com/`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/x-amz-json-1.1',
        'X-Amz-Target': 'RekognitionService.CompareFaces',
      },
      body: JSON.stringify({
        SourceImage: { Bytes: encodeBase64(origen) },
        TargetImage: { Bytes: encodeBase64(destino) },
        SimilarityThreshold: 0,
        QualityFilter: 'AUTO',
      }),
      signal: AbortSignal.timeout(15000),
    });
  } catch (e) {
    console.error('rekognition red', String(e));
    return { tipo: 'falla' };
  }

  const datos = await r.json().catch(() => ({}));
  if (!r.ok) {
    const tipo = String(datos?.__type ?? '').split('#').pop();
    // Sin rostro detectable en alguna de las dos imágenes.
    if (tipo === 'InvalidParameterException') return { tipo: 'sin_rostro' };
    console.error('rekognition', r.status, tipo, datos?.message ?? datos?.Message);
    return { tipo: 'falla' };
  }

  const coincidencias = (datos.FaceMatches ?? []) as { Similarity?: number }[];
  const otros = (datos.UnmatchedFaces ?? []) as unknown[];
  const rostros = coincidencias.length + otros.length;
  if (rostros === 0) return { tipo: 'sin_rostro' };
  const similitud = Math.max(0, ...coincidencias.map((c) => c.Similarity ?? 0));
  return { tipo: 'ok', similitud, rostros };
}
