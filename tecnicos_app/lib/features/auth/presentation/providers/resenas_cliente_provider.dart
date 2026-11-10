import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/core_providers.dart';
import '../../../../core/supabase/supabase_guard.dart';
import '../../../../core/utils/json_utils.dart';
import '../../../perfil_puntos/data/models/perfil_publico_model.dart';
import '../../../perfil_puntos/domain/entities/perfil_publico.dart';
import 'sesion_provider.dart';

class ResumenResenas {
  const ResumenResenas(this.resenas);

  final List<ResenaPublica> resenas;

  int get total => resenas.length;

  double get promedio => total == 0
      ? 0
      : resenas.fold<int>(0, (s, r) => s + r.calificacion) / total;
}

final resenasRecibidasProvider =
    FutureProvider.autoDispose<ResumenResenas>((ref) {
      final uid = ref.watch(usuarioActualProvider.select((u) => u?.id));
      if (uid == null) return const ResumenResenas([]);
      return supabaseGuard(() async {
        final filas = await ref
            .watch(supabaseClientProvider)
            .from('resenas')
            .select(PerfilPublicoModel.columnasResenas)
            .eq('destinatario_id', uid)
            .order('creado_en', ascending: false)
            .limit(50);
        return ResumenResenas([
          for (final f in filas)
            ResenaPublica(
              autor: PerfilPublicoModel.nombreCorto(anidado(f['autor'])),
              calificacion: aInt(f['calificacion']),
              comentario: (f['comentario'] as String?)?.trim(),
              creadoEn: aFecha(f['creado_en']),
            ),
        ]);
      });
    });