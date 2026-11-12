import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../core/utils/formatos.dart';
import '../../../../core/widgets/etiqueta_sector.dart';
import '../../domain/entities/tecnico_cercano.dart';

class MapaTecnicos extends StatefulWidget {
  const MapaTecnicos({
    super.key,
    required this.punto,
    required this.radioM,
    required this.tecnicos,
    this.onContactar,
    this.onVerPerfil,
    this.onCambiarRadio,
    this.alto = 460,
  });

  final double alto;
  final LatLng punto;
  final int radioM;
  final List<TecnicoCercano> tecnicos;
  final ValueChanged<TecnicoCercano>? onContactar;
  final ValueChanged<TecnicoCercano>? onVerPerfil;
  final ValueChanged<int>? onCambiarRadio;

  @override
  State<MapaTecnicos> createState() => _MapaTecnicosState();
}

class _MapaTecnicosState extends State<MapaTecnicos> {
  static const double _zoomInicial = 12.5;
  final MapController _controller = MapController();
  late double _radioKm = widget.radioM / 1000;

  @override
  void didUpdateWidget(MapaTecnicos anterior) {
    super.didUpdateWidget(anterior);
    if (anterior.radioM != widget.radioM) _radioKm = widget.radioM / 1000;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _zoom(double delta) {
    final camara = _controller.camera;
    _controller.move(camara.center, (camara.zoom + delta).clamp(3, 18));
  }

  @override
  Widget build(BuildContext context) {
    final cercano = widget.tecnicos.isEmpty
        ? null
        : widget.tecnicos.reduce((a, b) => a.metros <= b.metros ? a : b);

    return Container(
      height: widget.alto,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colores.superficie,
        borderRadius: BorderRadius.circular(Radios.muyGrande),
        boxShadow: Sombras.suave,
      ),
      child: Stack(
        children: [
          FlutterMap(
            mapController: _controller,
            options: MapOptions(
              initialCenter: widget.punto,
              initialZoom: _zoomInicial,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.eagledev.tecnicos_app',
              ),
              CircleLayer(
                circles: [
                  CircleMarker(
                    point: widget.punto,
                    radius: _radioKm * 1000,
                    useRadiusInMeter: true,
                    color: Colores.primario.withValues(alpha: 0.08),
                    borderColor: Colores.primario,
                    borderStrokeWidth: 1.5,
                  ),
                ],
              ),
              MarkerLayer(
                markers: [
                  for (final t in widget.tecnicos)
                    Marker(
                      point: t.ubicacion,
                      width: 150,
                      height: 92,
                      alignment: Alignment.topCenter,
                      child: _Pin(tecnico: t),
                    ),
                  Marker(
                    point: widget.punto,
                    width: 24,
                    height: 24,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colores.primario,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colores.tarjeta, width: 3),
                        boxShadow: Sombras.suave,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            top: Espacios.l,
            left: Espacios.l,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ControlRadio(
              km: _radioKm,
              onCambio: (v) => setState(() => _radioKm = v),
              onFin: widget.onCambiarRadio == null
                  ? null
                  : (v) => widget.onCambiarRadio!((v * 1000).round()),
            ),
                const SizedBox(height: Espacios.s),
                EtiquetaSector(punto: widget.punto),
              ],
            ),
          ),
          Positioned(
            top: Espacios.l,
            right: Espacios.l,
            child: ControlesMapa(
              onMas: () => _zoom(1),
              onMenos: () => _zoom(-1),
              onCentrar: () => _controller.move(widget.punto, _zoomInicial),
            ),
          ),
          if (cercano != null)
            Positioned(
              left: Espacios.l,
              right: Espacios.l,
              bottom: Espacios.l,
              child: _TarjetaCercano(
                tecnico: cercano,
                onContactar: widget.onContactar == null
                    ? null
                    : () => widget.onContactar!(cercano),
                onVerPerfil: widget.onVerPerfil == null
                    ? null
                    : () => widget.onVerPerfil!(cercano),
              ),
            ),
        ],
      ),
    );
  }
}

class _Pin extends StatelessWidget {
  const _Pin({required this.tecnico});

  final TecnicoCercano tecnico;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final calificacion = tecnico.totalResenas == 0
        ? ''
        : ' ${tecnico.calificacion.toStringAsFixed(1)} ★';
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colores.tarjeta,
            borderRadius: BorderRadius.circular(Radios.pildora),
            boxShadow: Sombras.suave,
          ),
          child: Text.rich(
            TextSpan(
              text: tecnico.primerNombre,
              children: [
                TextSpan(
                  text: calificacion,
                  style: const TextStyle(color: Colores.info),
                ),
              ],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textos.labelSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 38,
          height: 38,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colores.primarioSuave,
            shape: BoxShape.circle,
            border: Border.all(color: Colores.primario, width: 2),
            boxShadow: Sombras.suave,
          ),
          child: Text(
            tecnico.iniciales,
            style: textos.labelSmall?.copyWith(
              color: Colores.primarioOscuro,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Transform.translate(
          offset: const Offset(0, -7),
          child: const Icon(
            Icons.arrow_drop_down,
            size: 22,
            color: Colores.primario,
          ),
        ),
      ],
    );
  }
}

