import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../core/widgets/etiqueta_sector.dart';
import '../providers/perfil_tecnico_provider.dart';

class Disponibilidad extends Notifier<bool> {
  @override
  bool build() => true;

  void alternar() => state = !state;
}

final disponibleProvider = NotifierProvider<Disponibilidad, bool>(
  Disponibilidad.new,
);

/// Lo del técnico en la barra superior blanca: disponibilidad y sector.
class BarraTecnico extends ConsumerWidget {
  const BarraTecnico({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final punto = ref.watch(perfilTecnicoProvider).value?.ubicacionActual;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const PildoraDisponible(),
        const SizedBox(width: Espacios.l),
        SectorEnBarra(punto: punto),
      ],
    );
  }
}

/// Píldora verde suave con un interruptor chico. Al tocarla alterna.
class PildoraDisponible extends ConsumerWidget {
  const PildoraDisponible({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activo = ref.watch(disponibleProvider);
    final duracion = Movimiento.de(context, Movimiento.normal);
    final borde = BorderRadius.circular(Radios.pildora);
    final color = activo ? Colores.primario : Colores.tintaSuave;
    return Tooltip(
      message: activo
          ? 'Recibes solicitudes nuevas. Toca para pausar.'
          : 'No recibes solicitudes nuevas. Toca para activar.',
      child: Semantics(
        toggled: activo,
        label: 'Disponible',
        child: Material(
          color: activo ? Colores.primarioSuave : Colores.superficie,
          borderRadius: borde,
          child: InkWell(
            onTap: ref.read(disponibleProvider.notifier).alternar,
            borderRadius: borde,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(6, 6, 14, 6),
              child: ExcludeSemantics(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      duration: duracion,
                      width: 34,
                      height: 20,
                      padding: const EdgeInsets.all(2),
                      alignment: activo
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      decoration: BoxDecoration(
                        color: activo
                            ? Colores.primarioVivo
                            : Colores.superficieFuerte,
                        borderRadius: borde,
                      ),
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: const BoxDecoration(
                          color: Colores.tarjeta,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    const SizedBox(width: Espacios.s),
                    Text(
                      activo ? 'Disponible' : 'No disponible',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontSize: 13,
                        color: color,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
