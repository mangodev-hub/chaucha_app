// Pantalla "Verificar identidad" del técnico.
import 'dart:typed_data';

import '../../../core/state/base_store.dart';
import '../models/documento_tecnico.dart';
import '../services/documento_service.dart';


class VerificacionViewModel extends BaseStore<Verificacion> {
  VerificacionViewModel(this._service);

  final DocumentoService _service;

  Future<void> cargar() => execute(_service.miVerificacion);

  
  Future<String?> subir(TipoDocumento tipo, Uint8List bytes) async {
    final error = await ejecutarAccion(() => _service.subir(tipo, bytes));
    if (error == null && !isDisposed) await cargar();
    return error;
  }
}