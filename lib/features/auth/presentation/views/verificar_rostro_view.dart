import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/media/selector_fotos.dart';
import '../../../../core/media/selfie_camara.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/aviso_banner.dart';
import '../../../../core/widgets/boton_carga.dart';
import '../../../../core/widgets/foto_perfil_caja.dart';
import '../providers/sesion_provider.dart';
import '../providers/verificar_rostro_provider.dart';
import '../widgets/auth_layout.dart';

/// Tras cada inicio de sesión: selfie en vivo comparada con la foto de
/// perfil. Hasta que coincida, el router no deja entrar a la app.
class VerificarRostroView extends ConsumerWidget {
  const VerificarRostroView({super.key, required this.onCerrarSesion});

  final Future<void> Function() onCerrarSesion;

  // Siempre la cámara, nunca la galería: evita subir fotos de fotos.
  Future<void> _tomar(BuildContext context, WidgetRef ref) async {
    final Uint8List? bytes = kIsWeb
        ? await Navigator.of(context).push<Uint8List>(
            MaterialPageRoute(builder: (_) => const SelfieCamara()),
          )
        : await SelectorFotos.una(camara: true);
    if (bytes != null) {
      await ref.read(verificarRostroProvider.notifier).enviar(bytes);
    }
  }

  static String _iniciales(String nombre) => nombre
      .split(' ')
      .where((p) => p.isNotEmpty)
      .take(2)
      .map((p) => p[0].toUpperCase())
      .join();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usuario = ref.watch(usuarioActualProvider);
    final estado = ref.watch(verificarRostroProvider);
    final cargando = estado.isLoading;
    final mensaje = cargando
        ? null
        : estado.hasError
        ? AsyncValueView.mensajeDe(estado.error!)
        : estado.value;
    final textos = Theme.of(context).textTheme;

    return AuthLayout(
      titulo: 'Confirma que eres tú',
      subtitulo:
          'Tómate una selfie de frente, sin lentes ni gorra. La comparamos '
          'con tu foto de perfil para proteger tu cuenta.',
      tituloCentrado: true,
      anchoEscritorio: 440,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: FotoPerfilCaja(
              tamano: 96,
              circular: true,
              rutaFoto: usuario?.fotoPerfilRuta,
              iniciales: _iniciales(usuario?.nombreCompleto ?? ''),
            ),
          ),
          const SizedBox(height: Espacios.l),
          if (mensaje != null) ...[
            AvisoBanner(tipo: TipoAviso.error, mensaje: mensaje),
            const SizedBox(height: Espacios.l),
          ],
          BotonCarga(
            texto: 'Verificar mi rostro',
            icono: Icons.face_retouching_natural_outlined,
            cargando: cargando,
            onPressed: () => _tomar(context, ref),
          ),
          const SizedBox(height: Espacios.s),
          Text(
            'No guardamos esta selfie: solo el resultado de la comparación.',
            textAlign: TextAlign.center,
            style: textos.bodySmall?.copyWith(color: Colores.tintaSuave),
          ),
          TextButton(
            onPressed: cargando
                ? null
                : () => context.push(AppRoutes.privacidadVerificacion),
            child: const Text('Cómo usamos tus datos'),
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
