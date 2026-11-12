// Encabezado del inicio sobre el fondo oscuro: avatar con aro, "Hola,
// Carlos" en blanco y una línea debajo. En móvil reemplaza a la barra
// superior, así que el avatar abre el menú de la cuenta
// (perfil, agenda, configuración, salir), que el shell entrega por
// [AccionesShell].
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/tokens.dart';
import '../core/widgets/avatar_usuario.dart';
import '../features/auth/presentation/providers/sesion_provider.dart';
import 'menu_cuenta.dart';

/// Acciones del menú de la cuenta que el shell pone a disposición de las
/// pestañas con encabezado propio.
class AccionesShell extends InheritedWidget {
  const AccionesShell({
    super.key,
    required this.onCerrarSesion,
    required this.onPerfil,
    required this.onAgenda,
    required super.child,
  });

  final VoidCallback onCerrarSesion;
  final VoidCallback? onPerfil;
  final VoidCallback? onAgenda;

  static AccionesShell? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AccionesShell>();

  @override
  bool updateShouldNotify(AccionesShell anterior) =>
      onCerrarSesion != anterior.onCerrarSesion ||
      onPerfil != anterior.onPerfil ||
      onAgenda != anterior.onAgenda;
}

class EncabezadoSaludo extends ConsumerWidget {
  const EncabezadoSaludo({super.key, required this.subtitulo});

  /// Línea bajo el saludo ("Bienvenido a ChauchaApp").
  final String subtitulo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textos = Theme.of(context).textTheme;
    final usuario = ref.watch(usuarioActualProvider);
    final nombre = usuario?.nombres.trim().split(' ').first ?? '';
    final acciones = AccionesShell.maybeOf(context);

    final avatar = Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colores.primarioClaro, width: 2.5),
      ),
      child: AvatarUsuario(
        nombre: usuario?.nombreCompleto ?? '',
        rutaFoto: usuario?.fotoPerfilRuta,
        radio: 22,
      ),
    );

    return Row(
      children: [
        // Con menú disponible, el avatar lo abre; si no, es solo decorativo.
        if (acciones != null)
          MenuCuenta(
            onPerfil: acciones.onPerfil,
            onAgenda: acciones.onAgenda,
            onCerrarSesion: acciones.onCerrarSesion,
            compacto: true,
            hijo: avatar,
          )
        else
          avatar,
        const SizedBox(width: Espacios.m),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                nombre.isEmpty ? 'Hola' : 'Hola, $nombre',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textos.titleLarge?.copyWith(
                  color: Colores.sobreOscuro,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                subtitulo,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textos.bodyMedium?.copyWith(
                  color: Colores.sobreOscuro.withValues(alpha: 0.75),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
