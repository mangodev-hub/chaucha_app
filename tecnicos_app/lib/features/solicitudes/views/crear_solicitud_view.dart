// Formulario para pedir un técnico: oficio, descripción, ubicación, fotos.
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/catalogo/oficio.dart';
import '../../../core/media/selector_fotos.dart';
import '../../../core/state/view_state.dart';
import '../../../core/validators/form_validators.dart';
import '../../../core/widgets/boton_carga.dart';
import '../../../core/widgets/mapa_ubicacion.dart';
import '../../../core/widgets/mensajes.dart';
import '../../../core/widgets/seccion.dart';
import '../viewmodels/crear_solicitud_view_model.dart';


class CrearSolicitudView extends StatefulWidget {
  const CrearSolicitudView({super.key, required this.crearViewModel});

  final CrearSolicitudViewModel Function() crearViewModel;

  @override
  State<CrearSolicitudView> createState() => _CrearSolicitudViewState();
}

class _CrearSolicitudViewState extends State<CrearSolicitudView> {
  late final CrearSolicitudViewModel _vm = widget.crearViewModel();
  final _formKey = GlobalKey<FormState>();
  final _descripcion = TextEditingController();
  final _direccion = TextEditingController();

  @override
  void initState() {
    super.initState();
    _vm
      ..addListener(_alCambiarEstado)
      ..iniciar();
  }

  @override
  void dispose() {
    _vm
      ..removeListener(_alCambiarEstado)
      ..dispose();
    _descripcion.dispose();
    _direccion.dispose();
    super.dispose();
  }

  void _alCambiarEstado() {
    if (!mounted) return;
    switch (_vm.value) {
      case ViewLoaded<String>(:final data):
        context.mostrarMensaje('Solicitud publicada. Los técnicos ya pueden verla.');
        context.pop(data); 
      case ViewError<String>(:final message):
        context.mostrarMensaje(message);
      default:
        break;
    }
  }

  Future<void> _usarGps() async {
    final ok = await _vm.usarMiUbicacion();
    if (!ok && mounted) {
      context.mostrarMensaje(
        'No pudimos obtener tu ubicación. Toca el mapa para marcarla.',
      );
    }
  }

  Future<void> _agregarFotos() async {
    final fotos = await SelectorFotos.elegir(maximo: _vm.fotosDisponibles);
    _vm.agregarFotos(fotos);
  }

  Future<void> _enviar() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await _vm.enviar(
      descripcion: _descripcion.text,
      direccion: _direccion.text,
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  titulo: 'Fotos del problema (máx. '
                      '${CrearSolicitudViewModel.maximoFotos})',
                  child: _fotos(),
                ),
                const SizedBox(height: 32),
                ValueListenableBuilder<ViewState<String>>(
                  valueListenable: _vm,
                  builder: (context, estado, _) => BotonCarga(
                    texto: 'Publicar solicitud',
                    cargando: estado is ViewLoading<String>,
                    onPressed: _enviar,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _selectorOficio() {
    return ValueListenableBuilder<List<Oficio>>(
      valueListenable: _vm.oficios,
      builder: (context, oficios, _) => ValueListenableBuilder<int?>(
        valueListenable: _vm.oficioId,
        builder: (context, seleccionado, _) => DropdownButtonFormField<int>(

          initialValue: seleccionado,
          decoration: const InputDecoration(labelText: 'Tipo de servicio'),
          items: [
            for (final oficio in oficios)
              DropdownMenuItem(value: oficio.id, child: Text(oficio.nombre)),
          ],
          onChanged: _vm.seleccionarOficio,
          validator: (v) => v == null ? 'Selecciona el tipo de servicio.' : null,
        ),
      ),
    );
  }

  Widget _mapa() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Toca el mapa para mover el pin al lugar exacto.'),
        const SizedBox(height: 8),
        ValueListenableBuilder<LatLng>(
          valueListenable: _vm.ubicacion,
          builder: (context, punto, _) =>
              MapaUbicacion(punto: punto, onCambio: _vm.moverPin),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: ValueListenableBuilder<bool>(
            valueListenable: _vm.buscandoGps,
            builder: (context, buscando, _) => TextButton.icon(
              onPressed: buscando ? null : _usarGps,
              icon: const Icon(Icons.my_location),
              label: Text(buscando ? 'Buscando...' : 'Usar mi ubicación'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _fotos() {
    return ValueListenableBuilder<List<Uint8List>>(
      valueListenable: _vm.fotos,
      builder: (context, fotos, _) => Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (var i = 0; i < fotos.length; i++)
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.memory(
                    fotos[i],
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
                    onPressed: () => _vm.quitarFoto(i),
                    icon: const Icon(Icons.close),
                  ),
                ),
              ],
            ),
          if (fotos.length < CrearSolicitudViewModel.maximoFotos)
            SizedBox(
              width: 96,
              height: 96,
              child: OutlinedButton(
                onPressed: _agregarFotos,
                child: const Icon(Icons.add_a_photo_outlined),
              ),
            ),
        ],
      ),
    );
  }
}
