// Repositorios falsos y datos de prueba para los tests de solicitudes.
import 'dart:async';
import 'dart:typed_data';

import 'package:latlong2/latlong.dart';
import 'package:tecnicos_app/core/errors/app_failure.dart';
import 'package:tecnicos_app/features/auth/domain/entities/rol.dart';
import 'package:tecnicos_app/features/auth/domain/entities/usuario.dart';
import 'package:tecnicos_app/features/cotizaciones/domain/entities/cotizacion.dart';
import 'package:tecnicos_app/features/cotizaciones/domain/entities/nueva_cotizacion.dart';
import 'package:tecnicos_app/features/cotizaciones/domain/entities/rango_ocupado.dart';
import 'package:tecnicos_app/features/cotizaciones/domain/entities/tarifa.dart';
import 'package:tecnicos_app/features/cotizaciones/domain/repositories/cotizacion_repository.dart';
import 'package:tecnicos_app/features/solicitudes/domain/entities/foto_solicitud.dart';
import 'package:tecnicos_app/features/solicitudes/domain/entities/nueva_solicitud.dart';
import 'package:tecnicos_app/features/solicitudes/domain/entities/solicitud.dart';
import 'package:tecnicos_app/features/solicitudes/domain/repositories/solicitud_repository.dart';

Solicitud solicitudDePrueba({
  String id = 's1',
  LatLng? ubicacion,
  EstadoSolicitud estado = EstadoSolicitud.abierta,
}) => Solicitud(
  id: id,
  clienteId: 'c1',
  oficioId: 1,
  oficioNombre: 'Plomería',
  descripcion: 'Gotea la llave',
  estado: estado,
  creadoEn: DateTime(2026, 11, 7),
  ubicacion: ubicacion,
);

Cotizacion cotizacionDePrueba({
  String id = 'q1',
  String solicitudId = 's1',
  String tecnicoId = 't1',
  EstadoCotizacion estado = EstadoCotizacion.pendiente,
  Tarifa? tarifa,
}) => Cotizacion(
  id: id,
  solicitudId: solicitudId,
  tecnicoId: tecnicoId,
  tecnicoNombre: 'Luis Mora',
  tecnicoCalificacion: 4.5,
  precioBase: 25,
  solucion: 'Cambio el empaque de la llave.',
  tarifa: tarifa,
  estado: estado,
  creadoEn: DateTime(2026, 11, 7),
);

Usuario usuarioDePrueba(String id, Rol rol) => Usuario(
  id: id,
  rol: rol,
  nombres: 'Ana',
  apellidos: 'Pérez',
  creadoEn: DateTime(2026),
);

class SolicitudesFalsas implements SolicitudRepository {
  List<Solicitud> abiertas = const [];
  int consultasDeAbiertas = 0;
  int obtenidas = 0;
  int consultasDeMisSolicitudes = 0;
  final cambiosDeEstado = <(String, EstadoSolicitud)>[];

  /// Si no es null, `cambiarEstado` espera a que se complete.
  Completer<void>? cambioPendiente;
  AppFailure? fallaAlCambiar;

  @override
  Future<List<Solicitud>> abiertasDeOficios(List<int> oficioIds) async {
    consultasDeAbiertas++;
    return abiertas;
  }

  @override
  Future<Solicitud> obtener(String id) async {
    obtenidas++;
    return solicitudDePrueba(id: id);
  }

  @override
  Future<void> cambiarEstado(String solicitudId, EstadoSolicitud estado) async {
    cambiosDeEstado.add((solicitudId, estado));
    final pendiente = cambioPendiente;
    if (pendiente != null) await pendiente.future;
    final falla = fallaAlCambiar;
    if (falla != null) throw falla;
  }

  @override
  Future<void> editar(
    String id, {
    required String descripcion,
    required int oficioId,
    String? direccion,
  }) async {}

  @override
  Future<void> eliminar(String id) async {}

  @override
  Future<List<FotoSolicitud>> fotos(String solicitudId) async => const [];

  @override
  Future<List<Solicitud>> misSolicitudes() async {
    consultasDeMisSolicitudes++;
    return const [];
  }

  @override
  Future<List<Solicitud>> misTrabajos() async => const [];

  @override
  Future<List<Solicitud>> porIds(List<String> ids) async => [
    for (final id in ids) solicitudDePrueba(id: id),
  ];

  @override
  Future<String> crear(NuevaSolicitud nueva) async => 'nueva';

  @override
  Future<void> marcarTerminada(
    String solicitudId,
    List<Uint8List> evidencias,
  ) async {}
}

class CotizacionesFalsas implements CotizacionRepository {
  Set<String> cotizadasPorMi = const {};
  List<Cotizacion> deLaSolicitud = const [];
  final aceptadas = <String>[];
  AppFailure? fallaAlAceptar;

  @override
  Future<Set<String>> solicitudesCotizadasPorMi() async => cotizadasPorMi;

  @override
  Future<List<Cotizacion>> deSolicitud(String solicitudId) async =>
      deLaSolicitud;

  @override
  Future<void> aceptar(Cotizacion cotizacion) async {
    final falla = fallaAlAceptar;
    if (falla != null) throw falla;
    aceptadas.add(cotizacion.id);
  }

  final enviadas = <NuevaCotizacion>[];
  List<Cotizacion> mias = const [];

  @override
  Future<List<Cotizacion>> misOfertas() async => mias;
  final tarifasEnviadas = <(String, NuevaTarifa)>[];
  final tarifasRechazadas = <String>[];
  AppFailure? fallaAlEnviarTarifa;

  @override
  Future<void> enviarTarifa(String cotizacionId, NuevaTarifa tarifa) async {
    final falla = fallaAlEnviarTarifa;
    if (falla != null) throw falla;
    tarifasEnviadas.add((cotizacionId, tarifa));
  }

  @override
  Future<void> rechazarTarifa(String cotizacionId) async =>
      tarifasRechazadas.add(cotizacionId);

  @override
  Future<void> enviar(NuevaCotizacion nueva) async => enviadas.add(nueva);

  @override
  Future<List<Cotizacion>> deSolicitudes(List<String> solicitudIds) async => [
    for (final c in deLaSolicitud)
      if (solicitudIds.contains(c.solicitudId)) c,
  ];

  final reagendadosPropuestos = <(String, DateTime)>[];
  final reagendadosRespondidos = <(String, bool)>[];
  final visitasCanceladas = <String>[];
  List<RangoOcupado> ocupados = const [];

  @override
  Future<void> proponerReagendado(
    String cotizacionId,
    DateTime nuevaFecha,
  ) async => reagendadosPropuestos.add((cotizacionId, nuevaFecha));

  @override
  Future<void> responderReagendado(
    String cotizacionId, {
    required bool acepta,
  }) async => reagendadosRespondidos.add((cotizacionId, acepta));

  @override
  Future<void> cancelarVisita(String cotizacionId) async =>
      visitasCanceladas.add(cotizacionId);

  @override
  Future<List<RangoOcupado>> horariosOcupados(
    String cotizacionId, {
    required DateTime desde,
    required DateTime hasta,
  }) async => ocupados;
}
