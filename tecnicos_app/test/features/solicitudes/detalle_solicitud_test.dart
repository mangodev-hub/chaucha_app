import 'package:flutter_test/flutter_test.dart';
import 'package:tecnicos_app/features/auth/domain/entities/rol.dart';
import 'package:tecnicos_app/features/auth/domain/entities/usuario.dart';
import 'package:tecnicos_app/features/cotizaciones/domain/entities/cotizacion.dart';
import 'package:tecnicos_app/features/solicitudes/domain/entities/detalle_solicitud.dart';
import 'package:tecnicos_app/features/solicitudes/domain/entities/foto_solicitud.dart';

import 'falsos.dart';

DetalleSolicitud _detalle(Usuario usuario) => DetalleSolicitud(
      solicitud: solicitudDePrueba(),
      fotos: const [
        FotoSolicitud(tipo: TipoArchivo.problema, url: 'p1'),
        FotoSolicitud(tipo: TipoArchivo.evidencia, url: 'e1'),
        FotoSolicitud(tipo: TipoArchivo.problema, url: 'p2'),
      ],
      cotizaciones: [
        cotizacionDePrueba(id: 'q1', tecnicoId: 't1', estado: EstadoCotizacion.aceptada),
        cotizacionDePrueba(id: 'q2', tecnicoId: 't2', estado: EstadoCotizacion.rechazada),
      ],
      usuario: usuario,
    );

void main() {
  test('el cliente ve la cotización aceptada y no es técnico asignado', () {
    final detalle = _detalle(usuarioDePrueba('c1', Rol.cliente));

    expect(detalle.soyCliente, isTrue);
    expect(detalle.cotizacionAceptada?.id, 'q1');
    expect(detalle.miCotizacion, isNull);
    expect(detalle.soyTecnicoAsignado, isFalse);
  });

  test('el técnico de la cotización aceptada es el asignado', () {
    final detalle = _detalle(usuarioDePrueba('t1', Rol.tecnico));

    expect(detalle.soyCliente, isFalse);
    expect(detalle.miCotizacion?.id, 'q1');
    expect(detalle.soyTecnicoAsignado, isTrue);
  });

  test('otro técnico ve su cotización pero no es el asignado', () {
    final detalle = _detalle(usuarioDePrueba('t2', Rol.tecnico));

    expect(detalle.miCotizacion?.id, 'q2');
    expect(detalle.soyTecnicoAsignado, isFalse);
  });

  test('separa las fotos del problema y la evidencia', () {
    final detalle = _detalle(usuarioDePrueba('c1', Rol.cliente));

    expect(detalle.fotosDe(TipoArchivo.problema).map((f) => f.url), ['p1', 'p2']);
    expect(detalle.fotosDe(TipoArchivo.evidencia).map((f) => f.url), ['e1']);
  });
}
