import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/geo/geo_mapper.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/utils/formatos.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/foto_perfil_caja.dart';
import '../../../../core/widgets/mapa_radio.dart';
import '../../../../core/widgets/tarjeta_cerca.dart';
import '../../../catalogo/presentation/providers/oficios_provider.dart';
import '../../domain/entities/tecnico_cercano.dart';
import '../providers/inicio_provider.dart';

class CercaCliente extends ConsumerStatefulWidget {
  const CercaCliente({
    super.key,
    required this.onVerPerfil,
    required this.onContactar,
  });

  final ValueChanged<TecnicoCercano> onVerPerfil;
  final ValueChanged<TecnicoCercano> onContactar;

  @override
  ConsumerState<CercaCliente> createState() => _CercaClienteState();
}

class _CercaClienteState extends ConsumerState<CercaCliente> {
  static const Duration _espera = Duration(milliseconds: 400);

  /// Valor del slider mientras se arrastra (antes de consultar).
  double? _km;
  Timer? _reloj;
  String? _seleccionado;
  String? _resaltado;

  @override
  void dispose() {
    _reloj?.cancel();
    super.dispose();
  }

  void _aplicarRadio(double km) {
    _reloj?.cancel();
    ref.read(radioInicioProvider.notifier).cambiar((km * 1000).round());
  }

  void _moverRadio(double km) {
    setState(() => _km = km);
    _reloj?.cancel();
    _reloj = Timer(_espera, () => _aplicarRadio(km));
  }

