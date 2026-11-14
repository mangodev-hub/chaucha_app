// Todo es "mejor esfuerzo": si la función falla, no se muestra nada.
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../providers/core_providers.dart';

class EstadoPresencia {
  const EstadoPresencia({required this.enLinea, this.visto});

  static const desconocido = EstadoPresencia(enLinea: false);

  final bool enLinea;

  /// Último latido (para "Activo hace X"); null si nunca se conectó.
  final DateTime? visto;
}

class PresenciaRepository {
  PresenciaRepository(this._client);

  final SupabaseClient _client;

  static const String _funcion = 'presencia';

  bool get _conSesion => _client.auth.currentSession != null;

  Future<void> latido({String? conversacionId}) async {
    if (!_conSesion) return;
    try {
      await _client.functions.invoke(
        _funcion,
        body: {'conversacion_id': ?conversacionId},
      );
    } on Object {
      // Sin red o sin Redis: el siguiente latido lo intenta de nuevo.
    }
  }

  Future<void> salir() async {
    if (!_conSesion) return;
    try {
      await _client.functions.invoke(_funcion, body: {'salir': true});
    } on Object {
      // Si falla, la presencia vence sola a los 90 s.
    }
  }

  Future<Map<String, EstadoPresencia>> estados(List<String> ids) async {
    if (ids.isEmpty || !_conSesion) return const {};
    final r = await _client.functions.invoke(
      _funcion,
      method: HttpMethod.get,
      queryParameters: {'ids': ids.join(',')},
    );
    final mapa = r.data is Map ? (r.data as Map)['estados'] : null;
    if (mapa is! Map) return const {};
    return {
      for (final MapEntry(:key, :value) in mapa.entries)
        if (value is Map)
          '$key': EstadoPresencia(
            enLinea: value['en_linea'] == true,
            visto: DateTime.tryParse('${value['visto'] ?? ''}')?.toLocal(),
          ),
    };
  }

  /// Técnicos verificados en línea a [radio] metros (solo el conteo).
  Future<int> tecnicosEnLinea({
    required double lat,
    required double lng,
    int? oficioId,
    int radio = 5000,
  }) async {
    if (!_conSesion) return 0;
    final r = await _client.functions.invoke(
      _funcion,
      method: HttpMethod.get,
      queryParameters: {
        'lat': '$lat',
        'lng': '$lng',
        'radio': '$radio',
        'oficio': ?oficioId?.toString(),
      },
    );
    final total = r.data is Map ? (r.data as Map)['total'] : null;
    return total is num ? total.toInt() : 0;
  }
}

final presenciaRepositoryProvider = Provider<PresenciaRepository>(
  (ref) => PresenciaRepository(ref.watch(supabaseClientProvider)),
);

/// La conversación que está en pantalla (la fija `ChatPanel`).
class ConversacionAbierta extends Notifier<String?> {
  @override
  String? build() => null;

  void abrir(String id) => state = id;

  void cerrar(String id) {
    if (state == id) state = null;
  }
}

final conversacionAbiertaProvider =
    NotifierProvider<ConversacionAbierta, String?>(ConversacionAbierta.new);

/// Latidos mientras la app está en primer plano. Lo mantiene vivo el shell.
final presenciaProvider = Provider.autoDispose<void>((ref) {
  const cada = Duration(seconds: 30);
  final repo = ref.watch(presenciaRepositoryProvider);
  Timer? reloj;

  void latir() => unawaited(
    repo.latido(conversacionId: ref.read(conversacionAbiertaProvider)),
  );

  void encender() {
    reloj?.cancel();
    latir();
    reloj = Timer.periodic(cada, (_) => latir());
  }

  void apagar() {
    reloj?.cancel();
    reloj = null;
    unawaited(repo.salir());
  }

  // Abrir o cerrar un chat se avisa enseguida (para no duplicar el push).
  ref.listen(conversacionAbiertaProvider, (_, _) {
    if (reloj != null) latir();
  });

  final ciclo = AppLifecycleListener(onResume: encender, onHide: apagar);
  encender();

  ref.onDispose(() {
    ciclo.dispose();
    reloj?.cancel();
  });
});

/// Estado de una persona (chat, perfil). Se vuelve a pedir cada 30 s.
final estadoPresenciaProvider = FutureProvider.autoDispose
    .family<EstadoPresencia, String>((ref, usuarioId) async {
      final temporizador = Timer(
        const Duration(seconds: 30),
        ref.invalidateSelf,
      );
      ref.onDispose(temporizador.cancel);
      try {
        final estados = await ref.watch(presenciaRepositoryProvider).estados([
          usuarioId,
        ]);
        return estados[usuarioId] ?? EstadoPresencia.desconocido;
      } on Object {
        return EstadoPresencia.desconocido;
      }
    });

/// Cuántos técnicos verificados (del oficio, si se indica) están en línea
/// cerca de un punto. 0 si no se puede saber.
final tecnicosEnLineaProvider = FutureProvider.autoDispose
    .family<int, ({double lat, double lng, int? oficioId, int radio})>((
      ref,
      p,
    ) async {
      final temporizador = Timer(
        const Duration(seconds: 60),
        ref.invalidateSelf,
      );
      ref.onDispose(temporizador.cancel);
      try {
        return await ref
            .watch(presenciaRepositoryProvider)
            .tecnicosEnLinea(
              lat: p.lat,
              lng: p.lng,
              oficioId: p.oficioId,
              radio: p.radio,
            );
      } on Object {
        return 0;
      }
    });
