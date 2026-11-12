import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../../../app/pestana_solicitada.dart';
import '../../../../core/geo/geo_mapper.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/utils/formatos.dart';
import '../../../../core/validators/form_validators.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/avatar_usuario.dart';
import '../../../../core/widgets/barra_accion.dart';
import '../../../../core/widgets/boton_baja.dart';
import '../../../../core/widgets/boton_carga.dart';
import '../../../../core/widgets/cuadricula_adaptable.dart';
import '../../../../core/widgets/mapa_ubicacion.dart';
import '../../../../core/widgets/mensajes.dart';
import '../../../../core/widgets/pildora.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../core/widgets/seccion.dart';
import '../../../../core/widgets/tarjeta_app.dart';
import '../../../auth/presentation/providers/sesion_provider.dart';
import '../../../catalogo/domain/entities/oficio.dart';
import '../../../catalogo/presentation/providers/oficios_provider.dart';
import '../../../solicitudes/domain/entities/resumen_tecnico.dart';
import '../../../solicitudes/presentation/providers/inicio_tecnico_provider.dart';
import '../../domain/entities/cambios_perfil.dart';
import '../../domain/entities/nivel.dart';
import '../../domain/entities/perfil_publico.dart';
import '../../domain/entities/perfil_tecnico.dart';
import '../providers/perfil_publico_provider.dart';
import '../providers/perfil_tecnico_provider.dart';
import '../widgets/certificaciones_widgets.dart';
import '../widgets/resena_widgets.dart';
import 'aviso_verificacion_cliente.dart';
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
  final _claveOficios = GlobalKey();
  final _claveZona = GlobalKey();

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
    ref.listenManual(seccionPerfilProvider, (_, seccion) {
      if (seccion == null) return;
      ref.read(seccionPerfilProvider.notifier).limpiar();
      // Espera al cambio de pestaña para que la sección ya esté visible.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final contexto =
            (seccion == 'zona' ? _claveZona : _claveOficios).currentContext;
        if (contexto == null) return;
        unawaited(
          Scrollable.ensureVisible(
            contexto,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          ),
        );
      });
    });
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
        final nombre = ref.watch(usuarioActualProvider)?.nombreCompleto ?? '';
        final cabecera = <Widget>[
          _CabeceraTecnico(nombre: nombre, perfil: perfil),
          const SizedBox(height: Espacios.xl + 8),
          _EstadisticasTecnico(perfil: perfil),
          const SizedBox(height: Espacios.l),
          const _ActividadTecnico(),
          const SizedBox(height: Espacios.l),
          _NivelYResenas(perfil: perfil),
          const SeccionCertificaciones(),
          const SizedBox(height: Espacios.l),
        ];
        final banner = _BannerVerificacion(verificado: perfil.verificado);
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
        final oficios = KeyedSubtree(
          key: _claveOficios,
          child: BloqueTarjeta(
            icono: Icons.handyman_outlined,
            titulo: 'Mis oficios',
            subtitulo: 'Verás solicitudes de los oficios que elijas.',
            child: _oficios(),
          ),
        );
        final zona = KeyedSubtree(
          key: _claveZona,
          child: BloqueTarjeta(
            icono: Icons.map_outlined,
            titulo: 'Zona de trabajo',
            subtitulo: 'Toca el mapa para mover tu punto de partida.',
            child: _zona(),
          ),
        );

        if (escritorio) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(Espacios.xl),
            child: AnchoMaximo(
              ancho: 1100,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ...cabecera,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              banner,
                              const SizedBox(height: Espacios.l),
                              tarifa,
                              oficios,
                            ],
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
                      children: [
                        ...cabecera,
                        banner,
                        const SizedBox(height: Espacios.l),
                        tarifa,
                        oficios,
                        zona,
                      ],
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
          mostrarSector: true,
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
    return const AvisoVerificacionCliente(
      subtitulo: 'Los clientes confían más en técnicos verificados.',
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

/// Cabecera del perfil: banner, avatar con iniciales, nombre, ubicación,
/// nivel y verificado.
class _CabeceraTecnico extends StatelessWidget {
  const _CabeceraTecnico({required this.nombre, required this.perfil});

  final String nombre;
  final PerfilTecnico perfil;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final info = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(nombre, style: textos.headlineSmall),
                const SizedBox(height: Espacios.xs),
                const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: Colores.primario,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Quito, Ecuador',
                      style: TextStyle(color: Colores.tintaSuave),
                    ),
                  ],
                ),
                const SizedBox(height: Espacios.s),
                Wrap(
                  spacing: Espacios.s,
                  runSpacing: Espacios.xs,
                  children: [
                    Pildora(
                      texto: 'Nivel ${perfil.nivelNombre}',
                      icono: Icons.workspace_premium_outlined,
                      color: Colores.primario,
                    ),
                    if (perfil.verificado)
                      const Pildora(
                        texto: 'Verificado',
                        icono: Icons.verified,
                        color: Colores.acento,
                      ),
                    InsigniaSiCertificado(tecnicoId: perfil.usuarioId),
                  ],
                ),
              ],
            );
    return TarjetaApp(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(Radios.grande),
                ),
                child: Container(
                  height: 120,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colores.primarioOscuro, Colores.primario],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: Espacios.xl,
                bottom: -44,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colores.tarjeta,
                    shape: BoxShape.circle,
                  ),
                  child: Consumer(
                    builder: (context, ref, _) => AvatarUsuario(
                      nombre: nombre,
                      rutaFoto: ref.watch(usuarioActualProvider)?.fotoPerfilRuta,
                      radio: 44,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Espacios.xl + 104,
              Espacios.m,
              Espacios.l,
              Espacios.l,
            ),
            child: LayoutBuilder(
              builder: (context, c) {
                const baja = BotonBaja();
                // Ancho suficiente: el botón va a la derecha. Si no, debajo.
                if (c.maxWidth >= 480) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(child: info),
                      const SizedBox(width: Espacios.m),
                      baja,
                    ],
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    info,
                    const SizedBox(height: Espacios.m),
                    baja,
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Tarjetas de puntos y calificación.
class _EstadisticasTecnico extends StatelessWidget {
  const _EstadisticasTecnico({required this.perfil});

  final PerfilTecnico perfil;

  @override
  Widget build(BuildContext context) {
    final esNuevo = perfil.totalResenas == 0;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _DatoPerfil(
            icono: Icons.workspace_premium_outlined,
            valor: '${perfil.puntos}',
            etiqueta: 'Puntos',
          ),
        ),
        const SizedBox(width: Espacios.m),
        Expanded(
          child: _DatoPerfil(
            icono: Icons.star_rounded,
            valor: esNuevo
                ? 'Nuevo'
                : perfil.calificacionPromedio.toStringAsFixed(1),
            etiqueta: esNuevo
                ? 'Sin reseñas'
                : '${perfil.totalResenas} reseñas',
          ),
        ),
      ],
    );
  }
}

