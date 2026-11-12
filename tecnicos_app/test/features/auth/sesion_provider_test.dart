import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tecnicos_app/core/errors/app_failure.dart';
import 'package:tecnicos_app/features/auth/data/repositories/supabase_auth_repository.dart';
import 'package:tecnicos_app/features/auth/data/repositories/supabase_usuario_repository.dart';
import 'package:tecnicos_app/features/auth/domain/entities/registro_datos.dart';
import 'package:tecnicos_app/features/auth/domain/entities/registro_resultado.dart';
import 'package:tecnicos_app/features/auth/domain/entities/rol.dart';
import 'package:tecnicos_app/features/auth/domain/entities/sesion_estado.dart';
import 'package:tecnicos_app/features/auth/domain/entities/usuario.dart';
import 'package:tecnicos_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:tecnicos_app/features/auth/domain/repositories/usuario_repository.dart';
import 'package:tecnicos_app/features/auth/presentation/providers/sesion_provider.dart';

class _AuthFalso implements AuthRepository {
  final cambios = StreamController<String?>.broadcast();
  int cierres = 0;
  @override
  Stream<void> get recuperacionIniciada => const Stream.empty();

  @override
  String? get usuarioId => null;

  @override
  Future<void> enviarRecuperacion(String email) async {}

  @override
  Future<void> reenviarConfirmacion(String email) async {}

  @override
  Future<void> cambiarContrasena(String nueva) async {}
  @override
  Future<void> iniciarConGoogle() async {}

  @override
  Stream<String?> get cambiosDeSesion => cambios.stream;

  @override
  Future<void> cerrarSesion() async {
    cierres++;
    cambios.add(null);
  }

  @override
  Future<void> iniciarSesion({
    required String email,
    required String password,
  }) async {}

  @override
  Future<RegistroResultado> registrar(RegistroDatos datos) async =>
      RegistroResultado.sesionIniciada;

  @override
  String? get correoActual => null;

  @override
  bool get usaContrasena => true;

  @override
  Future<void> cambiarContrasenaConActual({
    required String actual,
    required String nueva,
  }) async {}

  @override
  Future<void> cambiarCorreo({
    required String contrasena,
    required String nuevo,
  }) async {}

  @override
  Future<void> cerrarSesionEnTodos() async {}
}

class _UsuariosFalso implements UsuarioRepository {
  @override
  Future<void> completarPerfil({
    required String cedula,
    required String codigoDactilar,
    required Rol rol,
  }) async {}

  final Map<String, Object?> respuestas = {};
  AppFailure? falla;

  @override
  Future<Usuario?> obtenerPorId(String id) async {
    final falla = this.falla;
    if (falla != null) throw falla;
    final respuesta = respuestas[id];
    if (respuesta is Completer<Usuario?>) return respuesta.future;
    return respuesta as Usuario?;
  }

  @override
  Future<String?> registrarSelfie({required String ruta}) async => null;
}

Usuario _usuario(String id, {Rol rol = Rol.cliente}) => Usuario(
  id: id,
  rol: rol,
  nombres: 'Ana',
  apellidos: 'Pérez',
  creadoEn: DateTime(2026),
);

/// Deja correr los eventos del stream y los `await` pendientes.
Future<void> _esperar() async {
  for (var i = 0; i < 5; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

void main() {
  late _AuthFalso auth;
  late _UsuariosFalso usuarios;
  late ProviderContainer container;

  setUp(() {
    auth = _AuthFalso();
    usuarios = _UsuariosFalso();
    container = ProviderContainer.test(
      overrides: [
        authRepositoryProvider.overrideWithValue(auth),
        usuarioRepositoryProvider.overrideWithValue(usuarios),
      ],
    );
    container.listen(sesionProvider, (_, _) {});
  });

  tearDown(() => auth.cambios.close());

  SesionEstado estado() => container.read(sesionProvider);

  test('arranca verificando', () {
    expect(estado(), isA<SesionVerificando>());
  });

  test('recargarUsuario actualiza el perfil de la sesión', () async {
    usuarios.respuestas['u1'] = _usuario('u1');
    auth.cambios.add('u1');
    await _esperar();
    expect(container.read(usuarioActualProvider)?.rol, Rol.cliente);

    usuarios.respuestas['u1'] = _usuario('u1', rol: Rol.tecnico);
    await container.read(sesionProvider.notifier).recargarUsuario();

    expect(container.read(usuarioActualProvider)?.rol, Rol.tecnico);
  });

  test('sin usuario pasa a SinSesion sin aviso', () async {
    auth.cambios.add(null);
    await _esperar();

    expect(estado(), isA<SinSesion>());
    expect((estado() as SinSesion).aviso, isNull);
  });

  test('con perfil pasa a ConSesion y expone el usuario', () async {
    usuarios.respuestas['u1'] = _usuario('u1', rol: Rol.tecnico);
    auth.cambios.add('u1');
    await _esperar();

    expect(estado(), isA<ConSesion>());
    expect(container.read(usuarioActualProvider)?.id, 'u1');
    expect(container.read(usuarioActualProvider)?.rol, Rol.tecnico);
  });

  test('sin perfil cierra sesión y conserva el aviso', () async {
    usuarios.respuestas['u1'] = null;
    auth.cambios.add('u1');
    await _esperar();

    expect(auth.cierres, 1);
    // El evento null que llega tras cerrar sesión mantiene el aviso.
    final sinSesion = estado() as SinSesion;
    expect(sinSesion.aviso, contains('no tiene un perfil'));
    expect(container.read(usuarioActualProvider), isNull);
  });

  test('si falla la carga del perfil cierra sesión con el mensaje', () async {
    usuarios.falla = const AppFailure('Sin conexión.');
    auth.cambios.add('u1');
    await _esperar();

    expect(auth.cierres, 1);
    expect((estado() as SinSesion).aviso, 'Sin conexión.');
  });

  test('descarta la respuesta de un cambio de sesión anterior', () async {
    final lento = Completer<Usuario?>();
    usuarios.respuestas['u1'] = lento;
    usuarios.respuestas['u2'] = _usuario('u2');

    auth.cambios.add('u1');
    await _esperar();
    auth.cambios.add('u2');
    await _esperar();
    lento.complete(_usuario('u1'));
    await _esperar();

    expect(container.read(usuarioActualProvider)?.id, 'u2');
  });

  test('el aviso se limpia en el siguiente cierre normal', () async {
    usuarios.respuestas['u1'] = null;
    auth.cambios.add('u1');
    await _esperar();
    auth.cambios.add(null);
    await _esperar();

    expect((estado() as SinSesion).aviso, isNull);
  });
}
