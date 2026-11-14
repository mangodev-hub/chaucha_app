// ignore_for_file: depend_on_referenced_packages
import 'dart:js_interop';
import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:isolate_manager/isolate_manager.dart';
import 'package:tecnicos_app/core/hilos/tareas.dart';
import 'package:web/web.dart' as web;

Future<void> main() async {
  final imagen = img.Image(width: 2000, height: 1000);
  final bytes = img.encodePng(imagen);
  final grupo = IsolateManager<Uint8List, Uint8List>.create(
    prepararFoto,
    workerName: 'prepararFoto',
    concurrent: 2,
  );
  web.console.log('inicio'.toJS);
  final inicio = DateTime.now();
  try {
    final salidas = await Future.wait([
      grupo.compute(bytes),
      grupo.compute(bytes),
    ]).timeout(const Duration(seconds: 20));
    final ancho = img.decodeImage(salidas.first)!.width;
    web.console.log('OK ancho=$ancho'.toJS);
    web.document.title =
        'OK ancho=$ancho ms=${DateTime.now().difference(inicio).inMilliseconds}';
  } catch (e) {
    web.console.log('FALLO $e'.toJS);
    web.document.title = 'FALLO $e';
  }
  web.console.log('fin'.toJS);
}
