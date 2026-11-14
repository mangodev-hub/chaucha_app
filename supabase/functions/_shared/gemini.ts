const lista = (v: string | undefined) =>
  (v ?? '').split(',').map((m) => m.trim()).filter((m) => /^[A-Za-z0-9._\-\/]+$/.test(m));

const MODELOS = [
  ...new Set([
    ...lista(Deno.env.get('MODELO_VISION_GEMINI')),
    // 3.5-flash primero: 3.8-flash se estaba colgando (timeouts de 25 s).
    'gemini-3.5-flash',
    'gemini-3.8-flash',
    'gemini-3.5-flash-lite',
  ]),
];
const REINTENTABLES = [429, 500, 502, 503, 504];
const INTENTOS_POR_MODELO = 2;
const TIEMPO_MAXIMO_MS = 20000;

const pausa = (ms: number) => new Promise((r) => setTimeout(r, ms));

export type Parte =
  | { text: string }
  | { inline_data: { mime_type: string; data: string } };

/** Devuelve el JSON que respondió el modelo, o null si ninguno respondió. */
export async function geminiJson<T>(
  instrucciones: string,
  partes: Parte[],
  esquema: Record<string, unknown>,
): Promise<T | null> {
  const clave = Deno.env.get('GEMINI_API_KEY');
  if (!clave) {
    console.error('Falta el secret GEMINI_API_KEY');
    return null;
  }
  for (const modelo of MODELOS) {
    for (let intento = 0; intento < INTENTOS_POR_MODELO; intento++) {
      let r: Response;
      try {
        r = await fetch(
          `https://generativelanguage.googleapis.com/v1beta/models/${modelo}:generateContent`,
          {
            method: 'POST',
            headers: { 'x-goog-api-key': clave, 'content-type': 'application/json' },
            signal: AbortSignal.timeout(TIEMPO_MAXIMO_MS),
            body: JSON.stringify({
              systemInstruction: { parts: [{ text: instrucciones }] },
              contents: [{ role: 'user', parts: partes }],
              generationConfig: {
                responseMimeType: 'application/json',
                responseSchema: esquema,
                maxOutputTokens: 4096,
                temperature: 0,
              },
            }),
          },
        );
      } catch (e) {
        console.error('gemini red/timeout', modelo, intento, String(e));
        break; // al siguiente modelo
      }

      if (r.ok) {
        const j = await r.json();
        const texto = j.candidates?.[0]?.content?.parts
          ?.find((p: { text?: string }) => typeof p.text === 'string')?.text ?? '';
        try {
          if (texto) return JSON.parse(texto) as T;
        } catch {
          console.error('gemini json invalido', modelo, texto.slice(0, 300));
        }
        break; // pasa al siguiente modelo
      }

      console.error('gemini', r.status, modelo, intento, (await r.text()).slice(0, 300));
      if (!REINTENTABLES.includes(r.status)) break;
      await pausa(800 * (intento + 1));
    }
  }
  return null;
}
