// Pestaña "Perfil" del técnico: nivel/puntos y datos de trabajo.
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/catalogo/oficio.dart';
import '../../../core/state/view_state.dart';
import '../../../core/utils/formatos.dart';
import '../../../core/validators/form_validators.dart';
import '../../../core/widgets/boton_carga.dart';
import '../../../core/widgets/mapa_ubicacion.dart';
import '../../../core/widgets/mensajes.dart';
import '../../../core/widgets/seccion.dart';
import '../../../core/widgets/view_state_builder.dart';
import '../models/perfil_tecnico.dart';
import '../viewmodels/perfil_tecnico_view_model.dart';
import '../viewmodels/verificacion_view_model.dart';
import 'verificacion_view.dart';


class PerfilTecnicoView extends StatefulWidget {
  const PerfilTecnicoView({
    super.key,
    required this.crearViewModel,
    required this.crearVerificacionViewModel,
  });

  final PerfilTecnicoViewModel Function() crearViewModel;
  final VerificacionViewModel Function() crearVerificacionViewModel;

  @override
  State<PerfilTecnicoView> createState() => _PerfilTecnicoViewState();
}

class _PerfilTecnicoViewState extends State<PerfilTecnicoView> {
  late final PerfilTecnicoViewModel _vm = widget.crearViewModel();
  final _formKey = GlobalKey<FormState>();
  final _tarifa = TextEditingController();

  @override
  void initState() {
    super.initState();
    _vm.cargar().then((_) {
      if (!mounted) return;
      final estado = _vm.value;
      if (estado is! ViewLoaded<PerfilTecnico>) return;
      _tarifa.text = estado.data.tarifaBase.toStringAsFixed(2);
    });
  }

  @override
  void dispose() {
    _vm.dispose();
    _tarifa.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final error = await _vm.guardar(
      tarifaBase: double.parse(_tarifa.text.trim().replaceAll(',', '.')),
    );
    if (mounted) context.mostrarMensaje(error ?? 'Perfil guardado.');
  }

  Future<void> _usarGps() async {
    final ok = await _vm.usarMiUbicacion();
    if (!ok && mounted) {
      context.mostrarMensaje('No pudimos obtener tu ubicación. Toca el mapa.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewStateBuilder<PerfilTecnico>(
      listenable: _vm,
      onRetry: _vm.cargar,
      onLoaded: (context, perfil) => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: AnchoMaximo(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Resumen(perfil: perfil),
                OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => VerificacionView(
                        crearViewModel: widget.crearVerificacionViewModel,
                      ),
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
                ValueListenableBuilder<bool>(
                  valueListenable: _vm.procesando,
                  builder: (context, guardando, _) => BotonCarga(
                    texto: 'Guardar perfil',
                    cargando: guardando,
                    onPressed: _guardar,
                  ),
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
    return ValueListenableBuilder<List<Oficio>>(
      valueListenable: _vm.catalogo,
      builder: (context, catalogo, _) => ValueListenableBuilder<Set<int>>(
        valueListenable: _vm.seleccionados,
        builder: (context, seleccionados, _) => Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final oficio in catalogo)
              FilterChip(
                label: Text(oficio.nombre),
                selected: seleccionados.contains(oficio.id),
                onSelected: (_) => _vm.alternarOficio(oficio.id),
              ),
          ],
        ),
      ),
    );
  }

  Widget _zona() {
    return ValueListenableBuilder<double>(
      valueListenable: _vm.radio,
      builder: (context, radio, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Atiendo hasta ${Formatos.distancia(radio)} a la redonda.'),
          Slider(
            value: radio,
            min: PerfilTecnicoViewModel.radioMinimo,
            max: PerfilTecnicoViewModel.radioMaximo,
            divisions: 19,
            label: Formatos.distancia(radio),
            onChanged: _vm.cambiarRadio,
          ),
          ValueListenableBuilder<LatLng>(
            valueListenable: _vm.ubicacion,
            builder: (context, punto, _) => MapaUbicacion(
              punto: punto,
              radioMetros: radio,
              onCambio: _vm.moverPin,
            ),
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
      ),
    );
  }
}


class _Resumen extends StatelessWidget {
  const _Resumen({required this.perfil});

  final PerfilTecnico perfil;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Nivel ${perfil.nivelNombre}', style: textos.titleLarge),
                const Spacer(),
                if (perfil.verificado)
                  const Chip(
                    avatar: Icon(Icons.verified, size: 18),
                    label: Text('Verificado'),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 24,
              runSpacing: 8,
              children: [
                _Dato(titulo: 'Puntos', valor: '${perfil.puntos}'),
                _Dato(
                  titulo: 'Calificación',
                  valor: '${perfil.calificacionPromedio.toStringAsFixed(1)} ★ '
                      '(${perfil.totalResenas})',
                ),
                _Dato(
                  titulo: 'Comisión',
                  valor: '${perfil.comisionPorcentaje.toStringAsFixed(0)} %',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Dato extends StatelessWidget {
  const _Dato({required this.titulo, required this.valor});

  final String titulo;
  final String valor;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(titulo, style: textos.labelMedium),
        Text(valor, style: textos.titleMedium),
      ],
    );
  }
}
