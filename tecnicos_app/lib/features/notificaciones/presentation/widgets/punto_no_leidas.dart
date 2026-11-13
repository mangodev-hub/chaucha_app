import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/notificaciones_provider.dart';

/// Pone un puntito sobre [child] si hay notificaciones sin leer de [tipos].
class PuntoNoLeidas extends ConsumerWidget {
  const PuntoNoLeidas({super.key, required this.tipos, required this.child});

  final List<String> tipos;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lista = ref.watch(notificacionesNoLeidasProvider).value;
    final hay = lista != null && lista.any((n) => tipos.contains(n.tipo));
    return Badge(isLabelVisible: hay, smallSize: 10, child: child);
  }
}
