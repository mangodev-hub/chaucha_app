import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/providers/core_providers.dart';
import '../../../../core/storage/storage_service.dart';
import '../../../../core/supabase/supabase_extensions.dart';
import '../../../../core/supabase/supabase_guard.dart';
import '../../domain/entities/datos_identidad.dart';
import '../../domain/entities/documento_tecnico.dart';
import '../../domain/entities/verificacion.dart';
import '../../domain/repositories/documento_repository.dart';
import '../models/documento_db.dart';
import '../models/documento_tecnico_model.dart';

final documentoRepositoryProvider = Provider<DocumentoRepository>(
  (ref) => SupabaseDocumentoRepository(
    ref.watch(supabaseClientProvider),
    ref.watch(storageServiceProvider),
  ),
);

class SupabaseDocumentoRepository implements DocumentoRepository {
  SupabaseDocumentoRepository(this._client, this._storage);

  static const String _tabla = 'documentos_tecnico';

  final SupabaseClient _client;
  final StorageService _storage;

  @override
  Future<Verificacion> miVerificacion() {
    return supabaseGuard(() async {
      final filas = await _client
          .from(_tabla)
          .select(DocumentoTecnicoModel.columnas)
          .eq('tecnico_id', _client.uidActual);
      final vigentes = Verificacion.vigentes(
        filas
            .map((fila) => DocumentoTecnicoModel.fromJson(fila).aEntidad())
            .toList(),
      );

      // Solo se firman las URLs de los documentos vigentes.
      final conUrl = await Future.wait(
        vigentes.values.map(
          (doc) async => doc.conUrl(
            await _storage.urlFirmada(
              bucket: Buckets.documentos,
              ruta: doc.ruta,
            ),
          ),
        ),
      );
      return Verificacion({
        for (final doc in conUrl) doc.tipo: doc,
      }, camposNoCoinciden: await _camposNoCoinciden(vigentes));
    });
  }

  /// Campos que no coincidieron en la última validación, si fue de estas mismas
  /// fotos y siguen pendientes.
  Future<Set<CampoIdentidad>> _camposNoCoinciden(
    Map<TipoDocumento, DocumentoTecnico> vigentes,
  ) async {
    final frente = vigentes[TipoDocumento.cedulaFrontal];
    final reverso = vigentes[TipoDocumento.cedulaPosterior];
    if (frente?.estado != EstadoDocumento.pendiente ||
        reverso?.estado != EstadoDocumento.pendiente) {
      return const {};
    }
    final ultima = await _client
        .from('comparaciones_rostro')
        .select('decision, datos')
        .eq('usuario_id', _client.uidActual)
        .order('creado_en', ascending: false)
        .limit(1)
        .maybeSingle();
    final datos = ultima?['datos'] as Map<String, dynamic>?;
    if (ultima?['decision'] != 'datos' ||
        datos?['frente'] != frente!.ruta ||
        datos?['reverso'] != reverso!.ruta) {
      return const {};
    }
    return {
      for (final c in (datos!['campos'] as List? ?? const []))
        ?CampoIdentidad.desdeDb(c as String),
    };
  }

  @override
  Future<DatosIdentidad> misDatos() {
    return supabaseGuard(() async {
      final uid = _client.uidActual;
      final (usuario, identidad) = (
        await _client
            .from('usuarios')
            .select('nombres, apellidos')
            .eq('id', uid)
            .single(),
        await _client
            .from('identidades')
            .select('cedula, codigo_dactilar')
            .eq('usuario_id', uid)
            .maybeSingle(),
      );
      return DatosIdentidad(
        nombres: usuario['nombres'] as String? ?? '',
        apellidos: usuario['apellidos'] as String? ?? '',
        cedula: identidad?['cedula'] as String? ?? '',
        codigoDactilar: identidad?['codigo_dactilar'] as String?,
      );
    });
  }

  @override
  Future<void> corregirDatos(DatosIdentidad datos) {
    return supabaseGuard(() async {
      await _client.rpc<void>(
        'corregir_datos_identidad',
        params: {
          'p_nombres': datos.nombres.trim(),
          'p_apellidos': datos.apellidos.trim(),
          'p_cedula': datos.cedula.trim(),
          'p_codigo_dactilar': datos.codigoDactilar?.trim(),
        },
      );
    });
  }

  @override
  Future<void> subir(TipoDocumento tipo, Uint8List bytes) {
    return supabaseGuard(() async {
      final uid = _client.uidActual;
      final ruta =
          '$uid/${tipo.valorDb}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      await _storage.subirImagen(
        bucket: Buckets.documentos,
        ruta: ruta,
        bytes: bytes,
      );
      final previo = await _client
          .from(_tabla)
          .select('tipo')
          .eq('tecnico_id', uid)
          .eq('tipo', tipo.valorDb)
          .maybeSingle();
      if (previo == null) {
        await _client.from(_tabla).insert({
          'tecnico_id': uid,
          'tipo': tipo.valorDb,
          'ruta_archivo': ruta,
        });
      } else {
        await _client
            .from(_tabla)
            .update({
              'ruta_archivo': ruta,
              'estado': 'pendiente',
              'revisado_por': null,
              'revisado_en': null,
            })
            .eq('tecnico_id', uid)
            .eq('tipo', tipo.valorDb);
      }
    });
  }

  @override
  Future<void> validarIdentidad() {
    return supabaseGuard(() async {
      await _client.functions
          .invoke('comparar-rostro-cedula')
          .timeout(const Duration(seconds: 90));
    });
  }
}
