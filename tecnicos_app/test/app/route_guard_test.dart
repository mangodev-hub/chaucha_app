import 'package:flutter_test/flutter_test.dart';
import 'package:tecnicos_app/app/route_guard.dart';
import 'package:tecnicos_app/core/router/app_routes.dart';
import 'package:tecnicos_app/features/auth/domain/entities/rol.dart';
import 'package:tecnicos_app/features/auth/domain/entities/sesion_estado.dart';
import 'package:tecnicos_app/features/auth/domain/entities/usuario.dart';

ConSesion _con(Rol rol) => ConSesion(
  Usuario(
    id: 'u1',
    rol: rol,
    nombres: 'Ana',
    apellidos: 'Pérez',
    creadoEn: DateTime(2026),
  ),
);

String? _redirigir(SesionEstado sesion, String ubicacion) =>
    resolverRedireccion(sesion: sesion, ubicacion: ubicacion);

void main() {
  group('verificando', () {
    const sesion = SesionVerificando();

    test('se queda en splash', () {
      expect(_redirigir(sesion, AppRoutes.splash), isNull);
    });

    test('cualquier otra ruta va a splash', () {
      expect(_redirigir(sesion, AppRoutes.login), AppRoutes.splash);
      expect(_redirigir(sesion, '/cliente/nueva'), AppRoutes.splash);
    });
  });

  group('sin sesión', () {
    const sesion = SinSesion();

    test('permite las rutas públicas', () {
      expect(_redirigir(sesion, AppRoutes.login), isNull);
      expect(_redirigir(sesion, AppRoutes.registro), isNull);
    });

    test('el resto va a login', () {
      expect(_redirigir(sesion, AppRoutes.splash), AppRoutes.login);
      expect(_redirigir(sesion, '/tecnico/chat/1'), AppRoutes.login);
    });
  });

  group('con sesión', () {
    test('sin cédula registrada va a completar el perfil', () {
      final sesion = ConSesion(
        Usuario(
          id: 'u1',
          rol: Rol.cliente,
          nombres: 'Ana',
          apellidos: '',
          creadoEn: DateTime(2026),
          perfilCompleto: false,
        ),
      );
      expect(
        _redirigir(sesion, AppRoutes.clienteInicio),
        AppRoutes.completarPerfil,
      );
      expect(_redirigir(sesion, AppRoutes.splash), AppRoutes.completarPerfil);
      expect(_redirigir(sesion, AppRoutes.completarPerfil), isNull);
    });
    group('recuperando contraseña', () {
      const sesion = SesionRecuperando();

      test('solo puede estar en restablecer', () {
        expect(_redirigir(sesion, AppRoutes.restablecer), isNull);
        expect(_redirigir(sesion, AppRoutes.login), AppRoutes.restablecer);
        expect(_redirigir(sesion, '/cliente'), AppRoutes.restablecer);
      });
    });

    test('recuperar es pública', () {
      expect(_redirigir(const SinSesion(), AppRoutes.recuperar), isNull);
    });

    test('con el perfil completo no se queda en completar perfil', () {
      expect(
        _redirigir(_con(Rol.cliente), AppRoutes.completarPerfil),
        AppRoutes.clienteInicio,
      );
    });
    test('el cliente navega dentro de su zona', () {
      final sesion = _con(Rol.cliente);
      expect(_redirigir(sesion, AppRoutes.clienteInicio), isNull);
      expect(_redirigir(sesion, '/cliente/solicitud/42'), isNull);
      expect(_redirigir(sesion, AppRoutes.perfilTecnico('t9')), isNull);
    });

    test('el técnico no entra al perfil público (es zona del cliente)', () {
      expect(
        _redirigir(_con(Rol.tecnico), AppRoutes.perfilTecnico('t9')),
        AppRoutes.tecnicoInicio,
      );
    });

    test('el cliente no entra a la zona del técnico ni a login', () {
      final sesion = _con(Rol.cliente);
      expect(_redirigir(sesion, '/tecnico'), AppRoutes.clienteInicio);
      expect(_redirigir(sesion, AppRoutes.login), AppRoutes.clienteInicio);
      expect(_redirigir(sesion, AppRoutes.splash), AppRoutes.clienteInicio);
    });

    test('un prefijo parecido no cuenta como su zona', () {
      expect(
        _redirigir(_con(Rol.cliente), '/clientes'),
        AppRoutes.clienteInicio,
      );
    });

    test('el técnico va a su inicio', () {
      final sesion = _con(Rol.tecnico);
      expect(_redirigir(sesion, AppRoutes.splash), AppRoutes.tecnicoInicio);
      expect(_redirigir(sesion, '/tecnico/solicitud/7'), isNull);
    });

    test('el admin va a /admin', () {
      expect(
        _redirigir(_con(Rol.admin), AppRoutes.splash),
        AppRoutes.adminInicio,
      );
    });
  });
}
