// Implementa app_dependencies para la aplicación.
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/catalogo/oficio.dart';
import '../core/geo/ubicacion_service.dart';
import '../core/storage/storage_service.dart';
import '../features/auth/services/auth_service.dart';
import '../features/auth/services/supabase_auth_service.dart';
import '../features/auth/services/supabase_usuario_service.dart';
import '../features/auth/services/usuario_service.dart';
import '../features/auth/viewmodels/session_store.dart';
import '../features/chat/services/chat_service.dart';
import '../features/chat/services/supabase_chat_service.dart';
import '../features/cotizaciones/services/cotizacion_service.dart';
import '../features/cotizaciones/services/supabase_cotizacion_service.dart';
import '../features/perfil_puntos/services/documento_service.dart';
import '../features/perfil_puntos/services/perfil_service.dart';
import '../features/perfil_puntos/services/supabase_documento_service.dart';
import '../features/perfil_puntos/services/supabase_perfil_service.dart';
import '../features/solicitudes/services/solicitud_service.dart';
import '../features/solicitudes/services/supabase_solicitud_service.dart';


class AppDependencies {
  AppDependencies._({
    required this.authService,
    required this.usuarioService,
    required this.sessionStore,
    required this.oficioService,
    required this.ubicacionService,
    required this.solicitudService,
    required this.cotizacionService,
    required this.chatService,
    required this.perfilService,
    required this.documentoService,
  });

  factory AppDependencies.supabase(SupabaseClient client) {
    final authService = SupabaseAuthService(client);
    final usuarioService = SupabaseUsuarioService(client);
    final storage = SupabaseStorageService(client);
    return AppDependencies._(
      authService: authService,
      usuarioService: usuarioService,
      sessionStore: SessionStore(
        authService: authService,
        usuarioService: usuarioService,
      ),
      oficioService: SupabaseOficioService(client),
      ubicacionService: GeolocatorUbicacionService(),
      solicitudService: SupabaseSolicitudService(client, storage),
      cotizacionService: SupabaseCotizacionService(client),
      chatService: SupabaseChatService(client),
      perfilService: SupabasePerfilService(client),
      documentoService: SupabaseDocumentoService(client, storage),
    );
  }

  final AuthService authService;
  final UsuarioService usuarioService;
  final SessionStore sessionStore;
  final OficioService oficioService;
  final UbicacionService ubicacionService;
  final SolicitudService solicitudService;
  final CotizacionService cotizacionService;
  final ChatService chatService;
  final PerfilService perfilService;
  final DocumentoService documentoService;

  void dispose() => sessionStore.dispose();
}
