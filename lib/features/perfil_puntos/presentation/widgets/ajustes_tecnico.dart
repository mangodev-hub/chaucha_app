// Ajustes rápidos del técnico desde el inicio ("Para empezar a trabajar"):
// elegir sus oficios y marcar su zona de trabajo sin ir a "Mi perfil". Cada
// uno abre un diálogo (escritorio) o una hoja inferior (teléfono) y guarda
// con el mismo `guardarPerfilProvider` del perfil, conservando lo demás.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/geo/geo_mapper.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/utils/formatos.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/boton_carga.dart';
import '../../../../core/widgets/mapa_ubicacion.dart';
import '../../../../core/widgets/mensajes.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../catalogo/domain/entities/oficio.dart';
import '../../../catalogo/presentation/providers/oficios_provider.dart';
import '../../domain/entities/cambios_perfil.dart';
import '../../domain/entities/perfil_tecnico.dart';
import '../providers/perfil_tecnico_provider.dart';

/// Abre el selector de oficios.
Future<void> mostrarSelectorOficios(BuildContext context) =>
    _mostrar(context, const _PanelOficios(), mensaje: 'Oficios guardados.');

/// Abre el mapa para marcar la zona de trabajo y el radio.
Future<void> mostrarZonaTrabajo(BuildContext context) =>
    _mostrar(context, const _PanelZona(), mensaje: 'Zona de trabajo guardada.');

Future<void> _mostrar(
  BuildContext context,
  Widget panel, {
  required String mensaje,
}) async {
  final Future<bool?> resultado;
  if (ResponsiveLayout.isDesktop(context)) {
    resultado = showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: panel,
        ),
      ),
    );
  } else {
    resultado = showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => panel,
    );
  }
  if (await resultado == true && context.mounted) {
    context.mostrarMensaje(mensaje, tipo: TipoMensaje.exito);
  }
}

/// Guarda [cambios] y cierra el panel con `true`, o muestra el error.
Future<void> _guardar(
  BuildContext context,
  WidgetRef ref,
  CambiosPerfil cambios,
) async {
  final ok = await ref.read(guardarPerfilProvider.notifier).guardar(cambios);
  if (!context.mounted) return;
  if (ok) {
    Navigator.of(context).pop(true);
  } else if (ref.read(guardarPerfilProvider) case AsyncError(:final error)) {
    context.mostrarMensaje(
      AsyncValueView.mensajeDe(error),
      tipo: TipoMensaje.error,
    );
  }
}

/// Lo que ya tiene el perfil, para guardar solo lo que cambia.
CambiosPerfil _cambios(
  PerfilTecnico perfil, {
  Set<int>? oficios,
  LatLng? ubicacion,
  int? radio,
}) => CambiosPerfil(
  tarifaBase: perfil.tarifaBase,
  rangoCoberturaM: radio ?? perfil.rangoCoberturaM,
  // Sin zona marcada y sin una nueva, no se inventa una.
  ubicacion: ubicacion ?? perfil.ubicacionActual,
  oficioIds: oficios ?? perfil.oficioIds.toSet(),
);

/// Marco común: título, texto, contenido y botón de guardar.
class _Marco extends StatelessWidget {
  const _Marco({
    required this.titulo,
    required this.texto,
    required this.child,
    required this.guardando,
    required this.onGuardar,
  });

  final String titulo;
  final String texto;
  final Widget child;
  final bool guardando;
  final VoidCallback? onGuardar;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        Espacios.xl,
        Espacios.xl,
        Espacios.xl,
        Espacios.xl + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(titulo, style: textos.titleLarge),
          const SizedBox(height: Espacios.xs),
          Text(
            texto,
            style: textos.bodyMedium?.copyWith(color: Colores.tintaSuave),
          ),
          const SizedBox(height: Espacios.l),
          child,
          const SizedBox(height: Espacios.xl),
          BotonCarga(
            texto: 'Guardar',
            icono: Icons.check_rounded,
            cargando: guardando,
            onPressed: onGuardar,
          ),
        ],
      ),
    );
  }
}

class _PanelOficios extends ConsumerStatefulWidget {
  const _PanelOficios();

