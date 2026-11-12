import '../../../../core/router/app_routes.dart';
import '../../domain/entities/contexto_chat.dart';

/// Ruta del perfil de la otra persona del chat; null si aún no se sabe.
String? rutaPerfilDelChat(ContextoChat? contexto, {required bool soyCliente}) {
  final c = contexto?.conversacion;
  if (c == null) return null;
  if (soyCliente) return AppRoutes.perfilTecnico(c.tecnicoId);
  final cliente = c.clienteId;
  return cliente == null ? null : AppRoutes.perfilCliente(cliente);
}
