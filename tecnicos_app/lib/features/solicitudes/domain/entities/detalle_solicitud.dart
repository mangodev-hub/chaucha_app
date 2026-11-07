// Todo lo que muestra la pantalla de detalle, con las reglas que deciden
// qué ve y qué puede hacer cada usuario.
import '../../../auth/domain/entities/rol.dart';
import '../../../auth/domain/entities/usuario.dart';
import '../../../cotizaciones/domain/entities/cotizacion.dart';
import 'foto_solicitud.dart';
import 'solicitud.dart';

class DetalleSolicitud {
  const DetalleSolicitud({
    required this.solicitud,
    required this.fotos,
    required this.cotizaciones,
    required this.usuario,
  });

  final Solicitud solicitud;
  final List<FotoSolicitud> fotos;
  final List<Cotizacion> cotizaciones;

  /// Quien está viendo el detalle.
  final Usuario usuario;

  bool get soyCliente => usuario.rol == Rol.cliente;

  EstadoSolicitud get estado => solicitud.estado;

  Cotizacion? get cotizacionAceptada =>
      _primera((c) => c.estado == EstadoCotizacion.aceptada);

  /// La cotización del técnico que está viendo (null para el cliente).
  Cotizacion? get miCotizacion => _primera((c) => c.tecnicoId == usuario.id);

  bool get soyTecnicoAsignado =>
      !soyCliente && cotizacionAceptada?.tecnicoId == usuario.id;

  List<FotoSolicitud> fotosDe(TipoArchivo tipo) =>
      fotos.where((f) => f.tipo == tipo).toList();

  Cotizacion? _primera(bool Function(Cotizacion) condicion) {
    for (final c in cotizaciones) {
      if (condicion(c)) return c;
    }
    return null;
  }
}
