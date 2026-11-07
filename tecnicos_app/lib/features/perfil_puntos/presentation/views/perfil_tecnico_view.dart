// Pestaña "Perfil" del técnico: nivel/puntos y datos de trabajo.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/geo/geo_mapper.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/utils/formatos.dart';
import '../../../../core/validators/form_validators.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/boton_carga.dart';
import '../../../../core/widgets/mapa_ubicacion.dart';
import '../../../../core/widgets/mensajes.dart';
import '../../../../core/widgets/seccion.dart';
import '../../../catalogo/domain/entities/oficio.dart';
import '../../../catalogo/presentation/providers/oficios_provider.dart';
import '../../domain/entities/cambios_perfil.dart';
import '../../domain/entities/perfil_tecnico.dart';
import '../providers/perfil_tecnico_provider.dart';
import 'verificacion_view.dart';

class PerfilTecnicoView extends ConsumerStatefulWidget {
  const PerfilTecnicoView({super.key});

  @override
  ConsumerState<PerfilTecnicoView> createState() => _PerfilTecnicoViewState();
}

class _PerfilTecnicoViewState extends ConsumerState<PerfilTecnicoView> {
  static const double _radioMinimo = 1000;
  static const double _radioMaximo = 20000;

  final _formKey = GlobalKey<FormState>();
  final _tarifa = TextEditingController();

  // Estado del formulario. Se llena una sola vez, con el primer perfil cargado.
  bool _inicializado = false;
  Set<int> _seleccionados = const {};
  LatLng _ubicacion = GeoMapper.quito;
  double _radio = 5000;

  @override
  void initState() {
    super.initState();
    // El callback corre antes del build que muestra el formulario, así que
    // basta con asignar los campos (sin setState).
    ref.listenManual(
      perfilTecnicoProvider,
      (_, estado) {
        if (estado case AsyncData(:final value)) _inicializar(value);
      },
      fireImmediately: true,
    );
  }

  @override
  void dispose() {
    _tarifa.dispose();
    super.dispose();
  }

  void _inicializar(PerfilTecnico perfil) {
    if (_inicializado) return;
    _inicializado = true;
    _tarifa.text = perfil.tarifaBase.toStringAsFixed(2);
    _seleccionados = perfil.oficioIds.toSet();
    _radio =
        perfil.rangoCoberturaM.clamp(_radioMinimo, _radioMaximo).toDouble();
    final guardada = perfil.ubicacionActual;
    if (guardada != null) {
      _ubicacion = guardada;
    } else {
      unawaited(_obtenerUbicacion());
    }
  }

  Future<bool> _obtenerUbicacion() async {
    final actual = await ref.read(ubicacionServiceProvider).obtenerActual();
    if (actual != null && mounted) setState(() => _ubicacion = actual);
    return actual != null;
  }

  Future<void> _usarGps() async {
    final ok = await _obtenerUbicacion();
    if (!ok && mounted) {
      context.mostrarMensaje('No pudimos obtener tu ubicación. Toca el mapa.');
    }
  }

  void _alternarOficio(int id) {
    setState(() {
      final nuevo = {..._seleccionados};
      if (!nuevo.remove(id)) nuevo.add(id);
      _seleccionados = nuevo;
    });
  }

