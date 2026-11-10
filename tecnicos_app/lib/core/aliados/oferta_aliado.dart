import 'package:flutter/material.dart';

import '../theme/tokens.dart';

class OfertaAliado {
  const OfertaAliado({
    required this.patrocinador,
    required this.titulo,
    required this.descripcion,
    required this.url,
    required this.icono,
    required this.color,
    this.accion = 'Ver oferta',
  });

  final String patrocinador;
  final String titulo;
  final String descripcion;
  final String url;
  final String accion;
  final IconData icono;
  final Color color;
}

/// Ofertas de aliados de ejemplo. Más adelante pueden venir de una tabla en Supabase.
const ofertasAliadosDemo = <OfertaAliado>[
  OfertaAliado(
    patrocinador: 'Ferretería El Constructor',
    titulo: '10% de descuento en materiales',
    descripcion:
        'Tuberías, cables y pintura para tu trabajo. Presenta tu cotización.',
    url: 'https://example.com/ferreteria',
    icono: Icons.hardware,
    color: Colores.primarioProfundo,
  ),
  OfertaAliado(
    patrocinador: 'Pinturas del Valle',
    titulo: 'Renueva tus paredes',
    descripcion: 'Galón de pintura interior con envío gratis en Quito.',
    url: 'https://example.com/pinturas',
    icono: Icons.format_paint,
    color: Colores.acentoOscuro,
  ),
  OfertaAliado(
    patrocinador: 'Seguros Hogar Seguro',
    titulo: 'Protege tu casa desde \$3 al mes',
    descripcion: 'Cobertura contra daños eléctricos y fugas de agua.',
    url: 'https://example.com/seguros',
    icono: Icons.shield_outlined,
    color: Colores.avisoOscuro,
    accion: 'Cotizar',
  ),
];
