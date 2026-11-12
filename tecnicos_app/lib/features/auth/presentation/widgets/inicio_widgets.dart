import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../core/utils/formatos.dart';
import '../../../../core/widgets/marca.dart';
import '../../../../core/widgets/pildora.dart';
import '../../../../core/widgets/seccion.dart';
import '../../../../core/widgets/tarjeta_app.dart';
import '../../../../core/widgets/tarjeta_onda.dart';
import '../../../../core/widgets/tarjeta_opcion.dart';
import '../../../catalogo/domain/entities/oficio.dart';
import '../../domain/entities/tecnico_cercano.dart';

class HeroBusqueda extends StatefulWidget {
  const HeroBusqueda({super.key, required this.onNueva});

  final ValueChanged<String?> onNueva;

  @override
  State<HeroBusqueda> createState() => _HeroBusquedaState();
}

class _HeroBusquedaState extends State<HeroBusqueda> {
  static const _frecuentes = [
    (
      Icons.water_damage_outlined,
      'Fuga de agua',
      'Fuga de agua en baño o cocina',
    ),
    (
      Icons.lock_outline,
      'Cambio de cerradura',
      'Cambio de cerradura de seguridad',
    ),
    (Icons.bolt, 'Cortocircuito', 'Cortocircuito o breaker caído'),
    (
      Icons.format_paint_outlined,
      'Pintura interior',
      'Pintura interior para departamento',
    ),
    (
      Icons.local_fire_department_outlined,
      'Calefón',
      'Mantenimiento de calefón a gas',
    ),
  ];

  final _texto = TextEditingController();
  final _foco = FocusNode();

  @override
  void dispose() {
    _texto.dispose();
    _foco.dispose();
    super.dispose();
  }

  void _enviar() {
    final texto = _texto.text.trim();
    widget.onNueva(texto.isEmpty ? null : texto);
  }

