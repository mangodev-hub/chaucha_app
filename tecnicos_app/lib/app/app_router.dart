// Router de la app. Se crea una sola vez y se refresca cuando cambia la sesión.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/router/app_routes.dart';
import '../core/widgets/pantalla_secundaria.dart';
import '../core/widgets/splash_view.dart';
import '../features/admin/presentation/views/admin_reclamos_view.dart';
import '../features/admin/presentation/views/admin_resumen_view.dart';
import '../features/admin/presentation/views/admin_solicitudes_view.dart';
import '../features/admin/presentation/views/admin_usuarios_view.dart';
import '../features/admin/presentation/views/admin_verificaciones_view.dart';
import '../features/auth/domain/entities/sesion_estado.dart';
import '../features/auth/presentation/providers/sesion_provider.dart';
import '../features/auth/presentation/views/completar_perfil_view.dart';
import '../features/auth/presentation/views/inicio_view.dart';
import '../features/auth/presentation/views/login_view.dart';
import '../features/auth/presentation/views/perfil_cliente_view.dart';
import '../features/auth/presentation/views/recuperar_view.dart';
import '../features/auth/presentation/views/registro_view.dart';
import '../features/auth/presentation/views/restablecer_view.dart';
import '../features/auth/presentation/views/selfie_view.dart';
import '../features/chat/presentation/views/chat_view.dart';
import '../features/chat/presentation/views/chats_view.dart';
import '../features/legal/presentation/views/pagina_legal_view.dart';
import '../features/perfil_puntos/presentation/views/perfil_publico_view.dart';
import '../features/perfil_puntos/presentation/views/perfil_tecnico_view.dart';
import '../features/reclamos/presentation/providers/reclamos_provider.dart';
import '../features/reclamos/presentation/views/mis_reclamos_view.dart';
import '../features/reclamos/presentation/views/reclamo_detalle_view.dart';
import '../features/solicitudes/presentation/views/agenda_view.dart';
import '../features/solicitudes/presentation/views/crear_solicitud_view.dart';
import '../features/solicitudes/presentation/views/inicio_tecnico_view.dart';
import '../features/solicitudes/presentation/views/mis_solicitudes_view.dart';
import '../features/solicitudes/presentation/views/mis_trabajos_view.dart';
import '../features/solicitudes/presentation/views/solicitud_detalle_view.dart';
import 'inicio_shell.dart';
import 'route_guard.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final cambiosDeSesion = ValueNotifier<SesionEstado>(ref.read(sesionProvider));
  ref.listen(sesionProvider, (_, nuevo) => cambiosDeSesion.value = nuevo);

  late final GoRouter router;

  Future<void> cerrarSesion() async {
    await ref.read(sesionProvider.notifier).cerrarSesion();
    router.go(AppRoutes.login);
  }

  // Detalle y chat existen bajo /cliente y bajo /tecnico.
  Widget detalle(GoRouterState state) =>
      SolicitudDetalleView(solicitudId: state.pathParameters['id']!);

  Widget chat(GoRouterState state) =>
      ChatView(conversacionId: state.pathParameters['id']!);

  // Shell del cliente. Con [pagina], la ruta secundaria se dibuja dentro de
  // la estructura web (barra, menú lateral y pie).
  InicioShell shellCliente({Widget? pagina, bool llena = false}) => InicioShell(
    pagina: pagina,
    paginaLlena: llena,
    rutaInicio: AppRoutes.clienteInicio,
    onCerrarSesion: cerrarSesion,
    rutaAgenda: AppRoutes.clienteAgenda,
    claro: true,
    onBuscar: (context, ref, texto) =>
        pedirTecnico(context, ref, descripcion: texto.isEmpty ? null : texto),
    notaMenu:
        'Técnicos verificados con cédula y selfie. Garantía de 30 días '
        'en cada servicio.',
    accionCentral: const AccionCentral(
      etiqueta: 'Pedir un técnico',
      corto: 'Pedir',
      icono: Icons.add_rounded,
      ruta: AppRoutes.clienteNuevaSolicitud,
    ),
    destinos: const [
      Destino(
        'Inicio',
        Icons.home_outlined,
        InicioView(esCliente: true),
        iconoActivo: Icons.home_rounded,
        saludo: 'Bienvenido a ChauchaApp',
      ),
      Destino(
        'Mis solicitudes',
        Icons.assignment_outlined,
        MisSolicitudesView(),
        iconoActivo: Icons.assignment_rounded,
        corto: 'Solicitudes',
        tiposNotificacion: ['cotizacion', 'tarifa', 'solicitud_expirada'],
        marcaAlEntrar: false,
      ),
      Destino(
        'Chats',
        Icons.chat_bubble_outline_rounded,
        ChatsView(esCliente: true),
        iconoActivo: Icons.chat_bubble_rounded,
        tiposNotificacion: tiposDeChat,
        marcaAlEntrar: false,
      ),
      Destino(
        'Mi perfil',
        Icons.person_outline,
        PerfilClienteView(),
        iconoActivo: Icons.person_rounded,
        corto: 'Perfil',
      ),
    ],
  );

  router = GoRouter(
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
        path: AppRoutes.terminos,
        builder: (context, state) => const TerminosView(),
      ),
      GoRoute(
        path: AppRoutes.privacidad,
        builder: (context, state) =>
            PrivacidadView(seccion: state.uri.queryParameters['seccion']),
      ),
      GoRoute(
        path: AppRoutes.completarPerfil,
        builder: (context, state) =>
            CompletarPerfilView(onCerrarSesion: cerrarSesion),
      ),
      GoRoute(
        path: AppRoutes.selfie,
        builder: (context, state) => SelfieView(onCerrarSesion: cerrarSesion),
      ),
      GoRoute(
        path: AppRoutes.clienteInicio,
        // Cinco destinos abajo: Inicio · Solicitudes · Pedir · Chats · Perfil.
        // La agenda del cliente se abre desde el menú y desde Mis solicitudes.
        builder: (context, state) => shellCliente(),
        routes: [
          GoRoute(
            path: 'agenda',
            builder: (context, state) => shellCliente(
              pagina: const PantallaSecundaria(
                titulo: 'Mi agenda',
                // La agenda trae su propio encabezado y el menú la marca.
                conMigas: false,
                cuerpo: AgendaView(esCliente: true),
              ),
            ),
          ),
          GoRoute(
            path: 'nueva',
            builder: (context, state) {
              final extra =
                  state.extra as ({int? oficioId, String? descripcion})?;
              return shellCliente(
                pagina: CrearSolicitudView(
                  oficioId: extra?.oficioId,
                  descripcion: extra?.descripcion,
                ),
              );
            },
          ),
          GoRoute(
            path: 'solicitud/:id',
            builder: (context, state) => shellCliente(pagina: detalle(state)),
          ),
          GoRoute(
            path: 'chat/:id',
            builder: (context, state) =>
                shellCliente(pagina: chat(state), llena: true),
          ),
          GoRoute(
            path: 'reclamo/:id',
            builder: (context, state) => shellCliente(
              pagina: ReclamoDetalleView(
                reclamoId: state.pathParameters['id']!,
              ),
              llena: true,
            ),
          ),
          GoRoute(
            path: 'reclamos',
            builder: (context, state) =>
                shellCliente(pagina: const MisReclamosView(esCliente: true)),
          ),
          GoRoute(
            path: 'tecnico/:id',
            builder: (context, state) => shellCliente(
              pagina: PerfilPublicoView(tecnicoId: state.pathParameters['id']!),
            ),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.tecnicoInicio,
        // Cinco destinos abajo: Inicio · Trabajos · Agenda · Chats · Perfil.
        builder: (context, state) => InicioShell(
          onCerrarSesion: cerrarSesion,
          destinos: const [
            Destino(
              'Inicio',
              Icons.home_outlined,
              InicioTecnicoView(),
              iconoActivo: Icons.home_rounded,
              saludo: 'Estos son los trabajos de tu zona',
            ),
            Destino(
              'Mis trabajos',
              Icons.work_outline,
              MisTrabajosView(),
              iconoActivo: Icons.work_rounded,
              corto: 'Trabajos',
              tiposNotificacion: [
                'cotizacion_aceptada',
                'tarifa_cancelada',
                'cierre',
              ],
            ),
            Destino(
              'Agenda',
              Icons.event_outlined,
              AgendaView(esCliente: false),
              iconoActivo: Icons.event_rounded,
            ),
            Destino(
              'Chats',
              Icons.chat_bubble_outline_rounded,
              ChatsView(esCliente: false),
              iconoActivo: Icons.chat_bubble_rounded,
              tiposNotificacion: tiposDeChat,
              marcaAlEntrar: false,
            ),
            Destino(
              'Mi perfil',
              Icons.person_outline,
              PerfilTecnicoView(),
              iconoActivo: Icons.person_rounded,
              corto: 'Perfil',
            ),
          ],
        ),
        routes: [
          GoRoute(
            path: 'solicitud/:id',
            builder: (context, state) => detalle(state),
          ),
          GoRoute(path: 'chat/:id', builder: (context, state) => chat(state)),
          GoRoute(
            path: 'reclamo/:id',
            builder: (context, state) =>
                ReclamoDetalleView(reclamoId: state.pathParameters['id']!),
          ),
          GoRoute(
            path: 'reclamos',
            builder: (context, state) =>
                const MisReclamosView(esCliente: false),
          ),
          GoRoute(
            path: 'tecnico/:id',
            builder: (context, state) =>
                PerfilPublicoView(tecnicoId: state.pathParameters['id']!),
          ),
          GoRoute(
            path: 'cliente/:id',
            builder: (context, state) => PerfilPublicoView(
              tecnicoId: state.pathParameters['id']!,
              esCliente: true,
            ),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.adminInicio,
        builder: (context, state) => InicioShell(
          onCerrarSesion: cerrarSesion,
          destinos: [
            const Destino(
              'Resumen',
              Icons.space_dashboard_outlined,
              AdminResumenView(),
              iconoActivo: Icons.space_dashboard_rounded,
            ),
            const Destino(
              'Solicitudes',
              Icons.assignment_outlined,
              AdminSolicitudesView(),
              iconoActivo: Icons.assignment_rounded,
            ),
            const Destino(
              'Usuarios',
              Icons.group_outlined,
              AdminUsuariosView(),
              iconoActivo: Icons.group_rounded,
            ),
            const Destino(
              'Verificaciones',
              Icons.badge_outlined,
              AdminVerificacionesView(),
              iconoActivo: Icons.badge_rounded,
              corto: 'Verificar',
            ),
            Destino(
              'Reclamos',
              Icons.verified_user_outlined,
              const AdminReclamosView(),
              iconoActivo: Icons.verified_user_rounded,
              conteo: reclamosRecibidosProvider,
            ),
          ],
        ),
        routes: [
          GoRoute(
            path: 'reclamo/:id',
            builder: (context, state) => ReclamoDetalleView(
              reclamoId: state.pathParameters['id']!,
              esAdmin: true,
            ),
          ),
          GoRoute(
            path: 'tecnico/:id',
            builder: (context, state) =>
                PerfilPublicoView(tecnicoId: state.pathParameters['id']!),
          ),
          GoRoute(
            path: 'cliente/:id',
            builder: (context, state) => PerfilPublicoView(
              tecnicoId: state.pathParameters['id']!,
              esCliente: true,
            ),
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
