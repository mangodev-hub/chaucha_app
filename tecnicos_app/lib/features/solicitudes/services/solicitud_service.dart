// Operaciones sobre solicitudes. .
import 'dart:typed_data';

import '../models/solicitud.dart';


abstract interface class SolicitudService {

  Future<List<Solicitud>> misSolicitudes();


  Future<String> crear(NuevaSolicitud nueva);



  Future<List<Solicitud>> abiertasDeOficios(List<int> oficioIds);


  Future<List<Solicitud>> misTrabajos();


  Future<void> marcarTerminada(String solicitudId, List<Uint8List> evidencias);


  Future<Solicitud> obtener(String id);

  Future<List<FotoSolicitud>> fotos(String solicitudId);

  Future<void> cambiarEstado(String solicitudId, EstadoSolicitud estado);
}
