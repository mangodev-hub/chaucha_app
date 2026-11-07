// Contrato de los documentos de verificación (cédula y selfie).
// Los métodos lanzan [AppFailure] si fallan.
import 'dart:typed_data';

import '../entities/documento_tecnico.dart';
import '../entities/verificacion.dart';

abstract interface class DocumentoRepository {
  /// Documentos vigentes del técnico conectado, con URL firmada.
  Future<Verificacion> miVerificacion();

  /// Sube la imagen y la registra como pendiente de revisión.
  Future<void> subir(TipoDocumento tipo, Uint8List bytes);
}
