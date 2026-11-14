import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/utils/formatos.dart';
import '../../../../core/utils/refrescar.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/mensajes.dart';
import '../../../../core/widgets/pantalla_secundaria.dart';
import '../../../../core/widgets/tarjeta_app.dart';
import '../../../admin/presentation/providers/admin_providers.dart';
import '../../domain/entities/reclamo.dart';
import '../providers/reclamos_provider.dart';
import '../widgets/reclamo_widgets.dart';

class ReclamoDetalleView extends ConsumerWidget {
  const ReclamoDetalleView({
    super.key,
    required this.reclamoId,
    this.esAdmin = false,
  });

  final String reclamoId;
  final bool esAdmin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reclamo = ref.watch(reclamoProvider(reclamoId));
    ref.listen(mensajesReclamoProvider(reclamoId), (antes, ahora) {
      final previos = antes?.value?.length;
      final nuevos = ahora.value?.length;
      if (previos != null && nuevos != null && nuevos != previos) {
        ref.invalidate(reclamoProvider(reclamoId));
      }
    });

    return PantallaSecundaria(
      titulo: reclamo.value?.codigo ?? 'Reclamo',
      cuerpo: AsyncValueView<Reclamo>(
        value: reclamo,
        onRetry: () => ref.invalidate(reclamoProvider(reclamoId)),
        onData: (context, r) => Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => esperarSinError(
                  ref.refresh(reclamoProvider(reclamoId).future),
                ),
                child: ListView(
                  padding: const EdgeInsets.all(Espacios.l),
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 760),
                        child: _Contenido(reclamo: r, esAdmin: esAdmin),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (r.estado.abierto)
              esAdmin
                  ? _AccionesAsesor(reclamo: r)
                  : _CajaRespuesta(reclamoId: r.id),
          ],
        ),
      ),
    );
  }
}

class _Contenido extends ConsumerWidget {
  const _Contenido({required this.reclamo, required this.esAdmin});

