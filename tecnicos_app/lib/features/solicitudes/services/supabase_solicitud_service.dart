// Ruta en Storage: `{solicitudId}/{tipo}_{marcaDeTiempo}_{n}.jpg`.
import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/geo/geo_mapper.dart';
import '../../../core/storage/storage_service.dart';
import '../../../core/supabase/supabase_extensions.dart';
import '../../../core/supabase/supabase_guard.dart';
import '../models/solicitud.dart';
import 'solicitud_service.dart';

class SupabaseSolicitudService implements SolicitudService {
  SupabaseSolicitudService(this._client, this._storage);

  static const String _tabla = 'solicitudes_servicio';
  static const String _tablaArchivos = 'solicitud_archivos';

  final SupabaseClient _client;
  final StorageService _storage;

  @override
  Future<List<Solicitud>> misSolicitudes() {
    return supabaseGuard(() async {
      final filas = await _client
          .from(_tabla)
          .select(Solicitud.columnas)
          .eq('cliente_id', _client.uidActual)
          .order('creado_en', ascending: false);
      return filas.map(Solicitud.fromJson).toList();
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
          .select(Solicitud.columnas)
          .inFilter('oficio_id', oficioIds)
          .inFilter('estado', [
            EstadoSolicitud.abierta.valorDb,
            EstadoSolicitud.cotizada.valorDb,
          ])
          .order('creado_en', ascending: false);
      return filas.map(Solicitud.fromJson).toList();
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
          .select(Solicitud.columnas)
          .inFilter('id', ids)
          .order('creado_en', ascending: false);
      return filas.map(Solicitud.fromJson).toList();
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
          .select(Solicitud.columnas)
          .eq('id', id)
          .single();
      return Solicitud.fromJson(fila);
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
      return Future.wait(filas.map((fila) async {
        final tipo = fila['tipo'] == TipoArchivo.evidencia.valorDb
            ? TipoArchivo.evidencia
            : TipoArchivo.problema;
        final url = await _storage.urlFirmada(
          bucket: Buckets.solicitudes,
          ruta: fila['ruta'] as String,
        );
        return FotoSolicitud(tipo: tipo, url: url);
      }));
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
