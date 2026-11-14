import 'dart:typed_data';

import '../entities/datos_identidad.dart';
import '../entities/documento_tecnico.dart';
import '../entities/verificacion.dart';

abstract interface class DocumentoRepository {
  /// Documentos vigentes del técnico conectado, con URL firmada.
  Future<Verificacion> miVerificacion();

  /// Sube la imagen y la registra como pendiente de revisión.
  Future<void> subir(TipoDocumento tipo, Uint8List bytes);

  Future<void> validarIdentidad();

  /// Datos del registro que se cotejan con la cédula.
  Future<DatosIdentidad> misDatos();

  /// Corrige los datos que no coincidieron con la cédula.
  Future<void> corregirDatos(DatosIdentidad datos);
}
