// Resultado del registro. 
import '../models/registro_datos.dart';



enum RegistroResultado { sesionIniciada, confirmarCorreo }


abstract interface class AuthService {


  Stream<String?> get cambiosDeSesion;

  Future<void> iniciarSesion({required String email, required String password});

  Future<RegistroResultado> registrar(RegistroDatos datos);

  Future<void> cerrarSesion();
}
