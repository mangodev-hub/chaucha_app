import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../core/widgets/espacio_publicitario.dart';


const _azul = Colores.primarioVivo;
const _azulOscuro = Colores.primarioProfundo;
const _hielo = Colores.primarioSuave;
const _fondo = Colores.fondo;
const _texto = Colores.tinta;
const _gris = Colores.tintaSuave;
const _borde = Colores.linea;
const _rojo = Colores.error;
const _estrella = Colores.estrella;
const _blanco = Colores.tarjeta;

class PerfilClienteView extends StatelessWidget {
  const PerfilClienteView({super.key});

  @override
  Widget build(BuildContext context) {
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
                const izquierda = Column(
                  children: [
                    _Historial(),
                    SizedBox(height: 24),
                    _Favoritos(),
                  ],
                );
                const derecha = Column(
                  children: [
                    _Ubicacion(),
                    SizedBox(height: 16),
                    _Nivel(),
                    SizedBox(height: 16),
                    _Privacidad(),
                    SizedBox(height: 16),
                    EspacioPublicitario(),
                  ],
                );
                return Column(
                  children: [
                    const _Cabecera(),
                    const SizedBox(height: 24),
                    const _Estadisticas(),
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
                    else ...const [
                      izquierda,
                      SizedBox(height: 24),
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

class _Estrellas extends StatelessWidget {
  const _Estrellas(this.nota);

  final double nota;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          nota.toStringAsFixed(1).replaceAll('.', ','),
          style: const TextStyle(
            color: _estrella,
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
        const SizedBox(width: 4),
        for (var i = 0; i < 5; i++)
          Icon(
            i < nota.round() ? Icons.star : Icons.star_border,
            size: 14,
            color: _estrella,
          ),
      ],
    );
  }
}

class _Cabecera extends StatelessWidget {
  const _Cabecera();

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
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
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
                      child: const _Avatar('Mateo Vargas', radio: 56),
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
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Mateo Vargas',
                          style: TextStyle(
                            color: _texto,
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: 12),
                        _Etiqueta('Nivel 2 · 340 puntos'),
                      ],
                    ),
                    SizedBox(height: 6),
                    Row(
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
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FilledButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      label: const Text('Editar perfil'),
                      style: FilledButton.styleFrom(
                        backgroundColor: _azul,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () => _mostrarBaja(context),
                      style: TextButton.styleFrom(foregroundColor: _rojo),
                      child: const Text('Darse de baja'),
                    ),
                  ],
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
  const _Estadisticas();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        const a = _Estadistica(
          Icons.check_circle_outline,
          '8',
          'Solicitudes completadas',
        );
        const b = _Estadistica(
          Icons.calendar_month_outlined,
          'Sep 2026',
          'Miembro desde',
        );
        const d = _Estadistica(
          Icons.star,
          '4,9',
          'Calificación promedio de los técnicos',
        );
        if (c.maxWidth >= 900) {
          return const Row(
            children: [
              Expanded(child: a),
              SizedBox(width: 16),
              Expanded(child: b),
              SizedBox(width: 16),
              Expanded(child: d),
            ],
          );
        }
        return const Column(
          children: [a, SizedBox(height: 12), b, SizedBox(height: 12), d],
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

class _Trabajo {
  const _Trabajo(
    this.oficio,
    this.titulo,
    this.fecha,
    this.tecnico,
    this.nota,
    this.resena,
  );

  final String oficio;
  final String titulo;
  final String fecha;
  final String tecnico;
  final double nota;
  final String resena;
}

const _trabajos = [
  _Trabajo(
    'Plomería',
    'Reparación de fuga en fregadero de cocina',
    '14 de octubre, 2026',
    'Carlos M. Enríquez',
    5,
    'Mateo tuvo todo despejado para el trabajo y fue muy atento con las especificaciones. Excelente cliente para coordinar.',
  ),
  _Trabajo(
    'Electricidad',
    'Instalación y revisión de breaker principal',
    '28 de septiembre, 2026',
    'Patricio Guayasamín',
    5,
    'Puntual en recibirme, clara descripción del problema eléctrico previo a mi llegada y trato muy cordial.',
  ),
  _Trabajo(
    'Cerrajería',
    'Cambio de cilindro y ajuste de chapa de seguridad',
    '9 de septiembre, 2026',
    'Roberto Andrango',
    4.8,
    'Facilitó el acceso sin demoras y verificamos el funcionamiento de la llave juntos. Muy recomendado.',
  ),
];

class _Historial extends StatelessWidget {
  const _Historial();

  @override
  Widget build(BuildContext context) {
    return _Tarjeta(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Expanded(
                child: Text(
                  'Historial de servicios',
                  style: TextStyle(
                    color: _texto,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              _Etiqueta('3 servicios'),
            ],
          ),
          const SizedBox(height: 16),
          for (final t in _trabajos) ...[
            _FilaTrabajo(t),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _FilaTrabajo extends StatelessWidget {
  const _FilaTrabajo(this.t);

  final _Trabajo t;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borde),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _Etiqueta(t.oficio),
              Text(
                t.titulo,
                style: const TextStyle(
                  color: _texto,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _Avatar(t.tecnico, radio: 12),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Técnico: ${t.tecnico} · ${t.fecha}',
                  style: const TextStyle(color: _gris, fontSize: 13),
                ),
              ),
              _Estrellas(t.nota),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: _fondo,
              border: Border(left: BorderSide(color: _azul, width: 3)),
            ),
            child: Text(
              '“${t.resena}”\n— Reseña de ${t.tecnico}',
              style: const TextStyle(
                color: _gris,
                fontSize: 13,
                fontStyle: FontStyle.italic,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Favoritos extends StatelessWidget {
  const _Favoritos();

  @override
  Widget build(BuildContext context) {
    return const _Tarjeta(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Mis técnicos favoritos',
                  style: TextStyle(
                    color: _texto,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              _Etiqueta('3 guardados'),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _Favorito('Patricio Guayasamín', 'Electricidad', 5),
              ),
              SizedBox(width: 12),
              Expanded(child: _Favorito('Carlos M. Enríquez', 'Plomería', 4.9)),
              SizedBox(width: 12),
              Expanded(child: _Favorito('Roberto Andrango', 'Cerrajería', 4.8)),
            ],
          ),
        ],
      ),
    );
  }
}

class _Favorito extends StatelessWidget {
  const _Favorito(this.nombre, this.oficio, this.nota);

  final String nombre;
  final String oficio;
  final double nota;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borde),
      ),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.topRight,
            child: Icon(Icons.favorite, color: Color(0xFFE91E63), size: 18),
          ),
          _Avatar(nombre, radio: 28),
          const SizedBox(height: 10),
          Text(
            nombre,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _texto,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          _Etiqueta(oficio),
          const SizedBox(height: 6),
          _Estrellas(nota),
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
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.low),
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

class _Nivel extends StatelessWidget {
  const _Nivel();

  @override
  Widget build(BuildContext context) {
    return const _Tarjeta(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.bolt, color: _estrella, size: 20),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Mi nivel',
                  style: TextStyle(
                    color: _texto,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              _Etiqueta('Nivel 2'),
            ],
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('340 puntos acumulados', style: TextStyle(fontSize: 13)),
              Text(
                'Meta: 500 pts',
                style: TextStyle(color: _gris, fontSize: 13),
              ),
            ],
          ),
          SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            child: LinearProgressIndicator(
              value: 340 / 500,
              minHeight: 8,
              color: _azul,
              backgroundColor: _hielo,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Te faltan 160 puntos para el Nivel 3.',
            style: TextStyle(color: _gris, fontSize: 13),
          ),
        ],
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

