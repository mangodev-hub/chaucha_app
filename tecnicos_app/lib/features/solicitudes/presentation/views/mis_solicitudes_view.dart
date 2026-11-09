import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/utils/refrescar.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/cuadricula_adaptable.dart';
import '../../../../core/widgets/estado_mensaje.dart';
import '../../../../core/widgets/mensajes.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../core/widgets/seccion.dart';
import '../../../../core/widgets/tarjeta_app.dart';
import '../../data/repositories/supabase_solicitud_repository.dart';
import '../../domain/entities/solicitud.dart';
import '../providers/listas_provider.dart';
import '../widgets/editar_solicitud_dialog.dart';
import '../widgets/solicitud_widgets.dart';

class MisSolicitudesView extends ConsumerStatefulWidget {
  const MisSolicitudesView({super.key});

  @override
  ConsumerState<MisSolicitudesView> createState() => _MisSolicitudesViewState();
}

class _MisSolicitudesViewState extends ConsumerState<MisSolicitudesView> {
  bool _verActivas = true;

  Future<void> _nueva() async {
    final creada = await context.push<String>(AppRoutes.clienteNuevaSolicitud);
    if (!mounted) return;
    if (creada != null) ref.invalidate(misSolicitudesProvider);
  }

  Future<void> _abrir(Solicitud solicitud) async {
    await context.push(
      AppRoutes.detalleSolicitud(solicitud.id, esCliente: true),
    );
    if (!mounted) return;
    ref.invalidate(misSolicitudesProvider);
  }

  Future<void> _ejecutar(Future<void> Function() accion, String exito) async {
    try {
      await accion();
      if (!mounted) return;
      ref.invalidate(misSolicitudesProvider);
      context.mostrarMensaje(exito, tipo: TipoMensaje.exito);
    } on AppFailure catch (e) {
      if (mounted) context.mostrarMensaje(e.message, tipo: TipoMensaje.error);
    }
  }

  Future<void> _editar(Solicitud s) async {
    final datos = await mostrarEditarSolicitud(context, s);
    if (datos == null || !mounted) return;
    await _ejecutar(
      () => ref.read(solicitudRepositoryProvider).editar(
            s.id,
            descripcion: datos.descripcion,
            oficioId: datos.oficioId,
            direccion: datos.direccion,
          ),
      'Solicitud actualizada.',
    );
  }

  Future<void> _eliminar(Solicitud s) async {
    final ok = await context.confirmar(
      'Eliminar solicitud',
      'Se borrará la solicitud junto con las propuestas y los chats con '
          'técnicos. No se puede deshacer.',
      textoConfirmar: 'Sí, eliminar',
      textoCancelar: 'Volver',
      destructivo: true,
      icono: Icons.delete_outline,
    );
    if (!ok || !mounted) return;
    await _ejecutar(
      () => ref.read(solicitudRepositoryProvider).eliminar(s.id),
      'Solicitud eliminada.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    return RefreshIndicator(
      onRefresh: () =>
          esperarSinError(ref.refresh(misSolicitudesProvider.future)),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          Espacios.l,
          Espacios.l,
          Espacios.l,
          Espacios.xxl,
        ),
        children: [
          AnchoMaximo(
            ancho: 1200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text('Mis solicitudes', style: textos.titleLarge),
                    ),
                    FilledButton.icon(
                      onPressed: _nueva,
                      icon: const Icon(Icons.add),
                      label: const Text('Nueva solicitud'),
                    ),
                  ],
                ),
                const SizedBox(height: Espacios.m),
                AsyncValueView<List<Solicitud>>(
                  value: ref.watch(misSolicitudesProvider),
                  onRetry: () => ref.invalidate(misSolicitudesProvider),
                  onData: (context, solicitudes) => _contenido(solicitudes),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _contenido(List<Solicitud> solicitudes) {
    final activas = [for (final s in solicitudes) if (s.estado.activa) s];
    final finalizadas = [for (final s in solicitudes) if (!s.estado.activa) s];
    final visibles = _verActivas ? activas : finalizadas;

    final principal = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (solicitudes.isNotEmpty) ...[
          _Resumen(
            activas: activas.length,
            conOfertas: [
              for (final s in solicitudes)
                if (s.estado == EstadoSolicitud.cotizada) s,
            ].length,
            completadas: [
              for (final s in solicitudes)
                if (s.estado == EstadoSolicitud.completada) s,
            ].length,
          ),
          const SizedBox(height: Espacios.l),
          Wrap(
            spacing: Espacios.s,
            children: [
              ChoiceChip(
                label: Text('Activas (${activas.length})'),
                selected: _verActivas,
                onSelected: (_) => setState(() => _verActivas = true),
              ),
              ChoiceChip(
                label: Text('Finalizadas (${finalizadas.length})'),
                selected: !_verActivas,
                onSelected: (_) => setState(() => _verActivas = false),
              ),
            ],
          ),
          const SizedBox(height: Espacios.m),
        ],
        if (solicitudes.isEmpty)
          EstadoMensaje(
            icono: Icons.handyman_outlined,
            titulo: 'Aún no tienes solicitudes',
            mensaje:
                'Pide un técnico y recibe propuestas de profesionales cerca '
                'de ti.',
            textoAccion: 'Crear mi primera solicitud',
            onAccion: _nueva,
          )
        else if (visibles.isEmpty)
          EstadoMensaje(
            compacto: true,
            icono: _verActivas ? Icons.inbox_outlined : Icons.history,
            mensaje: _verActivas
                ? 'No tienes solicitudes en curso.'
                : 'Todavía no tienes solicitudes finalizadas.',
          )
        else
          CuadriculaAdaptable(
            children: [
              for (final s in visibles)
                SolicitudCard(
                  solicitud: s,
                  onTap: () => _abrir(s),
                  onEditar: s.estado.recibeCotizaciones
                      ? () => _editar(s)
                      : null,
                  onEliminar: s.estado.recibeCotizaciones
                      ? () => _eliminar(s)
                      : null,
                ),
            ],
          ),
      ],
    );