  Future<void> _guardar() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final guardado = await ref.read(guardarPerfilProvider.notifier).guardar(
          CambiosPerfil(
            tarifaBase: double.parse(_tarifa.text.trim().replaceAll(',', '.')),
            rangoCoberturaM: _radio.round(),
            ubicacion: _ubicacion,
            oficioIds: _seleccionados,
          ),
        );
    if (!mounted) return;
    if (guardado) {
      context.mostrarMensaje('Perfil guardado.');
    } else if (ref.read(guardarPerfilProvider) case AsyncError(:final error)) {
      context.mostrarMensaje(AsyncValueView.mensajeDe(error));
    }
  }

  @override
  Widget build(BuildContext context) {
    final guardando = ref.watch(guardarPerfilProvider).isLoading;

    return AsyncValueView<PerfilTecnico>(
      value: ref.watch(perfilTecnicoProvider),
      onRetry: () => ref.invalidate(perfilTecnicoProvider),
      onData: (context, perfil) => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: AnchoMaximo(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Resumen(perfil: perfil),
                const SizedBox(height: Espacios.l),
                OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const VerificacionView(),
                    ),
                  ),
                  icon: const Icon(Icons.badge_outlined),
                  label: const Text('Enviar documentos de identidad'),
                ),
                const SizedBox(height: 8),
                Seccion(
                  titulo: 'Tarifa base',
                  child: TextFormField(
                    controller: _tarifa,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(prefixText: '\$ '),
                    validator: (v) => FormValidators.monto(v, campo: 'La tarifa'),
                  ),
                ),
                Seccion(titulo: 'Mis oficios', child: _oficios()),
                Seccion(titulo: 'Zona de trabajo', child: _zona()),
                const SizedBox(height: 24),
                BotonCarga(
                  texto: 'Guardar perfil',
                  cargando: guardando,
                  onPressed: _guardar,
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _oficios() {
    return AsyncValueView<List<Oficio>>(
      value: ref.watch(oficiosProvider),
      onRetry: () => ref.invalidate(oficiosProvider),
      onData: (context, catalogo) => Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final oficio in catalogo)
            FilterChip(
              label: Text(oficio.nombre),
              selected: _seleccionados.contains(oficio.id),
              onSelected: (_) => _alternarOficio(oficio.id),
            ),
        ],
      ),
    );
  }

  Widget _zona() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Atiendo hasta ${Formatos.distancia(_radio)} a la redonda.'),
        Slider(
          value: _radio,
          min: _radioMinimo,
          max: _radioMaximo,
          divisions: 19,
          label: Formatos.distancia(_radio),
          onChanged: (metros) => setState(() => _radio = metros),
        ),
        MapaUbicacion(
          punto: _ubicacion,
          radioMetros: _radio,
          onCambio: (punto) => setState(() => _ubicacion = punto),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: _usarGps,
            icon: const Icon(Icons.my_location),
            label: const Text('Usar mi ubicación'),
          ),
        ),
      ],
    );
  }
}

/// Encabezado del perfil: puntos en grande, nivel y datos en píldoras.
class _Resumen extends StatelessWidget {
  const _Resumen({required this.perfil});

  final PerfilTecnico perfil;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      decoration: BoxDecoration(
        color: Colores.acento,
        borderRadius: BorderRadius.circular(Radios.grande),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colores.tinta,
              borderRadius: BorderRadius.circular(Radios.pildora),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.workspace_premium_rounded,
                  color: Colores.acento,
                  size: 32,
                ),
                const SizedBox(width: Espacios.s),
                Text(
                  '${perfil.puntos} pts',
                  style: textos.displaySmall?.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
          const SizedBox(height: Espacios.m),
          Text(
            'Nivel ${perfil.nivelNombre}',
            style: textos.titleLarge?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: Espacios.l),
          Wrap(
            spacing: Espacios.s,
            runSpacing: Espacios.s,
            alignment: WrapAlignment.center,
            children: [
              _Pildora(
                icono: Icons.star_rounded,
                texto: '${perfil.calificacionPromedio.toStringAsFixed(1)} '
                    '(${perfil.totalResenas} reseñas)',
              ),
              _Pildora(
                icono: Icons.percent_rounded,
                texto:
                    'Comisión ${perfil.comisionPorcentaje.toStringAsFixed(0)} %',
              ),
              if (perfil.verificado)
                const _Pildora(icono: Icons.verified_rounded, texto: 'Verificado'),
            ],
          ),
        ],
      ),
    );
  }
}

class _Pildora extends StatelessWidget {
  const _Pildora({required this.icono, required this.texto});

  final IconData icono;
  final String texto;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Radios.pildora),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icono, size: 16, color: Colores.tinta),
          const SizedBox(width: Espacios.xs),
          Text(texto, style: Theme.of(context).textTheme.labelLarge),
        ],
      ),
    );
  }
}
