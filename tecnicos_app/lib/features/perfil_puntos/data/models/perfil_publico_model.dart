// Perfil público de un técnico armado con dos consultas de Supabase: su fila
// de `perfiles_tecnicos` (con nivel, nombre y oficios) y sus reseñas.
import '../../../../core/utils/json_utils.dart';
import '../../domain/entities/perfil_publico.dart';

abstract final class PerfilPublicoModel {
  /// Columnas de `perfiles_tecnicos` con los joins a nivel, usuario y oficios.
  static const String columnasPerfil =
      'usuario_id, verificado, calificacion_promedio, total_resenas, '
      'niveles_gamificacion(nombre), usuarios!fk_perfiles_usuario(nombres, apellidos), '
      'tecnico_oficios(oficios(nombre))';

  /// Columnas de `resenas` con el autor. `resenas` tiene dos claves hacia
  /// `usuarios` (autor y destinatario), así que se nombra la del autor.
  static const String columnasResenas =
      'calificacion, comentario, creado_en, '
      'autor:usuarios!fk_resenas_autor(nombres, apellidos)';

  /// Cuántas reseñas recientes se muestran.
  static const int limiteResenas = 10;

  static PerfilPublico desdeFilas(
    Map<String, dynamic> perfil,
    List<Map<String, dynamic>> resenas,
  ) {
    final usuario = anidado(perfil['usuarios']);
    final nombre = '${usuario?['nombres'] ?? ''} ${usuario?['apellidos'] ?? ''}'
        .trim();
    final oficios = <String>[
      for (final fila in _lista(perfil['tecnico_oficios']))
        if (anidado(fila['oficios'])?['nombre'] case final String nombre)
          nombre,
    ]..sort();
    return PerfilPublico(
      tecnicoId: perfil['usuario_id'] as String,
      nombre: nombre.isEmpty ? 'Técnico' : nombre,
      verificado: perfil['verificado'] as bool? ?? false,
      nivelNombre:
          anidado(perfil['niveles_gamificacion'])?['nombre'] as String? ??
          'Inicial',
      calificacionPromedio: aDouble(perfil['calificacion_promedio']),
      totalResenas: aInt(perfil['total_resenas']),
      oficios: oficios,
      resenas: [for (final fila in resenas) _resena(fila)],
    );
  }

  static ResenaPublica _resena(Map<String, dynamic> fila) {
    final comentario = (fila['comentario'] as String?)?.trim();
    return ResenaPublica(
      autor: nombreCorto(anidado(fila['autor'])),
      calificacion: aInt(fila['calificacion']),
      comentario: comentario == null || comentario.isEmpty ? null : comentario,
      creadoEn: aFecha(fila['creado_en']),
    );
  }

  /// "Ana Pérez" → "Ana P." (no se muestra el apellido completo del autor).
  static String nombreCorto(Map<String, dynamic>? usuario) {
    final nombres = (usuario?['nombres'] as String? ?? '').trim();
    final apellidos = (usuario?['apellidos'] as String? ?? '').trim();
    final primerNombre = nombres.split(RegExp(r'\s+')).first;
    if (primerNombre.isEmpty) return 'Cliente';
    if (apellidos.isEmpty) return primerNombre;
    return '$primerNombre ${apellidos[0].toUpperCase()}.';
  }

  static List<Map<String, dynamic>> _lista(Object? valor) => valor is List
      ? [
          for (final e in valor)
            if (e is Map<String, dynamic>) e,
        ]
      : const [];
}
