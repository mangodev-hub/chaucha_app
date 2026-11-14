import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/pie_pagina.dart';
import '../../../../core/config/info_app.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/tokens.dart';

const String _borrador = '[BORRADOR – pendiente de revisión]';

/// (id del ancla, título)
typedef SeccionLegal = (String, String);

class TerminosView extends StatelessWidget {
  const TerminosView({super.key});

  static const secciones = <SeccionLegal>[
    ('que-es', 'Qué es ChauchaApp'),
    ('registro', 'Registro y verificación'),
    ('solicitudes', 'Publicación de solicitudes'),
    ('visita', 'La visita y el trato directo con el técnico'),
    ('garantia', 'Garantía de 30 días y reclamos'),
    ('calificaciones', 'Calificaciones y sanciones'),
    ('publicidad', 'Publicidad'),
    ('responsabilidad', 'Limitación de responsabilidad'),
    ('contacto', 'Contacto'),
  ];

  @override
  Widget build(BuildContext context) =>
      const PaginaLegal(titulo: 'Términos y condiciones', secciones: secciones);
}

class PrivacidadView extends StatelessWidget {
  const PrivacidadView({super.key, this.seccion});

  /// Ancla a la que bajar al abrir (por ejemplo, `verificacion`).
  final String? seccion;

  static const secciones = <SeccionLegal>[
    ('datos', 'Datos que recogemos'),
    ('verificacion', 'Uso de datos de verificación (cédula y selfie)'),
    ('ubicacion', 'Ubicación y chats'),
    ('uso', 'Para qué los usamos'),
    ('acceso', 'Quién los ve'),
    ('conservacion', 'Cuánto tiempo se guardan'),
    ('derechos', 'Tus derechos'),
    ('contacto', 'Contacto'),
  ];

  @override
  Widget build(BuildContext context) => PaginaLegal(
    titulo: 'Política de privacidad',
    secciones: secciones,
    seccionInicial: seccion,
  );
}

class PaginaLegal extends StatefulWidget {
  const PaginaLegal({
    super.key,
    required this.titulo,
    required this.secciones,
    this.seccionInicial,
  });

  final String titulo;
  final List<SeccionLegal> secciones;
  final String? seccionInicial;

  @override
  State<PaginaLegal> createState() => _PaginaLegalState();
}

class _PaginaLegalState extends State<PaginaLegal> {
  late final Map<String, GlobalKey> _anclas = {
    for (final (id, _) in widget.secciones) id: GlobalKey(),
  };

  @override
  void initState() {
    super.initState();
    final ancla = _anclas[widget.seccionInicial];
    if (ancla != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final destino = ancla.currentContext;
        if (destino == null || !destino.mounted) return;
        Scrollable.ensureVisible(
          destino,
          duration: Movimiento.de(context, Movimiento.lento),
        );
      });
    }
  }

  void _volver() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.splash);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Colores.fondoClaro,
      appBar: AppBar(
        backgroundColor: Colores.tarjeta,
        foregroundColor: Colores.tinta,
        iconTheme: const IconThemeData(color: Colores.tinta),
        titleTextStyle: textos.titleMedium,
        leading: IconButton(
          tooltip: 'Volver',
          onPressed: _volver,
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: Text(widget.titulo),
        shape: const Border(bottom: BorderSide(color: Colores.bordeBarra)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    Espacios.xl,
                    Espacios.xxl,
                    Espacios.xl,
                    Espacios.xxl,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.titulo,
                        style: textos.headlineMedium?.copyWith(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: Espacios.xs),
                      Text(
                        'Última actualización: ${InfoApp.actualizacionLegal}',
                        style: textos.bodySmall?.copyWith(
                          color: Colores.tintaSuave,
                        ),
                      ),
                      for (var i = 0; i < widget.secciones.length; i++)
                        Padding(
                          key: _anclas[widget.secciones[i].$1],
                          padding: const EdgeInsets.only(top: Espacios.xl),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${i + 1}. ${widget.secciones[i].$2}',
                                style: textos.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: Espacios.s),
                              Text(
                                _borrador,
                                style: textos.bodyMedium?.copyWith(
                                  color: Colores.tintaSuave,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const PiePagina(),
          ],
        ),
      ),
    );
  }
}
