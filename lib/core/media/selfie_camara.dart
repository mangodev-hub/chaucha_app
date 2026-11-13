import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../widgets/hoja_clara.dart';

/// Cámara en vivo para la selfie. Devuelve los bytes de la foto o null si el
/// usuario cancela. Se usa en web, donde no hay forma de forzar la cámara
/// con image_picker.
class SelfieCamara extends StatefulWidget {
  const SelfieCamara({super.key});

  @override
  State<SelfieCamara> createState() => _SelfieCamaraState();
}

class _SelfieCamaraState extends State<SelfieCamara> {
  CameraController? _ctrl;
  String? _error;
  bool _tomando = false;

  @override
  void initState() {
    super.initState();
    _iniciar();
  }

  Future<void> _iniciar() async {
    try {
      final camaras = await availableCameras();
      final frontal = camaras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => camaras.first,
      );
      final ctrl = CameraController(
        frontal,
        ResolutionPreset.high,
        enableAudio: false,
      );
      await ctrl.initialize();
      if (!mounted) {
        await ctrl.dispose();
        return;
      }
      setState(() => _ctrl = ctrl);
    } catch (_) {
      if (mounted) {
        setState(
          () => _error =
              'Necesitamos acceso a la cámara para tomarte la foto. '
              'Actívala en el navegador e inténtalo de nuevo.',
        );
      }
    }
  }

  Future<void> _tomar() async {
    if (_tomando || _ctrl == null) return;
    setState(() => _tomando = true);
    try {
      final foto = await _ctrl!.takePicture();
      final Uint8List bytes = await foto.readAsBytes();
      if (mounted) Navigator.of(context).pop(bytes);
    } catch (_) {
      if (mounted) setState(() => _tomando = false);
    }
  }

  @override
  void dispose() {
    _ctrl?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Scaffold(
        appBar: AppBar(),
        body: HojaClara(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(_error!, textAlign: TextAlign.center),
            ),
          ),
        ),
      );
    }
    if (_ctrl == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned.fill(child: CameraPreview(_ctrl!)),
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                color: Colors.white,
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: FloatingActionButton(
              onPressed: _tomando ? null : _tomar,
              child: const Icon(Icons.camera_alt),
            ),
          ),
        ],
      ),
    );
  }
}
