import 'package:flutter/foundation.dart';
import 'package:isolate_manager/isolate_manager.dart';

import 'tareas.dart' as tareas;

/// Procesamiento de imágenes en paralelo y fuera del hilo de la interfaz.
abstract final class Hilos {
  /// Hilos de cada grupo: varias fotos (evidencias, cédula) se preparan a la
  /// vez sin trabar la pantalla.
  static const int _concurrentes = 2;

  static final _fotos = IsolateManager<Uint8List, Uint8List>.create(
    tareas.prepararFoto,
    workerName: 'prepararFoto',
    concurrent: _concurrentes,
  );

  static final _nitidez = IsolateManager<bool, Uint8List>.create(
    tareas.esNitida,
    workerName: 'esNitida',
  );

  static Future<bool> esNitida(Uint8List bytes) =>
      _ejecutar(_nitidez, tareas.esNitida, bytes);

  static Future<Uint8List> prepararFoto(Uint8List bytes) =>
      _ejecutar(_fotos, tareas.prepararFoto, bytes);

  static Future<List<Uint8List>> prepararFotos(List<Uint8List> fotos) =>
      Future.wait(fotos.map(prepararFoto));

  /// Un worker que no cargó en web no falla: se queda esperando.
  static const Duration _espera = Duration(seconds: 15);

  /// Si el hilo falla o no responde, la tarea corre aquí mismo.
  static Future<R> _ejecutar<R>(
    IsolateManager<R, Uint8List> grupo,
    R Function(Uint8List) tarea,
    Uint8List bytes,
  ) async {
    try {
      return await grupo.compute(bytes).timeout(_espera);
    } catch (e) {
      debugPrint('Hilos: $e; se ejecuta en el hilo principal.');
      return tarea(bytes);
    }
  }
}
