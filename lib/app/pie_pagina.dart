// Pie de página de la web: va al final del scroll de cada pantalla (no es
// fijo). Marca, enlaces de ChauchaApp, ayuda y legales, y la barra de
// derechos. En la app (Android) no hay pie: "Mi perfil" termina con
// [PieLegalMovil].
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/config/info_app.dart';
import '../core/router/app_routes.dart';
import '../core/theme/tokens.dart';
import '../core/widgets/dialogos_info.dart';
import '../core/widgets/marca.dart';
import '../core/widgets/scroll_pagina.dart';
import '../features/auth/domain/entities/rol.dart';
import '../features/auth/presentation/providers/sesion_provider.dart';

String get _derechos =>
    '© ${DateTime.now().year} ChauchaApp. Todos los derechos reservados.';

class PiePagina extends ConsumerWidget {
  const PiePagina({super.key, this.mostrar = kIsWeb});

  /// Solo en la web; las pruebas lo fuerzan.
  final bool mostrar;

  static const double anchoColumnas = 900;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Dentro de una pestaña con scroll de página, el pie lo pone el shell.
    if (!mostrar || ScrollDePagina.activo(context)) {
      return const SizedBox.shrink();
    }
    final textos = Theme.of(context).textTheme;
    final rol = ref.watch(usuarioActualProvider.select((u) => u?.rol));
    final reclamos = switch (rol) {
      Rol.cliente => AppRoutes.misReclamos(esCliente: true),
      Rol.tecnico => AppRoutes.misReclamos(esCliente: false),
      _ => null,
    };
    void ir(String ruta) => unawaited(context.push(ruta));

    final columnas = [
      _Columna(
        titulo: 'ChauchaApp',
        enlaces: [
          ('Cómo funciona', () => unawaited(mostrarComoFunciona(context))),
          ('Garantía de 30 días', () => unawaited(mostrarGarantia(context))),
          (
            'Únete como técnico',
            () => unawaited(mostrarUneteComoTecnico(context)),
          ),
        ],
      ),
      _Columna(
        titulo: 'Ayuda',
        enlaces: [
          ('Centro de ayuda', () => unawaited(mostrarAyuda(context))),
          (
            'Reportar un problema',
            () => unawaited(
              mostrarReportarProblema(
                context,
                onIrAReclamos: reclamos == null ? null : () => ir(reclamos),
              ),
            ),
          ),
          ('Contacto', () => unawaited(mostrarContacto(context))),
        ],
      ),
      _Columna(
        titulo: 'Legal',
        enlaces: [
          (
            'Términos y condiciones',
            () => unawaited(
              mostrarResumenTerminos(
                context,
                onVerCompleto: () => ir(AppRoutes.terminos),
              ),
            ),
          ),
          (
            'Política de privacidad',
            () => unawaited(
              mostrarResumenPrivacidad(
                context,
                onVerCompleto: () => ir(AppRoutes.privacidad),
              ),
            ),
          ),
          (
            'Uso de datos de verificación',
            () => unawaited(
              mostrarUsoDatosVerificacion(
                context,
                onVerCompleto: () => ir(AppRoutes.privacidadVerificacion),
              ),
            ),
          ),
        ],
      ),
    ];
    Widget marca({required bool centrada}) => Column(
      crossAxisAlignment: centrada
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        const Marca(),
        const SizedBox(height: Espacios.s),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 320),
          child: Text(
            'Técnicos verificados a domicilio en Quito. Garantía de 30 días '
            'en cada servicio.',
            textAlign: centrada ? TextAlign.center : TextAlign.start,
            style: textos.bodySmall?.copyWith(
              fontSize: 13,
              color: Colores.tintaSuave,
            ),
          ),
        ),
      ],
    );
    final pieTexto = textos.bodySmall?.copyWith(
      fontSize: 12,
      color: Colores.tintaSuave,
    );

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colores.tarjeta,
        border: Border(top: BorderSide(color: Colores.linea)),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1480),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(32, 40, 32, 24),
            child: LayoutBuilder(
              builder: (context, r) {
                final ancho = r.maxWidth >= anchoColumnas;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (ancho)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 2, child: marca(centrada: false)),
                          for (final c in columnas) Expanded(child: c),
                        ],
                      )
                    else ...[
                      marca(centrada: true),
                      const SizedBox(height: Espacios.xl),
                      // De 2 a 3 columnas de enlaces por fila.
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: Espacios.xl,
                        runSpacing: Espacios.xl,
                        children: [
                          for (final c in columnas)
                            SizedBox(width: 180, child: c),
                        ],
                      ),
                    ],
                    const SizedBox(height: Espacios.xl),
                    const Divider(height: 1, color: Colores.divisor),
                    const SizedBox(height: 20),
                    if (ancho)
                      Row(
                        children: [
                          Expanded(child: Text(_derechos, style: pieTexto)),
                          const SizedBox(width: Espacios.l),
                          Text(
                            'Hecho en Quito, Ecuador · v${InfoApp.version}',
                            style: pieTexto,
                          ),
                        ],
                      )
                    else ...[
                      Text(
                        _derechos,
                        textAlign: TextAlign.center,
                        style: pieTexto,
                      ),
                      const SizedBox(height: Espacios.xs),
                      Text(
                        'Hecho en Quito, Ecuador · v${InfoApp.version}',
                        textAlign: TextAlign.center,
                        style: pieTexto,
                      ),
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

class _Columna extends StatelessWidget {
  const _Columna({required this.titulo, required this.enlaces});

  final String titulo;
  final List<(String, VoidCallback)> enlaces;

  @override
  Widget build(BuildContext context) {
    final centrado = MediaQuery.sizeOf(context).width < PiePagina.anchoColumnas;
    return Column(
      crossAxisAlignment: centrado
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: Colores.tinta,
          ),
        ),
        const SizedBox(height: Espacios.s),
        for (var i = 0; i < enlaces.length; i++) ...[
          if (i > 0) const SizedBox(height: 6),
          EnlacePie(texto: enlaces[i].$1, onTap: enlaces[i].$2),
        ],
      ],
    );
  }
}

