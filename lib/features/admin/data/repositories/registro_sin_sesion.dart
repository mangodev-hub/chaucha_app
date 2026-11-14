import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/app_failure.dart';

class RegistroSinSesion {
  RegistroSinSesion({
    required this._url,
    required this._apiKey,
    required this._redireccion,
    http.Client? cliente,
  }) : _cliente = cliente ?? http.Client();

  final String _url;
  final String _apiKey;
  final String _redireccion;
  final http.Client _cliente;

  /// Crea la cuenta con [metadatos] (los mismos del registro de la app).
  Future<void> registrar({
    required String email,
    required String password,
    required Map<String, dynamic> metadatos,
  }) async {
    final uri = Uri.parse('$_url/auth/v1/signup')
        .replace(queryParameters: {'redirect_to': _redireccion});
    final respuesta = await _cliente.post(
      uri,
      headers: {'apikey': _apiKey, 'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'data': metadatos,
      }),
    );
    final cuerpo = _leer(respuesta.body);

    if (respuesta.statusCode >= 400) {
      throw AuthException(
        (cuerpo['msg'] ??
                cuerpo['error_description'] ??
                cuerpo['message'] ??
                'Error ${respuesta.statusCode}')
            .toString(),
        statusCode: '${respuesta.statusCode}',
        code: (cuerpo['error_code'] ?? cuerpo['code'])?.toString(),
      );
    }

    final usuario = cuerpo['user'] is Map<String, dynamic>
        ? cuerpo['user'] as Map<String, dynamic>
        : cuerpo;
    final identidades = usuario['identities'];
    if (identidades is List && identidades.isEmpty) {
      throw const AppFailure('Ya existe una cuenta con ese correo.');
    }
  }

  static Map<String, dynamic> _leer(String cuerpo) {
    try {
      final json = jsonDecode(cuerpo);
      return json is Map<String, dynamic> ? json : const {};
    } on FormatException {
      return const {};
    }
  }
}