  @override
  ConsumerState<_PanelOficios> createState() => _PanelOficiosState();
}

class _PanelOficiosState extends ConsumerState<_PanelOficios> {
  Set<int>? _elegidos;

  @override
  Widget build(BuildContext context) {
    final guardando = ref.watch(guardarPerfilProvider).isLoading;
    final perfil = ref.watch(perfilTecnicoProvider).value;
    final elegidos = _elegidos ?? perfil?.oficioIds.toSet() ?? const <int>{};
    return _Marco(
      titulo: 'Elige tus oficios',
      texto: 'Verás solicitudes de los oficios que elijas.',
      guardando: guardando,
      onGuardar: perfil == null || elegidos.isEmpty
          ? null
          : () => unawaited(
              _guardar(context, ref, _cambios(perfil, oficios: elegidos)),
            ),
      child: AsyncValueView<List<Oficio>>(
        value: ref.watch(oficiosProvider),
        onRetry: () => ref.invalidate(oficiosProvider),
        onData: (context, catalogo) => Wrap(
          spacing: Espacios.s,
          runSpacing: Espacios.s,
          children: [
            for (final oficio in catalogo)
              FilterChip(
                label: Text(oficio.nombre),
                selected: elegidos.contains(oficio.id),
                onSelected: (_) => setState(() {
                  final nuevo = {...elegidos};
                  if (!nuevo.remove(oficio.id)) nuevo.add(oficio.id);
                  _elegidos = nuevo;
                }),
              ),
          ],
        ),
      ),
    );
  }
}

class _PanelZona extends ConsumerStatefulWidget {
  const _PanelZona();

  @override
  ConsumerState<_PanelZona> createState() => _PanelZonaState();
}

class _PanelZonaState extends ConsumerState<_PanelZona> {
  static const double _radioMinimo = 1000;
  static const double _radioMaximo = 20000;

  LatLng? _punto;
  double? _radio;

  @override
  void initState() {
    super.initState();
    // Sin zona guardada, arranca en su ubicación actual si la hay.
    if (ref.read(perfilTecnicoProvider).value?.ubicacionActual == null) {
      unawaited(_usarGps(avisar: false));
    }
  }

  Future<void> _usarGps({bool avisar = true}) async {
    final actual = await ref.read(ubicacionServiceProvider).obtenerActual();
    if (!mounted) return;
    if (actual != null) {
      setState(() => _punto = actual);
    } else if (avisar) {
      context.mostrarMensaje('No pudimos obtener tu ubicación. Toca el mapa.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final guardando = ref.watch(guardarPerfilProvider).isLoading;
    final perfil = ref.watch(perfilTecnicoProvider).value;
    final punto = _punto ?? perfil?.ubicacionActual ?? GeoMapper.quito;
    final radio =
        _radio ??
        (perfil?.rangoCoberturaM ?? 5000)
            .clamp(_radioMinimo, _radioMaximo)
            .toDouble();
    return _Marco(
      titulo: 'Marca tu zona de trabajo',
      texto: 'Toca el mapa para poner tu punto de partida.',
      guardando: guardando,
      onGuardar: perfil == null
          ? null
          : () => unawaited(
              _guardar(
                context,
                ref,
                _cambios(perfil, ubicacion: punto, radio: radio.round()),
              ),
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Atiendo a la redonda hasta',
                  style: textos.bodyMedium,
                ),
              ),
              Text(
                Formatos.distancia(radio),
                style: textos.titleMedium?.copyWith(color: Colores.primario),
              ),
            ],
          ),
          Slider(
            value: radio,
            min: _radioMinimo,
            max: _radioMaximo,
            divisions: 19,
            label: Formatos.distancia(radio),
            onChanged: (metros) => setState(() => _radio = metros),
          ),
          MapaUbicacion(
            punto: punto,
            radioMetros: radio,
            mostrarSector: true,
            onCambio: (nuevo) => setState(() => _punto = nuevo),
          ),
          const SizedBox(height: Espacios.m),
          OutlinedButton.icon(
            onPressed: () => unawaited(_usarGps()),
            icon: const Icon(Icons.my_location),
            label: const Text('Usar mi ubicación'),
          ),
        ],
      ),
    );
  }
}
