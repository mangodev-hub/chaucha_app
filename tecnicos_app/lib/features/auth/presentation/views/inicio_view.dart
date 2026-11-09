import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/geo/geo_mapper.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/utils/refrescar.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/estado_mensaje.dart';
import '../../../../core/widgets/seccion.dart';
import '../../../catalogo/domain/entities/oficio.dart';
import '../../../catalogo/presentation/providers/oficios_provider.dart';
import '../../../solicitudes/presentation/providers/listas_provider.dart';
import '../../domain/entities/tecnico_cercano.dart';
import '../providers/inicio_provider.dart';
import '../widgets/inicio_widgets.dart';
import '../widgets/mapa_tecnicos.dart';
import '../../../../core/widgets/espacio_publicitario.dart';
import '../../../../core/widgets/pildora.dart';

/// Abre el formulario de nueva solicitud y, si se crea, va a su detalle.
Future<void> _pedir(
  BuildContext context,
  WidgetRef ref, {
  int? oficioId,
  String? descripcion,
}) async {
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
Future<void> _solicitarTecnico(BuildContext context, WidgetRef ref) async {
  final seguir = await showDialog<bool>(
    context: context,
    builder: (dialogo) => AlertDialog(
      icon: const Icon(Icons.warning_amber_rounded, color: Colores.aviso),
      title: const Text('Publica tu requerimiento primero'),
      content: const Text(
        'Para recibir cotizaciones debes publicar una solicitud con el '
        'resumen de tu problema y tu ubicación.',
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
  if (seguir != true || !context.mounted) return;
  await _pedir(context, ref);
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
                  onPressed: () => _verTodos(context, ref, oficios.value!, conteo),
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
                    const EspacioPublicitario(),
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
              const EspacioPublicitario(),
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
                  if (esCliente) ...[
                    HeroBusqueda(
                      onNueva: (texto) =>
                          _pedir(context, ref, descripcion: texto),
                    ),
                    separacion,
                  ],
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
    final km = (radioInicioM / 1000).toStringAsFixed(
      radioInicioM % 1000 == 0 ? 0 : 1,
    );
    return tecnicos.when(
      loading: () => SizedBox(
        height: alto,
        child: const Center(child: CircularProgressIndicator()),
      ),
      // El error ya se muestra (con reintento) en la lista de técnicos.
      error: (_, _) => const SizedBox.shrink(),
      data: (lista) => MapaTecnicos(
        punto: punto,
        radioM: radioInicioM,
        tecnicos: lista,
        alto: alto,
        etiquetaRadio: 'Radio: $km km (PostGIS)',
        onContactar:
            widget.esCliente ? () => _solicitarTecnico(context, ref) : null,
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
              children: [titulo, const SizedBox(height: Espacios.m), filtros],
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
                  destacado: i == 0,
                  onSolicitar: widget.esCliente
                      ? () => _solicitarTecnico(context, ref)
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