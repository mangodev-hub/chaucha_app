enum Rol {
  cliente,
  tecnico,
  admin;

  /// Roles que se pueden elegir al registrarse (admin se asigna a mano).
  static const List<Rol> registrables = [cliente, tecnico];
}
