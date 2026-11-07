// Rol del usuario. Refleja el CHECK de `usuarios.rol` en la base.
enum Rol {
  cliente('cliente'),
  tecnico('tecnico'),
  admin('admin');

  const Rol(this.valorDb);

  final String valorDb;

  static Rol desdeDb(String valor) => Rol.values.firstWhere(
        (rol) => rol.valorDb == valor,
        orElse: () => throw FormatException('Rol desconocido: $valor'),
      );



  static const List<Rol> registrables = [cliente, tecnico];
}
