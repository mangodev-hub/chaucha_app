import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/pestana_solicitada.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/utils/formatos.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/foto_perfil_caja.dart';
import '../../../../core/widgets/mensajes.dart';
import '../../../../core/widgets/tarjeta_inicio.dart';
import '../../../catalogo/presentation/widgets/icono_oficio.dart';
import '../../../perfil_puntos/data/repositories/supabase_perfil_repository.dart';
import '../../../perfil_puntos/domain/entities/nueva_resena.dart';
import '../../../perfil_puntos/presentation/widgets/resena_dialog.dart';
import '../../../perfil_puntos/presentation/widgets/resenas_perfil.dart';
import '../../../reclamos/domain/entities/reclamo.dart';
import '../../../reclamos/presentation/widgets/formulario_reclamo.dart';
import '../../../solicitudes/domain/entities/servicio_completado.dart';
import '../../../solicitudes/domain/entities/solicitud.dart';
import '../providers/perfil_cliente_provider.dart';
import '../views/inicio_view.dart';
import 'inicio_cliente_widgets.dart';

const _gris = Colores.tintaGris;

String _iniciales(String nombre) {
  final ini = nombre
      .split(' ')
      .where((p) => p.isNotEmpty)
      .take(2)
      .map((p) => p[0])
      .join();
  return ini.isEmpty ? '?' : ini.toUpperCase();
}

/// "Marco Antonio Vinueza Paredes" → "Marco Vinueza".
String _nombreCorto(String nombre) {
  final partes = nombre.split(' ').where((p) => p.isNotEmpty).toList();
  if (partes.length < 3) return partes.join(' ');
  return '${partes.first} ${partes[partes.length - 2]}';
}

String _dos(int n) => n.toString().padLeft(2, '0');
String _fecha(DateTime f) => '${_dos(f.day)}/${_dos(f.month)}/${f.year}';

void _irAPestana(WidgetRef ref, String titulo) =>
    ref.read(pestanaSolicitadaProvider.notifier).pedir(titulo);

/// Tarjeta blanca de la columna principal: radio 18, padding 20 y título
/// de 16 px en 800, con algo opcional a la derecha.
class SeccionPerfil extends StatelessWidget {
  const SeccionPerfil({
    super.key,
    required this.titulo,
    required this.child,
    this.extremo,
  });

  final String titulo;
  final Widget? extremo;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    return TarjetaInicio(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  titulo,
                  style: textos.titleMedium?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              ?extremo,
            ],
          ),
          const SizedBox(height: Espacios.m),
          child,
        ],
      ),
    );
  }
}

class _Enlace extends StatelessWidget {
  const _Enlace(this.texto, this.onTap);

  final String texto;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(Radios.pequeno),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Text(
        texto,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Colores.primarioVivo,
        ),
      ),
    ),
  );
}

class _Pildora extends StatelessWidget {
  const _Pildora({
    required this.texto,
    required this.fondo,
    required this.color,
    this.icono,
    this.onTap,
  });

  final String texto;
  final Color fondo;
  final Color color;
  final IconData? icono;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cuerpo = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: fondo,
        borderRadius: BorderRadius.circular(Radios.pildora),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icono != null) ...[
            Icon(icono, size: 14, color: color),
            const SizedBox(width: 4),
          ],
          Flexible(
            child: Text(
              texto,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
    final onTap = this.onTap;
    if (onTap == null) return cuerpo;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Radios.pildora),
      child: cuerpo,
    );
  }
}

ButtonStyle _estiloChico(BuildContext context, {bool conBorde = false}) =>
    TextButton.styleFrom(
      foregroundColor: conBorde ? Colores.primario : Colores.tarjeta,
      backgroundColor: conBorde ? Colores.tarjeta : Colores.primario,
      minimumSize: const Size(0, 34),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Radios.pequeno),
        side: conBorde
            ? const BorderSide(color: Colores.linea, width: 1.5)
            : BorderSide.none,
      ),
      textStyle: Theme.of(context).textTheme.labelLarge
          ?.copyWith(fontSize: 13, fontWeight: FontWeight.w700),
    );

// ------------------------------------------------------ solicitudes activas

