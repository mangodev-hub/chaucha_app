// Configuración del entorno, leída en tiempo de compilación.
class Env {
  const Env._({required this.supabaseUrl, required this.supabaseAnonKey});

  final String supabaseUrl;

  final String supabaseAnonKey;

  factory Env.fromDartDefines() {
    const url = String.fromEnvironment('SUPABASE_URL');
    const anonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

    if (url.isEmpty || anonKey.isEmpty) {
      throw StateError(
        'Faltan SUPABASE_URL o SUPABASE_ANON_KEY. '
        'Ejecuta: flutter run --dart-define-from-file=env.json',
      );
    }
    return const Env._(supabaseUrl: url, supabaseAnonKey: anonKey);
  }
}
