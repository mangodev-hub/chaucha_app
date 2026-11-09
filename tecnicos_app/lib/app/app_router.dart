// Router de la app. Se crea una sola vez y se refresca cuando cambia la sesión.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/router/app_routes.dart';
import '../core/widgets/splash_view.dart';
import '../features/auth/domain/entities/sesion_estado.dart';
import '../features/auth/presentation/providers/sesion_provider.dart';
import '../features/auth/presentation/views/completar_perfil_view.dart';
import '../features/auth/presentation/views/inicio_view.dart';
import '../features/auth/presentation/views/login_view.dart';
import '../features/auth/presentation/views/perfil_cliente_view.dart';
import '../features/auth/presentation/views/recuperar_view.dart';
import '../features/auth/presentation/views/registro_view.dart';
import '../features/auth/presentation/views/restablecer_view.dart';
import '../features/chat/presentation/views/chat_view.dart';
import '../features/perfil_puntos/presentation/views/perfil_publico_view.dart';
import '../features/perfil_puntos/presentation/views/perfil_tecnico_view.dart';
import '../features/solicitudes/presentation/views/crear_solicitud_view.dart';
import '../features/solicitudes/presentation/views/feed_view.dart';
import '../features/solicitudes/presentation/views/inicio_tecnico_view.dart';
import '../features/solicitudes/presentation/views/mis_solicitudes_view.dart';
import '../features/solicitudes/presentation/views/mis_trabajos_view.dart';
import '../features/solicitudes/presentation/views/solicitud_detalle_view.dart';
import 'inicio_shell.dart';
import 'route_guard.dart';

final routerProvider = Provider<GoRouter>((ref) {

  final cambiosDeSesion = ValueNotifier<SesionEstado>(ref.read(sesionProvider));
  ref.listen(sesionProvider, (_, nuevo) => cambiosDeSesion.value = nuevo);

  Future<void> cerrarSesion() =>
      ref.read(sesionProvider.notifier).cerrarSesion();

  // Detalle y chat existen bajo /cliente y bajo /tecnico.
  Widget detalle(GoRouterState state) =>
      SolicitudDetalleView(solicitudId: state.pathParameters['id']!);

  Widget chat(GoRouterState state) =>
      ChatView(conversacionId: state.pathParameters['id']!);

  final router = GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: cambiosDeSesion,
    redirect: (context, state) => resolverRedireccion(
      sesion: ref.read(sesionProvider),
      ubicacion: state.matchedLocation,
    ),
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashView(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginView(),
      ),
      
      GoRoute(
        path: AppRoutes.registro,
        builder: (context, state) => const RegistroView(),
      ),
            GoRoute(
        path: AppRoutes.recuperar,
        builder: (context, state) => const RecuperarView(),
      ),
      GoRoute(
        path: AppRoutes.restablecer,
        builder: (context, state) => RestablecerView(
          onCancelar: () =>
              ref.read(sesionProvider.notifier).cancelarRecuperacion(),
        ),
      ),
            GoRoute(
        path: AppRoutes.completarPerfil,
        builder: (context, state) =>
            CompletarPerfilView(onCerrarSesion: cerrarSesion),
      ),
GoRoute(
  path: AppRoutes.clienteInicio,
builder: (context, state) => InicioShell(
  onCerrarSesion: cerrarSesion,
  destinos: const [
    Destino('Inicio', Icons.home_outlined, InicioView(esCliente: true)),
    Destino('Mis solicitudes', Icons.assignment_outlined, MisSolicitudesView()),
    Destino('Mi perfil', Icons.person_outline, PerfilClienteView()),
  ],
),
  routes: [
GoRoute(
  path: 'nueva',
  builder: (context, state) {
    final extra = state.extra as ({int? oficioId, String? descripcion})?;
    return CrearSolicitudView(
      oficioId: extra?.oficioId,
      descripcion: extra?.descripcion,
    );
  },
),
          GoRoute(
            path: 'solicitud/:id',
            builder: (context, state) => detalle(state),
          ),
          GoRoute(
            path: 'chat/:id',
            builder: (context, state) => chat(state),
          ),
          GoRoute(
            path: 'tecnico/:id',
            builder: (context, state) =>
                PerfilPublicoView(tecnicoId: state.pathParameters['id']!),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.tecnicoInicio,
builder: (context, state) => InicioShell(
  onCerrarSesion: cerrarSesion,
  destinos: const [
    Destino('Inicio', Icons.home_outlined, InicioTecnicoView()),
    Destino('Solicitudes cerca', Icons.travel_explore, FeedView()),
    Destino('Mis trabajos', Icons.work_outline, MisTrabajosView()),
    Destino('Mi perfil', Icons.person_outline, PerfilTecnicoView()),
  ],
),
        routes: [
          GoRoute(
            path: 'solicitud/:id',
            builder: (context, state) => detalle(state),
          ),
          GoRoute(
            path: 'chat/:id',
            builder: (context, state) => chat(state),
          ),
        ],
      ),
    ],
  );

  ref.onDispose(() {
    router.dispose();
    cambiosDeSesion.dispose();
  });
  return router;
});
