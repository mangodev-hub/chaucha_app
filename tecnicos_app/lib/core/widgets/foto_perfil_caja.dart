import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/core_providers.dart';
import '../storage/storage_service.dart';
import '../theme/tokens.dart';

/// Foto de perfil (bucket público `perfiles`) en una caja cuadrada o
/// circular. Sin foto, o si no carga, muestra las [iniciales].
class FotoPerfilCaja extends ConsumerWidget {
  const FotoPerfilCaja({
    super.key,
    required this.iniciales,
    required this.tamano,
    this.rutaFoto,
    this.circular = false,
    this.borde,
    this.sombra,
    this.estiloTexto,
  });

  final String iniciales;
  final String? rutaFoto;
  final double tamano;
  final bool circular;
  final BoxBorder? borde;
  final List<BoxShadow>? sombra;
  final TextStyle? estiloTexto;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final url = rutaFoto == null
        ? null
        : ref
              .watch(storageServiceProvider)
              .urlPublica(bucket: Buckets.perfiles, ruta: rutaFoto!);
    final radio = circular ? null : BorderRadius.circular(Radios.medio);
    final textoIniciales = Center(
      child: Text(
        iniciales,
        style: estiloTexto ?? const TextStyle(color: Colores.primarioOscuro),
      ),
    );

    return Container(
      width: tamano,
      height: tamano,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colores.primarioSuave,
        shape: circular ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: radio,
        border: borde,
        boxShadow: sombra,
      ),
      child: url == null
          ? textoIniciales
          : Image.network(
              url,
              fit: BoxFit.cover,
              width: tamano,
              height: tamano,
              errorBuilder: (_, _, _) => textoIniciales,
            ),
    );
  }
}
