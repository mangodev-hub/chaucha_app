// Pestaña "Perfil" del técnico: nivel y puntos, verificación de identidad y
// datos de trabajo (tarifa, oficios y zona).
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
import '../../../../core/widgets/aviso_banner.dart';
import '../../../../core/widgets/barra_accion.dart';
import '../../../../core/widgets/boton_carga.dart';
import '../../../../core/widgets/mapa_ubicacion.dart';
import '../../../../core/widgets/mensajes.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../core/widgets/seccion.dart';
import '../../../../core/widgets/tarjeta_app.dart';
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
    ref.listenManual(perfilTecnicoProvider, (_, estado) {
      if (estado case AsyncData(:final value)) _inicializar(value);
    }, fireImmediately: true);
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
    _radio = perfil.rangoCoberturaM
        .clamp(_radioMinimo, _radioMaximo)
        .toDouble();
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
    final guardado = await ref
        .read(guardarPerfilProvider.notifier)
        .guardar(
          CambiosPerfil(
            tarifaBase: double.parse(_tarifa.text.trim().replaceAll(',', '.')),
            rangoCoberturaM: _radio.round(),
            ubicacion: _ubicacion,
            oficioIds: _seleccionados,
          ),
        );
    if (!mounted) return;
    if (guardado) {
      context.mostrarMensaje('Perfil guardado.', tipo: TipoMensaje.exito);
    } else if (ref.read(guardarPerfilProvider) case AsyncError(:final error)) {
      context.mostrarMensaje(
        AsyncValueView.mensajeDe(error),
        tipo: TipoMensaje.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final guardando = ref.watch(guardarPerfilProvider).isLoading;
    final escritorio = ResponsiveLayout.isDesktop(context);

    return AsyncValueView<PerfilTecnico>(
      value: ref.watch(perfilTecnicoProvider),
      onRetry: () => ref.invalidate(perfilTecnicoProvider),
      onData: (context, perfil) {
        final boton = BotonCarga(
          texto: 'Guardar perfil',
          icono: Icons.save_outlined,
          cargando: guardando,
          onPressed: _guardar,
        );
        final resumen = [
          _Resumen(perfil: perfil),
          const SizedBox(height: Espacios.l),
          _BannerVerificacion(verificado: perfil.verificado),
          const SizedBox(height: Espacios.l),
        ];
        final tarifa = BloqueTarjeta(
          icono: Icons.payments_outlined,
          titulo: 'Tarifa base',
          subtitulo: 'Lo que cobras como mínimo por una visita.',
          child: TextFormField(
            controller: _tarifa,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.attach_money),
              hintText: '0.00',
            ),
            validator: (v) => FormValidators.monto(v, campo: 'La tarifa'),
          ),
        );
        final oficios = BloqueTarjeta(
          icono: Icons.handyman_outlined,
          titulo: 'Mis oficios',
          subtitulo: 'Verás solicitudes de los oficios que elijas.',
          child: _oficios(),
        );
        final zona = BloqueTarjeta(
          icono: Icons.map_outlined,
          titulo: 'Zona de trabajo',
          subtitulo: 'Toca el mapa para mover tu punto de partida.',
          child: _zona(),
        );

        if (escritorio) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(Espacios.xl),
            child: AnchoMaximo(
              ancho: 1100,
              child: Form(
                key: _formKey,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [...resumen, tarifa, oficios],
                      ),
                    ),
                    const SizedBox(width: Espacios.xl),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [zona, boton],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        // Móvil: el contenido se desplaza y "Guardar" queda fijo abajo.
        return Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(Espacios.l),
                  child: AnchoMaximo(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [...resumen, tarifa, oficios, zona],
                    ),
                  ),
                ),
              ),
              BarraAccion(child: boton),
            ],
          ),
        );
      },
    );
  }

  Widget _oficios() {
    return AsyncValueView<List<Oficio>>(
      value: ref.watch(oficiosProvider),
      onRetry: () => ref.invalidate(oficiosProvider),
      onData: (context, catalogo) => Wrap(
        spacing: Espacios.s,
        runSpacing: Espacios.s,
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
    final textos = Theme.of(context).textTheme;
    return Column(
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
              Formatos.distancia(_radio),
              style: textos.titleMedium?.copyWith(color: Colores.primario),
            ),
          ],
        ),
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
        const SizedBox(height: Espacios.m),
        OutlinedButton.icon(
          onPressed: _usarGps,
          icon: const Icon(Icons.my_location),
          label: const Text('Usar mi ubicación'),
        ),
      ],
    );
  }
}

