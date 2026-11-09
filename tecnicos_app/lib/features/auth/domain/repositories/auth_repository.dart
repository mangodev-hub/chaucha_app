// Contrato de autenticación. Los métodos lanzan [AppFailure] si fallan.
import '../entities/registro_datos.dart';
import '../entities/registro_resultado.dart';

abstract interface class AuthRepository {
  /// Emite el id del usuario conectado, o null al cerrar sesión.
  Stream<String?> get cambiosDeSesion;

  Future<void> iniciarSesion({required String email, required String password});

  Future<RegistroResultado> registrar(RegistroDatos datos);

  Future<void> cerrarSesion();
  Future<void> iniciarConGoogle();
  Stream<void> get recuperacionIniciada;

  String? get usuarioId;

  Future<void> enviarRecuperacion(String email);

  Future<void> reenviarConfirmacion(String email);

  Future<void> cambiarContrasena(String nueva);
    String? get correoActual;

  bool get usaContrasena;

  Future<void> cambiarContrasenaConActual({
    required String actual,
    required String nueva,
  });

  Future<void> cambiarCorreo({
    required String contrasena,
    required String nuevo,
  });
  Future<void> cerrarSesionEnTodos();
}
