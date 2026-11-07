// Lectura de la tabla `usuarios`.
import '../models/usuario.dart';

abstract interface class UsuarioService {

  Future<Usuario?> obtenerPorId(String id);
}
