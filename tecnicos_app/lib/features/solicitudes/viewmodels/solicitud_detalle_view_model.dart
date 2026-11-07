// Todo lo que muestra la pantalla de detalle.
import 'dart:typed_data';

import '../../../core/state/base_store.dart';
import '../../auth/models/rol.dart';
import '../../auth/models/usuario.dart';
import '../../chat/services/chat_service.dart';
import '../../cotizaciones/models/cotizacion.dart';
import '../../cotizaciones/services/cotizacion_service.dart';
import '../../perfil_puntos/models/perfil_tecnico.dart';
import '../../perfil_puntos/services/perfil_service.dart';
import '../models/solicitud.dart';
import '../services/solicitud_service.dart';


class DetalleSolicitud {
  const DetalleSolicitud({
    required this.solicitud,
    required this.fotos,
    required this.cotizaciones,
    required this.usuario,
  });

  final Solicitud solicitud;
  final List<FotoSolicitud> fotos;
  final List<Cotizacion> cotizaciones;
  final Usuario usuario;

  bool get soyCliente => usuario.rol == Rol.cliente;

  EstadoSolicitud get estado => solicitud.estado;

  Cotizacion? get cotizacionAceptada => _primera(
        (c) => c.estado == EstadoCotizacion.aceptada,
      );


  Cotizacion? get miCotizacion => _primera((c) => c.tecnicoId == usuario.id);

  bool get soyTecnicoAsignado =>
      !soyCliente && cotizacionAceptada?.tecnicoId == usuario.id;

  List<FotoSolicitud> fotosDe(TipoArchivo tipo) =>
      fotos.where((f) => f.tipo == tipo).toList();

  Cotizacion? _primera(bool Function(Cotizacion) condicion) {
    for (final c in cotizaciones) {
      if (condicion(c)) return c;
    }
    return null;
  }
}





class SolicitudDetalleViewModel extends BaseStore<DetalleSolicitud> {
  SolicitudDetalleViewModel({
    required this.solicitudId,
    required this.usuario,
    required SolicitudService solicitudService,
    required CotizacionService cotizacionService,
    required ChatService chatService,
    required PerfilService perfilService,
  })  : _solicitudes = solicitudService,
        _cotizaciones = cotizacionService,
        _chat = chatService,
        _perfil = perfilService;

  final String solicitudId;
  final Usuario usuario;
  final SolicitudService _solicitudes;
  final CotizacionService _cotizaciones;
  final ChatService _chat;
  final PerfilService _perfil;

  Future<void> cargar() {
    return execute(() async {
      final resultados = await Future.wait([
        _solicitudes.obtener(solicitudId),
        _solicitudes.fotos(solicitudId),
        _cotizaciones.deSolicitud(solicitudId),
      ]);
      return DetalleSolicitud(
        solicitud: resultados[0] as Solicitud,
        fotos: resultados[1] as List<FotoSolicitud>,
        cotizaciones: resultados[2] as List<Cotizacion>,
        usuario: usuario,
      );
    });
  }


  Future<String?> aceptar(Cotizacion cotizacion) =>
      _accionYRecargar(() => _cotizaciones.aceptar(cotizacion));

  Future<String?> confirmarTerminado() => _accionYRecargar(
        () => _solicitudes.cambiarEstado(
          solicitudId,
          EstadoSolicitud.completada,
        ),
      );

  Future<String?> cancelar() => _accionYRecargar(
        () => _solicitudes.cambiarEstado(solicitudId, EstadoSolicitud.cancelada),
      );


  Future<String?> enviarCotizacion({
    required double manoObra,
    required double materiales,
    String? detalle,
  }) {
    return _accionYRecargar(
      () => _cotizaciones.enviar(
        NuevaCotizacion(
          solicitudId: solicitudId,
          manoObra: manoObra,
          materiales: materiales,
          detalle: detalle,
        ),
      ),
    );
  }

  Future<String?> marcarTerminada(List<Uint8List> evidencias) =>
      _accionYRecargar(
        () => _solicitudes.marcarTerminada(solicitudId, evidencias),
      );


  Future<String?> calificar({
    required String destinatarioId,
    required int estrellas,
    String? comentario,
  }) {
    return ejecutarAccion(
      () => _perfil.crearResena(
        NuevaResena(
          solicitudId: solicitudId,
          destinatarioId: destinatarioId,
          calificacion: estrellas,
          comentario: comentario,
        ),
      ),
    );
  }



  Future<({String? conversacionId, String? error})> abrirChat(
    String tecnicoId,
  ) async {
    String? id;
    final error = await ejecutarAccion(() async {
      id = await _chat.obtenerOCrearConversacion(
        solicitudId: solicitudId,
        tecnicoId: tecnicoId,
      );
    });
    return (conversacionId: id, error: error);
  }

  Future<String?> _accionYRecargar(Future<void> Function() accion) async {
    final error = await ejecutarAccion(accion);
    if (error == null && !isDisposed) await cargar();
    return error;
  }
}