class SolicitudesActivasPerfil extends ConsumerWidget {
  const SolicitudesActivasPerfil({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textos = Theme.of(context).textTheme;
    final activas = ref.watch(solicitudesActivasProvider);
    final lista = activas.value ?? const <SolicitudActiva>[];
    final Widget contenido;
    if (activas.isLoading && !activas.hasValue) {
      contenido = const SizedBox(
        height: 56,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    } else if (activas.hasError && !activas.hasValue) {
      contenido = Text(
        'No pudimos cargar tus solicitudes.',
        style: textos.bodyMedium?.copyWith(color: _gris),
      );
    } else if (lista.isEmpty) {
      contenido = Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: Espacios.m,
        runSpacing: Espacios.s,
        children: [
          Text(
            'No tienes solicitudes activas',
            style: textos.bodyMedium?.copyWith(color: _gris),
          ),
          TextButton(
            style: _estiloChico(context),
            onPressed: () =>
                unawaited(context.push(AppRoutes.clienteNuevaSolicitud)),
            child: const Text('+ Publicar solicitud'),
          ),
        ],
      );
    } else {
      contenido = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (i, a) in lista.take(2).indexed) ...[
            if (i > 0) const Divider(height: 1, color: Colores.divisor),
            _FilaActiva(activa: a),
          ],
        ],
      );
    }
    return SeccionPerfil(
      titulo: 'Mis solicitudes activas',
      extremo: lista.isEmpty
          ? null
          : _Enlace('Ver todas', () => _irAPestana(ref, 'Mis solicitudes')),
      child: contenido,
    );
  }
}

class _FilaActiva extends StatelessWidget {
  const _FilaActiva({required this.activa});

