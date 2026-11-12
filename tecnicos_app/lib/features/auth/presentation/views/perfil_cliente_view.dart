import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../core/widgets/avatar_usuario.dart';
import '../../../../core/widgets/carrusel_aliados.dart';
import '../../../perfil_puntos/presentation/views/aviso_verificacion_cliente.dart';
import '../../../perfil_puntos/presentation/widgets/resena_widgets.dart';
import '../providers/resenas_cliente_provider.dart';
import '../providers/sesion_provider.dart';

const _azul = Colores.primarioVivo;
const _azulOscuro = Colores.primarioProfundo;
const _hielo = Colores.primarioSuave;
const _fondo = Colores.fondo;
const _texto = Colores.tinta;
const _gris = Colores.tintaSuave;
const _borde = Colores.linea;
const _rojo = Colores.error;
const _blanco = Colores.tarjeta;

String _mesAnio(DateTime f) {
  const m = [
    'Ene',
    'Feb',
    'Mar',
    'Abr',
    'May',
    'Jun',
    'Jul',
    'Ago',
    'Sep',
    'Oct',
    'Nov',
    'Dic',
  ];
  return '${m[f.month - 1]} ${f.year}';
}

class PerfilClienteView extends ConsumerWidget {
  const PerfilClienteView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usuario = ref.watch(usuarioActualProvider);
    if (usuario == null) return const SizedBox.shrink();
    final resumen = ref.watch(resenasRecibidasProvider).value;

    return ColoredBox(
      color: _fondo,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: LayoutBuilder(
              builder: (context, c) {
                final ancho = c.maxWidth >= 900;
                const izquierda = _Resenas();
                const derecha = Column(
                  children: [
                    _Ubicacion(),
                    SizedBox(height: 16),
                    _Privacidad(),
                    SizedBox(height: 16),
                    CarruselAliados(),
                  ],
                );
                return Column(
                  children: [
                    _Cabecera(usuario.nombreCompleto),
                    const SizedBox(height: 24),
                    const AvisoVerificacionCliente(margenInferior: 24),
                    _Estadisticas(
                      promedio: resumen?.promedio ?? 0,
                      total: resumen?.total ?? 0,
                      desde: usuario.creadoEn.toLocal(),
                    ),
                    const SizedBox(height: 24),
                    if (ancho)
                      const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 8, child: izquierda),
                          SizedBox(width: 24),
                          Expanded(flex: 4, child: derecha),
                        ],
                      )
                    else ...[
                      izquierda,
                      const SizedBox(height: 24),
                      derecha,
                    ],
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _Tarjeta extends StatelessWidget {
  const _Tarjeta({
    required this.child,
    this.padding = const EdgeInsets.all(24),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: _blanco,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borde),
      ),
      child: child,
    );
  }
}

class _Etiqueta extends StatelessWidget {
  const _Etiqueta(this.texto);

  final String texto;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _hielo,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        texto,
        style: const TextStyle(
          color: _azulOscuro,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _Avatar extends ConsumerWidget {
  const _Avatar(this.nombre, {this.radio = 30});

  final String nombre;
  final double radio;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AvatarUsuario(
      nombre: nombre,
      rutaFoto: ref.watch(usuarioActualProvider)?.fotoPerfilRuta,
      radio: radio,
    );
  }
}

class _Cabecera extends StatelessWidget {
  const _Cabecera(this.nombre);

  final String nombre;

