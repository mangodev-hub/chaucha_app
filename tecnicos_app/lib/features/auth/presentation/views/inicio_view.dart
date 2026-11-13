import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/pestana_solicitada.dart';
import '../../../../app/pie_pagina.dart';
import '../../../../core/errors/app_failure.dart';
import '../../../../core/geo/geo_mapper.dart';
import '../../../../core/presence/presencia_service.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/utils/refrescar.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/dialogos_info.dart';
import '../../../../core/widgets/esqueleto_carga.dart';
import '../../../../core/widgets/hoja_clara.dart';
import '../../../../core/widgets/mensajes.dart';
import '../../../../core/widgets/scroll_pagina.dart';
import '../../../../core/widgets/tarjeta_inicio.dart';
import '../../../catalogo/domain/entities/oficio.dart';
import '../../../catalogo/presentation/providers/oficios_provider.dart';
import '../../../chat/data/repositories/supabase_chat_repository.dart';
import '../../../chat/domain/entities/resumen_chat.dart';
import '../../../chat/presentation/providers/mis_chats_provider.dart';
import '../../../chat/presentation/views/chats_view.dart';
import '../../../chat/presentation/widgets/chat_flotante.dart';
import '../../../cotizaciones/data/repositories/supabase_cotizacion_repository.dart';
import '../../../cotizaciones/presentation/widgets/selector_franja.dart';
import '../../../notificaciones/presentation/providers/notificaciones_provider.dart';
import '../../../perfil_puntos/presentation/views/aviso_verificacion_cliente.dart';
import '../../../publicidad/domain/entities/anuncio.dart';
import '../../../publicidad/presentation/widgets/bloque_publicidad.dart';
import '../../../solicitudes/domain/entities/solicitud.dart';
import '../../../solicitudes/presentation/providers/agenda_provider.dart';
import '../../../solicitudes/presentation/providers/detalle_provider.dart';
import '../../../solicitudes/presentation/providers/listas_provider.dart';
import '../../domain/entities/tecnico_cercano.dart';
import '../providers/inicio_provider.dart';
import '../providers/sesion_provider.dart';
import '../widgets/cerca_cliente.dart';
import '../widgets/inicio_cliente_widgets.dart';
import '../widgets/inicio_widgets.dart';

/// Abre la nueva solicitud (con oficio o descripción) si el cliente ya está
/// verificado, y luego su detalle.
Future<void> pedirTecnico(
  BuildContext context,
  WidgetRef ref, {
  int? oficioId,
  String? descripcion,
}) async {
  if (!await exigirVerificado(context, ref)) return;
  if (!context.mounted) return;
  final id = await context.push<String>(
    AppRoutes.clienteNuevaSolicitud,
    extra: (oficioId: oficioId, descripcion: descripcion),
  );
  if (!context.mounted || id == null) return;
  ref.invalidate(misSolicitudesProvider);
  await context.push(AppRoutes.detalleSolicitud(id, esCliente: true));
  if (!context.mounted) return;
  ref.invalidate(misSolicitudesProvider);
}

/// Regla de Selena: antes de negociar hay que publicar la solicitud.
/// Con solicitudes compatibles, el cliente elige una y se abre el chat.
Future<void> contactarTecnico(
  BuildContext context,
  WidgetRef ref, {
  required String tecnicoId,
  required String nombreCorto,
  required List<String> oficios,
}) => _solicitarTecnico(
  context,
  ref,
  TecnicoCercano(
    id: tecnicoId,
    nombres: nombreCorto,
    apellidos: '',
    oficios: oficios,
    calificacion: 0,
    totalResenas: 0,
    metros: 0,
    ubicacion: GeoMapper.quito,
    tarifaBase: 0,
    nivel: '',
  ),
);

Future<void> _solicitarTecnico(
  BuildContext context,
  WidgetRef ref,
  TecnicoCercano tecnico,
) async {
  var compatibles = <Solicitud>[];
  try {
    final lista = await ref.read(misSolicitudesProvider.future);
    compatibles = [
      for (final s in lista)
        if (s.estado.recibeCotizaciones &&
            tecnico.oficios.contains(s.oficioNombre))
          s,
    ];
  } catch (_) {}
  if (!context.mounted) return;

  if (compatibles.isEmpty) {
    final seguir = await showDialog<bool>(
      context: context,
      builder: (dialogo) => AlertDialog(
        icon: const Icon(Icons.warning_amber_rounded, color: Colores.aviso),
        title: const Text('Publica tu requerimiento primero'),
        content: Text(
          'Para escribirle a ${tecnico.nombreCorto} necesitas una solicitud '
          'de ${tecnico.oficios.join(' o ')}.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogo).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogo).pop(true),
            child: const Text('Publicar problema'),
          ),
        ],
      ),
    );
    if (seguir == true && context.mounted) await pedirTecnico(context, ref);
    return;
  }

  final elegida = compatibles.length == 1
      ? compatibles.first
      : await _elegirSolicitud(context, tecnico, compatibles);
  if (elegida == null || !context.mounted) return;

  try {
    final id = await ref
        .read(chatRepositoryProvider)
        .obtenerOCrearConversacion(
          solicitudId: elegida.id,
          tecnicoId: tecnico.id,
        );
    if (!context.mounted) return;
    await abrirChat(context, id, esCliente: true);
  } on AppFailure catch (e) {
    if (context.mounted) {
      context.mostrarMensaje(e.message, tipo: TipoMensaje.error);
    }
  }
}

