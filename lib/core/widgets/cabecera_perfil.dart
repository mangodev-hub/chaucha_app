import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import 'foto_perfil_caja.dart';
import 'insignia_verificado.dart';

class MetricaPerfil {
  const MetricaPerfil({
    required this.icono,
    required this.valor,
    required this.etiqueta,
    this.colorIcono = Colores.cieloOscuro,
  });

  final IconData icono;
  final String valor;
  final String etiqueta;
  final Color colorIcono;
}

class CabeceraPerfil extends StatelessWidget {
  const CabeceraPerfil({
    super.key,
    required this.nombre,
    required this.iniciales,
    required this.datos,
    required this.metricas,
    this.fotoRuta,
    this.acciones,
    this.verificado = false,
  });

  final String nombre;
  final String iniciales;
  final String? fotoRuta;

  /// Línea bajo el nombre (ubicación, píldoras...).
  final Widget datos;
  final Widget? acciones;
  final List<MetricaPerfil> metricas;

  /// Muestra el ícono de verificado sobre la foto.
  final bool verificado;

  static const double _alturaBanda = 140;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    return LayoutBuilder(
      builder: (context, r) {
        final movil = r.maxWidth < 640;
        final lado = movil ? 96.0 : 120.0;
        final foto = Container(
          width: lado + 10,
          height: lado + 10,
          padding: const EdgeInsets.all(5),
          decoration: const BoxDecoration(
            color: Colores.tarjeta,
            shape: BoxShape.circle,
          ),
          child: FotoPerfilCaja(
            tamano: lado,
            circular: true,
            rutaFoto: fotoRuta,
            iniciales: iniciales,
            colorFondo: Colores.cieloSuave,
            estiloTexto: textos.headlineMedium?.copyWith(
              fontSize: 36,
              fontWeight: FontWeight.w800,
              color: Colores.cieloOscuro,
            ),
          ),
        );
        final avatar = ConIconoVerificado(
          verificado: verificado,
          tamano: lado * 0.28,
          hijo: foto,
        );
        final titulo = Text(
          nombre,
          textAlign: movil ? TextAlign.center : TextAlign.start,
          style: textos.headlineSmall?.copyWith(
            fontSize: 26,
            fontWeight: FontWeight.w800,
          ),
        );
        final mitad = (lado + 10) / 2;

        final franja = movil
            ? Padding(
                padding: EdgeInsets.fromLTRB(
                  Espacios.l,
                  mitad + Espacios.s,
                  Espacios.l,
                  Espacios.l,
                ),
                child: Column(
                  children: [
                    titulo,
                    const SizedBox(height: Espacios.s),
                    datos,
                    if (acciones != null) ...[
                      const SizedBox(height: Espacios.m),
                      acciones!,
                    ],
                  ],
                ),
              )
            : Padding(
                padding: EdgeInsets.fromLTRB(
                  Espacios.xl + lado + 10 + Espacios.l,
                  Espacios.l,
                  Espacios.xl,
                  Espacios.l,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          titulo,
                          const SizedBox(height: Espacios.s),
                          datos,
                        ],
                      ),
                    ),
                    if (acciones != null) ...[
                      const SizedBox(width: Espacios.l),
                      acciones!,
                    ],
                  ],
                ),
              );

        return Container(
          decoration: BoxDecoration(
            color: Colores.tarjeta,
            borderRadius: BorderRadius.circular(Radios.tarjeta),
            boxShadow: Sombras.tarjeta,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(Radios.tarjeta),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const _Banda(alto: _alturaBanda),
                        franja,
                      ],
                    ),
                    Positioned(
                      top: _alturaBanda - mitad,
                      left: movil ? 0 : Espacios.xl,
                      right: movil ? 0 : null,
                      child: movil ? Center(child: avatar) : avatar,
                    ),
                  ],
                ),
                const Divider(height: 1, color: Colores.divisor),
                _Metricas(metricas: metricas, enGrilla: movil),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Banda extends StatelessWidget {
  const _Banda({required this.alto});

  final double alto;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: SizedBox(
        height: alto,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2B9FE0), Colores.cieloClaro],
            ),
          ),
          child: LayoutBuilder(
            builder: (context, r) => Stack(
              clipBehavior: Clip.hardEdge,
              children: [
                Positioned(
                  top: -60,
                  left: r.maxWidth / 2 - 60,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  right: 40,
                  bottom: -35,
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: const BoxDecoration(
                      color: Colores.primarioClaro,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Metricas extends StatelessWidget {
  const _Metricas({required this.metricas, required this.enGrilla});

  final List<MetricaPerfil> metricas;
  final bool enGrilla;

  @override
  Widget build(BuildContext context) {
    Widget celda(MetricaPerfil m) => _Celda(metrica: m);
    if (enGrilla) {
      final filas = <Widget>[];
      for (var i = 0; i < metricas.length; i += 2) {
        if (i > 0) filas.add(const Divider(height: 1, color: Colores.divisor));
        filas.add(
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: celda(metricas[i])),
                const VerticalDivider(width: 1, color: Colores.divisor),
                Expanded(
                  child: i + 1 < metricas.length
                      ? celda(metricas[i + 1])
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        );
      }
      return Column(children: filas);
    }
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < metricas.length; i++) ...[
            if (i > 0) const VerticalDivider(width: 1, color: Colores.divisor),
            Expanded(child: celda(metricas[i])),
          ],
        ],
      ),
    );
  }
}

class _Celda extends StatelessWidget {
  const _Celda({required this.metrica});

  final MetricaPerfil metrica;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    return Semantics(
      label: '${metrica.etiqueta}: ${metrica.valor}',
      excludeSemantics: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Espacios.m,
          vertical: Espacios.l,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(metrica.icono, size: 18, color: metrica.colorIcono),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    metrica.valor,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textos.titleMedium?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              metrica.etiqueta,
              textAlign: TextAlign.center,
              style: textos.bodySmall?.copyWith(
                fontSize: 12,
                color: Colores.tintaSuave,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
