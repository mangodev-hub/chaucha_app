// Mapeo de [Rol] al texto de `usuarios.rol`. Refleja el CHECK de la base.
import '../../domain/entities/rol.dart';

extension RolDb on Rol {
  String get valorDb => switch (this) {
        Rol.cliente => 'cliente',
        Rol.tecnico => 'tecnico',
        Rol.admin => 'admin',
      };

  static Rol desdeDb(String valor) => Rol.values.firstWhere(
        (rol) => rol.valorDb == valor,
        orElse: () => throw FormatException('Rol desconocido: $valor'),
      );
}
