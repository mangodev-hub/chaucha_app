// Perfil de un técnico tal como lo ve un cliente: reputación, oficios y
// reseñas recientes.
class PerfilPublico {
  const PerfilPublico({
    required this.tecnicoId,
    required this.nombre,
    required this.verificado,
    required this.nivelNombre,
    required this.calificacionPromedio,
    required this.totalResenas,
    required this.oficios,
    required this.resenas,
    this.fotoRuta,
    this.miembroDesde,
    this.esTecnico = true,
    this.esVip = false,
  });

  final String tecnicoId;
  final String nombre;
  final String? fotoRuta;
  final DateTime? miembroDesde;
  final bool esTecnico;

  /// Cliente VIP: ≥ 5 servicios cerrados en 90 días y sin reseñas "malo".
  /// Lo calcula un job nocturno en la base.
  final bool esVip;
  final bool verificado;
  final String nivelNombre;
  final double calificacionPromedio;
  final int totalResenas;

  /// Nombres de sus oficios, en orden alfabético.
  final List<String> oficios;

  /// Las más recientes primero.
  final List<ResenaPublica> resenas;

  /// Sin reseñas todavía: la calificación 0 no es una mala nota.
  bool get esNuevo => totalResenas == 0;
}

class ResenaPublica {
  const ResenaPublica({
    required this.autor,
    required this.calificacion,
    required this.creadoEn,
    this.comentario,
    this.etiquetas = const [],
  });

  /// Nombre corto del autor ("Ana P.").
  final String autor;
  final int calificacion;
  final String? comentario;
  final List<String> etiquetas;
  final DateTime creadoEn;
}
