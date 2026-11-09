// Perfil de un técnico visto por el cliente: reputación, oficios y reseñas.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../core/utils/refrescar.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/estado_mensaje.dart';
import '../../../../core/widgets/pildora.dart';
import '../../../../core/widgets/seccion.dart';
import '../../../../core/widgets/tarjeta_app.dart';
import '../../domain/entities/perfil_publico.dart';
import '../providers/perfil_publico_provider.dart';
import '../widgets/resena_widgets.dart';

class PerfilPublicoView extends ConsumerWidget {
  const PerfilPublicoView({super.key, required this.tecnicoId});

  final String tecnicoId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final perfil = perfilPublicoProvider(tecnicoId);
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil del técnico')),
      body: AsyncValueView<PerfilPublico>(
        value: ref.watch(perfil),
        onRetry: () => ref.invalidate(perfil),
        onData: (context, datos) => RefreshIndicator(
          onRefresh: () => esperarSinError(ref.refresh(perfil.future)),
          child: ListView(
            padding: const EdgeInsets.all(Espacios.l),
            children: [
              AnchoMaximo(
                ancho: 720,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _Encabezado(perfil: datos),
                    const SizedBox(height: Espacios.m),
                    _Estadisticas(perfil: datos),
                    Seccion(
                      titulo: 'Oficios',
                      child: datos.oficios.isEmpty
                          ? const EstadoMensaje(
                              compacto: true,
                              icono: Icons.handyman_outlined,
                              mensaje: 'Todavía no eligió sus oficios.',
                            )
                          : Wrap(
                              spacing: Espacios.s,
                              runSpacing: Espacios.s,
                              children: [
                                for (final oficio in datos.oficios)
                                  Pildora(
                                    texto: oficio,
                                    icono: Icons.handyman_outlined,
                                    color: Colores.primario,
                                  ),
                              ],
                            ),
                    ),
                    Seccion(
                      titulo: datos.totalResenas == 0
                          ? 'Reseñas'
                          : 'Reseñas (${datos.totalResenas})',
                      child: datos.resenas.isEmpty
                          ? const EstadoMensaje(
                              compacto: true,
                              icono: Icons.reviews_outlined,
                              mensaje: 'Aún no tiene reseñas.',
                            )
                          : Column(
                              children: [
                                for (final r in datos.resenas)
                                  TarjetaResena(resena: r),
                              ],
                            ),
                    ),
                    const SizedBox(height: Espacios.xl),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Inicial grande, nombre, verificación y nivel.
class _Encabezado extends StatelessWidget {
  const _Encabezado({required this.perfil});

  final PerfilPublico perfil;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final nombre = perfil.nombre.trim();
    final inicial = nombre.isEmpty ? '?' : nombre[0].toUpperCase();
    return TarjetaApp(
      padding: const EdgeInsets.all(Espacios.l + 4),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: Colores.primarioSuave,
            child: Text(
              inicial,
              style: textos.headlineSmall?.copyWith(
                color: Colores.primarioOscuro,
              ),
            ),
          ),
          const SizedBox(width: Espacios.l),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(perfil.nombre, style: textos.titleLarge),
                const SizedBox(height: Espacios.s),
                Wrap(
                  spacing: Espacios.s,
                  runSpacing: Espacios.xs,
                  children: [
                    if (perfil.verificado)
                      const Pildora(
                        texto: 'Verificado',
                        icono: Icons.verified,
                        color: Colores.acento,
                      )
                    else
                      const Pildora(
                        texto: 'Sin verificar',
                        icono: Icons.shield_outlined,
                        color: Colores.tintaSuave,
                      ),
                    Pildora(
                      texto: 'Nivel ${perfil.nivelNombre}',
                      icono: Icons.workspace_premium_outlined,
                      color: Colores.primario,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Calificación y número de reseñas, en dos tarjetas.
class _Estadisticas extends StatelessWidget {
  const _Estadisticas({required this.perfil});

  final PerfilPublico perfil;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _Dato(
            icono: Icons.star_rounded,
            colorIcono: Colores.estrella,
            valor: perfil.esNuevo
                ? 'Nuevo'
                : perfil.calificacionPromedio.toStringAsFixed(1),
            etiqueta: 'Calificación',
          ),
        ),
        const SizedBox(width: Espacios.m),
        Expanded(
          child: _Dato(
            icono: Icons.reviews_outlined,
            colorIcono: Colores.primario,
            valor: '${perfil.totalResenas}',
            etiqueta: perfil.totalResenas == 1 ? 'Reseña' : 'Reseñas',
          ),
        ),
      ],
    );
  }
}

class _Dato extends StatelessWidget {
  const _Dato({
    required this.icono,
    required this.colorIcono,
    required this.valor,
    required this.etiqueta,
  });

  final IconData icono;
  final Color colorIcono;
  final String valor;
  final String etiqueta;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    return TarjetaApp(
      child: Row(
        children: [
          Icon(icono, color: colorIcono, size: 28),
          const SizedBox(width: Espacios.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  valor,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textos.titleLarge,
                ),
                Text(
                  etiqueta,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textos.bodySmall?.copyWith(color: Colores.tintaSuave),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
