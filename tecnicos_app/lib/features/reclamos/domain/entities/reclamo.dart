// Reclamo dentro de la garantía de 30 días de un servicio. Solo lo ven
// quien lo hizo y los asesores (admin).

/// Días de garantía desde que se completa un servicio.
const int diasGarantia = 30;

enum CategoriaReclamo {
  fallaTrabajo('Falla en el trabajo'),
  noSePresento('No se presentó'),
  trato('Mal trato'),
  cobroIndebido('Cobro indebido'),
  otro('Otro');

  const CategoriaReclamo(this.etiqueta);

  final String etiqueta;

  /// El técnico no reporta fallas en su propio trabajo.
  static List<CategoriaReclamo> para({required bool esCliente}) => [
    for (final c in values)
      if (esCliente || c != fallaTrabajo) c,
  ];
}

enum EstadoReclamo {
  recibido('Recibido'),
  enRevision('En revisión'),
  necesitaInfo('Necesita información'),
  resuelto('Resuelto'),
  rechazado('Rechazado');

  const EstadoReclamo(this.etiqueta);

  final String etiqueta;

  bool get abierto => this != resuelto && this != rechazado;

  static const abiertos = {recibido, enRevision, necesitaInfo};
}

class Reclamo {
  const Reclamo({
    required this.id,
    required this.numero,
    required this.solicitudId,
    required this.autorId,
    required this.categoria,
    required this.descripcion,
    required this.evidencias,
    required this.estado,
    required this.creadoEn,
    this.cotizacionId,
    this.contraId,
    this.resolucion,
    this.cerradoEn,
    this.clienteId,
    this.oficio,
    this.servicio,
    this.autorNombre,
    this.contraNombre,
    this.inicioVisita,
  });

  final String id;
  final int numero;
  final String solicitudId;
  final String? cotizacionId;
  final String autorId;
  final String? contraId;
  final CategoriaReclamo categoria;
  final String descripcion;

  /// Rutas en el bucket privado `reclamos`.
  final List<String> evidencias;
  final EstadoReclamo estado;
  final String? resolucion;
  final DateTime creadoEn;
  final DateTime? cerradoEn;

  // Datos del servicio y de las personas (joins).
  /// Cliente del servicio: con él se sabe quién es el técnico.
  final String? clienteId;
  final String? oficio;
  final String? servicio;
  final String? autorNombre;
  final String? contraNombre;
  final DateTime? inicioVisita;

  String get codigo => 'REC-${numero.toString().padLeft(4, '0')}';

  int diasAbierto(DateTime ahora) =>
      (cerradoEn ?? ahora).difference(creadoEn).inDays;
}

class MensajeReclamo {
  const MensajeReclamo({
    required this.id,
    required this.texto,
    required this.esAsesor,
    required this.creadoEn,
    this.autorId,
  });

  final String id;
  final String? autorId;
  final bool esAsesor;
  final String texto;
  final DateTime creadoEn;

  /// Mensaje automático (sin autor): va centrado.
  bool get esSistema => autorId == null && !esAsesor;
}

/// Estado de la garantía de un servicio completado.
class Garantia {
  const Garantia({required this.completadaEn});

  final DateTime completadaEn;

  DateTime get vence => completadaEn.add(const Duration(days: diasGarantia));

  bool vigente(DateTime ahora) => ahora.isBefore(vence);

  /// Días que quedan, redondeando hacia arriba (el último día cuenta).
  int diasRestantes(DateTime ahora) {
    if (!vigente(ahora)) return 0;
    return (vence.difference(ahora).inHours / 24).ceil();
  }

  /// De 1 (recién completado) a 0 (vencida).
  double fraccionRestante(DateTime ahora) {
    if (!vigente(ahora)) return 0;
    const total = Duration(days: diasGarantia);
    return (vence.difference(ahora).inSeconds / total.inSeconds).clamp(0, 1);
  }
}
