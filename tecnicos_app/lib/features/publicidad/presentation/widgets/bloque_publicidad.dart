// Bloque de publicidad (inicio del cliente y del técnico, y perfil): la
// fuente de ingresos de la app. Mantiene el diseño del bloque del perfil
// (etiqueta "PUBLICIDAD", piezas de color con ícono, anunciante, título,
// descripción y botón blanco) y se comporta como un carrusel no invasivo:
// - alto fijo, para que el layout no salte entre anuncios ni al cargar;
// - avanza cada 7 s con un deslizamiento de 400 ms, y se pausa con el mouse
//   encima, con el foco dentro o con la pestaña oculta;
// - si el sistema pide reducir animaciones, no avanza solo;
// - se desliza con el dedo y los puntos se pueden tocar;
// - siempre dice "PUBLICIDAD" y no se puede cerrar;
// - solo negocios externos: la app no se anuncia a sí misma.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../core/widgets/esqueleto_carga.dart';
import '../../../../core/widgets/mensajes.dart';
import '../../../../core/widgets/tarjeta_app.dart';
import '../../domain/entities/anuncio.dart';
import '../providers/anuncios_provider.dart';

/// Pieza neutra cuando no hay anuncios activos: el espacio nunca queda
/// vacío, y nunca se usa para anunciar la propia app.
const piezaNeutra = Anuncio(
  id: 'espacio-publicitario',
  anunciante: 'Espacio publicitario',
  titulo: 'Anuncia tu negocio aquí',
  descripcion: 'Llega a vecinos de Quito que buscan servicios para su hogar.',
);

class BloquePublicidad extends ConsumerStatefulWidget {
  const BloquePublicidad({super.key, required this.ubicacion});

  final UbicacionAnuncio ubicacion;

  static const int maximo = 5;

  /// Alto fijo de la pieza: termina unos 20 px después de la descripción.
  /// Si algún anuncio del carrusel tiene "Ver más", todas usan
  /// [altoConBoton] (el alto no cambia entre anuncios).
  static const double altoPieza = 190;
  static const double altoConBoton = 240;
  static const Duration intervalo = Duration(seconds: 7);
  static const Duration deslizamiento = Duration(milliseconds: 400);

  @override
  ConsumerState<BloquePublicidad> createState() => _BloquePublicidadState();
}

