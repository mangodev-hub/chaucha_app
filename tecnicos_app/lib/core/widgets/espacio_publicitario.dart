import 'dart:async';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../publicidad/anuncio.dart';
import '../theme/tokens.dart';
import 'tarjeta_app.dart';

/// Carrusel de publicidad externa: cambia solo cada 7 s y abre el enlace.
class EspacioPublicitario extends StatefulWidget {
  const EspacioPublicitario({
    super.key,
    this.anuncios = anunciosDemo,
    this.alto = 240,
  });

  final List<Anuncio> anuncios;
  final double alto;

  @override
  State<EspacioPublicitario> createState() => _EspacioPublicitarioState();
}

class _EspacioPublicitarioState extends State<EspacioPublicitario> {
  final _pagina = PageController();
  Timer? _reloj;
  int _actual = 0;

  @override
  void initState() {
    super.initState();
    if (widget.anuncios.length > 1) {
      _reloj = Timer.periodic(const Duration(seconds: 7), (_) {
        if (!_pagina.hasClients) return;
        _pagina.animateToPage(
          (_actual + 1) % widget.anuncios.length,
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

  Future<void> _abrir(Anuncio anuncio) async {
    var abierto = false;
    try {
      abierto = await launchUrl(
        Uri.parse(anuncio.url),
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
    final anuncios = widget.anuncios;
    if (anuncios.isEmpty) return const SizedBox.shrink();
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
              itemCount: anuncios.length,
              onPageChanged: (i) => setState(() => _actual = i),
              itemBuilder: (context, i) => _Slide(
                anuncio: anuncios[i],
                onTap: () => _abrir(anuncios[i]),
              ),
            ),
          ),
          if (anuncios.length > 1) ...[
            const SizedBox(height: Espacios.m),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < anuncios.length; i++)
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
  const _Slide({required this.anuncio, required this.onTap});

  final Anuncio anuncio;
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
            anuncio.color,
            Color.lerp(anuncio.color, Colors.black, 0.3)!,
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
                child: Icon(anuncio.icono, color: Colors.white, size: 20),
              ),
              const SizedBox(width: Espacios.m),
              Expanded(
                child: Text(
                  anuncio.patrocinador,
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
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: anuncio.color,
              minimumSize: const Size(0, 40),
            ),
            onPressed: onTap,
            child: Text(anuncio.accion),
          ),
        ],
      ),
    );
  }
}