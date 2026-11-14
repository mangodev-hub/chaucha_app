import 'package:tecnicos_app/core/errors/app_failure.dart';
import 'package:tecnicos_app/features/chat/domain/entities/contexto_chat.dart';
import 'package:tecnicos_app/features/chat/domain/entities/conversacion.dart';
import 'package:tecnicos_app/features/chat/domain/entities/conversacion_pendiente.dart';
import 'package:tecnicos_app/features/chat/domain/entities/mensaje.dart';
import 'package:tecnicos_app/features/chat/domain/entities/resumen_chat.dart';
import 'package:tecnicos_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:tecnicos_app/features/cotizaciones/domain/entities/cotizacion.dart';
import 'package:tecnicos_app/features/cotizaciones/domain/entities/tarifa.dart';
import 'package:tecnicos_app/features/solicitudes/domain/entities/solicitud.dart';

import '../solicitudes/falsos.dart';

const conversacionDePrueba = Conversacion(
  id: 'k1',
  solicitudId: 's1',
  tecnicoId: 't1',
);

const tarifaDePrueba = Tarifa(precioAcordado: 40);

ContextoChat contextoDePrueba({
  EstadoCotizacion estadoOferta = EstadoCotizacion.pendiente,
  EstadoSolicitud estadoSolicitud = EstadoSolicitud.cotizada,
  Tarifa? tarifa,
  bool conOferta = true,
}) => ContextoChat(
  conversacion: conversacionDePrueba,
  estadoSolicitud: estadoSolicitud,
  oferta: conOferta
      ? cotizacionDePrueba(estado: estadoOferta, tarifa: tarifa)
      : null,
);

/// Chat falso que solo guarda los mensajes enviados.
class ChatFalso implements ChatRepository {
  final enviados = <String>[];
  AppFailure? fallaAlEnviar;

  @override
  Future<Conversacion> conversacion(String conversacionId) async =>
      conversacionDePrueba;

  @override
  Future<List<ConversacionPendiente>> porResponder() async => const [];

  @override
  Stream<List<Mensaje>> mensajes(String conversacionId) => const Stream.empty();

  @override
  Future<void> enviar({
    required String conversacionId,
    required String texto,
  }) async {
    final falla = fallaAlEnviar;
    if (falla != null) throw falla;
    enviados.add(texto);
  }

  @override
  Future<String> obtenerOCrearConversacion({
    required String solicitudId,
    required String tecnicoId,
  }) async => 'k1';

  @override
  Future<List<ResumenChat>> misChats() async => const [];
}