class _BloquePublicidadState extends ConsumerState<BloquePublicidad>
    with WidgetsBindingObserver {
  /// Colores de las piezas, en orden (como el bloque original del perfil).
  static const _colores = [
    Colores.fondo,
    Colores.acentoOscuro,
    Colores.avisoOscuro,
  ];

  final _paginas = PageController();
  Timer? _reloj;
  int _actual = 0;
  int _total = 0;
  bool _mouse = false;
  bool _foco = false;
  bool _visible = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _reloj?.cancel();
    _paginas.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState estado) {
    _visible = estado == AppLifecycleState.resumed;
    _programar();
  }

  bool get _pausado =>
      _mouse ||
      _foco ||
      !_visible ||
      (MediaQuery.maybeDisableAnimationsOf(context) ?? false);

  void _programar() {
    _reloj?.cancel();
    _reloj = null;
    if (!mounted || _total < 2 || _pausado) return;
    _reloj = Timer.periodic(BloquePublicidad.intervalo, (_) {
      if (!mounted || !_paginas.hasClients) return;
      unawaited(
        _paginas.animateToPage(
          (_actual + 1) % _total,
          duration: BloquePublicidad.deslizamiento,
          curve: Curves.easeInOut,
        ),
      );
    });
  }

  void _ir(int pagina) {
    if (!_paginas.hasClients) return;
    unawaited(
      _paginas.animateToPage(
        pagina,
        duration: Movimiento.de(context, BloquePublicidad.deslizamiento),
        curve: Curves.easeInOut,
      ),
    );
    _programar();
  }

  Future<void> _abrir(String url) async {
    var abierto = false;
    try {
      abierto = await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
        webOnlyWindowName: '_blank',
      );
    } catch (_) {
      abierto = false;
    }
    if (abierto || !mounted) return;
    context.mostrarMensaje(
      'No se pudo abrir el enlace.',
      tipo: TipoMensaje.error,
    );
  }

  @override
  Widget build(BuildContext context) {
    final estado = ref.watch(anunciosProvider(widget.ubicacion));
    final cargando = estado.isLoading && !estado.hasValue;
    final lista = estado.value ?? const <Anuncio>[];
    final anuncios = lista.isEmpty
        ? const [piezaNeutra]
        : lista.take(BloquePublicidad.maximo).toList();
    if (!cargando && anuncios.length != _total) {
      _total = anuncios.length;
      if (_actual >= _total) _actual = 0;
      WidgetsBinding.instance.addPostFrameCallback((_) => _programar());
    }
    final textos = Theme.of(context).textTheme;
    final alto = anuncios.any((a) => a.urlDestino != null)
        ? BloquePublicidad.altoConBoton
        : BloquePublicidad.altoPieza;

    return MouseRegion(
      onEnter: (_) {
        _mouse = true;
        _programar();
      },
      onExit: (_) {
        _mouse = false;
        _programar();
      },
      child: Focus(
        canRequestFocus: false,
        skipTraversal: true,
        onFocusChange: (dentro) {
          _foco = dentro;
          _programar();
        },
        child: TarjetaApp(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'PUBLICIDAD',
                style: textos.labelSmall?.copyWith(
                  color: Colores.tintaSuave,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: Espacios.m),
              SizedBox(
                height: alto,
                child: cargando
                    ? EsqueletoCarga(
                        etiqueta: 'Cargando publicidad',
                        child: BloqueEsqueleto(
                          alto: alto,
                          radio: Radios.grande,
                        ),
                      )
                    : PageView.builder(
                        controller: _paginas,
                        itemCount: anuncios.length,
                        onPageChanged: (i) => setState(() => _actual = i),
                        itemBuilder: (context, i) {
                          final url = anuncios[i].urlDestino;
                          return _Pieza(
                            anuncio: anuncios[i],
                            color: _colores[i % _colores.length],
                            onVerMas: url == null ? null : () => _abrir(url),
                          );
                        },
                      ),
              ),
              const SizedBox(height: Espacios.m),
              // Siempre ocupa su lugar: el alto no cambia con 1 o 5 anuncios.
              SizedBox(
                height: 14,
                child: !cargando && anuncios.length > 1
                    ? _Puntos(
                        total: anuncios.length,
                        actual: _actual,
                        onTap: _ir,
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Pieza extends StatelessWidget {
  const _Pieza({
    required this.anuncio,
    required this.color,
    required this.onVerMas,
  });

  final Anuncio anuncio;
  final Color color;
  final VoidCallback? onVerMas;

  static IconData icono(CategoriaAnuncio categoria) => switch (categoria) {
    CategoriaAnuncio.ferreteria => Icons.hardware_outlined,
    CategoriaAnuncio.restaurante => Icons.restaurant_outlined,
    CategoriaAnuncio.cafeteria => Icons.local_cafe_outlined,
    CategoriaAnuncio.pinturas => Icons.format_paint_outlined,
    CategoriaAnuncio.lavanderia => Icons.checkroom_outlined,
    CategoriaAnuncio.materiales => Icons.foundation_outlined,
    CategoriaAnuncio.otro => Icons.storefront_outlined,
  };

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final imagen = anuncio.imagenUrl;
    final anunciante = anuncio.anunciante;
    final fondo = BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [color, Color.lerp(color, Colors.black, 0.3)!],
      ),
    );

    return Semantics(
      container: true,
      label: 'Publicidad: ${anuncio.titulo}',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Radios.grande),
        child: Stack(
          fit: StackFit.expand,
          children: [
            DecoratedBox(decoration: fondo),
            // Con imagen, va de fondo con un velo oscuro del 55 % para que
            // el texto se lea.
            if (imagen != null) ...[
              Image.network(
                imagen,
                fit: BoxFit.cover,
                semanticLabel: anuncio.titulo,
                errorBuilder: (_, _, _) => const SizedBox.shrink(),
              ),
              ColoredBox(color: Colors.black.withValues(alpha: 0.55)),
            ],
            Padding(
              padding: const EdgeInsets.all(Espacios.xl - 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          icono(anuncio.categoria),
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: Espacios.m),
                      Expanded(
                        child: Text(
                          anunciante == null || anunciante.isEmpty
                              ? 'Anunciante'
                              : anunciante,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textos.labelLarge?.copyWith(
                            color: Colors.white70,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Espacios.m),
                  Text(
                    anuncio.titulo,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textos.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: Espacios.xs),
                  Text(
                    anuncio.descripcion,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textos.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  const Spacer(),
                  if (onVerMas != null)
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: color,
                        minimumSize: const Size(0, 40),
                      ),
                      onPressed: onVerMas,
                      child: const Text('Ver más'),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Puntos extends StatelessWidget {
  const _Puntos({
    required this.total,
    required this.actual,
    required this.onTap,
  });

  final int total;
  final int actual;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < total; i++)
          Semantics(
            button: true,
            selected: i == actual,
            label: 'Anuncio ${i + 1} de $total',
            child: GestureDetector(
              onTap: () => onTap(i),
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 4),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: i == actual ? 18 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: i == actual
                        ? Colores.primario
                        : Colores.superficieFuerte,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
