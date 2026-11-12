import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/media/selector_fotos.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/aviso_banner.dart';
import '../../../../core/widgets/boton_carga.dart';
import '../providers/selfie_provider.dart';
import '../widgets/auth_layout.dart';

class SelfieView extends ConsumerWidget {
  const SelfieView({super.key, required this.onCerrarSesion});

  final Future<void> Function() onCerrarSesion;

  Future<void> _tomar(WidgetRef ref) async {
    final bytes = await SelectorFotos.una(camara: true);
    if (bytes != null) await ref.read(selfieProvider.notifier).enviar(bytes);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estado = ref.watch(selfieProvider);
    final cargando = estado.isLoading;
    final mensaje = cargando
        ? null
        : estado.hasError
            ? AsyncValueView.mensajeDe(estado.error!)
            : estado.value;
    return AuthLayout(
      titulo: 'Tu foto de perfil',
      subtitulo: 'Tómate una selfie de frente y con el rostro descubierto. '
          'Será tu foto pública y no podrás cambiarla.',
      tituloCentrado: true,
      anchoEscritorio: 440,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (mensaje != null) ...[
            AvisoBanner(tipo: TipoAviso.error, mensaje: mensaje),
            const SizedBox(height: Espacios.l),
          ],
          BotonCarga(
            texto: 'Tomar selfie',
            icono: Icons.camera_alt_outlined,
            cargando: cargando,
            onPressed: () => _tomar(ref),
          ),
          TextButton(
            onPressed: cargando ? null : onCerrarSesion,
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );
  }
}