  final SolicitudActiva activa;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final s = activa.solicitud;
    final paso = s.estado.paso;
    final (texto, fondo, color) = switch (s.estado) {
      EstadoSolicitud.cotizada => (
        'Con ofertas · ${activa.ofertas}',
        Colores.cieloSuave,
        Colores.cieloOscuro,
      ),
      EstadoSolicitud.aceptada => (
        'En curso',
        Colores.primarioSuave,
        Colores.primario,
      ),
      EstadoSolicitud.porConfirmar => (
        'Por confirmar',
        Colores.avisoSuave,
        Colores.avisoOscuro,
      ),
      _ => ('Esperando ofertas', Colores.superficie, _gris),
    };
    final barra = Semantics(
      label: 'Paso $paso de 4',
      excludeSemantics: true,
      child: SizedBox(
        width: 120,
        child: Row(
          children: [
            for (var i = 1; i <= 4; i++) ...[
              if (i > 1) const SizedBox(width: 4),
              Expanded(
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: i <= paso ? Colores.primarioVivo : Colores.linea,
                    borderRadius: BorderRadius.circular(Radios.pildora),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
    final pildora = _Pildora(texto: texto, fondo: fondo, color: color);
    return InkWell(
      onTap: () => unawaited(
        context.push(AppRoutes.detalleSolicitud(s.id, esCliente: true)),
      ),
      borderRadius: BorderRadius.circular(Radios.pequeno),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Espacios.m),
        child: LayoutBuilder(
          builder: (context, r) {
            final ancho = r.maxWidth >= 560;
            final info = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.descripcion,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textos.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${s.oficioNombre} · Publicada '
                  '${Formatos.haceTiempo(s.creadoEn)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textos.bodySmall?.copyWith(fontSize: 12, color: _gris),
                ),
                if (!ancho) ...[
                  const SizedBox(height: Espacios.s),
                  Row(
                    children: [
                      barra,
                      const SizedBox(width: Espacios.m),
                      Flexible(child: pildora),
                    ],
                  ),
                ],
              ],
            );
            return Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colores.cieloSuave,
                    borderRadius: BorderRadius.circular(Radios.pequeno),
                  ),
                  child: Icon(
                    iconoOficio(s.oficioNombre),
                    size: 20,
                    color: Colores.cieloOscuro,
                  ),
                ),
                const SizedBox(width: Espacios.m),
                Expanded(child: info),
                if (ancho) ...[
                  const SizedBox(width: Espacios.l),
                  barra,
                  const SizedBox(width: Espacios.l),
                  pildora,
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

// ------------------------------------------------------------ historial

class HistorialServiciosPerfil extends ConsumerWidget {
  const HistorialServiciosPerfil({super.key, this.ahora});

  /// Solo para pruebas.
  final DateTime? ahora;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textos = Theme.of(context).textTheme;
    final historial = ref.watch(historialServiciosProvider);
    final lista = historial.value ?? const <ServicioCompletado>[];
    final Widget contenido;
    if (historial.isLoading && !historial.hasValue) {
      contenido = const SizedBox(
        height: 56,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    } else if (historial.hasError && !historial.hasValue) {
      contenido = Text(
        'No pudimos cargar tu historial.',
        style: textos.bodyMedium?.copyWith(color: _gris),
      );
    } else if (lista.isEmpty) {
      contenido = Text(
        'Cuando completes tu primer servicio aparecerá aquí con su garantía '
        'de $diasGarantia días.',
        style: textos.bodyMedium?.copyWith(color: _gris),
      );
    } else {
      contenido = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (i, s) in lista.take(4).indexed) ...[
            if (i > 0) const Divider(height: 1, color: Colores.divisor),
            _FilaServicio(servicio: s, ahora: ahora ?? DateTime.now()),
          ],
          if (lista.length > 4) ...[
            const SizedBox(height: Espacios.s),
            Align(
              alignment: Alignment.centerLeft,
              child: _Enlace(
                'Ver todo el historial',
                () => _irAPestana(ref, 'Mis solicitudes'),
              ),
            ),
          ],
        ],
      );
    }
    return SeccionPerfil(
      titulo: 'Historial de servicios',
      extremo: lista.isEmpty
          ? null
          : Text(
              lista.length == 1
                  ? '1 completado'
                  : '${lista.length} completados',
              style: textos.bodySmall?.copyWith(fontSize: 12, color: _gris),
            ),
      child: contenido,
    );
  }
}

class _FilaServicio extends ConsumerWidget {
  const _FilaServicio({required this.servicio, required this.ahora});

  final ServicioCompletado servicio;
  final DateTime ahora;

  Future<void> _calificar(BuildContext context, WidgetRef ref) async {
    final s = servicio;
    final datos = await mostrarDialogoResena(
      context,
      nombre: s.tecnicoNombre,
      paraTecnico: true,
    );
    if (datos == null) return;
    try {
      await ref
          .read(perfilRepositoryProvider)
          .crearResena(
            NuevaResena(
              solicitudId: s.solicitudId,
              destinatarioId: s.tecnicoId,
              calificacion: datos.estrellas,
              comentario: datos.comentario,
              etiquetas: datos.etiquetas,
            ),
          );
      ref.invalidate(historialServiciosProvider);
      if (context.mounted) {
        context.mostrarMensaje(
          '¡Gracias por tu calificación!',
          tipo: TipoMensaje.exito,
        );
      }
    } on Object catch (e) {
      if (context.mounted) {
        context.mostrarMensaje(
          AsyncValueView.mensajeDe(e),
          tipo: TipoMensaje.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textos = Theme.of(context).textTheme;
    final s = servicio;
    final garantia = Garantia(completadaEn: s.completadaEn);
    final dias = garantia.diasRestantes(ahora);
    final precio = s.precioVisita;

    final quien = Row(
      children: [
        FotoPerfilCaja(
          tamano: 36,
          circular: true,
          rutaFoto: s.tecnicoFotoRuta,
          iniciales: _iniciales(s.tecnicoNombre),
          colorFondo: Colores.cieloSuave,
          estiloTexto: textos.labelMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: Colores.cieloOscuro,
          ),
        ),
        const SizedBox(width: Espacios.m),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                s.tecnicoNombre,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textos.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              Text(
                '${s.oficioNombre} · ${s.descripcion}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textos.bodySmall?.copyWith(fontSize: 12, color: _gris),
              ),
            ],
          ),
        ),
      ],
    );
    final cuando = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _fecha(s.completadaEn),
          style: textos.bodySmall?.copyWith(fontSize: 12, color: _gris),
        ),
        if (precio != null)
          Text(
            Formatos.dinero(precio),
            style: textos.bodyMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: Colores.cieloOscuro,
            ),
          ),
      ],
    );
    final mi = s.miCalificacion;
    final valoracion = mi != null
        ? Semantics(
            label: 'Calificaste con $mi de 5',
            excludeSemantics: true,
            child: Estrellas(valor: mi.toDouble(), tamano: 14),
          )
        : TextButton(
            style: _estiloChico(context),
            onPressed: () => unawaited(_calificar(context, ref)),
            child: const Text('Calificar'),
          );
    final pildora = dias > 0
        ? _Pildora(
            texto: 'Garantía: $dias ${dias == 1 ? 'día' : 'días'}',
            icono: Icons.verified_user_outlined,
            fondo: Colores.primarioSuave,
            color: Colores.primario,
            onTap: () => unawaited(
              reportarProblema(
                context,
                solicitudId: s.solicitudId,
                esCliente: true,
              ),
            ),
          )
        : const _Pildora(
            texto: 'Garantía vencida',
            fondo: Colores.superficie,
            color: _gris,
          );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Espacios.m),
      child: LayoutBuilder(
        builder: (context, r) {
          if (r.maxWidth >= 600) {
            return Row(
              children: [
                Expanded(flex: 5, child: quien),
                const SizedBox(width: Espacios.m),
                SizedBox(width: 96, child: cuando),
                const SizedBox(width: Espacios.m),
                SizedBox(
                  width: 92,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: valoracion,
                  ),
                ),
                const SizedBox(width: Espacios.m),
                SizedBox(
                  width: 160,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: pildora,
                  ),
                ),
              ],
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              quien,
              const SizedBox(height: Espacios.s),
              Padding(
                padding: const EdgeInsets.only(left: 36 + Espacios.m),
                child: Wrap(
                  spacing: Espacios.m,
                  runSpacing: Espacios.s,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [cuando, valoracion, pildora],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------- volver a contratar

class VolverAContratar extends ConsumerWidget {
  const VolverAContratar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historial =
        ref.watch(historialServiciosProvider).value ??
        const <ServicioCompletado>[];
    final tecnicos = tecnicosRecurrentes(historial);
    if (tecnicos.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: Espacios.l),
      child: SeccionPerfil(
        titulo: 'Técnicos con los que trabajaste',
        child: LayoutBuilder(
          builder: (context, r) {
            if (r.maxWidth >= 600) {
              const columnas = 3;
              final ancho =
                  (r.maxWidth - Espacios.m * (columnas - 1)) / columnas;
              return Wrap(
                spacing: Espacios.m,
                runSpacing: Espacios.m,
                children: [
                  for (final t in tecnicos)
                    SizedBox(
                      width: ancho,
                      child: _TarjetaTecnico(tecnico: t),
                    ),
                ],
              );
            }
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final (i, t) in tecnicos.indexed) ...[
                    if (i > 0) const SizedBox(width: Espacios.m),
                    SizedBox(width: 230, child: _TarjetaTecnico(tecnico: t)),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _TarjetaTecnico extends ConsumerWidget {
  const _TarjetaTecnico({required this.tecnico});

  final TecnicoRecurrente tecnico;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textos = Theme.of(context).textTheme;
    final s = tecnico.ultimo;
    final n = tecnico.servicios;
    final nuevo = s.tecnicoTotalResenas == 0;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colores.fondoClaro,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              FotoPerfilCaja(
                tamano: 44,
                circular: true,
                rutaFoto: s.tecnicoFotoRuta,
                iniciales: _iniciales(s.tecnicoNombre),
                colorFondo: Colores.cieloSuave,
                estiloTexto: textos.labelLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: Colores.cieloOscuro,
                ),
              ),
              const SizedBox(width: Espacios.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _nombreCorto(s.tecnicoNombre),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textos.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      s.oficioNombre,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textos.bodySmall?.copyWith(
                        fontSize: 12,
                        color: _gris,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: Espacios.s),
          Row(
            children: [
              if (nuevo)
                const _Pildora(
                  texto: 'Nuevo',
                  fondo: Colores.cieloSuave,
                  color: Colores.cieloOscuro,
                )
              else ...[
                const Icon(
                  Icons.star_rounded,
                  size: 16,
                  color: Colores.estrella,
                ),
                const SizedBox(width: 2),
                Text(
                  s.tecnicoCalificacion.toStringAsFixed(1).replaceAll('.', ','),
                  style: textos.labelLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
              const SizedBox(width: Espacios.s),
              Flexible(
                child: Text(
                  n == 1 ? '1 servicio contigo' : '$n servicios contigo',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textos.bodySmall?.copyWith(fontSize: 11, color: _gris),
                ),
              ),
            ],
          ),
          const SizedBox(height: Espacios.m),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  style: _estiloChico(context, conBorde: true),
                  onPressed: () => unawaited(
                    context.push(AppRoutes.perfilTecnico(s.tecnicoId)),
                  ),
                  child: const Text('Ver perfil'),
                ),
              ),
              const SizedBox(width: Espacios.s),
              Expanded(
                child: TextButton(
                  style: _estiloChico(context),
                  onPressed: () => unawaited(
                    contactarTecnico(
                      context,
                      ref,
                      tecnicoId: s.tecnicoId,
                      nombreCorto: _nombreCorto(s.tecnicoNombre),
                      oficios: [s.oficioNombre],
                    ),
                  ),
                  child: const Text('Escribir'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