  @override
  Widget build(BuildContext context) {
    return _Tarjeta(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Container(
                  height: 160,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [_azulOscuro, _azul],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 32,
                bottom: -48,
                child: Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: _blanco,
                        shape: BoxShape.circle,
                      ),
                      child: _Avatar(nombre, radio: 56),
                    ),
                    Positioned(
                      right: 4,
                      bottom: 4,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: _azul,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.photo_camera,
                          size: 18,
                          color: _blanco,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(176, 16, 32, 24),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              runSpacing: 16,
              spacing: 16,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nombre,
                      style: const TextStyle(
                        color: _texto,
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: _azul,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Quito, Ecuador',
                          style: TextStyle(color: _gris, fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: () => _mostrarBaja(context),
                  icon: const Icon(Icons.person_remove_outlined, size: 18),
                  label: const Text(
                    'Darse de baja',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: _rojo,
                    backgroundColor: _rojo.withValues(alpha: 0.08),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: _rojo.withValues(alpha: 0.3)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _mostrarBaja(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: _blanco,
      icon: const Icon(Icons.warning_amber_rounded, color: _rojo, size: 40),
      title: const Text('¿Quieres darte de baja de ChauchaApp?'),
      content: const Text(
        'Tu cuenta quedará desactivada y se cancelarán tus solicitudes activas.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Mantener mi cuenta'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          style: FilledButton.styleFrom(backgroundColor: _rojo),
          child: const Text('Continuar con la baja'),
        ),
      ],
    ),
  );
}

class _Estadisticas extends StatelessWidget {
  const _Estadisticas({
    required this.promedio,
    required this.total,
    required this.desde,
  });

  final double promedio;
  final int total;
  final DateTime desde;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final a = _Estadistica(
          Icons.star_outline_rounded,
          total == 0 ? '—' : promedio.toStringAsFixed(1),
          'Calificación promedio',
        );
        final b = _Estadistica(
          Icons.rate_review_outlined,
          '$total',
          'Reseñas recibidas',
        );
        final d = _Estadistica(
          Icons.calendar_month_outlined,
          _mesAnio(desde),
          'Miembro desde',
        );
        if (c.maxWidth >= 900) {
          return Row(
            children: [
              Expanded(child: a),
              const SizedBox(width: 16),
              Expanded(child: b),
              const SizedBox(width: 16),
              Expanded(child: d),
            ],
          );
        }
        return Column(
          children: [
            a,
            const SizedBox(height: 12),
            b,
            const SizedBox(height: 12),
            d,
          ],
        );
      },
    );
  }
}

class _Estadistica extends StatelessWidget {
  const _Estadistica(this.icono, this.valor, this.titulo);

  final IconData icono;
  final String valor;
  final String titulo;