    if (ResponsiveLayout.isDesktop(context)) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 8, child: principal),
          const SizedBox(width: Espacios.xl),
          const Expanded(flex: 4, child: _ComoFunciona()),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        principal,
        const SizedBox(height: Espacios.l),
        const _ComoFunciona(),
      ],
    );
  }
}

class _Resumen extends StatelessWidget {
  const _Resumen({
    required this.activas,
    required this.conOfertas,
    required this.completadas,
  });

  final int activas;
  final int conOfertas;
  final int completadas;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _Dato(Icons.assignment_outlined, activas, 'Activas')),
        const SizedBox(width: Espacios.m),
        Expanded(
          child: _Dato(Icons.local_offer_outlined, conOfertas, 'Con ofertas'),
        ),
        const SizedBox(width: Espacios.m),
        Expanded(
          child: _Dato(Icons.check_circle_outline, completadas, 'Completadas'),
        ),
      ],
    );
  }
}

class _Dato extends StatelessWidget {
  const _Dato(this.icono, this.valor, this.titulo);

  final IconData icono;
  final int valor;
  final String titulo;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    return TarjetaApp(
      padding: const EdgeInsets.all(Espacios.m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icono, color: Colores.primario),
          const SizedBox(height: Espacios.xs),
          Text('$valor', style: textos.headlineSmall),
          Text(
            titulo,
            style: textos.bodySmall?.copyWith(color: Colores.tintaSuave),
          ),
        ],
      ),
    );
  }
}

class _ComoFunciona extends StatelessWidget {
  const _ComoFunciona();

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    Widget paso(int n, String titulo, String texto) => Padding(
      padding: const EdgeInsets.only(top: Espacios.m),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: Colores.primarioSuave,
            child: Text(
              '$n',
              style: textos.labelMedium?.copyWith(color: Colores.primario),
            ),
          ),
          const SizedBox(width: Espacios.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titulo, style: textos.titleSmall),
                Text(
                  texto,
                  style: textos.bodySmall?.copyWith(color: Colores.tintaSuave),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return TarjetaApp(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('¿Cómo funciona?', style: textos.titleMedium),
          paso(1, 'Publica tu solicitud',
              'Describe el problema y marca tu ubicación.'),
          paso(2, 'Recibe propuestas',
              'Los técnicos de tu zona te escriben con un precio base.'),
          paso(3, 'Chatea y acuerda',
              'Habla con el técnico y acuerden el precio.'),
          const SizedBox(height: Espacios.l),
          Text(
            'Puedes editar o eliminar tu solicitud mientras no hayas '
            'aceptado a un técnico.',
            style: textos.bodySmall?.copyWith(color: Colores.tintaSuave),
          ),
        ],
      ),
    );
  }
}