// Documentos de verificación del técnico (cédula y selfie).
import 'dart:typed_data';

import '../models/documento_tecnico.dart';


abstract interface class DocumentoService {
  Future<Verificacion> miVerificacion();

  
  Future<void> subir(TipoDocumento tipo, Uint8List bytes);
}