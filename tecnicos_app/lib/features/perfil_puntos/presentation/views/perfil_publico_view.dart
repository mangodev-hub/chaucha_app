// Perfil de un técnico visto por el cliente: reputación, oficios y reseñas.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../core/utils/formatos.dart';
import '../../../../core/utils/refrescar.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/avatar_usuario.dart';
import '../../../../core/widgets/estado_mensaje.dart';
import '../../../../core/widgets/hoja_clara.dart';
import '../../../../core/widgets/pildora.dart';
import '../../../../core/widgets/seccion.dart';
import '../../../../core/widgets/tarjeta_app.dart';
import '../../../../core/widgets/tarjeta_onda.dart';
import '../../domain/entities/certificacion.dart';
import '../../domain/entities/perfil_publico.dart';
import '../providers/certificaciones_provider.dart';
import '../providers/perfil_publico_provider.dart';
import '../widgets/certificaciones_widgets.dart';
import '../widgets/resena_widgets.dart';

class PerfilPublicoView extends ConsumerWidget {
  const PerfilPublicoView({
    super.key,
    required this.tecnicoId,
    this.esCliente = false,
  });

  /// Con true, [tecnicoId] es el id de un cliente.
  final bool esCliente;
  final String tecnicoId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final perfil = esCliente
        ? perfilClientePublicoProvider(tecnicoId)
        : perfilPublicoProvider(tecnicoId);
    return Scaffold(
      appBar: AppBar(
        title: Text(esCliente ? 'Perfil del cliente' : 'Perfil del técnico'),
      ),
      body: HojaClara(
        child: AsyncValueView<PerfilPublico>(
          value: ref.watch(perfil),
          onRetry: () => ref.invalidate(perfil),
          onData: (context, datos) {
            final certificados = datos.esTecnico
                ? ref
                          .watch(certificacionesAprobadasProvider(tecnicoId))
                          .value ??
                      const <Certificacion>[]
                : const <Certificacion>[];
            return RefreshIndicator(
              onRefresh: () => esperarSinError(ref.refresh(perfil.future)),
              child: ListView(
                padding: const EdgeInsets.all(Espacios.l),
                children: [
                  AnchoMaximo(
                    ancho: 720,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _Encabezado(
                          perfil: datos,
                          certificado: certificados.isNotEmpty,
                        ),
                        const SizedBox(height: Espacios.m),
                        _Estadisticas(perfil: datos),
                        if (datos.esTecnico)
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
                        if (certificados.isNotEmpty)
                          Seccion(
                            titulo: 'Certificaciones',
                            child: ListaCertificacionesPublica(
                              certificaciones: certificados,
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
            );
          },
        ),
      ),
    );
  }
}

/// Foto, nombre, verificación y nivel.
class _Encabezado extends StatelessWidget {
  const _Encabezado({required this.perfil, this.certificado = false});

  final PerfilPublico perfil;
  final bool certificado;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    // Cabecera celeste con el avatar en un aro blanco.
    return TarjetaOnda.celeste(
      padding: const EdgeInsets.all(Espacios.l + 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: const BoxDecoration(
              color: Colores.tarjeta,
              shape: BoxShape.circle,
            ),
            child: AvatarUsuario(
              nombre: perfil.nombre,
              rutaFoto: perfil.fotoRuta,
              radio: 32,
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
                    if (certificado) const InsigniaCertificado(),
                    if (perfil.esTecnico)
                      Pildora(
                        texto: 'Nivel ${perfil.nivelNombre}',
                        icono: Icons.workspace_premium_outlined,
                        color: Colores.info,
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
            colorIcono: Colores.cieloOscuro,
            valor: '${perfil.totalResenas}',
            etiqueta: perfil.totalResenas == 1 ? 'Reseña' : 'Reseñas',
          ),
        ),
        if (perfil.miembroDesde case final desde?) ...[
          const SizedBox(width: Espacios.m),
          Expanded(
            child: _Dato(
              icono: Icons.calendar_month_outlined,
              colorIcono: Colores.cieloOscuro,
              valor: Formatos.mesAnio(desde),
              etiqueta: 'Miembro desde',
            ),
          ),
        ],
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
