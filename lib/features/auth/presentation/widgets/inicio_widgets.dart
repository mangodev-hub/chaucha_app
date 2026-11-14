import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../core/widgets/tarjeta_opcion.dart';
import '../../../catalogo/domain/entities/oficio.dart';
import '../../../catalogo/presentation/widgets/icono_oficio.dart';

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

  @override
  Widget build(BuildContext context) {
    return TarjetaOpcion(
      titulo: oficio.nombre,
      subtitulo: cerca > 0 ? '$cerca activos' : 'Sin técnicos',
      icono: iconoOficio(oficio.nombre),
      onTap: onTap,
    );
  }
}
