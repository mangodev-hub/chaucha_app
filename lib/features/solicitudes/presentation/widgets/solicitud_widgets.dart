// Widgets compartidos de solicitudes: chip de estado, tarjeta y galería.
import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../core/utils/formatos.dart';
import '../../../../core/widgets/estado_mensaje.dart';
import '../../../../core/widgets/foto_perfil_caja.dart';
import '../../../../core/widgets/pildora.dart';
import '../../../../core/widgets/tarjeta_app.dart';
import '../../domain/entities/solicitud.dart';

extension EstadoSolicitudVista on EstadoSolicitud {
  String get etiqueta => switch (this) {
    EstadoSolicitud.abierta => 'Abierta',
    EstadoSolicitud.cotizada => 'Con ofertas',
    EstadoSolicitud.aceptada => 'En curso',
    EstadoSolicitud.porConfirmar => 'Por confirmar',
    EstadoSolicitud.completada => 'Completada',
    EstadoSolicitud.cancelada => 'Cancelada',
  };

  /// El acento (verde) queda solo para lo positivo: trabajo completado.
  Color get color => switch (this) {
    EstadoSolicitud.abierta || EstadoSolicitud.cotizada => Colores.info,
    EstadoSolicitud.aceptada => Colores.primario,
    EstadoSolicitud.porConfirmar => Colores.aviso,
    EstadoSolicitud.completada => Colores.acento,
    EstadoSolicitud.cancelada => Colores.tintaSuave,
  };

  /// Para separar las listas en "activas" y "finalizadas".
  bool get activa =>
      this != EstadoSolicitud.completada && this != EstadoSolicitud.cancelada;
}

class EstadoChip extends StatelessWidget {
  const EstadoChip(this.estado, {super.key});

  final EstadoSolicitud estado;

  @override
  Widget build(BuildContext context) =>
      Pildora(texto: estado.etiqueta, color: estado.color);
}

/// Tarjeta de una solicitud en las listas: oficio, estado, fecha,
/// descripción y, en el feed, distancia y si ya se cotizó.
class SolicitudCard extends StatelessWidget {
  const SolicitudCard({
    super.key,
    required this.solicitud,
    required this.onTap,
    this.distancia,
    this.yaCotice = false,
    this.onEditar,
    this.onEliminar,
    this.novedades = 0,
    this.mostrarCliente = false,
  });

  final Solicitud solicitud;
  final VoidCallback onTap;
  final VoidCallback? onEditar;
  final VoidCallback? onEliminar;
  final int novedades;

  /// Distancia ya formateada ("1.2 km"), solo en el feed del técnico.
  final String? distancia;
  final bool yaCotice;