Future<Solicitud?> _elegirSolicitud(
  BuildContext context,
  TecnicoCercano tecnico,
  List<Solicitud> lista,
) {
  return showModalBottomSheet<Solicitud>(
    context: context,
    showDragHandle: true,
    builder: (hoja) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Espacios.xl,
              0,
              Espacios.xl,
              Espacios.s,
            ),
            child: Text(
              '¿Qué solicitud le envías a ${tecnico.nombreCorto}?',
              style: Theme.of(hoja).textTheme.titleMedium,
            ),
          ),
          for (final s in lista)
            ListTile(
              leading: const Icon(Icons.assignment_outlined),
              title: Text(s.oficioNombre),
              subtitle: Text(
                s.descripcion,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () => Navigator.of(hoja).pop(s),
            ),
          const SizedBox(height: Espacios.s),
        ],
      ),
    ),
  );
}

class InicioView extends ConsumerWidget {
  const InicioView({super.key, required this.esCliente});

  final bool esCliente;

  /// Desde este ancho, el panel derecho va al lado del contenido principal.
  static const double anchoTresColumnas = 1280;

  /// Bajo este ancho es el teléfono: una sola columna.
  static const double anchoMovil = 700;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tecnicos = ref.watch(tecnicosCercanosProvider);
    final oficios = ref.watch(oficiosProvider);
    final nombre =
        ref.watch(usuarioActualProvider)?.nombres.trim().split(' ').first ?? '';
    final radio = ref.watch(radioInicioProvider);
    final radioKm = (radio / 1000).round();
    // Técnicos con la app abierta ahora mismo (presencia en Redis).
    final punto = ref.watch(ubicacionInicioProvider).value;
    final enLinea = punto == null
        ? 0
        : ref
                  .watch(
                    tecnicosEnLineaProvider((
                      lat: punto.latitude,
                      lng: punto.longitude,
                      oficioId: null,
                      radio: radio,
                    )),
                  )
                  .value ??
              0;

    final conteo = <String, int>{};
    for (final t in tecnicos.value ?? const <TecnicoCercano>[]) {
      for (final o in t.oficios) {
        conteo[o] = (conteo[o] ?? 0) + 1;
      }
    }
    final populares = [...?oficios.value]
      ..sort((a, b) {
        final c = (conteo[b.nombre] ?? 0).compareTo(conteo[a.nombre] ?? 0);
        return c != 0 ? c : a.nombre.compareTo(b.nombre);
      });

    final subtitulo =
        switch (tecnicos.value?.length) {
          null => 'Buscando técnicos verificados cerca de tu casa…',
          1 => '1 técnico verificado a menos de $radioKm km de tu casa.',
          final n =>
            '$n técnicos verificados a menos de $radioKm km de tu casa.',
        } +
        switch (enLinea) {
          0 => '',
          1 => ' 1 está en línea ahora.',
          final n => ' $n están en línea ahora.',
        };

    final ancho = MediaQuery.sizeOf(context).width;
    final movil = ancho < anchoMovil;
    final tresColumnas = ancho >= anchoTresColumnas;
    const espacio = SizedBox(height: 18);
    const espacioPanel = SizedBox(height: Espacios.l);

    final portada = PortadaCliente(
      nombre: nombre,
      subtitulo: subtitulo,
      oficios: populares.take(4).toList(),
      onOficio: (o) => pedirTecnico(context, ref, oficioId: o.id),
      onTodos: oficios.value == null
          ? null
          : () => unawaited(_verTodos(context, ref, oficios.value!, conteo)),
    );
    const aviso = AvisoVerificacionCliente(
      margenSuperior: 18,
      estiloInicio: true,
    );
    final solicitud = _BloqueSolicitudActiva(
      onPublicar: () => pedirTecnico(context, ref),
    );
    final cerca = CercaCliente(
      onVerPerfil: (t) =>
          unawaited(context.push(AppRoutes.perfilTecnico(t.id))),
      onContactar: (t) => _solicitarTecnico(context, ref, t),
    );
    final confianza = TarjetasConfianza(
      onGarantia: () => unawaited(mostrarGarantia(context)),
    );
    const chats = _BloqueChats();
    const visita = _BloqueProximaVisita();
    const publicidad = BloquePublicidad(
      ubicacion: UbicacionAnuncio.homeCliente,
    );