  /// Buscador en píldora: ícono, campo sin borde y, a la derecha, el botón
  /// redondo verde que publica la solicitud.
  Widget _campo(TextTheme textos) => Container(
    padding: const EdgeInsets.only(left: Espacios.l + 2, right: 6),
    height: 56,
    decoration: BoxDecoration(
      color: Colores.tarjeta,
      borderRadius: BorderRadius.circular(Radios.pildora),
      border: Border.all(color: Colores.linea),
    ),
    child: Row(
      children: [
        const Icon(Icons.search_rounded, color: Colores.tintaSuave, size: 22),
        const SizedBox(width: Espacios.m),
        Expanded(
          child: TextField(
            controller: _texto,
            focusNode: _foco,
            onSubmitted: (_) => _enviar(),
            style: textos.bodyLarge,
            decoration: InputDecoration.collapsed(
              hintText: 'Ej. fuga de agua, cerradura...',
              hintStyle: textos.bodyLarge?.copyWith(
                color: Colores.tintaSuave,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
        const SizedBox(width: Espacios.s),
        Semantics(
          button: true,
          label: 'Nueva solicitud',
          child: Material(
            color: Colores.primario,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: _enviar,
              child: const SizedBox.square(
                dimension: 44,
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: Colores.sobreOscuro,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );

  Widget _ubicacion(TextTheme textos) => Container(
    height: 56,
    padding: const EdgeInsets.symmetric(horizontal: Espacios.l + 2),
    decoration: BoxDecoration(
      color: Colores.cieloSuave,
      borderRadius: BorderRadius.circular(Radios.pildora),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.location_on_outlined, color: Colores.info, size: 20),
        const SizedBox(width: Espacios.s),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'UBICACIÓN ACTUAL',
              style: textos.labelSmall?.copyWith(
                color: Colores.tintaSuave,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
                fontSize: 10,
              ),
            ),
            Text(
              'Quito, Ecuador',
              style: textos.labelLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    return TarjetaOnda.clara(
      titulo: 'Cuéntanos qué pasa',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LayoutBuilder(
            builder: (context, restricciones) {
              if (restricciones.maxWidth >= 760) {
                return Row(
                  children: [
                    Expanded(child: _campo(textos)),
                    const SizedBox(width: Espacios.m),
                    _ubicacion(textos),
                  ],
                );
              }
              return _campo(textos);
            },
          ),
          const SizedBox(height: Espacios.l),
          Wrap(
            spacing: Espacios.s,
            runSpacing: Espacios.s,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                'FRECUENTES:',
                style: textos.labelSmall?.copyWith(
                  color: Colores.tintaSuave,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
              for (final (icono, etiqueta, texto) in _frecuentes)
                InkWell(
                  borderRadius: BorderRadius.circular(Radios.pildora),
                  onTap: () {
                    _texto.text = texto;
                    _foco.requestFocus();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Espacios.m,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colores.cieloSuave,
                      borderRadius: BorderRadius.circular(Radios.pildora),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icono, size: 14, color: Colores.cieloOscuro),
                        const SizedBox(width: 6),
                        Text(etiqueta, style: textos.labelMedium),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Etiqueta pequeña en azul + título grande + acción opcional a la derecha.
class EncabezadoSeccion extends StatelessWidget {
  const EncabezadoSeccion({
    super.key,
    required this.titulo,
    this.etiqueta,
    this.trailing,
  });

  final String titulo;
  final String? etiqueta;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (etiqueta != null)
                Text(
                  etiqueta!.toUpperCase(),
                  style: textos.labelSmall?.copyWith(
                    color: Colores.info,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.6,
                  ),
                ),
              Text(titulo, style: textos.headlineSmall),
            ],
          ),
        ),
        ?trailing,
      ],
    );
  }
}

/// Enlace "Ver todos" en la esquina de una tarjeta con onda: píldora clara
/// con texto oscuro y una flecha.
class EnlaceVerTodos extends StatelessWidget {
  const EnlaceVerTodos({super.key, required this.texto, required this.onTap});

  final String texto;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colores.lienzo.withValues(alpha: 0.85),
      shape: const StadiumBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const StadiumBorder(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            Espacios.m,
            Espacios.xs + 2,
            Espacios.s,
            Espacios.xs + 2,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                texto,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Colores.tinta,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: Espacios.xs),
              const Icon(
                Icons.arrow_forward_rounded,
                size: 16,
                color: Colores.tinta,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Etiqueta "En vivo en Quito".
class EtiquetaEnVivo extends StatelessWidget {
  const EtiquetaEnVivo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Espacios.m, vertical: 4),
      decoration: BoxDecoration(
        color: Colores.primarioSuave,
        borderRadius: BorderRadius.circular(Radios.pildora),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.circle, size: 8, color: Colores.acento),
          const SizedBox(width: 6),
          Text(
            'En vivo en Quito',
            style: Theme.of(context).textTheme.labelSmall
                ?.copyWith(color: Colores.info, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

/// "Radio de búsqueda: [5 km (PostGIS)]".
class EtiquetaRadio extends StatelessWidget {
  const EtiquetaRadio({super.key, required this.texto});

  final String texto;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Radio de búsqueda:',
          style: textos.bodySmall?.copyWith(color: Colores.tintaSuave),
        ),
        const SizedBox(width: Espacios.s),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colores.primarioSuave,
            borderRadius: BorderRadius.circular(Radios.pequeno),
          ),
          child: Text(
            texto,
            style: textos.labelSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
        ),
      ],
    );
  }
}

class Categorias extends StatelessWidget {
  const Categorias({
    super.key,
    required this.oficios,
    required this.conteo,
    this.onTap,
    this.maximo = 8,
  });

  final List<Oficio> oficios;
  final Map<String, int> conteo;
  final ValueChanged<Oficio>? onTap;
  final int maximo;

  @override
  Widget build(BuildContext context) {
    final ordenados = [...oficios]
      ..sort((a, b) {
        final c = (conteo[b.nombre] ?? 0).compareTo(conteo[a.nombre] ?? 0);
        return c != 0 ? c : a.nombre.compareTo(b.nombre);
      });
    return LayoutBuilder(
      builder: (context, restricciones) {
        final ancho = restricciones.maxWidth;
        // Sin ancho (todavía no hay espacio, o es infinito) no se reparte
        // nada: un ancho de tarjeta negativo rompe el layout y deja al
        // rastreador del mouse en estado inválido en web.
        if (!ancho.isFinite || ancho <= 0) return const SizedBox.shrink();
        final columnas = ancho >= 700 ? 4 : (ancho >= 480 ? 3 : 2);
        final anchoTarjeta = ((ancho - Espacios.m * (columnas - 1)) / columnas)
            .clamp(0.0, ancho);
        return Wrap(
          spacing: Espacios.m,
          runSpacing: Espacios.m,
          children: [
            for (final oficio in ordenados.take(maximo))
              SizedBox(
                width: anchoTarjeta,
                child: _Categoria(
                  oficio: oficio,
                  cerca: conteo[oficio.nombre] ?? 0,
                  onTap: onTap == null ? null : () => onTap!(oficio),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _Categoria extends StatelessWidget {
  const _Categoria({required this.oficio, required this.cerca, this.onTap});

  final Oficio oficio;
  final int cerca;
  final VoidCallback? onTap;

  static IconData _icono(String nombre) {
    final n = nombre.toLowerCase();
    if (n.contains('plom')) return Icons.plumbing;
    if (n.contains('electr')) return Icons.bolt;
    if (n.contains('cerraj')) return Icons.vpn_key_outlined;
    if (n.contains('carpint')) return Icons.carpenter;
    if (n.contains('pint')) return Icons.format_paint_outlined;
    if (n.contains('alba')) return Icons.construction;
    if (n.contains('calef') || n.contains('gas')) {
      return Icons.local_fire_department_outlined;
    }
    if (n.contains('lavad') || n.contains('blanca') || n.contains('refri')) {
      return Icons.local_laundry_service_outlined;
    }
    if (n.contains('limpie')) return Icons.cleaning_services_outlined;
    if (n.contains('jardin')) return Icons.yard_outlined;
    if (n.contains('aire')) return Icons.ac_unit;
    if (n.contains('vidri')) return Icons.window_outlined;
    if (n.contains('fumig')) return Icons.pest_control_outlined;
    if (n.contains('imperme')) return Icons.roofing;
    if (n.contains('mudanz')) return Icons.local_shipping_outlined;
    if (n.contains('camara') || n.contains('cámara')) {
      return Icons.videocam_outlined;
    }
    if (n.contains('tapic')) return Icons.chair_outlined;
    if (n.contains('gypsum')) return Icons.home_repair_service_outlined;
    return Icons.handyman_outlined;
  }

  @override
  Widget build(BuildContext context) {
    return TarjetaOpcion(
      titulo: oficio.nombre,
      subtitulo: cerca > 0 ? '$cerca activos' : 'Sin técnicos',
      icono: _icono(oficio.nombre),
      onTap: onTap,
    );
  }
}

/// Píldoras de filtro: Todos, un oficio por píldora y "Garantía Chaucha".
class FiltrosTecnicos extends StatelessWidget {
  const FiltrosTecnicos({
    super.key,
    required this.oficios,
    required this.seleccionado,
    required this.onCambio,
  });

  final List<String> oficios;
  final String? seleccionado;
  final ValueChanged<String?> onCambio;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _Pastilla(
            texto: 'Todos',
            activa: seleccionado == null,
            onTap: () => onCambio(null),
          ),
          for (final oficio in oficios) ...[
            const SizedBox(width: Espacios.s),
            _Pastilla(
              texto: oficio,
              activa: seleccionado == oficio,
              onTap: () => onCambio(oficio),
            ),
          ],
        ],
      ),
    );
  }
}

class _Pastilla extends StatelessWidget {
  const _Pastilla({
    required this.texto,
    required this.activa,
    required this.onTap,
  });

  final String texto;
  final bool activa;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: activa ? Colores.primario : Colores.tarjeta,
      shape: StadiumBorder(
        side: BorderSide(color: activa ? Colores.primario : Colores.linea),
      ),
      child: InkWell(
        onTap: onTap,
        customBorder: const StadiumBorder(),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Espacios.l,
            vertical: Espacios.s + 2,
          ),
          child: Text(
            texto,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: activa
                  ? Theme.of(context).colorScheme.onPrimary
                  : Colores.tintaSuave,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

/// Cuadrícula de columnas iguales: tantas como quepan hasta [maxColumnas].
class GrillaResponsiva extends StatelessWidget {
  const GrillaResponsiva({
    super.key,
    required this.children,
    this.anchoMinimo = 260,
    this.maxColumnas = 4,
    this.espacio = Espacios.l + 4,
  });

  final List<Widget> children;
  final double anchoMinimo;
  final int maxColumnas;
  final double espacio;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, restricciones) {
        final caben =
            ((restricciones.maxWidth + espacio) / (anchoMinimo + espacio))
                .floor();
        final columnas = math.max(1, math.min(maxColumnas, caben));
        final ancho =
            (restricciones.maxWidth - espacio * (columnas - 1)) / columnas;
        return Wrap(
          spacing: espacio,
          runSpacing: espacio,
          children: [
            for (final hijo in children) SizedBox(width: ancho, child: hijo),
          ],
        );
      },
    );
  }
}

class TecnicoCard extends StatelessWidget {
  const TecnicoCard({super.key, required this.tecnico, this.onSolicitar});

  final TecnicoCercano tecnico;

  /// Null para el técnico (solo el cliente puede solicitar).
  final VoidCallback? onSolicitar;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final t = tecnico;
    final precio = t.tarifaBase.toStringAsFixed(t.tarifaBase % 1 == 0 ? 0 : 2);
    return TarjetaApp(
      padding: const EdgeInsets.all(Espacios.l + 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colores.primarioSuave,
                      borderRadius: BorderRadius.circular(Radios.medio),
                    ),
                    child: Text(
                      t.iniciales,
                      style: textos.titleLarge?.copyWith(
                        color: Colores.primarioOscuro,
                      ),
                    ),
                  ),
                  Positioned(
                    right: -4,
                    bottom: -4,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colores.acento,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colores.tarjeta, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              if (t.nivel.isNotEmpty)
                Pildora(texto: t.nivel, color: Colores.primario),
            ],
          ),
          const SizedBox(height: Espacios.l),
          Row(
            children: [
              Flexible(
                child: Text(
                  t.nombreCorto,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textos.titleMedium,
                ),
              ),
              const SizedBox(width: 6),
              const Icon(Icons.verified, size: 18, color: Colores.primario),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            t.oficios.join(' · '),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textos.bodySmall?.copyWith(
              color: Colores.info,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: Espacios.l),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Espacios.m,
              vertical: Espacios.s,
            ),
            decoration: BoxDecoration(
              color: Colores.superficie,
              borderRadius: BorderRadius.circular(Radios.medio),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.star_rounded,
                  size: 16,
                  color: Colores.estrella,
                ),
                const SizedBox(width: 4),
                Text(
                  t.totalResenas == 0
                      ? 'Nuevo'
                      : t.calificacion.toStringAsFixed(
                          t.calificacion % 1 == 0 ? 1 : 2,
                        ),
                  style: textos.labelLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (t.totalResenas > 0) ...[
                  const SizedBox(width: 4),
                  Text(
                    '(${t.totalResenas})',
                    style: textos.bodySmall?.copyWith(
                      color: Colores.tintaSuave,
                    ),
                  ),
                ],
                const SizedBox(width: Espacios.m),
                Container(
                  width: 4,
                  height: 4,
                  decoration: const BoxDecoration(
                    color: Colores.superficieFuerte,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: Espacios.m),
                Expanded(
                  child: Text(
                    'a ${Formatos.distancia(t.metros.toDouble())}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textos.bodySmall?.copyWith(
                      color: Colores.tintaSuave,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: Espacios.l + 4),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TARIFA BASE',
                    style: textos.labelSmall?.copyWith(
                      color: Colores.tintaSuave,
                      letterSpacing: 0.8,
                      fontSize: 10,
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      text: '\$$precio',
                      style: textos.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                      children: [
                        TextSpan(
                          text: ' / visita',
                          style: textos.bodySmall?.copyWith(
                            color: Colores.tintaSuave,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              if (onSolicitar != null)
                FilledButton(
                  style: FilledButton.styleFrom(minimumSize: const Size(0, 44)),
                  onPressed: onSolicitar,
                  child: const Text('Solicitar'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Técnico en una fila: datos a la izquierda, tarifa y botones a la derecha.
class TecnicoFila extends StatelessWidget {
  const TecnicoFila({
    super.key,
    required this.tecnico,
    this.onSolicitar,
    this.onVerPerfil,
  });

  final TecnicoCercano tecnico;

  /// Abre el perfil público del técnico al tocar la tarjeta.
  final VoidCallback? onVerPerfil;

  /// Null para el técnico (solo el cliente puede solicitar).
  final VoidCallback? onSolicitar;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final t = tecnico;
    final minutos = math.max(1, (t.metros / 400).ceil());
    final precio = t.tarifaBase.toStringAsFixed(t.tarifaBase % 1 == 0 ? 0 : 2);

    final avatar = Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 60,
          height: 60,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Colores.cieloSuave,
            shape: BoxShape.circle,
          ),
          child: Text(
            t.iniciales,
            style: textos.titleLarge?.copyWith(color: Colores.cieloOscuro),
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: Colores.acento,
              shape: BoxShape.circle,
              border: Border.all(color: Colores.tarjeta, width: 2),
            ),
          ),
        ),
      ],
    );

    final info = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                t.nombreCorto,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textos.titleMedium,
              ),
            ),
            const SizedBox(width: 6),
            const Icon(
              Icons.verified_outlined,
              size: 18,
              color: Colores.primario,
            ),
            if (t.nivel.isNotEmpty) ...[
              const SizedBox(width: Espacios.s),
              Pildora(texto: t.nivel, color: Colores.primario),
            ],
          ],
        ),
        const SizedBox(height: 2),
        Text(
          '${t.oficios.join(' · ')} • a $minutos min • '
          '${Formatos.distancia(t.metros.toDouble())}',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: textos.bodySmall?.copyWith(color: Colores.tintaSuave),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            const Icon(Icons.star_rounded, size: 16, color: Colores.estrella),
            const SizedBox(width: 4),
            Text(
              t.totalResenas == 0
                  ? 'Nuevo'
                  : t.calificacion.toStringAsFixed(
                      t.calificacion % 1 == 0 ? 1 : 2,
                    ),
              style: textos.labelLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
            if (t.totalResenas > 0) ...[
              const SizedBox(width: 4),
              Text(
                '(${t.totalResenas} reseñas)',
                style: textos.bodySmall?.copyWith(color: Colores.tintaSuave),
              ),
            ],
          ],
        ),
      ],
    );

    final tarifa = Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'TARIFA',
          style: textos.labelSmall?.copyWith(
            color: Colores.tintaSuave,
            letterSpacing: 0.8,
            fontSize: 10,
          ),
        ),
        Text.rich(
          TextSpan(
            text: '\$$precio',
            style: textos.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            children: [
              TextSpan(
                text: ' /visita',
                style: textos.bodySmall?.copyWith(
                  color: Colores.tintaSuave,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );

    final acciones = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (onSolicitar != null)
          FilledButton(
            style: FilledButton.styleFrom(minimumSize: const Size(0, 44)),
            onPressed: onSolicitar,
            child: const Text('Solicitar'),
          ),
      ],
    );

    return TarjetaApp(
      onTap: onVerPerfil,
      padding: const EdgeInsets.all(Espacios.l),
      child: LayoutBuilder(
        builder: (context, restricciones) {
          if (restricciones.maxWidth >= 640) {
            return Row(
              children: [
                avatar,
                const SizedBox(width: Espacios.l + 4),
                Expanded(child: info),
                const SizedBox(width: Espacios.l),
                tarifa,
                const SizedBox(width: Espacios.l),
                acciones,
              ],
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  avatar,
                  const SizedBox(width: Espacios.l + 4),
                  Expanded(child: info),
                ],
              ),
              const SizedBox(height: Espacios.l),
              Row(children: [tarifa, const Spacer(), acciones]),
            ],
          );
        },
      ),
    );
  }
}

/// Franja de tres garantías.
class BannerConfianza extends StatelessWidget {
  const BannerConfianza({super.key});

  static const _pilares = [
    (
      Icons.verified_user_outlined,
      'Garantía Chaucha 30 Días',
      'Reembolso de mano de obra o visita sin costo ante cualquier falla.',
    ),
    (
      Icons.badge_outlined,
      'Cédula 100% Auditada',
      'Registro Civil y antecedentes penales de Policía Nacional certificados.',
    ),
    (
      Icons.payments_outlined,
      'Pago Contra Entrega',
      'Transferencia DeUna o tarjeta solo al validar y aprobar el trabajo.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    Widget pilar((IconData, String, String) datos) => Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colores.lienzo.withValues(alpha: 0.8),
            shape: BoxShape.circle,
          ),
          child: Icon(datos.$1, color: Colores.primario, size: 24),
        ),
        const SizedBox(width: Espacios.l),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(datos.$2, style: textos.titleSmall),
              const SizedBox(height: Espacios.xs),
              Text(
                datos.$3,
                style: textos.bodyMedium?.copyWith(
                  color: Colores.tinta,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );

    return TarjetaOnda.verde(
      titulo: 'Contrata tranquilo',
      child: LayoutBuilder(
        builder: (context, restricciones) {
          if (restricciones.maxWidth >= 640) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < _pilares.length; i++) ...[
                  if (i > 0) const SizedBox(width: Espacios.xxl),
                  Expanded(child: pilar(_pilares[i])),
                ],
              ],
            );
          }
          return Column(
            children: [
              for (var i = 0; i < _pilares.length; i++) ...[
                if (i > 0) const SizedBox(height: Espacios.xl),
                pilar(_pilares[i]),
              ],
            ],
          );
        },
      ),
    );
  }
}

/// Pie de página.
class PieInicio extends StatelessWidget {
  const PieInicio({super.key});

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final suave = textos.bodySmall?.copyWith(
      color: Colores.sobreOscuro.withValues(alpha: 0.7),
    );
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: Espacios.xl,
        vertical: Espacios.xl,
      ),
      child: AnchoMaximo(
        ancho: 1200,
        child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: Espacios.xl,
          runSpacing: Espacios.l,
          children: [
            // Wrap y no Row: en el teléfono el lema baja debajo de la marca
            // en lugar de desbordar.
            Wrap(
              spacing: Espacios.m,
              runSpacing: Espacios.s,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const Marca(sobreOscuro: true),
                Text(
                  'Plataforma de servicios para el hogar • Quito, Ecuador',
                  style: suave,
                ),
              ],
            ),
            Wrap(
              spacing: Espacios.l,
              runSpacing: Espacios.s,
              children: [
                Text('Términos', style: suave),
                Text('Privacidad', style: suave),
                Text('Soporte 24/7', style: suave),
                Text('© 2026 ChauchaApp', style: suave),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
