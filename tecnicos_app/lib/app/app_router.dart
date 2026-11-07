// Implementa app_router para la aplicación.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/router/app_routes.dart';
import '../core/widgets/splash_view.dart';
import '../features/auth/models/usuario.dart';
import '../features/auth/views/login_view.dart';
import '../features/auth/views/registro_view.dart';
import '../features/chat/viewmodels/chat_view_model.dart';
import '../features/chat/views/chat_view.dart';
import '../features/perfil_puntos/viewmodels/perfil_tecnico_view_model.dart';
import '../features/perfil_puntos/viewmodels/verificacion_view_model.dart';
import '../features/perfil_puntos/views/perfil_tecnico_view.dart';
import '../features/solicitudes/viewmodels/crear_solicitud_view_model.dart';
import '../features/solicitudes/viewmodels/feed_view_model.dart';
import '../features/solicitudes/viewmodels/mis_solicitudes_view_model.dart';
import '../features/solicitudes/viewmodels/solicitud_detalle_view_model.dart';
import '../features/solicitudes/views/crear_solicitud_view.dart';
import '../features/solicitudes/views/feed_view.dart';
import '../features/solicitudes/views/mis_solicitudes_view.dart';
import '../features/solicitudes/views/solicitud_detalle_view.dart';
import 'app_dependencies.dart';

import 'route_guard.dart';
import 'tecnico_shell.dart';


GoRouter buildAppRouter(AppDependencies deps) {
  final sesion = deps.sessionStore;


  Usuario usuario() => sesion.usuario!;

  Widget detalle(GoRouterState state) => SolicitudDetalleView(
        crearViewModel: () => SolicitudDetalleViewModel(
          solicitudId: state.pathParameters['id']!,
          usuario: usuario(),
          solicitudService: deps.solicitudService,
          cotizacionService: deps.cotizacionService,
          chatService: deps.chatService,
          perfilService: deps.perfilService,
        ),
      );

  Widget chat(GoRouterState state) => ChatView(
        crearViewModel: () => ChatViewModel(
          conversacionId: state.pathParameters['id']!,
          miId: usuario().id,
          chatService: deps.chatService,
        ),
      );

  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: sesion,
    redirect: (context, state) => resolverRedireccion(
      sesion: sesion.value,
      ubicacion: state.matchedLocation,
    ),
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashView(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) =>
            LoginView(authService: deps.authService, sesion: sesion),
      ),
      GoRoute(
        path: AppRoutes.registro,
        builder: (context, state) =>
            RegistroView(authService: deps.authService),
      ),


      GoRoute(
        path: AppRoutes.clienteInicio,
        builder: (context, state) => MisSolicitudesView(
          crearViewModel: () => MisSolicitudesViewModel(deps.solicitudService),
          onCerrarSesion: sesion.cerrarSesion,
        ),
        routes: [
          GoRoute(
            path: 'nueva',
            builder: (context, state) => CrearSolicitudView(
              crearViewModel: () => CrearSolicitudViewModel(
                solicitudService: deps.solicitudService,
                oficioService: deps.oficioService,
                ubicacionService: deps.ubicacionService,
              ),
            ),
          ),
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


      GoRoute(
        path: AppRoutes.tecnicoInicio,
        builder: (context, state) => TecnicoShell(
          onCerrarSesion: sesion.cerrarSesion,
          feed: FeedView(
            crearViewModel: () => FeedViewModel(
              solicitudService: deps.solicitudService,
              cotizacionService: deps.cotizacionService,
              perfilService: deps.perfilService,
            ),
          ),
          trabajos: MisTrabajosView(
            crearViewModel: () => MisTrabajosViewModel(deps.solicitudService),
          ),
          perfil: PerfilTecnicoView(
            crearViewModel: () => PerfilTecnicoViewModel(
              perfilService: deps.perfilService,
              oficioService: deps.oficioService,
              ubicacionService: deps.ubicacionService,
            ),
            crearVerificacionViewModel: () =>
                VerificacionViewModel(deps.documentoService),
          ),
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



    ]
  );
}
