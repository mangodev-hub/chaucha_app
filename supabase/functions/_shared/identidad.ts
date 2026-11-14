/** Mayúsculas, sin tildes ni signos y con espacios simples. Ñ se conserva. */
export function normalizar(texto: string | null | undefined): string {
  return (texto ?? '')
    .toUpperCase()
    .replace(/Ñ/g, '\u0000')
    .normalize('NFD')
    .replace(/[̀-ͯ]/g, '')
    .replace(/\u0000/g, 'Ñ')
    .replace(/[^A-ZÑ0-9 ]/g, ' ')
    .replace(/\s+/g, ' ')
    .trim();
}

export const soloDigitos = (t: string | null | undefined) => (t ?? '').replace(/\D/g, '');
export const soloAlfanum = (t: string | null | undefined) =>
  (t ?? '').toUpperCase().replace(/[^A-Z0-9]/g, '');

/** Cédula ecuatoriana: 10 dígitos, provincia válida y dígito verificador (módulo 10). */
export function cedulaValida(cedula: string): boolean {
  if (!/^\d{10}$/.test(cedula)) return false;
  const provincia = Number(cedula.slice(0, 2));
  if (!((provincia >= 1 && provincia <= 24) || provincia === 30)) return false;
  if (Number(cedula[2]) >= 6) return false;
  let suma = 0;
  for (let i = 0; i < 9; i++) {
    let p = Number(cedula[i]) * (i % 2 === 0 ? 2 : 1);
    if (p > 9) p -= 9;
    suma += p;
  }
  return (10 - (suma % 10)) % 10 === Number(cedula[9]);
}

const palabras = (t: string | null | undefined) => normalizar(t).split(' ').filter(Boolean);

const iguales = (a: string[], b: string[]) => a.length === b.length && a.every((p, i) => p === b[i]);

export type Cotejo = 'coincide' | 'no_coincide' | 'ilegible';

export function cotejarNombreCompleto(
  apellidos: string,
  nombres: string,
  impreso: string | null | undefined,
): { apellidos: Cotejo; nombres: Cotejo } {
  const impresas = palabras(impreso);
  if (impresas.length < 2) return { apellidos: 'ilegible', nombres: 'ilegible' };
  const a = palabras(apellidos);
  const n = palabras(nombres);
  const prefijo = a.length > 0 && iguales(impresas.slice(0, a.length), a);
  const sufijo = n.length > 0 && iguales(impresas.slice(impresas.length - n.length), n);
  const completo = a.length + n.length === impresas.length;
  return {
    apellidos: prefijo && completo ? 'coincide' : 'no_coincide',
    nombres: sufijo && completo ? 'coincide' : 'no_coincide',
  };
}

export function cotejarCedula(registrada: string, leida: string | null | undefined): Cotejo {
  const l = soloDigitos(leida);
  if (l.length !== 10) return 'ilegible';
  return l === soloDigitos(registrada) ? 'coincide' : 'no_coincide';
}

/** Código dactilar (p. ej. V4443V4442): exacto. */
export function cotejarDactilar(
  registrado: string | null | undefined,
  leido: string | null | undefined,
): Cotejo {
  const r = soloAlfanum(registrado);
  const l = soloAlfanum(leido);
  if (!r) return 'coincide'; // no lo registró: no hay contra qué comparar
  if (l.length < 6) return 'ilegible';
  return r === l ? 'coincide' : 'no_coincide';
}

export type NivelRostro = 'alto' | 'medio' | 'bajo' | 'sin_rostro' | 'falla';

export function nivelRostro(similitud: number | null, alto: number, bajo: number): NivelRostro {
  if (similitud === null) return 'falla';
  if (similitud >= alto) return 'alto';
  if (similitud >= bajo) return 'medio';
  return 'bajo';
}

export type Lado = 'cedula_frontal' | 'cedula_posterior';

/** Campos del registro que se cotejan con la cédula. */
export type Campo = 'cedula' | 'nombres' | 'apellidos' | 'codigo_dactilar';

export type Decision =
  | { decision: 'aprobada' }
  | { decision: 'revision'; motivos: string[] }
  | { decision: 'rechazada'; lado: Lado; motivo: string }
  | { decision: 'datos'; campos: Campo[] };

export type Entrada = {
  esCedula: boolean | null; // null: el OCR no respondió
  rostro: NivelRostro;
  cedula: Cotejo;
  nombres: Cotejo;
  apellidos: Cotejo;
  dactilar: Cotejo;
};

export function decidir(e: Entrada): Decision {
  if (e.esCedula === false) {
    return {
      decision: 'rechazada',
      lado: 'cedula_frontal',
      motivo: 'La foto no parece el frente de una cédula ecuatoriana. Vuelve a tomarla.',
    };
  }
  if (e.rostro === 'bajo') {
    return {
      decision: 'rechazada',
      lado: 'cedula_frontal',
      motivo: 'El rostro de la cédula no coincide con tu selfie.',
    };
  }
  if (e.rostro === 'sin_rostro') {
    return {
      decision: 'rechazada',
      lado: 'cedula_frontal',
      motivo: 'No se distingue el rostro en la cédula. Toma la foto con buena luz y sin reflejos.',
    };
  }
  if (e.esCedula !== null && e.cedula === 'ilegible') {
    return {
      decision: 'rechazada',
      lado: 'cedula_frontal',
      motivo: 'No se lee el número de la cédula. Toma la foto de cerca, enfocada y sin reflejos.',
    };
  }

  const campos: Campo[] = [];
  if (e.cedula === 'no_coincide') campos.push('cedula');
  if (e.nombres === 'no_coincide') campos.push('nombres');
  if (e.apellidos === 'no_coincide') campos.push('apellidos');
  if (e.dactilar === 'no_coincide') campos.push('codigo_dactilar');
  if (campos.length > 0) return { decision: 'datos', campos };

  const motivos: string[] = [];
  if (e.esCedula === null) motivos.push('No se pudo leer la cédula automáticamente.');
  if (e.rostro === 'medio') motivos.push('Similitud facial intermedia.');
  if (e.rostro === 'falla') motivos.push('No se pudo comparar el rostro automáticamente.');
  if (e.nombres === 'ilegible' || e.apellidos === 'ilegible') {
    motivos.push('El nombre no se leyó con claridad.');
  }
  if (e.dactilar === 'ilegible') motivos.push('No se leyó el código dactilar.');
  return motivos.length === 0 ? { decision: 'aprobada' } : { decision: 'revision', motivos };
}
