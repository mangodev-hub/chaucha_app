// Formulario para pedir un técnico, en cuatro bloques numerados: oficio,
// descripción, ubicación y fotos. "Publicar" queda fijo abajo en móvil.
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/geo/geo_mapper.dart';
import '../../../../core/media/selector_fotos.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/validators/form_validators.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/barra_accion.dart';
import '../../../../core/widgets/boton_carga.dart';
import '../../../../core/widgets/campos.dart';
import '../../../../core/widgets/encabezado_pantalla.dart';
import '../../../../core/widgets/mapa_ubicacion.dart';
import '../../../../core/widgets/mensajes.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../core/widgets/seccion.dart';
import '../../../../core/widgets/tarjeta_app.dart';
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
        tipo: TipoMensaje.error,
      );
    }
  }

  Future<void> _agregarFotos() async {
    final nuevas = await SelectorFotos.elegir(
      maximo: NuevaSolicitud.maximoFotos - _fotos.length,
    );
    if (!mounted) return;
    setState(() {
      _fotos = [..._fotos, ...nuevas].take(NuevaSolicitud.maximoFotos).toList();
    });
  }

  void _quitarFoto(int indice) {
    setState(() => _fotos = [..._fotos]..removeAt(indice));
  }

  Future<void> _enviar() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final id = await ref
        .read(crearSolicitudProvider.notifier)
        .crear(
          oficioId: _oficioId,
          descripcion: _descripcion.text,
          direccion: _direccion.text,
          ubicacion: _ubicacion,
          fotos: _fotos,
        );
    if (!mounted) return;
    if (id != null) {
      context
        ..mostrarMensaje(
          'Solicitud publicada. Los técnicos ya pueden verla.',
          tipo: TipoMensaje.exito,
        )
        ..pop(id);
    } else if (ref.read(crearSolicitudProvider) case AsyncError(:final error)) {
      context.mostrarMensaje(
        AsyncValueView.mensajeDe(error),
        tipo: TipoMensaje.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final publicando = ref.watch(crearSolicitudProvider).isLoading;
    final escritorio = ResponsiveLayout.isDesktop(context);
    final boton = BotonCarga(
      texto: 'Publicar solicitud',
      icono: Icons.send_outlined,
      cargando: publicando,
      onPressed: _enviar,
    );

    const intro = Padding(
      padding: EdgeInsets.only(bottom: Espacios.xl),
      child: EncabezadoPantalla(
        titulo: 'Pide un técnico',
        subtitulo:
            'Cuéntanos qué pasa y recibe cotizaciones de técnicos '
            'cerca de ti.',
      ),
    );
    final servicio = BloqueTarjeta(
      numero: 1,
      titulo: 'Tipo de servicio',
      child: _selectorOficio(),
    );
    final problema = BloqueTarjeta(
      numero: 2,
      titulo: 'Describe el problema',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CampoEtiquetado(
            etiqueta: '¿Qué problema tienes?',
            child: TextFormField(
              controller: _descripcion,
              minLines: 3,
              maxLines: 6,
              decoration: const InputDecoration(
                hintText: 'Ej.: la llave del lavabo gotea desde ayer',
              ),
              validator: (v) =>
                  FormValidators.requerido(v, campo: 'La descripción'),
            ),
          ),
          const SizedBox(height: Espacios.l),
          CampoEtiquetado(
            etiqueta: 'Referencia de la dirección',
            ayuda: 'Opcional',
            child: TextFormField(
              controller: _direccion,
              decoration: const InputDecoration(
                hintText: 'Ej.: casa esquinera, portón negro',
                prefixIcon: Icon(Icons.place_outlined),
              ),
            ),
          ),
        ],
      ),
    );
    final ubicacion = BloqueTarjeta(
      numero: 3,
      titulo: 'Ubicación',
      subtitulo: 'Toca el mapa para mover el pin al lugar exacto.',
      child: _mapa(),
    );
    final fotos = BloqueTarjeta(
      numero: 4,
      titulo: 'Fotos del problema',
      subtitulo: 'Opcional · hasta ${NuevaSolicitud.maximoFotos} fotos',
      child: _fotosSeleccionadas(),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Nueva solicitud')),
      bottomNavigationBar: escritorio ? null : BarraAccion(child: boton),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(escritorio ? Espacios.xl : Espacios.l),
          child: AnchoMaximo(
            ancho: escritorio ? 1100 : 900,
            child: escritorio
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      intro,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [servicio, problema, fotos],
                            ),
                          ),
                          const SizedBox(width: Espacios.xl),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [ubicacion, boton],
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [intro, servicio, problema, ubicacion, fotos],
                  ),
          ),
        ),
      ),
    );
  }

  /// Oficios como chips (se ven todos de un vistazo). Es un campo del
  /// formulario para validar que se elija uno.
  Widget _selectorOficio() {
    return AsyncValueView<List<Oficio>>(
      value: ref.watch(oficiosProvider),
      onRetry: () => ref.invalidate(oficiosProvider),
      onData: (context, oficios) => FormField<int>(
        initialValue: _oficioId,
        validator: (v) => v == null ? 'Selecciona el tipo de servicio.' : null,
        builder: (campo) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: Espacios.s,
              runSpacing: Espacios.s,
              children: [
                for (final oficio in oficios)
                  ChoiceChip(
                    label: Text(oficio.nombre),
                    selected: _oficioId == oficio.id,
                    onSelected: (_) {
                      setState(() => _oficioId = oficio.id);
                      campo.didChange(oficio.id);
                    },
                  ),
              ],
            ),
            if (campo.errorText case final error?)
              Padding(
                padding: const EdgeInsets.only(top: Espacios.s),
                child: Text(
                  error,
                  style: Theme.of(context).textTheme.bodySmall
                      ?.copyWith(color: Colores.error),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _mapa() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MapaUbicacion(
          punto: _ubicacion,
          onCambio: (punto) => setState(() => _ubicacion = punto),
        ),
        const SizedBox(height: Espacios.m),
        OutlinedButton.icon(
          onPressed: _buscandoGps ? null : _usarGps,
          icon: const Icon(Icons.my_location),
          label: Text(_buscandoGps ? 'Buscando...' : 'Usar mi ubicación'),
        ),
      ],
    );
  }

  Widget _fotosSeleccionadas() {
    const lado = 96.0;
    final blanco = Theme.of(context).colorScheme.onPrimary;
    return Wrap(
      spacing: Espacios.s,
      runSpacing: Espacios.s,
      children: [
        for (var i = 0; i < _fotos.length; i++)
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(Radios.medio),
                child: Image.memory(
                  _fotos[i],
                  width: lado,
                  height: lado,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                right: Espacios.xs,
                top: Espacios.xs,
                child: Material(
                  color: Colores.tinta.withValues(alpha: 0.7),
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => _quitarFoto(i),
                    child: Padding(
                      padding: const EdgeInsets.all(Espacios.xs),
                      child: Icon(
                        Icons.close,
                        size: 16,
                        color: blanco,
                        semanticLabel: 'Quitar foto',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        if (_fotos.length < NuevaSolicitud.maximoFotos)
          SizedBox.square(
            dimension: lado,
            child: Material(
              color: Colores.superficie,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Radios.medio),
                side: const BorderSide(
                  color: Colores.primarioClaro,
                  width: 1.5,
                ),
              ),
              child: InkWell(
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Radios.medio),
                ),
                onTap: _agregarFotos,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.add_a_photo_outlined,
                      color: Colores.primario,
                    ),
                    const SizedBox(height: Espacios.xs),
                    Text(
                      'Agregar',
                      style: Theme.of(context).textTheme.labelMedium
                          ?.copyWith(color: Colores.primario),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
