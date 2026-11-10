import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/widgets/carrusel_aliados.dart';
import '../../../solicitudes/domain/entities/solicitud.dart';
import '../../../solicitudes/presentation/providers/listas_provider.dart';
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

String _fecha(DateTime f) {
  final d = f.toLocal();
  return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
}

class PerfilClienteView extends ConsumerWidget {
  const PerfilClienteView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usuario = ref.watch(usuarioActualProvider);
    if (usuario == null) return const SizedBox.shrink();
    final todas =
        ref.watch(misSolicitudesProvider).value ?? const <Solicitud>[];
    final completadas = [
      for (final s in todas)
        if (s.estado == EstadoSolicitud.completada) s,
    ];
    final pendientes = [
      for (final s in todas)
        if (s.estado.recibeCotizaciones) s,
    ];
    final activas = pendientes.length;

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
                final izquierda = Column(
                  children: [
                    _Activas(pendientes),
                    const SizedBox(height: 24),
                    _Historial(completadas),
                  ],
                );
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
                    _Estadisticas(
                      completadas: completadas.length,
                      activas: activas,
                      desde: usuario.creadoEn.toLocal(),
                    ),
                    const SizedBox(height: 24),
                    if (ancho)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 8, child: izquierda),
                          const SizedBox(width: 24),
                          const Expanded(flex: 4, child: derecha),
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

class _Avatar extends StatelessWidget {
  const _Avatar(this.nombre, {this.radio = 30});

  final String nombre;
  final double radio;

  @override
  Widget build(BuildContext context) {
    final iniciales = nombre
        .split(' ')
        .where((p) => p.isNotEmpty)
        .take(2)
        .map((p) => p[0].toUpperCase())
        .join();
    return CircleAvatar(
      radius: radio,
      backgroundColor: _hielo,
      child: Text(
        iniciales,
        style: TextStyle(
          color: _azulOscuro,
          fontSize: radio * 0.6,
          fontWeight: FontWeight.w700,
        ),
      ),
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
    required this.completadas,
    required this.activas,
    required this.desde,
  });

  final int completadas;
  final int activas;
  final DateTime desde;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final a = _Estadistica(
          Icons.check_circle_outline,
          '$completadas',
          'Solicitudes completadas',
        );
        final b = _Estadistica(
          Icons.calendar_month_outlined,
          _mesAnio(desde),
          'Miembro desde',
        );
        final d = _Estadistica(
          Icons.pending_actions_outlined,
          '$activas',
          'Solicitudes activas',
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

class _Historial extends StatelessWidget {
  const _Historial(this.solicitudes);

  final List<Solicitud> solicitudes;

  @override
  Widget build(BuildContext context) {
    return _Tarjeta(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Historial de servicios',
                  style: TextStyle(
                    color: _texto,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              _Etiqueta('${solicitudes.length} servicios'),
            ],
          ),
          const SizedBox(height: 16),
          if (solicitudes.isEmpty)
            const Text(
              'Aún no tienes servicios completados.',
              style: TextStyle(color: _gris, fontSize: 14),
            )
          else
            for (final s in solicitudes) ...[
              _FilaTrabajo(s),
              const SizedBox(height: 12),
            ],
        ],
      ),
    );
  }
}

class _Activas extends StatelessWidget {
  const _Activas(this.solicitudes);

  final List<Solicitud> solicitudes;

  @override
  Widget build(BuildContext context) {
    return _Tarjeta(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Solicitudes activas',
                  style: TextStyle(
                    color: _texto,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              _Etiqueta('${solicitudes.length} en curso'),
            ],
          ),
          const SizedBox(height: 16),
          if (solicitudes.isEmpty)
            const Text(
              'No tienes solicitudes en curso.',
              style: TextStyle(color: _gris, fontSize: 14),
            )
          else
            for (final s in solicitudes) ...[
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => context.push(
                  AppRoutes.detalleSolicitud(s.id, esCliente: true),
                ),
                child: _FilaTrabajo(s),
              ),
              const SizedBox(height: 12),
            ],
        ],
      ),
    );
  }
}

class _FilaTrabajo extends StatelessWidget {
  const _FilaTrabajo(this.s);

  final Solicitud s;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borde),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _Etiqueta(s.oficioNombre),
              const SizedBox(width: 12),
              Text(
                _fecha(s.creadoEn),
                style: const TextStyle(color: _gris, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            s.descripcion,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: _texto,
              fontSize: 16,
              fontWeight: FontWeight.w600,
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
    return _Tarjeta(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
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
          const SizedBox(height: 12),
          const _MapaZona(),
          const SizedBox(height: 12),
          const Text(
            'Se usa para encontrar técnicos cercanos sin exponer tu domicilio particular.',
            style: TextStyle(color: _gris, fontSize: 13),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.edit_location_alt_outlined, size: 18),
              label: const Text('Cambiar ubicación'),
            ),
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

  @override
  void initState() {
    super.initState();
    unawaited(_detectar());
  }

  Future<void> _detectar() async {
    try {
      var permiso = await Geolocator.checkPermission();
      if (permiso == LocationPermission.denied) {
        permiso = await Geolocator.requestPermission();
      }
      if (permiso == LocationPermission.denied ||
          permiso == LocationPermission.deniedForever) {
        return;
      }
      final p = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
        ),
      );
      if (!mounted) return;
      final punto = LatLng(
        (p.latitude * 200).round() / 200,
        (p.longitude * 200).round() / 200,
      );
      setState(() => _centro = punto);
      _controlador.move(punto, 14);
    } catch (_) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
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
          ],
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
