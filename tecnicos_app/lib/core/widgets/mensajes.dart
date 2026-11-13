import 'package:flutter/material.dart';

import '../theme/tokens.dart';

enum TipoMensaje { info, exito, error, eliminado }

OverlayEntry? _avisoActual;

extension Mensajes on BuildContext {
  /// Popup superior derecho (arriba y a lo ancho en móvil) con barra de
  /// progreso. [titulo] e [icono] son opcionales; por defecto salen del tipo.
  void mostrarMensaje(
    String texto, {
    TipoMensaje tipo = TipoMensaje.info,
    String? titulo,
    IconData? icono,
  }) {
    final (color, suave, iconoBase, tituloBase) = switch (tipo) {
      TipoMensaje.info => (
        Colores.primario,
        Colores.primarioSuave,
        Icons.info_outline_rounded,
        'Aviso',
      ),
      TipoMensaje.exito => (
        Colores.acento,
        Colores.acentoSuave,
        Icons.check_rounded,
        'Listo',
      ),
      TipoMensaje.error => (
        Colores.error,
        Colores.errorSuave,
        Icons.error_outline_rounded,
        'Algo salió mal',
      ),
      TipoMensaje.eliminado => (
        Colores.error,
        Colores.errorSuave,
        Icons.delete_outline_rounded,
        'Eliminado',
      ),
    };
    final overlay = Overlay.of(this, rootOverlay: true);
    if (_avisoActual?.mounted ?? false) _avisoActual!.remove();

    late final OverlayEntry entrada;
    void cerrar() {
      if (_avisoActual == entrada) _avisoActual = null;
      if (entrada.mounted) entrada.remove();
    }

    entrada = OverlayEntry(
      builder: (ctx) {
        final ancha = MediaQuery.sizeOf(ctx).width > 600;
        return Positioned(
          top: MediaQuery.paddingOf(ctx).top + Espacios.xl,
          left: ancha ? 0 : Espacios.l,
          right: ancha ? 0 : Espacios.l,
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: _Aviso(
                titulo: titulo ?? tituloBase,
                texto: texto,
                color: color,
                suave: suave,
                icono: icono ?? iconoBase,
                duracion: Duration(
                  milliseconds: tipo == TipoMensaje.error ? 5000 : 3500,
                ),
                onCerrar: cerrar,
              ),
            ),
          ),
        );
      },
    );
    _avisoActual = entrada;
    overlay.insert(entrada);
  }

  Future<bool> confirmar(
    String titulo,
    String mensaje, {
    String textoConfirmar = 'Aceptar',
    String textoCancelar = 'Cancelar',
    bool destructivo = false,
    IconData? icono,
  }) async {
    final respuesta = await showDialog<bool>(
      context: this,
      builder: (context) {
        final colores = Theme.of(context).colorScheme;
        return AlertDialog(
          icon: icono == null
              ? null
              : Icon(icono, color: destructivo ? colores.error : null),
          title: Text(titulo),
          content: Text(mensaje),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(textoCancelar),
            ),
            FilledButton(
              style: destructivo
                  ? FilledButton.styleFrom(
                      backgroundColor: colores.error,
                      foregroundColor: colores.onError,
                      minimumSize: const Size(0, 44),
                    )
                  : FilledButton.styleFrom(minimumSize: const Size(0, 44)),
              onPressed: () => Navigator.pop(context, true),
              child: Text(textoConfirmar),
            ),
          ],
        );
      },
    );
    return respuesta ?? false;
  }
}

class _Aviso extends StatefulWidget {
  const _Aviso({
    required this.titulo,
    required this.texto,
    required this.color,
    required this.suave,
    required this.icono,
    required this.duracion,
    required this.onCerrar,
  });

  final String titulo;
  final String texto;
  final Color color;
  final Color suave;
  final IconData icono;
  final Duration duracion;
  final VoidCallback onCerrar;

  @override
  State<_Aviso> createState() => _AvisoState();
}

class _AvisoState extends State<_Aviso> with SingleTickerProviderStateMixin {
  late final AnimationController _progreso =
      AnimationController(vsync: this, duration: widget.duracion)
        ..addStatusListener((s) {
          if (s == AnimationStatus.completed) widget.onCerrar();
        });

  @override
  void initState() {
    super.initState();
    _progreso.forward();
  }

  @override
  void dispose() {
    _progreso.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Movimiento.de(context, Movimiento.lento),
      curve: Movimiento.rebote,
      builder: (context, t, hijo) => Opacity(
        opacity: t.clamp(0.0, 1.0),
        child: Transform.translate(
          offset: Offset(0, -24 * (1 - t)),
          child: hijo,
        ),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          decoration: BoxDecoration(
            color: Colores.tarjeta,
            borderRadius: BorderRadius.circular(Radios.grande),
            border: Border.all(
              color: widget.color.withValues(alpha: 0.35),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(alpha: 0.22),
                blurRadius: 32,
                offset: const Offset(0, 12),
              ),
              const BoxShadow(
                color: Color(0x290F2A44),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(
            Espacios.l,
            Espacios.l,
            Espacios.s,
            Espacios.l,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: widget.suave,
                      borderRadius: BorderRadius.circular(Radios.medio),
                    ),
                    child: Icon(widget.icono, color: widget.color, size: 26),
                  ),
                  const SizedBox(width: Espacios.l),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.titulo,
                          style: textos.titleMedium?.copyWith(
                            color: Colores.tinta,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.texto,
                          style: textos.bodyMedium?.copyWith(
                            color: Colores.tintaSuave,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: widget.onCerrar,
                    tooltip: 'Cerrar',
                    icon: const Icon(Icons.close_rounded, size: 20),
                    color: Colores.tintaSuave,
                  ),
                ],
              ),
              const SizedBox(height: Espacios.m),
              Padding(
                padding: const EdgeInsets.only(right: Espacios.s),
                child: AnimatedBuilder(
                  animation: _progreso,
                  builder: (context, _) => ClipRRect(
                    borderRadius: BorderRadius.circular(Radios.pildora),
                    child: LinearProgressIndicator(
                      value: _progreso.value,
                      minHeight: 5,
                      color: widget.color,
                      backgroundColor: widget.suave,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
