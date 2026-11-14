import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

abstract final class SelectorFotos {
  static const int _anchoMaximo = 1280;
  static const int _calidad = 70;

  static Future<List<Uint8List>> elegir({required int maximo}) async {
    if (maximo <= 0) return const [];
    final archivos = await ImagePicker().pickMultiImage(
      maxWidth: _anchoMaximo.toDouble(),
      imageQuality: _calidad,
    );
    final elegidos = archivos.take(maximo);
    return Future.wait(elegidos.map((archivo) => archivo.readAsBytes()));
  }

  static Future<Uint8List?> una({required bool camara}) async {
    final archivo = await ImagePicker().pickImage(
      source: camara ? ImageSource.camera : ImageSource.gallery,
      maxWidth: _anchoMaximo.toDouble(),
      imageQuality: _calidad,
    );
    return archivo?.readAsBytes();
  }
}