class _DatoPerfil extends StatelessWidget {
  const _DatoPerfil({
    required this.icono,
    required this.valor,
    required this.etiqueta,
  });

  final IconData icono;
  final String valor;
  final String etiqueta;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    return TarjetaApp(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconoRecuadro(icono: icono, lado: 40),
          const SizedBox(height: Espacios.s),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(valor, style: textos.headlineSmall),
          ),
          Text(
            etiqueta,
            maxLines: 2,
            style: textos.bodySmall?.copyWith(color: Colores.tintaSuave),
          ),
        ],
      ),
    );
  }
}

/// Actividad del técnico: ofertas, tickets, trabajos y lo ganado en el mes.
class _ActividadTecnico extends ConsumerWidget {
  const _ActividadTecnico();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Seccion(
      titulo: 'Tu actividad',
      child: AsyncValueView<ResumenTecnico>(
        value: ref.watch(resumenTecnicoProvider),
        onRetry: () => ref.invalidate(resumenTecnicoProvider),
        onData: (context, r) => CuadriculaAdaptable(
          anchoMinimo: 0,
          children: [
            _DatoPerfil(
              icono: Icons.local_offer_outlined,
              valor: '${r.ofertasPendientes}',
              etiqueta: 'Ofertas pendientes',
            ),
            _DatoPerfil(
              icono: Icons.receipt_long_outlined,
              valor: '${r.ticketsPorConfirmar}',
              etiqueta: 'Tickets por confirmar',
            ),
            _DatoPerfil(
              icono: Icons.task_alt,
              valor: '${r.completados}',
              etiqueta: 'Trabajos completados',
            ),
            _DatoPerfil(
              icono: Icons.payments_outlined,
              valor: Formatos.dinero(r.ganadoEsteMes),
              etiqueta: 'Ganado este mes',
            ),
          ],
        ),
      ),
    );
  }
}

/// Insignias de nivel, puntos que faltan para el siguiente y reseñas.
class _NivelYResenas extends ConsumerWidget {
  const _NivelYResenas({required this.perfil});

  final PerfilTecnico perfil;

