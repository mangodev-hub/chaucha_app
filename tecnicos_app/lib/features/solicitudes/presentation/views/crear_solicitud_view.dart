// Formulario para pedir un técnico: oficio, descripción, ubicación, fotos.
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/geo/geo_mapper.dart';
import '../../../../core/media/selector_fotos.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/validators/form_validators.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/boton_carga.dart';
import '../../../../core/widgets/mapa_ubicacion.dart';
import '../../../../core/widgets/mensajes.dart';
import '../../../../core/widgets/seccion.dart';
import '../../../catalogo/domain/entities/oficio.dart';
import '../../../catalogo/presentation/providers/oficios_provider.dart';
import '../../domain/entities/nueva_solicitud.dart';
import '../providers/crear_solicitud_provider.dart';

class CrearSolicitudView extends ConsumerStatefulWidget {
  const CrearSolicitudView({super.key});

  @override
  ConsumerState<CrearSolicitudView> createState() => _CrearSolicitudViewState();
}

class _CrearSolicitudViewState extends ConsumerState<CrearSolicitudView> {
  final _formKey = GlobalKey<FormState>();
  final _descripcion = TextEditingController();
  final _direccion = TextEditingController();

  int? _oficioId;
  LatLng _ubicacion = GeoMapper.quito;
  bool _buscandoGps = false;
  List<Uint8List> _fotos = const [];

  @override
  void initState() {
    super.initState();
    // Aquí no se puede usar setState: se marca directo y se busca el GPS.
    _buscandoGps = true;
    unawaited(_buscarUbicacion());
  }

  @override
  void dispose() {
    _descripcion.dispose();
    _direccion.dispose();
    super.dispose();
  }

  Future<bool> _obtenerUbicacion() {
    setState(() => _buscandoGps = true);
    return _buscarUbicacion();
  }

  Future<bool> _buscarUbicacion() async {
    final actual = await ref.read(ubicacionServiceProvider).obtenerActual();
    if (!mounted) return false;
    setState(() {
      _buscandoGps = false;
      if (actual != null) _ubicacion = actual;
    });
    return actual != null;
  }

  Future<void> _usarGps() async {
    final ok = await _obtenerUbicacion();
    if (!ok && mounted) {
      context.mostrarMensaje(
        'No pudimos obtener tu ubicación. Toca el mapa para marcarla.',
      );
    }
  }

  Future<void> _agregarFotos() async {
    final nuevas = await SelectorFotos.elegir(
      maximo: NuevaSolicitud.maximoFotos - _fotos.length,
    );
    if (!mounted) return;
    setState(() {
      _fotos =
          [..._fotos, ...nuevas].take(NuevaSolicitud.maximoFotos).toList();
    });
  }

  void _quitarFoto(int indice) {
    setState(() => _fotos = [..._fotos]..removeAt(indice));
  }

  Future<void> _enviar() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final id = await ref.read(crearSolicitudProvider.notifier).crear(
          oficioId: _oficioId,
          descripcion: _descripcion.text,
          direccion: _direccion.text,
          ubicacion: _ubicacion,
          fotos: _fotos,
        );
    if (!mounted) return;
    if (id != null) {
      context
        ..mostrarMensaje('Solicitud publicada. Los técnicos ya pueden verla.')
        ..pop(id);
    } else if (ref.read(crearSolicitudProvider) case AsyncError(:final error)) {
      context.mostrarMensaje(AsyncValueView.mensajeDe(error));
    }
  }

  @override
  Widget build(BuildContext context) {
    final publicando = ref.watch(crearSolicitudProvider).isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Nueva solicitud')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: AnchoMaximo(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _selectorOficio(),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descripcion,
                  minLines: 3,
                  maxLines: 6,
                  decoration: const InputDecoration(
                    labelText: '¿Qué problema tienes?',
                    hintText: 'Ej.: la llave del lavabo gotea desde ayer',
                  ),
                  validator: (v) =>
                      FormValidators.requerido(v, campo: 'La descripción'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _direccion,
                  decoration: const InputDecoration(
                    labelText: 'Referencia de la dirección (opcional)',
                    hintText: 'Ej.: casa esquinera, portón negro',
                  ),
                ),
                Seccion(titulo: 'Ubicación', child: _mapa()),
                Seccion(
                  titulo:
                      'Fotos del problema (máx. ${NuevaSolicitud.maximoFotos})',
                  child: _fotosSeleccionadas(),
                ),
                const SizedBox(height: 32),
                BotonCarga(
                  texto: 'Publicar solicitud',
                  cargando: publicando,
                  onPressed: _enviar,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _selectorOficio() {
    return AsyncValueView<List<Oficio>>(
      value: ref.watch(oficiosProvider),
      onRetry: () => ref.invalidate(oficiosProvider),
      onData: (context, oficios) => DropdownButtonFormField<int>(
        initialValue: _oficioId,
        decoration: const InputDecoration(labelText: 'Tipo de servicio'),
        items: [
          for (final oficio in oficios)
            DropdownMenuItem(value: oficio.id, child: Text(oficio.nombre)),
        ],
        onChanged: (id) => setState(() => _oficioId = id),
        validator: (v) => v == null ? 'Selecciona el tipo de servicio.' : null,
      ),
    );
  }

  Widget _mapa() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Toca el mapa para mover el pin al lugar exacto.'),
        const SizedBox(height: 8),
        MapaUbicacion(
          punto: _ubicacion,
          onCambio: (punto) => setState(() => _ubicacion = punto),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: _buscandoGps ? null : _usarGps,
            icon: const Icon(Icons.my_location),
            label: Text(_buscandoGps ? 'Buscando...' : 'Usar mi ubicación'),
          ),
        ),
      ],
    );
  }

  Widget _fotosSeleccionadas() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (var i = 0; i < _fotos.length; i++)
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.memory(
                  _fotos[i],
                  width: 96,
                  height: 96,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: IconButton.filledTonal(
                  iconSize: 16,
                  visualDensity: VisualDensity.compact,
                  onPressed: () => _quitarFoto(i),
                  icon: const Icon(Icons.close),
                ),
              ),
            ],
          ),
        if (_fotos.length < NuevaSolicitud.maximoFotos)
          SizedBox(
            width: 96,
            height: 96,
            child: OutlinedButton(
              onPressed: _agregarFotos,
              child: const Icon(Icons.add_a_photo_outlined),
            ),
          ),
      ],
    );
  }
}
