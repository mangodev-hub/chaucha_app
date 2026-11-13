// Bloque de reseñas de un perfil: resumen (promedio, barras de 5 a 1 y las
// etiquetas más repetidas), las 3 más recientes y "Ver las n reseñas" con
// la lista completa filtrable por fecha.
import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../core/widgets/tarjeta_inicio.dart';
import '../../domain/entities/perfil_publico.dart';

String _dos(int n) => n.toString().padLeft(2, '0');

String _fecha(DateTime f) {
  final l = f.toLocal();
  return '${_dos(l.day)}/${_dos(l.month)}/${l.year}';
}

String _iniciales(String autor) => autor
    .split(' ')
    .where((p) => p.isNotEmpty)
    .take(2)
    .map((p) => p[0])
    .join()
    .toUpperCase();

class ResenasPerfil extends StatelessWidget {
  const ResenasPerfil({
    super.key,
    required this.titulo,
    required this.resenas,
    required this.vacio,
  });

  final String titulo;

  /// Todas las reseñas cargadas, la más reciente primero.
  final List<ResenaPublica> resenas;

  /// Lo que se muestra debajo del resumen cuando no hay reseñas.
  final Widget vacio;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    return TarjetaInicio(
      padding: const EdgeInsets.all(Espacios.l + 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            titulo,
            style: textos.titleMedium?.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: Espacios.m),
          ResumenResenas(resenas: resenas),
          const SizedBox(height: Espacios.m),
          if (resenas.isEmpty)
            vacio
          else ...[
            for (var i = 0; i < resenas.length && i < 3; i++) ...[
              if (i > 0) const Divider(height: 1, color: Colores.divisor),
              FilaResena(resena: resenas[i], cielo: i.isOdd),
            ],
            const SizedBox(height: Espacios.m),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () =>
                    unawaited(mostrarTodasLasResenas(context, resenas)),
                style: TextButton.styleFrom(
                  backgroundColor: Colores.primarioSuave,
                  foregroundColor: Colores.primario,
                  minimumSize: const Size(0, 40),
                  padding: const EdgeInsets.symmetric(horizontal: Espacios.l),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Radios.pequeno),
                  ),
                ),
                child: Text(
                  resenas.length == 1
                      ? 'Ver la reseña'
                      : 'Ver las ${resenas.length} reseñas',
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Promedio, barras de 5 a 1 y las 4 etiquetas más repetidas.
class ResumenResenas extends StatelessWidget {
  const ResumenResenas({super.key, required this.resenas});

  final List<ResenaPublica> resenas;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final total = resenas.length;
    final promedio = total == 0
        ? 0.0
        : resenas.fold<int>(0, (s, r) => s + r.calificacion) / total;
    final porNota = {
      for (var n = 1; n <= 5; n++)
        n: resenas.where((r) => r.calificacion == n).length,
    };
    final conteoEtiquetas = <String, int>{};
    for (final r in resenas) {
      for (final e in r.etiquetas) {
        conteoEtiquetas[e] = (conteoEtiquetas[e] ?? 0) + 1;
      }
    }
    final etiquetas =
        (conteoEtiquetas.entries.toList()
              ..sort((a, b) => b.value.compareTo(a.value)))
            .take(4)
            .map((e) => e.key)
            .toList();

    final cifra = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          total == 0 ? '—' : promedio.toStringAsFixed(1).replaceAll('.', ','),
          style: textos.headlineLarge?.copyWith(
            fontSize: 40,
            fontWeight: FontWeight.w800,
            color: total == 0 ? Colores.tintaSuave : Colores.tinta,
          ),
        ),
        Estrellas(valor: promedio),
        const SizedBox(height: 2),
        Text(
          total == 1 ? 'de 5 · 1 reseña' : 'de 5 · $total reseñas',
          style: textos.bodySmall?.copyWith(
            fontSize: 11,
            color: Colores.tintaSuave,
          ),
        ),
      ],
    );
    final barras = Column(
      children: [
        for (var n = 5; n >= 1; n--)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: [
                SizedBox(
                  width: 12,
                  child: Text('$n', style: textos.labelSmall),
                ),
                const SizedBox(width: Espacios.s),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(Radios.pildora),
                    child: LinearProgressIndicator(
                      value: total == 0 ? 0 : porNota[n]! / total,
                      minHeight: 6,
                      color: Colores.estrella,
                      backgroundColor: Colores.linea,
                    ),
                  ),
                ),
                const SizedBox(width: Espacios.s),
                SizedBox(
                  width: 22,
                  child: Text(
                    '${porNota[n]}',
                    textAlign: TextAlign.end,
                    style: textos.labelSmall?.copyWith(
                      color: Colores.tintaSuave,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
    final pildoras = Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        for (final e in etiquetas)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colores.primarioSuave,
              borderRadius: BorderRadius.circular(Radios.pildora),
            ),
            child: Text(
              e,
              style: textos.labelMedium?.copyWith(
                color: Colores.primario,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
      ],
    );

    return Container(
      padding: const EdgeInsets.all(Espacios.l),
      decoration: BoxDecoration(
        color: Colores.fondoClaro,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Semantics(
        label: total == 0
            ? 'Sin reseñas'
            : 'Promedio ${promedio.toStringAsFixed(1)} de 5 con $total reseñas',
        child: LayoutBuilder(
          builder: (context, r) {
            if (r.maxWidth < 520) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      cifra,
                      const SizedBox(width: Espacios.l),
                      Expanded(child: barras),
                    ],
                  ),
                  if (etiquetas.isNotEmpty) ...[
                    const SizedBox(height: Espacios.m),
                    pildoras,
                  ],
                ],
              );
            }
            return Row(
              children: [
                cifra,
                const SizedBox(width: Espacios.xl),
                Expanded(flex: 3, child: barras),
                if (etiquetas.isNotEmpty) ...[
                  const SizedBox(width: Espacios.xl),
                  Expanded(flex: 2, child: pildoras),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class Estrellas extends StatelessWidget {
  const Estrellas({super.key, required this.valor, this.tamano = 14});

  final double valor;
  final double tamano;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      for (var i = 1; i <= 5; i++)
        Icon(
          valor >= i
              ? Icons.star_rounded
              : valor >= i - 0.5
              ? Icons.star_half_rounded
              : Icons.star_outline_rounded,
          size: tamano,
          color: valor >= i - 0.5 ? Colores.estrella : Colores.linea,
        ),
    ],
  );
}

class FilaResena extends StatelessWidget {
  const FilaResena({super.key, required this.resena, required this.cielo});

  final ResenaPublica resena;
  final bool cielo;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final r = resena;
    final comentario = r.comentario;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Espacios.m),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: cielo ? Colores.cieloSuave : Colores.primarioSuave,
              shape: BoxShape.circle,
            ),
            child: Text(
              _iniciales(r.autor),
              style: textos.labelMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: cielo ? Colores.cieloOscuro : Colores.primario,
              ),
            ),
          ),
          const SizedBox(width: Espacios.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              r.autor,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: textos.labelLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const SizedBox(width: Espacios.s),
                          Estrellas(valor: r.calificacion.toDouble()),
                        ],
                      ),
                    ),
                    const SizedBox(width: Espacios.s),
                    Text(
                      _fecha(r.creadoEn),
                      style: textos.bodySmall?.copyWith(
                        color: Colores.tintaSuave,
                      ),
                    ),
                  ],
                ),
                if (comentario != null && comentario.isNotEmpty) ...[
                  const SizedBox(height: Espacios.xs),
                  Text(
                    comentario,
                    style: textos.bodyMedium?.copyWith(fontSize: 14),
                  ),
                ],
                if (r.etiquetas.isNotEmpty) ...[
                  const SizedBox(height: Espacios.s),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      for (final e in r.etiquetas)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colores.superficie,
                            borderRadius: BorderRadius.circular(Radios.pildora),
                          ),
                          child: Text(
                            e,
                            style: textos.labelSmall?.copyWith(
                              color: Colores.tintaSuave,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum _Periodo {
  todas('Todas', null),
  mes('Último mes', Duration(days: 30)),
  seisMeses('Últimos 6 meses', Duration(days: 182)),
  anio('Último año', Duration(days: 365));

  const _Periodo(this.etiqueta, this.duracion);

  final String etiqueta;
  final Duration? duracion;
}

/// Todas las reseñas, con filtro por fecha.
Future<void> mostrarTodasLasResenas(
  BuildContext context,
  List<ResenaPublica> resenas,
) {
  return showDialog<void>(
    context: context,
    builder: (_) => _TodasLasResenas(resenas: resenas),
  );
}

class _TodasLasResenas extends StatefulWidget {
  const _TodasLasResenas({required this.resenas});

  final List<ResenaPublica> resenas;

  @override
  State<_TodasLasResenas> createState() => _TodasLasResenasState();
}

class _TodasLasResenasState extends State<_TodasLasResenas> {
  _Periodo _periodo = _Periodo.todas;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final desde = _periodo.duracion == null
        ? null
        : DateTime.now().subtract(_periodo.duracion!);
    final visibles = [
      for (final r in widget.resenas)
        if (desde == null || r.creadoEn.isAfter(desde)) r,
    ];
    return Dialog(
      insetPadding: const EdgeInsets.all(Espacios.l),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640, maxHeight: 720),
        child: Padding(
          padding: const EdgeInsets.all(Espacios.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Reseñas (${widget.resenas.length})',
                      style: textos.titleLarge,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Cerrar',
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const SizedBox(height: Espacios.s),
              Wrap(
                spacing: Espacios.s,
                runSpacing: Espacios.s,
                children: [
                  for (final p in _Periodo.values)
                    ChoiceChip(
                      label: Text(p.etiqueta),
                      selected: _periodo == p,
                      onSelected: (_) => setState(() => _periodo = p),
                    ),
                ],
              ),
              const SizedBox(height: Espacios.m),
              Expanded(
                child: visibles.isEmpty
                    ? Center(
                        child: Text(
                          'No hay reseñas en este periodo.',
                          style: textos.bodyMedium?.copyWith(
                            color: Colores.tintaSuave,
                          ),
                        ),
                      )
                    : ListView.separated(
                        itemCount: visibles.length,
                        separatorBuilder: (_, _) =>
                            const Divider(height: 1, color: Colores.divisor),
                        itemBuilder: (_, i) =>
                            FilaResena(resena: visibles[i], cielo: i.isOdd),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
