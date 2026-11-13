// Lectura de columnas geography que PostgREST devuelve como EWKB en hex.
/** Punto de una columna geography leída por PostgREST (EWKB en hex). */
export function puntoDeEwkb(hex: string | null | undefined): { lng: number; lat: number } | null {
  if (!hex || typeof hex !== 'string' || hex.length < 42) return null;
  const bytes = new Uint8Array(hex.match(/../g)!.map((b) => parseInt(b, 16)));
  const vista = new DataView(bytes.buffer);
  const le = bytes[0] === 1;
  const tipo = vista.getUint32(1, le);
  let o = 5;
  if (tipo & 0x20000000) o += 4; // trae SRID
  if ((tipo & 0xff) !== 1) return null; // solo POINT
  const lng = vista.getFloat64(o, le);
  const lat = vista.getFloat64(o + 8, le);
  return Number.isFinite(lng) && Number.isFinite(lat) ? { lng, lat } : null;
}
