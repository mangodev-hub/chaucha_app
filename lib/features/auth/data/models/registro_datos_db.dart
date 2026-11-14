import '../../domain/entities/registro_datos.dart';
import 'rol_db.dart';

extension RegistroDatosDb on RegistroDatos {
  Map<String, dynamic> toMetadata() => {
    'nombres': nombres.trim(),
    'apellidos': apellidos.trim(),
    'cedula': cedula.trim(),
    'rol': rol.valorDb,
    'codigo_dactilar': codigoDactilar.trim().toUpperCase(),
  };
}