  static const _colores = {
    'Bronce': Color(0xFFCD7F32),
    'Plata': Color(0xFF9EA7B0),
    'Oro': Color(0xFFF5B301),
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textos = Theme.of(context).textTheme;
    final niveles = ref.watch(nivelesProvider).value;
    final miId = ref.watch(usuarioActualProvider)?.id;
    final resenas = miId == null
        ? null
        : ref.watch(perfilPublicoProvider(miId)).value?.resenas;
    final progreso = niveles == null || niveles.isEmpty
        ? null
        : ProgresoNivel.calcular(perfil.puntos, niveles);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (niveles != null && progreso != null)
          TarjetaApp(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    for (final n in niveles)
                      _Insignia(
                        nombre: n.nombre,
                        puntos: n.puntosMinimos,
                        color: _colores[n.nombre] ?? Colores.primario,
                        lograda: perfil.puntos >= n.puntosMinimos,
                        actual: n.nombre == perfil.nivelNombre,
                      ),
                  ],
                ),
                const SizedBox(height: Espacios.l),
                ClipRRect(
                  borderRadius: BorderRadius.circular(Radios.pildora),
                  child: LinearProgressIndicator(
                    value: progreso.esNivelMaximo ? 1 : progreso.fraccion,
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: Espacios.s),
                Text(
                  progreso.esNivelMaximo
                      ? '¡Llegaste al nivel más alto!'
                      : 'Te faltan ${progreso.puntosFaltantes} puntos para '
                            'llegar a ${progreso.siguiente!.nombre}.',
                  textAlign: TextAlign.center,
                  style: textos.bodyMedium,
                ),
              ],
            ),
          ),
        if (resenas != null && resenas.isNotEmpty) ...[
          const SizedBox(height: Espacios.l),
          _SeccionResenas(resenas: resenas),
        ],
      ],
    );
  }
}

class _Insignia extends StatelessWidget {
  const _Insignia({
    required this.nombre,
    required this.puntos,
    required this.color,
    required this.lograda,
    required this.actual,
  });

  final String nombre;
  final int puntos;
  final Color color;
  final bool lograda;
  final bool actual;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: lograda ? color : Colors.grey.shade300,
            border: actual
                ? Border.all(color: Colores.primario, width: 3)
                : null,
          ),
          child: Icon(
            lograda ? Icons.workspace_premium_rounded : Icons.lock_outline,
            color: Colors.white,
            size: 30,
          ),
        ),
        const SizedBox(height: 4),
        Text(nombre, style: textos.labelLarge),
        Text('$puntos pts', style: textos.bodySmall),
      ],
    );
  }
}

/// Reseñas recibidas, en columnas y con filtro por fecha.
class _SeccionResenas extends StatefulWidget {
  const _SeccionResenas({required this.resenas});

  final List<ResenaPublica> resenas;

  @override
  State<_SeccionResenas> createState() => _SeccionResenasState();
}

class _SeccionResenasState extends State<_SeccionResenas> {
  static const int _inicial = 4;
  static const List<({String texto, int? dias})> _filtros = [
    (texto: 'Todas', dias: null),
    (texto: '7 días', dias: 7),
    (texto: '30 días', dias: 30),
    (texto: '3 meses', dias: 90),
  ];

  int? _dias;
  bool _todas = false;

  @override
  Widget build(BuildContext context) {
    final desde = _dias == null
        ? null
        : DateTime.now().subtract(Duration(days: _dias!));
    final lista = [
      for (final r in widget.resenas)
        if (desde == null || r.creadoEn.isAfter(desde)) r,
    ];
    final visibles = _todas ? lista : lista.take(_inicial).toList();
    return Seccion(
      titulo: 'Reseñas',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: Espacios.s,
            children: [
              for (final f in _filtros)
                ChoiceChip(
                  label: Text(f.texto),
                  selected: _dias == f.dias,
                  onSelected: (_) => setState(() {
                    _dias = f.dias;
                    _todas = false;
                  }),
                ),
            ],
          ),
          const SizedBox(height: Espacios.m),
          if (lista.isEmpty)
            Text(
              'No hay reseñas en este periodo.',
              style: Theme.of(context).textTheme.bodyMedium,
            )
          else
            CuadriculaAdaptable(
              anchoMinimo: 560,
              children: [for (final r in visibles) TarjetaResena(resena: r)],
            ),
          if (lista.length > _inicial)
            TextButton(
              onPressed: () => setState(() => _todas = !_todas),
              child: Text(_todas ? 'Ver menos' : 'Ver las ${lista.length}'),
            ),
        ],
      ),
    );
  }
}