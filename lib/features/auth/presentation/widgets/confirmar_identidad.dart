// Confirmación de identidad del técnico antes de enviar una oferta: su rostro
// en vivo, con captura automática, contra la foto de perfil validada. No usa
// la huella ni el desbloqueo del celular: muchos técnicos tienen las huellas
// gastadas por el trabajo, y así se verifica a la persona, no al teléfono.
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/hilos/hilos.dart';
import '../../../../core/media/selfie_camara.dart';
import '../../../../core/widgets/mensajes.dart';
import '../../data/repositories/supabase_usuario_repository.dart';
import '../../domain/entities/resultado_rostro.dart';

const _intentos = 3;

typedef CapturaRostro = Future<Uint8List?> Function(BuildContext context);

/// Abre la cámara frontal y toma la foto sola tras una cuenta regresiva.
final capturaRostroProvider = Provider<CapturaRostro>(
  (ref) =>
      (context) => Navigator.of(context).push<Uint8List>(
        MaterialPageRoute(
          builder: (_) => const SelfieCamara(
            automatica: true,
            titulo: 'Confirma que eres tú',
          ),
        ),
      ),
);

/// true si el rostro coincidió con la foto de perfil y el servidor registró
/// la confirmación (la exige el trigger de cotizaciones).
Future<bool> confirmarIdentidadParaOfertar(
  BuildContext context,
  WidgetRef ref,
) async {
  final usuarios = ref.read(usuarioRepositoryProvider);
  final capturar = ref.read(capturaRostroProvider);
  for (var intento = 1; intento <= _intentos; intento++) {
    final foto = await capturar(context);
    if (foto == null || !context.mounted) return false;

    final ResultadoRostro resultado;
    try {
      resultado = await _mientras(
        context,
        () async =>
            usuarios.verificarRostroPostulacion(await Hilos.prepararFoto(foto)),
      );
    } on AppFailure catch (e) {
      if (context.mounted) {
        context.mostrarMensaje(e.message, tipo: TipoMensaje.error);
      }
      return false;
    }
    if (!context.mounted) return false;
    if (resultado.verificado) return true;

    if (intento == _intentos) {
      context.mostrarMensaje(
        resultado.motivo ?? 'No pudimos confirmar tu identidad.',
        tipo: TipoMensaje.error,
      );
      return false;
    }
    final otraVez = await context.confirmar(
      'No pudimos confirmar que eres tú',
      resultado.motivo ?? 'Inténtalo de nuevo con buena luz.',
      textoConfirmar: 'Intentar de nuevo',
      textoCancelar: 'Cancelar',
      icono: Icons.face_retouching_off_outlined,
    );
    if (!otraVez || !context.mounted) return false;
  }
  return false;
}

/// Muestra un indicador modal mientras corre [tarea].
Future<T> _mientras<T>(BuildContext context, Future<T> Function() tarea) async {
  final navegador = Navigator.of(context, rootNavigator: true);
  unawaited(
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const PopScope(
        canPop: false,
        child: Center(child: CircularProgressIndicator()),
      ),
    ),
  );
  try {
    return await tarea();
  } finally {
    navegador.pop();
  }
}