class ControlesMapa extends StatelessWidget {
  const ControlesMapa({super.key, 
    required this.onMas,
    required this.onMenos,
    required this.onCentrar,
  });

  final VoidCallback onMas;
  final VoidCallback onMenos;
  final VoidCallback onCentrar;

  Widget _caja(List<Widget> hijos) => Container(
    decoration: BoxDecoration(
      color: Colores.tarjeta,
      borderRadius: BorderRadius.circular(Radios.medio),
      boxShadow: Sombras.suave,
    ),
    child: Column(mainAxisSize: MainAxisSize.min, children: hijos),
  );

  Widget _boton(
    IconData icono,
    String ayuda,
    VoidCallback onTap, {
    Color color = Colores.tinta,
  }) => IconButton(
    tooltip: ayuda,
    constraints: const BoxConstraints.tightFor(width: 40, height: 40),
    padding: EdgeInsets.zero,
    icon: Icon(icono, size: 20, color: color),
    onPressed: onTap,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _caja([
          _boton(Icons.add, 'Acercar mapa', onMas),
          _boton(Icons.remove, 'Alejar mapa', onMenos),
        ]),
        const SizedBox(height: Espacios.s),
        _caja([
          _boton(
            Icons.my_location,
            'Mi ubicación',
            onCentrar,
            color: Colores.primario,
          ),
        ]),
      ],
    );
  }
}

class ControlRadio extends StatelessWidget {
  const ControlRadio({super.key, required this.km, required this.onCambio, this.onFin});

  final double km;
  final ValueChanged<double> onCambio;
  final ValueChanged<double>? onFin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: const EdgeInsets.fromLTRB(Espacios.m, 6, Espacios.m, 0),
      decoration: BoxDecoration(
        color: Colores.tarjeta,
        borderRadius: BorderRadius.circular(Radios.medio),
        boxShadow: Sombras.suave,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Radio: ${km.round()} km',
            style: Theme.of(context).textTheme.labelSmall
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
          Slider(
            value: km,
            min: 1,
            max: 20,
            divisions: 19,
            label: '${km.round()} km',
            onChanged: onCambio,
            onChangeEnd: onFin,
          ),
        ],
      ),
    );
  }
}

class _TarjetaCercano extends StatelessWidget {
  const _TarjetaCercano({
    required this.tecnico,
    this.onContactar,
    this.onVerPerfil,
  });

  final TecnicoCercano tecnico;
  final VoidCallback? onContactar;
  final VoidCallback? onVerPerfil;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final minutos = math.max(1, (tecnico.metros / 400).ceil());
    final precio = tecnico.tarifaBase.toStringAsFixed(
      tecnico.tarifaBase % 1 == 0 ? 0 : 2,
    );
    final detalle = [
      tecnico.oficios.join(' · '),
      if (tecnico.totalResenas > 0)
        '${tecnico.calificacion.toStringAsFixed(1)} ★',
      '\$$precio / visita',
    ].join(' • ');

    return Container(
      padding: const EdgeInsets.all(Espacios.m + 2),
      decoration: BoxDecoration(
        color: Colores.tarjeta.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(Radios.grande),
        boxShadow: Sombras.suave,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(Icons.circle, size: 8, color: Colores.primario),
              const SizedBox(width: Espacios.xs + 2),
              Text(
                'Técnico más próximo',
                style: textos.labelSmall?.copyWith(
                  color: Colores.info,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colores.superficie,
                  borderRadius: BorderRadius.circular(Radios.pildora),
                ),
                child: Text(
                  'a $minutos min • ${Formatos.distancia(tecnico.metros.toDouble())}',
                  style: textos.labelSmall?.copyWith(
                    color: Colores.tintaSuave,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Espacios.m),
          InkWell(
            borderRadius: BorderRadius.circular(Radios.medio),
            onTap: onVerPerfil,
            child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colores.primarioSuave,
                  borderRadius: BorderRadius.circular(Radios.medio),
                ),
                child: Text(
                  tecnico.iniciales,
                  style: textos.titleSmall?.copyWith(
                    color: Colores.primarioOscuro,
                  ),
                ),
              ),
              const SizedBox(width: Espacios.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${tecnico.nombres} ${tecnico.apellidos}'.trim(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textos.titleSmall,
                    ),
                    Text(
                      detalle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textos.bodySmall?.copyWith(
                        color: Colores.tintaSuave,
                      ),
                    ),
                  ],
                ),
              ),
              if (onContactar != null) ...[
                const SizedBox(width: Espacios.m),
                FilledButton.icon(
                  style: FilledButton.styleFrom(minimumSize: const Size(0, 44)),
                  onPressed: onContactar,
                  icon: const Icon(Icons.bolt, size: 18),
                  label: const Text('Contactar'),
                ),
              ],
            ],
          ),
          ),
        ],
      ),
    );
  }
}