  /// Vista del técnico: foto y nombre del cliente en lugar del ícono.
  final bool mostrarCliente;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final distancia = this.distancia;
    return TarjetaApp(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (mostrarCliente)
                FotoPerfilCaja(
                  tamano: 44,
                  rutaFoto: solicitud.clienteFotoRuta,
                  iniciales: solicitud.clienteIniciales,
                  estiloTexto: textos.titleSmall?.copyWith(
                    color: Colores.primarioOscuro,
                  ),
                )
              else
                const IconoRecuadro(icono: Icons.handyman_outlined),
              const SizedBox(width: Espacios.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      solicitud.oficioNombre,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textos.titleMedium,
                    ),
                    Text(
                      [
                        if (mostrarCliente && solicitud.clienteNombre != null)
                          solicitud.clienteNombre!,
                        Formatos.fecha(solicitud.creadoEn),
                      ].join(' · '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textos.bodySmall?.copyWith(
                        color: Colores.tintaSuave,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: Espacios.s),
              Flexible(child: EstadoChip(solicitud.estado)),
              if (onEditar != null || onEliminar != null)
                PopupMenuButton<String>(
                  tooltip: 'Opciones',
                  onSelected: (v) =>
                      v == 'editar' ? onEditar?.call() : onEliminar?.call(),
                  itemBuilder: (_) => [
                    if (onEditar != null)
                      const PopupMenuItem(
                        value: 'editar',
                        child: ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(Icons.edit_outlined),
                          title: Text('Editar'),
                        ),
                      ),
                    if (onEliminar != null)
                      const PopupMenuItem(
                        value: 'eliminar',
                        child: ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(
                            Icons.delete_outline,
                            color: Colores.error,
                          ),
                          title: Text(
                            'Eliminar',
                            style: TextStyle(color: Colores.error),
                          ),
                        ),
                      ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: Espacios.m),
          Text(
            solicitud.descripcion,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: textos.bodyMedium,
          ),
          if (distancia != null || yaCotice || novedades > 0) ...[
            const SizedBox(height: Espacios.m),
            Wrap(
              spacing: Espacios.s,
              runSpacing: Espacios.xs,
              children: [
                if (novedades > 0)
                  Pildora(
                    texto: novedades == 1
                        ? '1 novedad'
                        : '$novedades novedades',
                    icono: Icons.notifications_active_outlined,
                    color: Colores.aviso,
                  ),
                if (distancia != null)
                  Pildora(
                    texto: 'a $distancia',
                    icono: Icons.place_outlined,
                    color: Colores.info,
                  ),
                if (yaCotice)
                  const Pildora(
                    texto: 'Ya ofertaste',
                    icono: Icons.check,
                    color: Colores.acento,
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Fila de miniaturas. Al tocar una se abre el visor a pantalla completa.
class GaleriaFotos extends StatelessWidget {
  const GaleriaFotos({
    super.key,
    required this.urls,
    this.mensajeVacio = 'Sin fotos.',
  });

  static const double _lado = 110;

  final List<String> urls;
  final String mensajeVacio;

  @override
  Widget build(BuildContext context) {
    if (urls.isEmpty) {
      return EstadoMensaje(
        icono: Icons.image_not_supported_outlined,
        mensaje: mensajeVacio,
        compacto: true,
      );
    }
    return SizedBox(
      height: _lado,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: urls.length,
        separatorBuilder: (context, indice) =>
            const SizedBox(width: Espacios.s),
        itemBuilder: (context, i) => MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => mostrarVisorFotos(context, urls: urls, inicial: i),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Radios.medio),
              child: Image.network(
                urls[i],
                width: _lado,
                height: _lado,
                fit: BoxFit.cover,
                // Las URLs firmadas tardan un poco: se muestra un hueco gris.
                loadingBuilder: (context, imagen, progreso) =>
                    progreso == null ? imagen : const _HuecoFoto(),
                errorBuilder: (context, error, pila) =>
                    const _HuecoFoto(icono: Icons.broken_image_outlined),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HuecoFoto extends StatelessWidget {
  const _HuecoFoto({this.icono});

  final IconData? icono;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: GaleriaFotos._lado,
      height: GaleriaFotos._lado,
      color: Colores.superficieFuerte,
      child: icono == null ? null : Icon(icono, color: Colores.tintaSuave),
    );
  }
}

/// Visor a pantalla completa: zoom con los dedos o la rueda, deslizar o
/// flechas para cambiar de foto, y botón de cerrar.
Future<void> mostrarVisorFotos(
  BuildContext context, {
  required List<String> urls,
  int inicial = 0,
}) {
  return showDialog<void>(
    context: context,
    useSafeArea: false,
    builder: (context) => _VisorFotos(urls: urls, inicial: inicial),
  );
}

class _VisorFotos extends StatefulWidget {
  const _VisorFotos({required this.urls, required this.inicial});

  final List<String> urls;
  final int inicial;

  @override
  State<_VisorFotos> createState() => _VisorFotosState();
}

class _VisorFotosState extends State<_VisorFotos> {
  late final PageController _paginas = PageController(
    initialPage: widget.inicial,
  );
  late int _actual = widget.inicial;

  @override
  void dispose() {
    _paginas.dispose();
    super.dispose();
  }

  void _ir(int indice) {
    unawaited(
      _paginas.animateToPage(
        indice,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sobreOscuro = Theme.of(context).colorScheme.onPrimary;
    final total = widget.urls.length;
    return Dialog.fullscreen(
      backgroundColor: Colores.tinta,
      child: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: _paginas,
              itemCount: total,
              onPageChanged: (i) => setState(() => _actual = i),
              itemBuilder: (context, i) => InteractiveViewer(
                maxScale: 4,
                child: Center(
                  child: Image.network(
                    widget.urls[i],
                    fit: BoxFit.contain,
                    loadingBuilder: (context, imagen, progreso) =>
                        progreso == null
                        ? imagen
                        : CircularProgressIndicator(color: sobreOscuro),
                    errorBuilder: (context, error, pila) => Icon(
                      Icons.broken_image_outlined,
                      color: sobreOscuro,
                      size: 48,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: Espacios.s,
              left: Espacios.l,
              right: Espacios.s,
              child: Row(
                children: [
                  if (total > 1)
                    Text(
                      '${_actual + 1} / $total',
                      style: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(color: sobreOscuro),
                    ),
                  const Spacer(),
                  IconButton(
                    tooltip: 'Cerrar',
                    color: sobreOscuro,
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            if (_actual > 0)
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  tooltip: 'Anterior',
                  color: sobreOscuro,
                  icon: const Icon(Icons.chevron_left, size: 36),
                  onPressed: () => _ir(_actual - 1),
                ),
              ),
            if (_actual < total - 1)
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  tooltip: 'Siguiente',
                  color: sobreOscuro,
                  icon: const Icon(Icons.chevron_right, size: 36),
                  onPressed: () => _ir(_actual + 1),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
