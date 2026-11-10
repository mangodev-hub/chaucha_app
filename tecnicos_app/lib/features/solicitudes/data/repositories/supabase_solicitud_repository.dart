// Implementación de [SolicitudRepository] con Supabase (tablas + Storage).
// Ruta de fotos en Storage: `{solicitudId}/{tipo}_{marcaDeTiempo}_{n}.jpg`.
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/geo/geo_mapper.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/storage/storage_service.dart';
import '../../../../core/supabase/supabase_extensions.dart';
import '../../../../core/supabase/supabase_guard.dart';
import '../../domain/entities/foto_solicitud.dart';
import '../../domain/entities/nueva_solicitud.dart';
import '../../domain/entities/solicitud.dart';
import '../../domain/repositories/solicitud_repository.dart';
import '../models/solicitud_db.dart';
import '../models/solicitud_model.dart';

final solicitudRepositoryProvider = Provider<SolicitudRepository>(
  (ref) => SupabaseSolicitudRepository(
    ref.watch(supabaseClientProvider),
    ref.watch(storageServiceProvider),
  ),
);

class SupabaseSolicitudRepository implements SolicitudRepository {
  SupabaseSolicitudRepository(this._client, this._storage);

  static const String _tabla = 'solicitudes_servicio';
  static const String _tablaArchivos = 'solicitud_archivos';

  final SupabaseClient _client;
  final StorageService _storage;

  List<Solicitud> _aEntidades(List<Map<String, dynamic>> filas) =>
      filas.map((fila) => SolicitudModel.fromJson(fila).aEntidad()).toList();

  @override
  Future<List<Solicitud>> misSolicitudes() {
    return supabaseGuard(() async {
      final filas = await _client
          .from(_tabla)
          .select(SolicitudModel.columnas)
          .eq('cliente_id', _client.uidActual)
          .order('creado_en', ascending: false);
      return _aEntidades(filas);
    });
  }

  @override
  Future<void> editar(
    String id, {
    required String descripcion,
    required int oficioId,
    String? direccion,
  }) {
    return supabaseGuard(() async {
      await _client.rpc('editar_solicitud', params: {
        'p_id': id,
        'p_descripcion': descripcion,
        'p_oficio_id': oficioId,
        'p_direccion': direccion,
      });
    });
  }

  @override
  Future<void> eliminar(String id) {
    return supabaseGuard(() async {
      await _client.rpc('eliminar_solicitud', params: {'p_id': id});
    });
  }
  
  @override
  Future<String> crear(NuevaSolicitud nueva) {
    return supabaseGuard(() async {
      final fila = await _client
          .from(_tabla)
          .insert({
            'cliente_id': _client.uidActual,
            'oficio_id': nueva.oficioId,
            'descripcion': nueva.descripcion.trim(),
            'ubicacion': GeoMapper.toPostGisPoint(nueva.ubicacion),
            'direccion_referencia': nueva.direccionReferencia?.trim(),
          })
          .select('id')
          .single();
      final id = fila['id'] as String;
      await _subirFotos(id, TipoArchivo.problema, nueva.fotos);
      return id;
    });
  }

  @override
  Future<List<Solicitud>> abiertasDeOficios(List<int> oficioIds) {
    if (oficioIds.isEmpty) return Future.value(const []);
    return supabaseGuard(() async {
      final filas = await _client
          .from(_tabla)
          .select(SolicitudModel.columnas)
          .inFilter('oficio_id', oficioIds)
          .inFilter('estado', [
            EstadoSolicitud.abierta.valorDb,
            EstadoSolicitud.cotizada.valorDb,
          ])
          .order('creado_en', ascending: false);
      return _aEntidades(filas);
    });
  }

  @override
  Future<List<Solicitud>> misTrabajos() {
    return supabaseGuard(() async {
      final aceptadas = await _client
          .from('cotizaciones')
          .select('solicitud_id')
          .eq('tecnico_id', _client.uidActual)
          .eq('estado', 'aceptada');
      final ids = aceptadas.map((f) => f['solicitud_id'] as String).toList();
      if (ids.isEmpty) return const <Solicitud>[];

      final filas = await _client
          .from(_tabla)
          .select(SolicitudModel.columnas)
          .inFilter('id', ids)
          .order('creado_en', ascending: false);
      return _aEntidades(filas);
    });
  }

  @override
  Future<List<Solicitud>> porIds(List<String> ids) {
    if (ids.isEmpty) return Future.value(const <Solicitud>[]);
    return supabaseGuard(() async {
      final filas = await _client
          .from(_tabla)
          .select(SolicitudModel.columnas)
          .inFilter('id', ids);
      return _aEntidades(filas);
    });
  }

  @override
  Future<void> marcarTerminada(String solicitudId, List<Uint8List> evidencias) {
    return supabaseGuard(() async {
      await _subirFotos(solicitudId, TipoArchivo.evidencia, evidencias);
      await _actualizarEstado(solicitudId, EstadoSolicitud.porConfirmar);
    });
  }

  @override
  Future<Solicitud> obtener(String id) {
    return supabaseGuard(() async {
      final fila = await _client
          .from(_tabla)
          .select(SolicitudModel.columnas)
          .eq('id', id)
          .single();
      return SolicitudModel.fromJson(fila).aEntidad();
    });
  }

  @override
  Future<List<FotoSolicitud>> fotos(String solicitudId) {
    return supabaseGuard(() async {
      final filas = await _client
          .from(_tablaArchivos)
          .select('tipo, ruta')
          .eq('solicitud_id', solicitudId)
          .order('creado_en');
      final fotos = await Future.wait(
        filas.map((fila) async {
          final ruta = fila['ruta'] as String;
          try {
            final url = await _storage.urlFirmada(
              bucket: Buckets.solicitudes,
              ruta: ruta,
            );
            return FotoSolicitud(
              tipo: TipoArchivoDb.desdeDb(fila['tipo']),
              url: url,
            );
          } on AppFailure catch (e) {
            // Una foto que no se puede firmar (por ejemplo, el archivo ya no
            // existe) no debe tumbar todo el detalle: se omite.
            debugPrint('No se pudo firmar la foto $ruta: ${e.cause ?? e}');
            return null;
          }
        }),
      );
      return fotos.nonNulls.toList();
    });
  }

  @override
  Future<void> cambiarEstado(String solicitudId, EstadoSolicitud estado) {
    return supabaseGuard(() => _actualizarEstado(solicitudId, estado));
  }

  Future<void> _actualizarEstado(String id, EstadoSolicitud estado) async {
    await _client.from(_tabla).update({'estado': estado.valorDb}).eq('id', id);
  }

  Future<void> _subirFotos(
    String solicitudId,
    TipoArchivo tipo,
    List<Uint8List> fotos,
  ) async {
    final marca = DateTime.now().millisecondsSinceEpoch;
    for (var i = 0; i < fotos.length; i++) {
      final ruta = '$solicitudId/${tipo.valorDb}_${marca}_$i.jpg';
      await _storage.subirImagen(
        bucket: Buckets.solicitudes,
        ruta: ruta,
        bytes: fotos[i],
      );
      await _client.from(_tablaArchivos).insert({
        'solicitud_id': solicitudId,
        'tipo': tipo.valorDb,
        'ruta': ruta,
      });
    }
  }
}