  @override
  Widget build(BuildContext context) {
    final tecnicos = ref.watch(tecnicosCercanosProvider);
    final punto = ref.watch(ubicacionInicioProvider).value ?? GeoMapper.quito;
    final oficios = ref.watch(oficiosProvider).value ?? const [];
    final oficio = ref.watch(oficioInicioProvider);
    final km = _km ?? ref.watch(radioInicioProvider) / 1000;

    final lista = [...?tecnicos.value]
      ..sort((a, b) => a.metros.compareTo(b.metros));
    TecnicoCercano? elegido;
    for (final t in lista) {
      if (t.id == _seleccionado) elegido = t;
    }

    return TarjetaCerca(
      titulo: 'Cerca de ti',
      km: km,
      minKm: 1,
      maxKm: 15,
      onKm: _moverRadio,
      onKmFin: _aplicarRadio,
      cargando: tecnicos.isLoading,
      chips: oficios.isEmpty
          ? null
          : ChipsOficio(
              opciones: [for (final o in oficios) (o.id, o.nombre)],
              seleccionado: oficio,
              onCambio: (id) {
                setState(() => _seleccionado = null);
                ref.read(oficioInicioProvider.notifier).elegir(id);
              },
            ),
      mapa: (alto) => MapaRadio(
        centro: punto,
        radioM: (km * 1000).round(),
        alto: alto,
        seleccionadoId: _seleccionado,
        resaltadoId: _resaltado,
        onTocar: (id) => setState(() => _seleccionado = id),
        puntos: [
          for (var i = 0; i < lista.length; i++)
            PuntoMapa(
              id: lista[i].id,
              ubicacion: lista[i].ubicacion,
              etiqueta: 'Técnico ${lista[i].nombreCorto}',
              pin: (resaltado, seleccionado) => PinCircular(
                resaltado: resaltado,
                seleccionado: seleccionado,
                color: i.isOdd ? Colores.cieloSuave : Colores.primarioSuave,
                child: FotoPerfilCaja(
                  tamano: 38,
                  circular: true,
                  rutaFoto: lista[i].fotoRuta,
                  iniciales: lista[i].iniciales,
                  colorFondo: i.isOdd
                      ? Colores.cieloSuave
                      : Colores.primarioSuave,
                  estiloTexto: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: i.isOdd ? Colores.cieloOscuro : Colores.primario,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
        ],
        tarjeta: elegido == null
            ? null
            : _MiniTecnico(
                tecnico: elegido,
                onVerPerfil: () => widget.onVerPerfil(elegido!),
                onContactar: () => widget.onContactar(elegido!),
                onCerrar: () => setState(() => _seleccionado = null),
              ),
      ),
      lista: (conScroll) {
        if (tecnicos.hasError && !tecnicos.hasValue) {
          return AsyncValueView<List<TecnicoCercano>>(
            value: tecnicos,
            onRetry: () => ref.invalidate(tecnicosCercanosProvider),
            onData: (_, _) => const SizedBox.shrink(),
          );
        }
        if (!tecnicos.hasValue) {
          return const Center(child: CircularProgressIndicator());
        }
        if (lista.isEmpty) {
          return _Vacio(
            'No hay técnicos en ${km.round()} km. Prueba ampliando el radio.',
          );
        }
        final filas = [
          for (var i = 0; i < lista.length; i++)
            _FilaTecnico(
              tecnico: lista[i],
              cielo: i.isOdd,
              seleccionado: lista[i].id == _seleccionado,
              onTap: () => setState(() => _seleccionado = lista[i].id),
              onResaltar: (si) =>
                  setState(() => _resaltado = si ? lista[i].id : null),
            ),
        ];
        if (!conScroll) return Column(children: filas);
        return ListView(children: filas);
      },
    );
  }
}

class _FilaTecnico extends StatelessWidget {
  const _FilaTecnico({
    required this.tecnico,
    required this.cielo,
    required this.seleccionado,
    required this.onTap,
    required this.onResaltar,
  });

  final TecnicoCercano tecnico;
  final bool cielo;
  final bool seleccionado;
  final VoidCallback onTap;
  final ValueChanged<bool> onResaltar;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final t = tecnico;
    final oficio = t.oficios.isEmpty ? 'Técnico' : t.oficios.first;
    final borde = BorderRadius.circular(Radios.pequeno);
    return MouseRegion(
      onEnter: (_) => onResaltar(true),
      onExit: (_) => onResaltar(false),
      child: Material(
        color: seleccionado ? Colores.primarioSuave : Colors.transparent,
        borderRadius: borde,
        child: InkWell(
          onTap: onTap,
          borderRadius: borde,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Espacios.s,
              vertical: Espacios.s,
            ),
            child: Row(
              children: [
                FotoPerfilCaja(
                  tamano: 40,
                  circular: true,
                  rutaFoto: t.fotoRuta,
                  iniciales: t.iniciales,
                  colorFondo: cielo
                      ? Colores.cieloSuave
                      : Colores.primarioSuave,
                  estiloTexto: textos.labelLarge?.copyWith(
                    color: cielo ? Colores.cieloOscuro : Colores.primario,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(width: Espacios.s + 2),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.nombreCorto,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textos.labelLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        '$oficio · ${Formatos.kilometros(t.metros.toDouble())}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textos.bodySmall?.copyWith(
                          color: Colores.tintaSuave,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: Espacios.xs),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _Estrella(calificacion: t.calificacion),
                    Text(
                      'Verificado',
                      style: textos.labelSmall?.copyWith(
                        color: Colores.primario,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Estrella extends StatelessWidget {
  const _Estrella({required this.calificacion});

  final double calificacion;

  @override
  Widget build(BuildContext context) {
    final texto = calificacion.toStringAsFixed(1).replaceAll('.', ',');
    return Semantics(
      label: 'Calificación $texto de 5',
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, size: 16, color: Colores.estrella),
          const SizedBox(width: 2),
          Text(
            texto,
            style: Theme.of(context).textTheme.labelMedium
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _MiniTecnico extends StatelessWidget {
  const _MiniTecnico({
    required this.tecnico,
    required this.onVerPerfil,
    required this.onContactar,
    required this.onCerrar,
  });

  final TecnicoCercano tecnico;
  final VoidCallback onVerPerfil;
  final VoidCallback onContactar;
  final VoidCallback onCerrar;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final t = tecnico;
    final oficio = t.oficios.isEmpty ? 'Técnico' : t.oficios.first;
    final forma = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Radios.pequeno),
    );
    return Material(
      color: Colores.tarjeta,
      elevation: 4,
      shadowColor: Colores.tinta.withValues(alpha: 0.2),
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.all(Espacios.m),
        child: Row(
          children: [
            FotoPerfilCaja(
              tamano: 40,
              circular: true,
              rutaFoto: t.fotoRuta,
              iniciales: t.iniciales,
              estiloTexto: textos.labelLarge?.copyWith(
                color: Colores.primario,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(width: Espacios.s + 2),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.nombreCorto,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textos.labelLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          '$oficio · ',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textos.bodySmall?.copyWith(
                            color: Colores.tintaSuave,
                          ),
                        ),
                      ),
                      _Estrella(calificacion: t.calificacion),
                      Text(
                        ' · ${Formatos.kilometros(t.metros.toDouble())}',
                        style: textos.bodySmall?.copyWith(
                          color: Colores.tintaSuave,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: Espacios.s),
            TextButton(
              onPressed: onContactar,
              style: TextButton.styleFrom(shape: forma),
              child: const Text('Contactar'),
            ),
            FilledButton(
              onPressed: onVerPerfil,
              style: FilledButton.styleFrom(
                minimumSize: const Size(0, 40),
                shape: forma,
              ),
              child: const Text('Ver perfil'),
            ),
            IconButton(
              tooltip: 'Cerrar',
              visualDensity: VisualDensity.compact,
              onPressed: onCerrar,
              icon: const Icon(Icons.close_rounded, size: 18),
            ),
          ],
        ),
      ),
    );
  }
}

class _Vacio extends StatelessWidget {
  const _Vacio(this.texto);

  final String texto;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(Espacios.l),
      child: Text(
        texto,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium
            ?.copyWith(color: Colores.tintaSuave),
      ),
    ),
  );
}