/// Invita a verificar la identidad, o confirma que ya está verificada.
class _BannerVerificacion extends StatelessWidget {
  const _BannerVerificacion({required this.verificado});

  final bool verificado;

  @override
  Widget build(BuildContext context) {
    if (verificado) {
      return const AvisoBanner(
        tipo: TipoAviso.exito,
        icono: Icons.verified,
        titulo: 'Cuenta verificada',
        mensaje: 'Los clientes ven tu insignia de técnico verificado.',
      );
    }
    final textos = Theme.of(context).textTheme;
    return TarjetaApp(
      onTap: () => mostrarVerificacion(context),
      colorBorde: Colores.primarioClaro,
      child: Row(
        children: [
          const IconoRecuadro(icono: Icons.shield_outlined, lado: 44),
          const SizedBox(width: Espacios.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Verifica tu identidad', style: textos.titleSmall),
                Text(
                  'Sube tu cédula y una selfie. Los clientes confían más '
                  'en técnicos verificados.',
                  style: textos.bodySmall?.copyWith(color: Colores.tintaSuave),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colores.primario),
        ],
      ),
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
    final blanco = Theme.of(context).colorScheme.onPrimary;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colores.primario, Colores.primarioOscuro],
        ),
        boxShadow: Sombras.suave,
        borderRadius: BorderRadius.circular(Radios.grande),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: blanco.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(Radios.pildora),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.workspace_premium_rounded,
                  color: Colores.estrella,
                  size: 32,
                ),
                const SizedBox(width: Espacios.s),
                // En pantallas angostas, el número se achica en vez de
                // desbordarse.
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '${perfil.puntos} pts',
                      style: textos.displaySmall?.copyWith(color: blanco),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: Espacios.m),
          Text(
            'Nivel ${perfil.nivelNombre}',
            style: textos.titleLarge?.copyWith(color: blanco),
          ),
          const SizedBox(height: Espacios.l),
          Wrap(
            spacing: Espacios.s,
            runSpacing: Espacios.s,
            alignment: WrapAlignment.center,
            children: [
              _Pildora(
                icono: Icons.star_rounded,
                colorIcono: Colores.estrella,
                texto:
                    '${perfil.calificacionPromedio.toStringAsFixed(1)} '
                    '(${perfil.totalResenas} reseñas)',
              ),
              _Pildora(
                icono: Icons.percent_rounded,
                texto:
                    'Comisión ${perfil.comisionPorcentaje.toStringAsFixed(0)} %',
              ),
              if (perfil.verificado)
                const _Pildora(
                  icono: Icons.verified_rounded,
                  colorIcono: Colores.acento,
                  texto: 'Verificado',
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Pildora extends StatelessWidget {
  const _Pildora({
    required this.icono,
    required this.texto,
    this.colorIcono = Colores.tinta,
  });

  final IconData icono;
  final String texto;
  final Color colorIcono;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colores.tarjeta,
        borderRadius: BorderRadius.circular(Radios.pildora),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icono, size: 16, color: colorIcono),
          const SizedBox(width: Espacios.xs),
          Flexible(
            child: Text(texto, style: Theme.of(context).textTheme.labelLarge),
          ),
        ],
      ),
    );
  }
}
