import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../auth/domain/entities/rol.dart';
import '../../../auth/presentation/providers/sesion_provider.dart';
import '../providers/tarifa_chat_provider.dart';
import '../views/chat_view.dart';

/// Escritorio: ventana flotante estilo Messenger. Móvil: pantalla completa.
Future<void> abrirChat(
  BuildContext context,
  String conversacionId, {
  required bool esCliente,
}) async {
  if (ResponsiveLayout.isDesktop(context)) {
    _ChatFlotante.abrir(context, conversacionId);
    return;
  }
  await context.push(AppRoutes.chat(conversacionId, esCliente: esCliente));
}

abstract final class _ChatFlotante {
  static OverlayEntry? _entrada;
  static final ValueNotifier<String?> id = ValueNotifier<String?>(null);

  static void abrir(BuildContext context, String conversacionId) {
    id.value = conversacionId;
    if (_entrada != null) return;
    final entrada = OverlayEntry(builder: (_) => const _Ventana());
    _entrada = entrada;
    Overlay.of(context, rootOverlay: true).insert(entrada);
  }

  static void cerrar() {
    _entrada?.remove();
    _entrada = null;
    id.value = null;
  }
}

class _Ventana extends ConsumerStatefulWidget {
  const _Ventana();

  @override
  ConsumerState<_Ventana> createState() => _VentanaState();
}

class _VentanaState extends ConsumerState<_Ventana> {
  bool _minimizada = false;

  @override
  Widget build(BuildContext context) {
    // Si se cierra la sesión, la ventana desaparece.
    ref.listen(usuarioActualProvider, (_, usuario) {
      if (usuario == null) {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => _ChatFlotante.cerrar(),
        );
      }
    });

    final alto = MediaQuery.sizeOf(context).height;
    final altura = _minimizada
        ? 52.0
        : (alto - 96).clamp(320.0, 520.0).toDouble();
    final blanco = Theme.of(context).colorScheme.onPrimary;

    return Positioned(
      right: 96,
      bottom: 0,
      child: ValueListenableBuilder<String?>(
        valueListenable: _ChatFlotante.id,
        builder: (context, id, _) {
          if (id == null) return const SizedBox.shrink();
          final esCliente =
              ref.watch(usuarioActualProvider)?.rol == Rol.cliente;
          final nombre = esCliente
              ? ref.watch(contextoChatProvider(id)).value?.oferta?.tecnicoNombre
              : null;
          return Material(
            elevation: 10,
            color: Colores.fondo,
            clipBehavior: Clip.antiAlias,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(Radios.grande),
              ),
            ),
            child: SizedBox(
              width: 360,
              height: altura,
              child: Column(
                children: [
                  Container(
                    height: 52,
                    padding: const EdgeInsets.only(left: Espacios.l),
                    color: Colores.primario,
                    child: Row(
                      children: [
                        Icon(
                          Icons.chat_bubble_rounded,
                          color: blanco,
                          size: 20,
                        ),
                        const SizedBox(width: Espacios.s),
                        Expanded(
                          child: Text(
                            nombre ?? 'Chat',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(color: blanco),
                          ),
                        ),
                        IconButton(
                          tooltip: _minimizada ? 'Expandir' : 'Minimizar',
                          color: blanco,
                          icon: Icon(
                            _minimizada
                                ? Icons.keyboard_arrow_up_rounded
                                : Icons.remove_rounded,
                          ),
                          onPressed: () =>
                              setState(() => _minimizada = !_minimizada),
                        ),
                        IconButton(
                          tooltip: 'Cerrar',
                          color: blanco,
                          icon: const Icon(Icons.close_rounded),
                          onPressed: _ChatFlotante.cerrar,
                        ),
                      ],
                    ),
                  ),
                  if (!_minimizada)
                    Expanded(
                      child: ChatPanel(key: ValueKey(id), conversacionId: id),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
