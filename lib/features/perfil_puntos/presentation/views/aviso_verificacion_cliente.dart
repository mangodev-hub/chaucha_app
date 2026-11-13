import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/widgets/tarjeta_app.dart';
import '../../../auth/domain/entities/rol.dart';
import '../../../auth/presentation/providers/sesion_provider.dart';
import '../../domain/entities/documento_tecnico.dart';
import '../providers/verificacion_provider.dart';
import 'verificacion_view.dart';

/// Tarjeta con los pasos que faltan para verificarse. Cada paso abre la
/// verificación y arranca directo (cédula o selfie). Desaparece al quedar
/// verificado.
class AvisoVerificacionCliente extends ConsumerWidget {
  const AvisoVerificacionCliente({
    super.key,
    this.subtitulo = 'Necesitas verificarte para pedir un técnico.',
    this.margenInferior = 0,
    this.margenSuperior = 0,
    this.estiloInicio = false,
  });

  final String subtitulo;
  final double margenInferior;
  final double margenSuperior;

  /// Tarjeta blanca con sombra, como las del inicio del cliente.
  final bool estiloInicio;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usuario = ref.watch(usuarioActualProvider);
    if (usuario == null || usuario.verificado || usuario.rol == Rol.admin) {
      return const SizedBox.shrink();
    }
    final v = ref.watch(verificacionProvider).value;
    final frenteHecho = v != null && !v.puedeSubir(TipoDocumento.cedulaFrontal);
    final reversoHecho =
        v != null && !v.puedeSubir(TipoDocumento.cedulaPosterior);
    final selfieHecha = usuario.fotoVerificada;
    final enRevision = v != null && v.todoEnviado && selfieHecha;
    final textos = Theme.of(context).textTheme;

    Future<void> abrir() async {
      await mostrarVerificacion(context);
      await refrescarVerificacion(ref);
    }

    final contenido = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(Radios.medio),
          onTap: abrir,
          child: Row(
            children: [
              IconoRecuadro(
                icono: enRevision
                    ? Icons.hourglass_top_rounded
                    : Icons.shield_outlined,
                lado: 44,
              ),
              const SizedBox(width: Espacios.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      enRevision
                          ? 'Perfil en revisión'
                          : 'Falta verificar tu identidad',
                      style: textos.titleSmall,
                    ),
                    Text(
                      enRevision
                          ? 'Tu verificación se realizará pronto.'
                          : subtitulo,
                      style: textos.bodySmall?.copyWith(
                        color: Colores.tintaSuave,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: Espacios.s),
        _LineaPaso(
          numero: 1,
          texto: 'Frente de la cédula',
          hecho: frenteHecho,
          onTap: abrir,
        ),
        _LineaPaso(
          numero: 2,
          texto: 'Reverso de la cédula',
          hecho: reversoHecho,
          onTap: abrir,
        ),
        _LineaPaso(
          numero: 3,
          texto: 'Tómate una selfie',
          hecho: selfieHecha,
          onTap: abrir,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: () =>
                unawaited(context.push(AppRoutes.privacidadVerificacion)),
            icon: const Icon(Icons.lock_outline_rounded, size: 16),
            label: const Text('Uso de datos de verificación'),
          ),
        ),
      ],
    );
    return Padding(
      padding: EdgeInsets.only(top: margenSuperior, bottom: margenInferior),
      child: estiloInicio
          ? Container(
              padding: const EdgeInsets.all(Espacios.l),
              decoration: BoxDecoration(
                color: Colores.tarjeta,
                borderRadius: BorderRadius.circular(Radios.tarjeta),
                border: Border.all(color: Colores.primarioClaro),
                boxShadow: Sombras.tarjeta,
              ),
              child: contenido,
            )
          : TarjetaApp(colorBorde: Colores.primarioClaro, child: contenido),
    );
  }
}

class _LineaPaso extends StatelessWidget {
  const _LineaPaso({
    required this.numero,
    required this.texto,
    required this.hecho,
    required this.onTap,
  });

  final int numero;
  final String texto;
  final bool hecho;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    return InkWell(
      borderRadius: BorderRadius.circular(Radios.medio),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: Espacios.s,
          horizontal: Espacios.xs,
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 13,
              backgroundColor: hecho ? Colores.acento : Colores.primario,
              child: hecho
                  ? const Icon(Icons.check, size: 16, color: Colores.tarjeta)
                  : Text(
                      '$numero',
                      style: textos.labelMedium?.copyWith(
                        color: Colores.tarjeta,
                      ),
                    ),
            ),
            const SizedBox(width: Espacios.m),
            Expanded(
              child: Text(
                texto,
                style: textos.bodyMedium?.copyWith(
                  color: hecho ? Colores.tintaSuave : null,
                  decoration: hecho ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
            if (!hecho)
              const Icon(Icons.chevron_right, color: Colores.primario),
          ],
        ),
      ),
    );
  }
}

/// Devuelve true si el cliente puede continuar. Si no está verificado,
/// muestra un diálogo que lo lleva a verificarse y devuelve false.
Future<bool> exigirVerificado(BuildContext context, WidgetRef ref) async {
  if (ref.read(usuarioActualProvider)?.verificado ?? true) return true;
  await refrescarVerificacion(ref);
  if (ref.read(usuarioActualProvider)?.verificado ?? true) return true;
  if (!context.mounted) return false;
  final ir = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Verifica tu identidad'),
      content: const Text(
        'Para pedir un técnico primero debes verificar tu identidad. '
        'Mientras tanto puedes navegar y chatear.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: const Text('Ahora no'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          child: const Text('Verificarme'),
        ),
      ],
    ),
  );
  if (ir == true && context.mounted) unawaited(mostrarVerificacion(context));
  return false;
}

Future<void> refrescarVerificacion(WidgetRef ref) async {
  try {
    await ref.read(sesionProvider.notifier).recargarUsuario();
  } on AppFailure {
    return;
  }
}
