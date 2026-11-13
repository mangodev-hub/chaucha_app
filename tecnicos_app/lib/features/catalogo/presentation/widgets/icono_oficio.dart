import 'package:flutter/material.dart';

/// Ícono de cada oficio del catálogo (por nombre).
IconData iconoOficio(String nombre) {
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
