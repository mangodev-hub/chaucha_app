// Confirmación de identidad del técnico antes de enviar una oferta: primero
// la biometría del celular (Face ID o huella, sin foto); si no tiene, su
// rostro en vivo con captura automática contra la foto de perfil.
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/hilos/hilos.dart';
import '../../../../core/media/selfie_camara.dart';
import '../../../../core/seguridad/biometria.dart';
import '../../../../core/widgets/mensajes.dart';
import '../../data/repositories/supabase_usuario_repository.dart';
import '../../domain/entities/resultado_rostro.dart';

const _intentos = 3;

/// true si el técnico confirmó que es él y el servidor lo registró.
Future<bool> confirmarIdentidadParaOfertar(
  BuildContext context,
  WidgetRef ref,
) async {
  final usuarios = ref.read(usuarioRepositoryProvider);
  final biometria = await ref
      .read(biometriaProvider)
      .confirmar('Confirma que eres tú para enviar tu oferta');
  if (!context.mounted) return false;
  switch (biometria) {
    case ResultadoBiometria.cancelada:
      return false;
    case ResultadoBiometria.confirmada:
      try {
        await usuarios.registrarVerificacionPostulacion();
        return true;
      } on AppFailure catch (e) {
        if (context.mounted) {
          context.mostrarMensaje(e.message, tipo: TipoMensaje.error);
        }
        return false;
      }
    case ResultadoBiometria.noDisponible:
      return _conRostro(context, ref);
  }
}

Future<bool> _conRostro(BuildContext context, WidgetRef ref) async {
  final usuarios = ref.read(usuarioRepositoryProvider);
  for (var intento = 1; intento <= _intentos; intento++) {
    final foto = await Navigator.of(context).push<Uint8List>(
      MaterialPageRoute(
        builder: (_) => const SelfieCamara(
          automatica: true,
          titulo: 'Confirma que eres tú',
        ),
      ),
    );
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

    final quedan = _intentos - intento;
    if (quedan == 0) {
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
