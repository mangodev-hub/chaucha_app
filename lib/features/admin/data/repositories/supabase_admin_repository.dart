// Implementación de [AdminRepository] con Supabase. Lo que toca a otros
// usuarios pasa por funciones RPC que exigen el rol admin
// (`supabase/migrations/20261109150000_panel_admin.sql`); las lecturas de
// solicitudes y documentos usan las políticas RLS de admin ya existentes.
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/config/auth_redirect.dart';
import '../../../../core/config/env.dart';
import '../../../../core/errors/app_failure.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/storage/storage_service.dart';
import '../../../../core/supabase/supabase_extensions.dart';
import '../../../../core/supabase/supabase_guard.dart';
import '../../../auth/data/models/registro_datos_db.dart';
import '../../../auth/domain/entities/registro_datos.dart';
import '../../../perfil_puntos/data/models/documento_db.dart';
import '../../../perfil_puntos/domain/entities/documento_tecnico.dart';
import '../../domain/entities/resumen_admin.dart';
import '../../domain/entities/revision_tecnico.dart';
import '../../domain/entities/solicitud_admin.dart';
import '../../domain/entities/usuario_admin.dart';
import '../../domain/repositories/admin_repository.dart';
import '../models/admin_models.dart';
import 'registro_sin_sesion.dart';

final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  final env = Env.fromDartDefines();
  return SupabaseAdminRepository(
    ref.watch(supabaseClientProvider),
    ref.watch(storageServiceProvider),
    RegistroSinSesion(
      url: env.supabaseUrl,
      apiKey: env.supabaseAnonKey,
      redireccion: AuthRedirect.url,
    ),
  );
});

class SupabaseAdminRepository implements AdminRepository {
  SupabaseAdminRepository(this._client, this._storage, this._registro);

  static const String _documentos = 'documentos_tecnico';

  final SupabaseClient _client;
  final StorageService _storage;
  final RegistroSinSesion _registro;

  @override
  Future<ResumenAdmin> resumen() {
    return supabaseGuard(() async {
      final json = await _client.rpc<Map<String, dynamic>>('admin_resumen');
      return ResumenAdminModel.desdeJson(json);
    });
  }

  @override
  Future<List<SolicitudAdmin>> solicitudes() {
    return supabaseGuard(() async {
      final filas = await _client
          .from('solicitudes_servicio')
          .select(SolicitudAdminModel.columnas)
          .order('creado_en', ascending: false);
      return filas.map(SolicitudAdminModel.desdeFila).toList();
    });
  }

  @override
  Future<List<UsuarioAdmin>> usuarios() {
    return supabaseGuard(() async {
      final filas = await _client.rpc<List<dynamic>>('admin_usuarios');
      return [
        for (final fila in filas)
          UsuarioAdminModel.desdeFila(fila as Map<String, dynamic>),
      ];
    });
  }

  @override
  Future<void> crearUsuario(RegistroDatos datos) {
    return supabaseGuard(
      () => _registro.registrar(
        email: datos.email.trim(),
        password: datos.password,
        metadatos: datos.toMetadata(),
      ),
    );
  }

  @override
  Future<void> actualizarUsuario(String id, CambiosUsuario cambios) {
    return supabaseGuard(() async {
      await _client.rpc<void>(
        'admin_actualizar_usuario',
        params: {
          'p_id': id,
          'p_nombres': cambios.nombres,
          'p_apellidos': cambios.apellidos,
          'p_ciudad': cambios.ciudad,
        },
      );
    });
  }

  @override
  Future<void> suspenderUsuario(String id, {required bool suspendido}) {
    return supabaseGuard(() async {
      await _client.rpc<void>(
        'admin_suspender_usuario',
        params: {'p_id': id, 'p_suspendido': suspendido},
      );
    });
  }

  @override
  Future<void> eliminarUsuario(String id) {
    return supabaseGuard(() async {
      await _client.rpc<void>('admin_eliminar_usuario', params: {'p_id': id});
    });
  }

  @override
  Future<List<RevisionTecnico>> revisionesPendientes() {
    return supabaseGuard(() async {
      final pendientes = await _client
          .from(_documentos)
          .select('tecnico_id')
          .eq('estado', EstadoDocumento.pendiente.valorDb);
      final ids = {for (final f in pendientes) f['tecnico_id'] as String};
      if (ids.isEmpty) return const [];

      // Todos sus documentos (también los ya aprobados), para verlos juntos.
      final filas = await _client
          .from(_documentos)
          .select(RevisionTecnicoModel.columnas)
          .inFilter('tecnico_id', ids.toList());
      final urls = <String, String>{};
      await Future.wait(
        filas.map((fila) async {
          final ruta = fila['ruta_archivo'] as String;
          try {
            urls[ruta] = await _storage.urlFirmada(
              bucket: Buckets.documentos,
              ruta: ruta,
            );
          } on AppFailure catch (e) {
            // Sin imagen se puede revisar igual (y rechazar).
            debugPrint('No se pudo firmar el documento $ruta: ${e.cause ?? e}');
          }
        }),
      );
      return RevisionTecnicoModel.agrupar(filas, urls);
    });
  }

  @override
  Future<void> revisarDocumento(String documentoId, {required bool aprobado}) {
    return supabaseGuard(() async {
      final estado = aprobado
          ? EstadoDocumento.aprobada
          : EstadoDocumento.rechazada;
      await _client
          .from(_documentos)
          .update({
            'estado': estado.valorDb,
            'revisado_por': _client.uidActual,
            'revisado_en': DateTime.now().toUtc().toIso8601String(),
          })
          .eq('id', documentoId);
    });
  }
}
