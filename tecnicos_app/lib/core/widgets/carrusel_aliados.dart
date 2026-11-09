import 'dart:async';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../aliados/oferta_aliado.dart';
import '../theme/tokens.dart';
import 'tarjeta_app.dart';

/// Carrusel de ofertas de aliados (publicidad externa): cambia solo cada 7 s y abre el enlace.
class CarruselAliados extends StatefulWidget {
  const CarruselAliados({
    super.key,
    this.ofertas = ofertasAliadosDemo,
    this.alto = 240,
  });

  final List<OfertaAliado> ofertas;
  final double alto;

  @override
  State<CarruselAliados> createState() => _CarruselAliadosState();
}

class _CarruselAliadosState extends State<CarruselAliados> {
  final _pagina = PageController();
  Timer? _reloj;
  int _actual = 0;

  @override
  void initState() {
    super.initState();
    if (widget.ofertas.length > 1) {
      _reloj = Timer.periodic(const Duration(seconds: 7), (_) {
        if (!_pagina.hasClients) return;
        _pagina.animateToPage(
          (_actual + 1) % widget.ofertas.length,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  @override
  void dispose() {
    _reloj?.cancel();
    _pagina.dispose();
    super.dispose();
  }

  Future<void> _abrir(OfertaAliado oferta) async {
    var abierto = false;
    try {
      abierto = await launchUrl(
        Uri.parse(oferta.url),
        mode: LaunchMode.externalApplication,
      );
    } catch (_) {
      abierto = false;
    }
    if (abierto || !mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No se pudo abrir el enlace.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ofertas = widget.ofertas;
    if (ofertas.isEmpty) return const SizedBox.shrink();
    final textos = Theme.of(context).textTheme;
    return TarjetaApp(
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
            height: widget.alto,
            child: PageView.builder(
              controller: _pagina,
              itemCount: ofertas.length,
              onPageChanged: (i) => setState(() => _actual = i),
              itemBuilder: (context, i) => _Slide(
                oferta: ofertas[i],
                onTap: () => _abrir(ofertas[i]),
              ),
            ),
          ),
          if (ofertas.length > 1) ...[
            const SizedBox(height: Espacios.m),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < ofertas.length; i++)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: i == _actual ? 18 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: i == _actual
                          ? Colores.primario
                          : Colores.superficieFuerte,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  const _Slide({required this.oferta, required this.onTap});

  final OfertaAliado oferta;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(Espacios.xl - 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Radios.grande),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            oferta.color,
            Color.lerp(oferta.color, Colors.black, 0.3)!,
          ],
        ),
      ),
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
                child: Icon(oferta.icono, color: Colors.white, size: 20),
              ),
              const SizedBox(width: Espacios.m),
              Expanded(
                child: Text(
                  oferta.patrocinador,
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
            oferta.titulo,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: textos.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: Espacios.xs),
          Text(
            oferta.descripcion,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: textos.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          const Spacer(),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: oferta.color,
              minimumSize: const Size(0, 40),
            ),
            onPressed: onTap,
            child: Text(oferta.accion),
          ),
        ],
      ),
    );
  }
}