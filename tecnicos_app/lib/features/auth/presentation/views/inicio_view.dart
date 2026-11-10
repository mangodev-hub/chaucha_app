import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/geo/geo_mapper.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/utils/refrescar.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/carrusel_aliados.dart';
import '../../../../core/widgets/estado_mensaje.dart';
import '../../../../core/widgets/mensajes.dart';
import '../../../../core/widgets/pildora.dart';
import '../../../../core/widgets/seccion.dart';
import '../../../../core/widgets/tarjeta_portada.dart';
import '../../../catalogo/domain/entities/oficio.dart';
import '../../../catalogo/presentation/providers/oficios_provider.dart';
import '../../../chat/data/repositories/supabase_chat_repository.dart';
import '../../../chat/presentation/widgets/chat_flotante.dart';
import '../../../perfil_puntos/presentation/views/aviso_verificacion_cliente.dart';
import '../../../solicitudes/domain/entities/solicitud.dart';
import '../../../solicitudes/presentation/providers/listas_provider.dart';
import '../../domain/entities/tecnico_cercano.dart';
import '../providers/inicio_provider.dart';
import '../widgets/inicio_widgets.dart';
import '../widgets/mapa_tecnicos.dart';

Future<void> _pedir(
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
    if (seguir == true && context.mounted) await _pedir(context, ref);
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

class InicioView extends ConsumerStatefulWidget {
  const InicioView({super.key, required this.esCliente});

  final bool esCliente;

  @override
  ConsumerState<InicioView> createState() => _InicioViewState();
}

class _InicioViewState extends ConsumerState<InicioView> {
  /// Oficio elegido en las píldoras (null = todos).
  String? _filtro;

  @override
  Widget build(BuildContext context) {
    final esCliente = widget.esCliente;
    final tecnicos = ref.watch(tecnicosCercanosProvider);
    final oficios = ref.watch(oficiosProvider);
    final ancho = MediaQuery.sizeOf(context).width;
    final margen = ancho >= 1024 ? 48.0 : (ancho >= 640 ? 32.0 : Espacios.l);
    final dosColumnas = ancho >= 1000;
    const separacion = SizedBox(height: 40);

    final conteo = <String, int>{};
    for (final t in tecnicos.value ?? const <TecnicoCercano>[]) {
      for (final o in t.oficios) {
        conteo[o] = (conteo[o] ?? 0) + 1;
      }
    }

    final especialidades = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        EncabezadoSeccion(
          etiqueta: 'Especialidades',
          titulo: 'Servicios populares en Quito',
          trailing: esCliente && oficios.hasValue
              ? TextButton.icon(
                  iconAlignment: IconAlignment.end,
                  onPressed: () =>
                      _verTodos(context, ref, oficios.value!, conteo),
                  icon: const Icon(Icons.arrow_forward, size: 18),
                  label: Text('Ver todos (${oficios.value!.length})'),
                )
              : null,
        ),
        const SizedBox(height: Espacios.l),
        AsyncValueView<List<Oficio>>(
          value: oficios,
          onRetry: () => ref.invalidate(oficiosProvider),
          onData: (context, lista) => Categorias(
            oficios: lista,
            conteo: conteo,
            onTap: esCliente
                ? (oficio) => _pedir(context, ref, oficioId: oficio.id)
                : null,
          ),
        ),
      ],
    );

    final lista = AsyncValueView<List<TecnicoCercano>>(
      value: tecnicos,
      onRetry: () => ref.invalidate(tecnicosCercanosProvider),
      onData: (context, datos) => _destacados(datos),
    );

    final cuerpo = dosColumnas
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 58,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    especialidades,
                    separacion,
                    lista,
                    separacion,
                    const BannerConfianza(),
                  ],
                ),
              ),
              const SizedBox(width: Espacios.xxl),
              Expanded(
                flex: 42,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _mapa(tecnicos, 520),
                    const SizedBox(height: Espacios.xl),
                    const CarruselAliados(),
                  ],
                ),
              ),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              especialidades,
              separacion,
              _mapa(tecnicos, 380),
              separacion,
              lista,
              separacion,
              const CarruselAliados(),
              separacion,
              const BannerConfianza(),
            ],
          );

    return RefreshIndicator(
      onRefresh: () =>
          esperarSinError(ref.refresh(tecnicosCercanosProvider.future)),
      child: ListView(
        children: [
          AnchoMaximo(
            ancho: 1360,
            child: Padding(
              padding: EdgeInsets.fromLTRB(margen, Espacios.l, margen, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TarjetaPortada(
                    titulo: esCliente
                        ? '¿Qué arreglamos hoy?'
                        : 'Técnicos en Quito.',
                    subtitulo: 'Técnicos verificados, a la puerta de tu casa.',
                    dato: switch (tecnicos.value?.length) {
                      null => 'Técnicos verificados',
                      1 => '1 técnico cerca · en vivo',
                      final n => '$n técnicos cerca · en vivo',
                    },
                    iconoDato: Icons.near_me_rounded,
                  ),
                  // El buscador va pegado a la portada; sin él, el cuerpo
                  // lleva la separación normal entre secciones.
                  if (esCliente) ...[
                    const SizedBox(height: Espacios.l),
                    HeroBusqueda(
                      onNueva: (texto) =>
                          _pedir(context, ref, descripcion: texto),
                    ),
                  ],
                  separacion,
                  cuerpo,
                ],
              ),
            ),
          ),
          const PieInicio(),
        ],
      ),
    );
  }

  Widget _mapa(AsyncValue<List<TecnicoCercano>> tecnicos, double alto) {
    final punto = ref.watch(ubicacionInicioProvider).value ?? GeoMapper.quito;
    final radioM = ref.watch(radioInicioProvider);
    return tecnicos.when(
      skipLoadingOnReload: true,
      loading: () => SizedBox(
        height: alto,
        child: const Center(child: CircularProgressIndicator()),
      ),
      error: (_, _) => const SizedBox.shrink(),
      data: (lista) => MapaTecnicos(
        punto: punto,
        radioM: radioM,
        onCambiarRadio: ref.read(radioInicioProvider.notifier).cambiar,
        tecnicos: lista,
        alto: alto,
        onContactar: widget.esCliente
            ? (t) => _solicitarTecnico(context, ref, t)
            : null,
      ),
    );
  }

  Widget _destacados(List<TecnicoCercano> lista) {
    final oficios = ({for (final t in lista) ...t.oficios}.toList())..sort();
    final ordenados = [...lista]
      ..sort((a, b) => b.calificacion.compareTo(a.calificacion));
    final visibles = _filtro == null
        ? ordenados
        : [
            for (final t in ordenados)
              if (t.oficios.contains(_filtro)) t,
          ];
    final textos = Theme.of(context).textTheme;

    final titulo = Wrap(
      spacing: Espacios.m,
      runSpacing: Espacios.s,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text('Técnicos calificados cerca de ti', style: textos.headlineSmall),
        Pildora(texto: '${lista.length} en tu zona', color: Colores.primario),
      ],
    );
    final filtros = FiltrosTecnicos(
      oficios: oficios,
      seleccionado: _filtro,
      onCambio: (oficio) => setState(() => _filtro = oficio),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LayoutBuilder(
          builder: (context, restricciones) {
            if (restricciones.maxWidth >= 820) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(flex: 5, child: titulo),
                  const SizedBox(width: Espacios.l),
                  Expanded(
                    flex: 4,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: filtros,
                    ),
                  ),
                ],
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                titulo,
                const SizedBox(height: Espacios.m),
                filtros,
              ],
            );
          },
        ),
        const SizedBox(height: Espacios.l + 4),
        if (visibles.isEmpty)
          const EstadoMensaje(
            compacto: true,
            icono: Icons.location_searching,
            mensaje: 'Aún no hay técnicos verificados para mostrar.',
          )
        else
          Column(
            children: [
              for (var i = 0; i < visibles.length; i++) ...[
                if (i > 0) const SizedBox(height: Espacios.l),
                TecnicoFila(
                  tecnico: visibles[i],
                  onSolicitar: widget.esCliente
                      ? () => _solicitarTecnico(context, ref, visibles[i])
                      : null,
                ),
              ],
            ],
          ),
      ],
    );
  }
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
  await _pedir(context, ref, oficioId: elegido.id);
}