    final Widget contenido;
    if (tresColumnas) {
      contenido = Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                portada,
                espacio,
                confianza,
                aviso,
                espacio,
                solicitud,
                espacio,
                cerca,
              ],
            ),
          ),
          const SizedBox(width: 24),
          const SizedBox(
            width: 340,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [chats, espacioPanel, visita, espacioPanel, publicidad],
            ),
          ),
        ],
      );
    } else {
      contenido = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          portada,
          espacio,
          confianza,
          aviso,
          espacio,
          solicitud,
          espacio,
          cerca,
          espacio,
          // En el teléfono la próxima visita va antes que los chats; la
          // publicidad siempre al final.
          if (movil) ...[
            visita,
            espacio,
            chats,
          ] else ...[
            chats,
            espacio,
            visita,
          ],
          espacio,
          publicidad,
        ],
      );
    }

    // Dentro del scroll único de la web, la página ya tiene scroll y pie.
    if (ScrollDePagina.activo(context)) return contenido;

    final pagina = RefreshIndicator(
      onRefresh: () => Future.wait([
        esperarSinError(ref.refresh(tecnicosCercanosProvider.future)),
        esperarSinError(ref.refresh(solicitudActivaProvider.future)),
        esperarSinError(ref.refresh(misChatsProvider.future)),
        esperarSinError(ref.refresh(proximaVisitaProvider.future)),
      ]),
      // Un solo scroll para toda la página, sin alturas fijas.
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        // En web, 12 px a los lados para que no se corten las sombras de
        // las tarjetas (el shell descuenta ese margen).
        padding: movil
            ? const EdgeInsets.all(Espacios.l)
            : const EdgeInsets.fromLTRB(12, 0, 12, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            contenido,
            const SizedBox(height: Espacios.xxl),
            const PiePagina(),
          ],
        ),
      ),
    );
    // En web va directo sobre el fondo claro; en el teléfono, dentro de la
    // hoja clara del marco oscuro.
    return movil ? HojaClara(child: pagina) : pagina;
  }
}

class _BloqueSolicitudActiva extends ConsumerWidget {
  const _BloqueSolicitudActiva({required this.onPublicar});

  final VoidCallback onPublicar;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activa = ref.watch(solicitudActivaProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TituloBloque(
          titulo: 'Tu solicitud activa',
          enlace: 'Ver todas',
          onEnlace: () => ref
              .read(pestanaSolicitadaProvider.notifier)
              .pedir('Mis solicitudes'),
        ),
        const SizedBox(height: Espacios.s),
        AsyncValueView<({Solicitud solicitud, int ofertas})?>(
          value: activa,
          onRetry: () => ref.invalidate(solicitudActivaProvider),
          cargando: (_) => const _CargandoTarjeta(alto: 110),
          onData: (context, dato) {
            if (dato == null) return SinSolicitudActiva(onPublicar: onPublicar);
            return TarjetaSolicitudActiva(
              solicitud: dato.solicitud,
              ofertas: dato.ofertas,
              onTap: () async {
                await context.push(
                  AppRoutes.detalleSolicitud(
                    dato.solicitud.id,
                    esCliente: true,
                  ),
                );
                ref.invalidate(solicitudActivaProvider);
              },
            );
          },
        ),
      ],
    );
  }
}

class _BloqueChats extends ConsumerWidget {
  const _BloqueChats();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chats = ref.watch(misChatsProvider);
    final noLeidas =
        ref.watch(notificacionesNoLeidasProvider).value ?? const [];
    int sinLeerDe(String id) => noLeidas
        .where((n) => tiposDeChat.contains(n.tipo) && n.referenciaId == id)
        .length;

