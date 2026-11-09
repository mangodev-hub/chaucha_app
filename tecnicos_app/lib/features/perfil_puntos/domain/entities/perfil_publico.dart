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
  });

  final String tecnicoId;
  final String nombre;
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
  });

  /// Nombre corto del autor ("Ana P.").
  final String autor;
  final int calificacion;
  final String? comentario;
  final DateTime creadoEn;
}