  @override
  Widget build(BuildContext context) {
    return _Tarjeta(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _hielo,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icono, color: _azul, size: 26),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  valor,
                  style: const TextStyle(
                    color: _texto,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  titulo,
                  style: const TextStyle(color: _gris, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Resenas extends ConsumerWidget {
  const _Resenas();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final datos = ref.watch(resenasRecibidasProvider);
    return _Tarjeta(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Reseñas de técnicos',
                  style: TextStyle(
                    color: _texto,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (datos.value case final r? when r.total > 0)
                _Etiqueta('${r.promedio.toStringAsFixed(1)} ★'),
            ],
          ),
          const SizedBox(height: 16),
          datos.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => const Text(
              'No pudimos cargar tus reseñas.',
              style: TextStyle(color: _gris, fontSize: 14),
            ),
            data: (r) => r.resenas.isEmpty
                ? const Text(
                    'Aún no tienes reseñas. Aparecerán cuando un técnico '
                    'califique un trabajo contigo.',
                    style: TextStyle(color: _gris, fontSize: 14),
                  )
                : Column(
                    children: [
                      for (final res in r.resenas) TarjetaResena(resena: res),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _Ubicacion extends StatelessWidget {
  const _Ubicacion();

  @override
  Widget build(BuildContext context) {
    return const _Tarjeta(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_on_outlined, color: _azul, size: 20),
              SizedBox(width: 8),
              Text(
                'Mi ubicación',
                style: TextStyle(
                  color: _texto,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          _MapaZona(),
          SizedBox(height: 12),
          Text(
            'Se usa para encontrar técnicos cercanos sin exponer tu domicilio particular.',
            style: TextStyle(color: _gris, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _MapaZona extends StatefulWidget {
  const _MapaZona();

  @override
  State<_MapaZona> createState() => _MapaZonaState();
}

class _MapaZonaState extends State<_MapaZona> {
  final _controlador = MapController();
  LatLng _centro = const LatLng(-0.1807, -78.4678);
  String? _lugar;
  bool _buscando = false;
  String? _aviso;

  @override
  void initState() {
    super.initState();
    unawaited(_detectar());
  }

  Future<void> _detectar({bool manual = false}) async {
    if (manual) setState(() => _buscando = true);
    try {
      var permiso = await Geolocator.checkPermission();
      if (permiso == LocationPermission.denied) {
        permiso = await Geolocator.requestPermission();
      }
      if (permiso == LocationPermission.denied ||
          permiso == LocationPermission.deniedForever) {
        if (manual && mounted) {
          setState(
            () => _aviso =
                'Activa el permiso de ubicación para usar esta opción.',
          );
        }
        return;
      }
      final p = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
        ),
      );
      if (!mounted) return;
      _fijar(_redondear(LatLng(p.latitude, p.longitude)));
    } catch (_) {
      if (manual && mounted) {
        setState(() => _aviso = 'No pudimos obtener tu ubicación actual.');
      }
    } finally {
      if (manual && mounted) setState(() => _buscando = false);
    }
  }

  LatLng _redondear(LatLng p) => LatLng(
    (p.latitude * 200).round() / 200,
    (p.longitude * 200).round() / 200,
  );

  void _fijar(LatLng punto) {
    setState(() {
      _centro = punto;
      _lugar = null;
      _aviso = null;
    });
    _controlador.move(punto, 14);
    unawaited(_resolverLugar(punto));
  }

  Future<void> _elegir() async {
    final punto = await showDialog<LatLng>(
      context: context,
      builder: (_) => _SelectorUbicacion(inicial: _centro),
    );
    if (punto == null || !mounted) return;
    _fijar(_redondear(punto));
  }

  Future<void> _resolverLugar(LatLng p) async {
    try {
      final r = await http.get(
        Uri.https('nominatim.openstreetmap.org', '/reverse', {
          'lat': '${p.latitude}',
          'lon': '${p.longitude}',
          'format': 'jsonv2',
          'zoom': '17',
          'addressdetails': '1',
        }),
        headers: {'Accept-Language': 'es'},
      );
      if (r.statusCode != 200) return;
      final cuerpo = jsonDecode(r.body) as Map?;
      final a = (cuerpo?['address'] as Map?) ?? const {};
      final calle = a['road'] as String?;
      final calleValida =
          calle != null && !RegExp(r'^[A-Za-z]?\d+[A-Za-z]?$').hasMatch(calle)
          ? calle
          : null;
      final texto = [
        calleValida,
        a['neighbourhood'] ?? a['suburb'],
      ].whereType<String>().join(', ');
      if (!mounted || texto.isEmpty) return;
      setState(() => _lugar = texto);
    } catch (_) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            height: 150,
            child: FlutterMap(
              mapController: _controlador,
              options: MapOptions(
                initialCenter: _centro,
                initialZoom: 14,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.drag | InteractiveFlag.pinchZoom,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.eagledev.tecnicosapp',
                ),
                CircleLayer(
                  circles: [
                    CircleMarker(
                      point: _centro,
                      radius: 500,
                      useRadiusInMeter: true,
                      color: _azul.withValues(alpha: 0.25),
                      borderColor: _azul,
                      borderStrokeWidth: 2,
                    ),
                  ],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _centro,
                      width: 40,
                      height: 40,
                      alignment: Alignment.topCenter,
                      child: const Icon(
                        Icons.location_on,
                        color: _rojo,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Icon(Icons.place_outlined, size: 16, color: _azul),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                _lugar ?? 'Quito, Ecuador',
                style: const TextStyle(
                  color: _texto,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (_aviso != null) ...[
          const SizedBox(height: 8),
          Text(_aviso!, style: const TextStyle(color: _rojo, fontSize: 12)),
        ],
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: _buscando ? null : () => _detectar(manual: true),
            icon: _buscando
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.my_location, size: 18),
            label: const Text('Usar mi ubicación actual'),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _elegir,
            icon: const Icon(Icons.edit_location_alt_outlined, size: 18),
            label: const Text('Seleccionar en el mapa'),
          ),
        ),
      ],
    );
  }
}

class _SelectorUbicacion extends StatefulWidget {
  const _SelectorUbicacion({required this.inicial});

  final LatLng inicial;

  @override
  State<_SelectorUbicacion> createState() => _SelectorUbicacionState();
}

class _SelectorUbicacionState extends State<_SelectorUbicacion> {
  late LatLng _punto = widget.inicial;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: _blanco,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520, maxHeight: 560),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Selecciona tu ubicación',
                style: TextStyle(
                  color: _texto,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Toca el mapa para mover el pin.',
                style: TextStyle(color: _gris, fontSize: 13),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: FlutterMap(
                    options: MapOptions(
                      initialCenter: widget.inicial,
                      initialZoom: 15,
                      onTap: (_, p) => setState(() => _punto = p),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.eagledev.tecnicosapp',
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: _punto,
                            width: 40,
                            height: 40,
                            alignment: Alignment.topCenter,
                            child: const Icon(
                              Icons.location_on,
                              color: _rojo,
                              size: 40,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancelar'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: () => Navigator.of(context).pop(_punto),
                    child: const Text('Confirmar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Privacidad extends StatelessWidget {
  const _Privacidad();

  @override
  Widget build(BuildContext context) {
    return const _Tarjeta(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lock_outline, color: _azul),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Privacidad protegida',
                  style: TextStyle(
                    color: _texto,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Tu dirección exacta solo se comparte con el técnico que aceptes.',
                  style: TextStyle(color: _gris, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
