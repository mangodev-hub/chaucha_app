// Perfil público de un técnico, por id (lo abre el cliente desde una oferta).
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/supabase/supabase_guard.dart';
import '../../data/models/perfil_publico_model.dart';
import '../../data/repositories/supabase_perfil_repository.dart';
import '../../domain/entities/perfil_publico.dart';

final perfilPublicoProvider = FutureProvider.autoDispose
    .family<PerfilPublico, String>(
      (ref, tecnicoId) =>
          ref.watch(perfilRepositoryProvider).perfilPublico(tecnicoId),
    );

/// Perfil público de un cliente (lo abre el técnico desde una solicitud).
final perfilClientePublicoProvider = FutureProvider.autoDispose
    .family<PerfilPublico, String>(
      (ref, clienteId) => supabaseGuard(() async {
        final cliente = ref.watch(supabaseClientProvider);
        final resultados = await Future.wait<Object?>([
          cliente
              .from('usuarios')
              .select(PerfilPublicoModel.columnasCliente)
              .eq('id', clienteId)
              .maybeSingle(),
          cliente
              .from('resenas')
              .select(PerfilPublicoModel.columnasResenas)
              .eq('destinatario_id', clienteId)
              .order('creado_en', ascending: false)
              .limit(PerfilPublicoModel.limiteResenas),
        ]);
        final usuario = resultados[0] as Map<String, dynamic>?;
        if (usuario == null) {
          throw const AppFailure('No encontramos el perfil de este cliente.');
        }
        return PerfilPublicoModel.desdeCliente(
          usuario,
          resultados[1]! as List<Map<String, dynamic>>,
        );
      }),
    );