    return ResumenChats(
      onVerTodos: () =>
          ref.read(pestanaSolicitadaProvider.notifier).pedir('Chats'),
      contenido: AsyncValueView<List<ResumenChat>>(
        value: chats,
        onRetry: () => ref.invalidate(misChatsProvider),
        cargando: (_) => const Padding(
          padding: EdgeInsets.symmetric(vertical: Espacios.m),
          child: Center(child: CircularProgressIndicator()),
        ),
        onData: (context, lista) {
          if (lista.isEmpty) {
            return const TextoVacio('Aún no tienes conversaciones.');
          }
          final recientes = [...lista]
            ..sort((a, b) {
              final fa = a.enviadoEn;
              final fb = b.enviadoEn;
              if (fa == null && fb == null) return 0;
              if (fa == null) return 1;
              if (fb == null) return -1;
              return fb.compareTo(fa);
            });
          return Column(
            children: [
              for (var i = 0; i < recientes.length && i < 3; i++)
                FilaChat(
                  chat: recientes[i],
                  sinLeer: sinLeerDe(recientes[i].conversacionId),
                  cielo: i.isOdd,
                  onTap: () => unawaited(
                    abrirChat(
                      context,
                      recientes[i].conversacionId,
                      esCliente: true,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _BloqueProximaVisita extends ConsumerWidget {
  const _BloqueProximaVisita();

  Future<void> _reagendar(
    BuildContext context,
    WidgetRef ref,
    ItemAgenda item,
    DateTime inicio,
  ) async {
    final oferta = item.oferta;
    final fecha = await elegirFranja(
      context,
      titulo: 'Nueva fecha y hora',
      inicial: inicio,
      cargarOcupados: (desde, hasta) => ref
          .read(cotizacionRepositoryProvider)
          .horariosOcupados(oferta.id, desde: desde, hasta: hasta),
    );
    if (fecha == null || !context.mounted) return;
    final acciones = accionesSolicitudProvider(item.solicitud.id);
    final ok = await ref
        .read(acciones.notifier)
        .proponerReagendado(oferta.id, fecha);
    if (!context.mounted) return;
    if (ok) {
      ref.invalidate(proximaVisitaProvider);
      context.mostrarMensaje(
        'Propuesta enviada. El técnico debe aceptarla.',
        tipo: TipoMensaje.exito,
      );
    } else if (ref.read(acciones) case AsyncError(:final error)) {
      context.mostrarMensaje(
        AsyncValueView.mensajeDe(error),
        tipo: TipoMensaje.error,
      );
    }
  }

  Future<void> _escribir(
    BuildContext context,
    WidgetRef ref,
    ItemAgenda item,
  ) async {
    try {
      final id = await ref
          .read(chatRepositoryProvider)
          .obtenerOCrearConversacion(
            solicitudId: item.solicitud.id,
            tecnicoId: item.oferta.tecnicoId,
          );
      if (!context.mounted) return;
      await abrirChat(context, id, esCliente: true);
    } on AppFailure catch (e) {
      if (context.mounted) {
        context.mostrarMensaje(e.message, tipo: TipoMensaje.error);
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final proxima = ref.watch(proximaVisitaProvider);
    return TarjetaProximaVisita(
      contenido: AsyncValueView<ItemAgenda?>(
        value: proxima,
        onRetry: () => ref.invalidate(proximaVisitaProvider),
        cargando: (_) => const Padding(
          padding: EdgeInsets.symmetric(vertical: Espacios.m),
          child: Center(child: CircularProgressIndicator()),
        ),
        onData: (context, item) {
          if (item == null) {
            return const TextoVacio('No tienes visitas agendadas');
          }
          // Mantiene vivas las acciones mientras se ve la visita.
          ref.watch(accionesSolicitudProvider(item.solicitud.id));
          final oferta = item.oferta;
          final inicio = oferta.inicioVisita ?? item.fecha!;
          final fin = oferta.finVisita ?? inicio.add(const Duration(hours: 1));
          return DatosProximaVisita(
            inicio: inicio,
            fin: fin,
            tecnico: oferta.tecnicoNombre,
            titulo: item.solicitud.descripcion,
            precio: oferta.tarifa?.precioAcordado ?? oferta.precioBase,
            onReagendar: () =>
                unawaited(_reagendar(context, ref, item, inicio)),
            onEscribir: () => unawaited(_escribir(context, ref, item)),
          );
        },
      ),
    );
  }
}

class _CargandoTarjeta extends StatelessWidget {
  const _CargandoTarjeta({required this.alto});

  final double alto;

  @override
  Widget build(BuildContext context) => EsqueletoCarga(
    child: TarjetaInicio(
      alto: alto,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BloqueEsqueleto(alto: 14, ancho: 180),
          SizedBox(height: Espacios.s),
          BloqueEsqueleto(alto: 10),
        ],
      ),
    ),
  );
}

/// Hoja con todos los oficios; al elegir uno abre la nueva solicitud.
Future<void> _verTodos(
  BuildContext context,
  WidgetRef ref,
  List<Oficio> lista,
  Map<String, int> conteo,
) async {
  final elegido = await showModalBottomSheet<Oficio>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    constraints: const BoxConstraints(maxWidth: 900),
    builder: (hoja) => SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          Espacios.xl,
          0,
          Espacios.xl,
          Espacios.xl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Todos los servicios',
              style: Theme.of(hoja).textTheme.titleLarge,
            ),
            const SizedBox(height: Espacios.l),
            Categorias(
              oficios: lista,
              conteo: conteo,
              maximo: lista.length,
              onTap: (oficio) => Navigator.of(hoja).pop(oficio),
            ),
          ],
        ),
      ),
    ),
  );
  if (elegido == null || !context.mounted) return;
  await pedirTecnico(context, ref, oficioId: elegido.id);
}
