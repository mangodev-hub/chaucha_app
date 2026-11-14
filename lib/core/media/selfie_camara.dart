import 'dart:async';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../widgets/hoja_clara.dart';

/// Cámara en vivo para la selfie. Con [automatica], no hay botón: tras una
/// cuenta regresiva la foto se toma sola.
class SelfieCamara extends StatefulWidget {
  const SelfieCamara({super.key, this.automatica = false, this.titulo});

  final bool automatica;

  /// Texto arriba de la cámara (p. ej. "Confirma que eres tú").
  final String? titulo;

  @override
  State<SelfieCamara> createState() => _SelfieCamaraState();
}

class _SelfieCamaraState extends State<SelfieCamara> {
  CameraController? _ctrl;
  String? _error;
  bool _tomando = false;
  Timer? _reloj;
  int _cuenta = 3;

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
      if (widget.automatica) _contar();
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

  void _contar() {
    _reloj = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return t.cancel();
      if (_cuenta <= 1) {
        t.cancel();
        unawaited(_tomar());
      } else {
        setState(() => _cuenta--);
      }
    });
  }

  @override
  void dispose() {
    _reloj?.cancel();
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
          if (widget.titulo case final titulo?)
            SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 56),
                  child: _Etiqueta(titulo),
                ),
              ),
            ),
          if (widget.automatica)
            Padding(
              padding: const EdgeInsets.all(32),
              child: _Etiqueta(
                _tomando ? 'Verificando…' : 'Mira a la cámara · $_cuenta',
              ),
            )
          else
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

class _Etiqueta extends StatelessWidget {
  const _Etiqueta(this.texto);

  final String texto;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
    decoration: BoxDecoration(
      color: Colors.black54,
      borderRadius: BorderRadius.circular(999),
    ),
    child: Text(
      texto,
      style: Theme.of(context).textTheme.titleMedium
          ?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
    ),
  );
}
