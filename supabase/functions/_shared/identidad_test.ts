import { assertEquals } from 'jsr:@std/assert@1';
import {
  cedulaValida,
  cotejarCedula,
  cotejarDactilar,
  cotejarNombreCompleto,
  decidir,
  type Entrada,
  normalizar,
} from './identidad.ts';

Deno.test('cédula: dígito verificador y provincia', () => {
  assertEquals(cedulaValida('1710034065'), true);
  assertEquals(cedulaValida('1710034066'), false);
  assertEquals(cedulaValida('9910034065'), false);
});

Deno.test('normaliza tildes y conserva la Ñ', () => {
  assertEquals(normalizar('Buñay José'), 'BUÑAY JOSE');
});

Deno.test('nombre: exacto, cada parte en su lugar', () => {
  const impreso = 'BUÑAY CONDOR JOSE EDUARDO';
  const ok = { apellidos: 'coincide', nombres: 'coincide' };
  assertEquals(cotejarNombreCompleto('Buñay Cóndor', 'José Eduardo', impreso), ok);
  assertEquals(cotejarNombreCompleto('de la Torre', 'Ana', 'DE LA TORRE ANA'), ok);
  // Un apellido mal escrito, aunque sea una letra.
  assertEquals(cotejarNombreCompleto('Buñay Condori', 'José Eduardo', impreso), {
    apellidos: 'no_coincide',
    nombres: 'coincide',
  });
  // Ñ escrita como N.
  assertEquals(
    cotejarNombreCompleto('Bunay Condor', 'José Eduardo', impreso).apellidos,
    'no_coincide',
  );
  // Apellidos en el lugar de los nombres.
  assertEquals(cotejarNombreCompleto('José Eduardo', 'Buñay Cóndor', impreso), {
    apellidos: 'no_coincide',
    nombres: 'no_coincide',
  });
  // Falta un apellido: no se sabe de cuál, se marcan los dos.
  assertEquals(cotejarNombreCompleto('Buñay', 'José Eduardo', impreso), {
    apellidos: 'no_coincide',
    nombres: 'no_coincide',
  });
  // Falta el segundo nombre.
  assertEquals(cotejarNombreCompleto('Buñay Cóndor', 'José', impreso).nombres, 'no_coincide');
  assertEquals(cotejarNombreCompleto('Pérez', 'Juan', '').apellidos, 'ilegible');
});

Deno.test('número de cédula y código dactilar', () => {
  assertEquals(cotejarCedula('1710034065', '171003406-5'), 'coincide');
  assertEquals(cotejarCedula('1710034065', '1710034000'), 'no_coincide');
  assertEquals(cotejarDactilar('V4443V4442', 'V4443V4442'), 'coincide');
  assertEquals(cotejarDactilar('V4443V4442', 'V4443V4H42'), 'no_coincide');
  assertEquals(cotejarDactilar('V4443V4442', 'E1111E2222'), 'no_coincide');
});

const base: Entrada = {
  esCedula: true,
  rostro: 'alto',
  cedula: 'coincide',
  nombres: 'coincide',
  apellidos: 'coincide',
  dactilar: 'coincide',
};

Deno.test('decisión', () => {
  assertEquals(decidir(base).decision, 'aprobada');
  assertEquals(decidir({ ...base, rostro: 'medio' }).decision, 'revision');
  assertEquals(decidir({ ...base, rostro: 'bajo' }).decision, 'rechazada');
  assertEquals(decidir({ ...base, esCedula: false }).decision, 'rechazada');
  assertEquals(
    decidir({ ...base, esCedula: null, cedula: 'ilegible', nombres: 'ilegible', apellidos: 'ilegible', dactilar: 'ilegible' })
      .decision,
    'revision',
  );
});

Deno.test('datos que no coinciden: dice cuáles', () => {
  assertEquals(decidir({ ...base, cedula: 'no_coincide', apellidos: 'no_coincide' }), {
    decision: 'datos',
    campos: ['cedula', 'apellidos'],
  });
  assertEquals(decidir({ ...base, dactilar: 'no_coincide' }), {
    decision: 'datos',
    campos: ['codigo_dactilar'],
  });
  // La foto mala se corrige antes que los datos.
  assertEquals(decidir({ ...base, rostro: 'bajo', cedula: 'no_coincide' }).decision, 'rechazada');
});
