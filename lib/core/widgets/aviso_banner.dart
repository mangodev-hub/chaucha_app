import 'package:flutter/material.dart';

import '../theme/tokens.dart';

enum TipoAviso { info, exito, aviso, error }

extension on TipoAviso {
  Color get color => switch (this) {
    TipoAviso.info => Colores.primario,
    TipoAviso.exito => Colores.acento,
    TipoAviso.aviso => Colores.aviso,
    TipoAviso.error => Colores.error,
  };

  Color get fondo => switch (this) {
    TipoAviso.info => Colores.primarioSuave,
    TipoAviso.exito => Colores.acentoSuave,
    TipoAviso.aviso => Colores.avisoSuave,
    TipoAviso.error => Colores.errorSuave,
  };

  Color get texto => switch (this) {
    TipoAviso.info => Colores.primarioOscuro,
    TipoAviso.exito => Colores.acentoOscuro,
    TipoAviso.aviso => Colores.avisoOscuro,
    TipoAviso.error => Colores.errorOscuro,
  };

  IconData get icono => switch (this) {
    TipoAviso.info => Icons.info_outline,
    TipoAviso.exito => Icons.check_circle_outline,
    TipoAviso.aviso => Icons.warning_amber_rounded,
    TipoAviso.error => Icons.error_outline,
  };
}

class AvisoBanner extends StatelessWidget {
  const AvisoBanner({
    super.key,
    required this.mensaje,
    this.tipo = TipoAviso.info,
    this.titulo,
    this.icono,
    this.compacto = false,
  });

  final String mensaje;
  final TipoAviso tipo;
  final String? titulo;

  /// Si es null, se usa el ícono del [tipo].
  final IconData? icono;

  /// Una sola línea de texto pequeño (etiquetas informativas).
  final bool compacto;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final titulo = this.titulo;
    return Semantics(
      container: true,
      liveRegion: tipo == TipoAviso.error,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: compacto ? Espacios.m : Espacios.l,
          vertical: compacto ? Espacios.s : Espacios.m + 2,
        ),
        decoration: BoxDecoration(
          color: tipo.fondo,
          borderRadius: BorderRadius.circular(Radios.medio),
        ),
        child: Row(
          crossAxisAlignment: compacto
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          children: [
            Icon(
              icono ?? tipo.icono,
              color: tipo.color,
              size: compacto ? 18 : 22,
            ),
            SizedBox(width: compacto ? Espacios.s : Espacios.m),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (titulo != null) ...[
                    Text(
                      titulo,
                      style: textos.titleSmall?.copyWith(color: tipo.texto),
                    ),
                    const SizedBox(height: 2),
                  ],
                  Text(
                    mensaje,
                    style: (compacto ? textos.labelMedium : textos.bodyMedium)
                        ?.copyWith(
                          color: tipo.texto,
                          fontWeight: compacto ? FontWeight.w600 : null,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
