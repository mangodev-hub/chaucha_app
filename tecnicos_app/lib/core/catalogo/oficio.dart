// Fila del catálogo `oficios` (Plomería, Electricidad...).
import 'package:supabase_flutter/supabase_flutter.dart';

import '../supabase/supabase_guard.dart';
import '../utils/json_utils.dart';





class Oficio {
  const Oficio({required this.id, required this.nombre});

  factory Oficio.fromJson(Map<String, dynamic> json) =>
      Oficio(id: aInt(json['id']), nombre: json['nombre'] as String);

  final int id;
  final String nombre;
}

abstract interface class OficioService {
  Future<List<Oficio>> listar();
}

class SupabaseOficioService implements OficioService {
  SupabaseOficioService(this._client);

  final SupabaseClient _client;
  List<Oficio>? _cache; 

  @override
  Future<List<Oficio>> listar() async {
    final cache = _cache;
    if (cache != null) return cache;
    return supabaseGuard(() async {
      final filas =
          await _client.from('oficios').select('id, nombre').order('nombre');
      return _cache = filas.map(Oficio.fromJson).toList();
    });
  }
}