/// Enlace del pie: gris, verde al pasar el mouse, alto mínimo de 32.
class EnlacePie extends StatefulWidget {
  const EnlacePie({
    super.key,
    required this.texto,
    required this.onTap,
    this.tamano = 13,
  });

  final String texto;
  final VoidCallback onTap;
  final double tamano;

  @override
  State<EnlacePie> createState() => _EnlacePieState();
}

class _EnlacePieState extends State<EnlacePie> {
  bool _encima = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      link: true,
      child: InkWell(
        onTap: widget.onTap,
        onHover: (si) => setState(() => _encima = si),
        borderRadius: BorderRadius.circular(Radios.pequeno),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 32),
          child: Align(
            widthFactor: 1,
            child: Text(
              widget.texto,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: widget.tamano,
                color: _encima ? Colores.primario : Colores.tintaSuave,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Final de "Mi perfil" en la app: Términos, Privacidad, Ayuda y los
/// derechos. En la web no se muestra (ahí está [PiePagina]).
class PieLegalMovil extends StatelessWidget {
  const PieLegalMovil({super.key, this.mostrar = !kIsWeb});

  final bool mostrar;

  @override
  Widget build(BuildContext context) {
    if (!mostrar) return const SizedBox.shrink();
    void ir(String ruta) => unawaited(context.push(ruta));
    return Padding(
      padding: const EdgeInsets.only(top: Espacios.xl),
      child: Column(
        children: [
          Wrap(
            alignment: WrapAlignment.center,
            spacing: Espacios.m,
            children: [
              EnlacePie(
                texto: 'Términos',
                onTap: () => unawaited(
                  mostrarResumenTerminos(
                    context,
                    onVerCompleto: () => ir(AppRoutes.terminos),
                  ),
                ),
              ),
              EnlacePie(
                texto: 'Privacidad',
                onTap: () => unawaited(
                  mostrarResumenPrivacidad(
                    context,
                    onVerCompleto: () => ir(AppRoutes.privacidad),
                  ),
                ),
              ),
              EnlacePie(
                texto: 'Ayuda',
                onTap: () => unawaited(mostrarAyuda(context)),
              ),
            ],
          ),
          Text(
            _derechos,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(fontSize: 11, color: Colores.tintaSuave),
          ),
        ],
      ),
    );
  }
}