  final Reclamo reclamo;
  final bool esAdmin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textos = Theme.of(context).textTheme;
    final r = reclamo;
    final mensajes = ref.watch(mensajesReclamoProvider(r.id));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: Espacios.m,
          runSpacing: Espacios.s,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(r.codigo, style: textos.headlineSmall),
            PildoraEstadoReclamo(r.estado),
          ],
        ),
        const SizedBox(height: Espacios.xs),
        Text(
          '${r.categoria.etiqueta} · Enviado el '
          '${Formatos.fechaCorta(r.creadoEn)}',
          style: textos.bodySmall?.copyWith(color: Colores.tintaSuave),
        ),
        const SizedBox(height: Espacios.l),
        PasosReclamo(estado: r.estado),
        if (r.estado == EstadoReclamo.necesitaInfo && !esAdmin) ...[
          const SizedBox(height: Espacios.l),
          Container(
            padding: const EdgeInsets.all(Espacios.m),
            decoration: BoxDecoration(
              color: Colores.avisoSuave,
              borderRadius: BorderRadius.circular(Radios.medio),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded, color: Colores.aviso),
                const SizedBox(width: Espacios.s),
                Expanded(
                  child: Text(
                    'El asesor necesita más información',
                    style: textos.titleSmall?.copyWith(
                      color: Colores.avisoOscuro,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: Espacios.l),
        _TarjetaServicio(reclamo: r, esAdmin: esAdmin),
        const SizedBox(height: Espacios.l),
        Text('Conversación', style: textos.titleMedium),
        const SizedBox(height: Espacios.s),
        AsyncValueView<List<MensajeReclamo>>(
          value: mensajes,
          onRetry: () => ref.invalidate(mensajesReclamoProvider(r.id)),
          onData: (context, lista) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final m in lista)
                BurbujaReclamo(
                  mensaje: m,
                  esMio: !m.esAsesor && m.autorId == r.autorId,
                ),
            ],
          ),
        ),
        if (!r.estado.abierto) ...[
          const SizedBox(height: Espacios.l),
          TarjetaApp(
            color: r.estado == EstadoReclamo.resuelto
                ? Colores.primarioSuave
                : Colores.superficie,
            conBorde: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Resolución', style: textos.titleSmall),
                const SizedBox(height: Espacios.xs),
                Text(
                  r.resolucion ?? 'El reclamo se cerró.',
                  style: textos.bodyMedium,
                ),
                if (r.cerradoEn != null) ...[
                  const SizedBox(height: Espacios.xs),
                  Text(
                    'Cerrado el ${Formatos.fechaCorta(r.cerradoEn!)}',
                    style: textos.bodySmall?.copyWith(
                      color: Colores.tintaSuave,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _TarjetaServicio extends StatelessWidget {
  const _TarjetaServicio({required this.reclamo, required this.esAdmin});

  final Reclamo reclamo;
  final bool esAdmin;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final r = reclamo;
    final visita = r.inicioVisita;
    final autorEsCliente = r.clienteId != null && r.autorId == r.clienteId;

    Widget persona(
      String rol,
      String? nombre,
      String? id, {
      required bool esCliente,
    }) {
      final texto = Text(
        '$rol: ${nombre ?? 'Sin datos'}',
        style: textos.bodyMedium,
      );
      if (!esAdmin || id == null) return texto;
      return InkWell(
        onTap: () => unawaited(
          context.push(
            esCliente
                ? AppRoutes.perfilClienteAdmin(id)
                : AppRoutes.perfilTecnicoAdmin(id),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Espacios.xs),
          child: Row(
            children: [
              Flexible(child: texto),
              const Icon(Icons.open_in_new_rounded, size: 16),
            ],
          ),
        ),
      );
    }

    return TarjetaApp(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            [r.oficio, r.servicio].whereType<String>().join(' · '),
            style: textos.titleSmall,
          ),
          const SizedBox(height: Espacios.xs),
          if (esAdmin) ...[
            persona(
              autorEsCliente ? 'Reporta el cliente' : 'Reporta el técnico',
              r.autorNombre,
              r.autorId,
              esCliente: autorEsCliente,
            ),
            persona(
              autorEsCliente ? 'Técnico' : 'Cliente',
              r.contraNombre,
              r.contraId,
              esCliente: !autorEsCliente,
            ),
          ] else if (r.contraNombre != null)
            Text('Con ${r.contraNombre}', style: textos.bodyMedium),
          if (visita != null)
            Text(
              'Visita del ${Formatos.fechaCorta(visita)} a las '
              '${Formatos.hora(visita)}',
              style: textos.bodySmall?.copyWith(color: Colores.tintaSuave),
            ),
          const Divider(height: Espacios.xl),
          Text(r.descripcion, style: textos.bodyMedium),
          if (r.evidencias.isNotEmpty) ...[
            const SizedBox(height: Espacios.m),
            Wrap(
              spacing: Espacios.s,
              runSpacing: Espacios.s,
              children: [
                for (final ruta in r.evidencias) MiniaturaEvidencia(ruta: ruta),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _CajaRespuesta extends ConsumerStatefulWidget {
  const _CajaRespuesta({required this.reclamoId});

  final String reclamoId;

  @override
  ConsumerState<_CajaRespuesta> createState() => _CajaRespuestaState();
}

class _CajaRespuestaState extends ConsumerState<_CajaRespuesta> {
  final _texto = TextEditingController();

  @override
  void dispose() {
    _texto.dispose();
    super.dispose();
  }

  Future<void> _enviar() async {
    final texto = _texto.text.trim();
    if (texto.isEmpty) return;
    final acciones = accionesReclamoProvider(widget.reclamoId);
    final ok = await ref.read(acciones.notifier).responder(texto);
    if (!mounted) return;
    if (ok) {
      _texto.clear();
    } else if (ref.read(acciones) case AsyncError(:final error)) {
      context.mostrarMensaje(
        AsyncValueView.mensajeDe(error),
        tipo: TipoMensaje.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final enviando = ref
        .watch(accionesReclamoProvider(widget.reclamoId))
        .isLoading;
    return Material(
      color: Colores.tarjeta,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(Espacios.m),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _texto,
                  enabled: !enviando,
                  minLines: 1,
                  maxLines: 4,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    hintText: 'Escribe al asesor',
                  ),
                ),
              ),
              const SizedBox(width: Espacios.s),
              IconButton.filled(
                tooltip: 'Enviar',
                onPressed: enviando ? null : _enviar,
                icon: enviando
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.send_rounded),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AccionesAsesor extends ConsumerWidget {
  const _AccionesAsesor({required this.reclamo});

  final Reclamo reclamo;

  Future<void> _gestionar(
    BuildContext context,
    WidgetRef ref,
    EstadoReclamo estado, {
    String? titulo,
  }) async {
    String? mensaje;
    if (titulo != null) {
      mensaje = await _pedirTexto(context, titulo);
      if (mensaje == null) return;
    }
    if (!context.mounted) return;
    final acciones = accionesReclamoProvider(reclamo.id);
    final ok = await ref
        .read(acciones.notifier)
        .gestionar(estado, mensaje: mensaje);
    if (!context.mounted) return;
    if (ok) {
      context.mostrarMensaje(
        'Reclamo actualizado: ${estado.etiqueta.toLowerCase()}.',
        tipo: TipoMensaje.exito,
      );
    } else if (ref.read(acciones) case AsyncError(:final error)) {
      context.mostrarMensaje(
        AsyncValueView.mensajeDe(error),
        tipo: TipoMensaje.error,
      );
    }
  }

  Future<void> _suspender(BuildContext context, WidgetRef ref) async {
    final id = reclamo.contraId;
    if (id == null) return;
    final ok = await context.confirmar(
      'Suspender usuario',
      '¿Suspender a ${reclamo.contraNombre ?? 'esta persona'}? No podrá usar '
          'la app hasta que lo reactives.',
      textoConfirmar: 'Suspender',
      destructivo: true,
      icono: Icons.block,
    );
    if (!ok || !context.mounted) return;
    final acciones = accionesUsuarioProvider(id);
    final hecho = await ref.read(acciones.notifier).suspender(suspendido: true);
    if (!context.mounted) return;
    if (hecho) {
      context.mostrarMensaje('Usuario suspendido.', tipo: TipoMensaje.exito);
    } else if (ref.read(acciones) case AsyncError(:final error)) {
      context.mostrarMensaje(
        AsyncValueView.mensajeDe(error),
        tipo: TipoMensaje.error,
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ocupado = ref.watch(accionesReclamoProvider(reclamo.id)).isLoading;
    final estilo = OutlinedButton.styleFrom(
      minimumSize: const Size(0, 40),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Radios.pequeno),
      ),
    );
    VoidCallback? si(VoidCallback accion) => ocupado ? null : accion;

    return Material(
      color: Colores.tarjeta,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(Espacios.m),
          child: Wrap(
            spacing: Espacios.s,
            runSpacing: Espacios.s,
            alignment: WrapAlignment.center,
            children: [
              if (reclamo.estado != EstadoReclamo.enRevision)
                FilledButton(
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(0, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Radios.pequeno),
                    ),
                  ),
                  onPressed: si(
                    () => _gestionar(context, ref, EstadoReclamo.enRevision),
                  ),
                  child: const Text('Tomar caso'),
                ),
              OutlinedButton(
                style: estilo,
                onPressed: si(
                  () => _gestionar(
                    context,
                    ref,
                    EstadoReclamo.necesitaInfo,
                    titulo: '¿Qué información necesitas?',
                  ),
                ),
                child: const Text('Pedir información'),
              ),
              OutlinedButton(
                style: estilo,
                onPressed: si(
                  () => _gestionar(
                    context,
                    ref,
                    EstadoReclamo.resuelto,
                    titulo: 'Respuesta para resolver el reclamo',
                  ),
                ),
                child: const Text('Resolver'),
              ),
              OutlinedButton(
                style: estilo,
                onPressed: si(
                  () => _gestionar(
                    context,
                    ref,
                    EstadoReclamo.rechazado,
                    titulo: 'Motivo para rechazar el reclamo',
                  ),
                ),
                child: const Text('Rechazar'),
              ),
              if (reclamo.contraId != null)
                TextButton.icon(
                  onPressed: si(() => _suspender(context, ref)),
                  style: TextButton.styleFrom(foregroundColor: Colores.error),
                  icon: const Icon(Icons.block, size: 18),
                  label: const Text('Suspender usuario'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Diálogo con un campo obligatorio. Devuelve el texto o null si se cancela.
Future<String?> _pedirTexto(BuildContext context, String titulo) {
  final control = TextEditingController();
  return showDialog<String>(
    context: context,
    builder: (dialogo) => StatefulBuilder(
      builder: (dialogo, setState) => AlertDialog(
        title: Text(titulo),
        content: SizedBox(
          width: 420,
          child: TextField(
            controller: control,
            autofocus: true,
            minLines: 3,
            maxLines: 6,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              hintText: 'El usuario verá este mensaje',
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogo).pop(),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: control.text.trim().isEmpty
                ? null
                : () => Navigator.of(dialogo).pop(control.text.trim()),
            child: const Text('Enviar'),
          ),
        ],
      ),
    ),
  ).whenComplete(control.dispose);
}
