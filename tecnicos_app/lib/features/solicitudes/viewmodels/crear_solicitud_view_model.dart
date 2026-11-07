// Formulario "Nueva solicitud". 
import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/catalogo/oficio.dart';
import '../../../core/errors/app_failure.dart';
import '../../../core/geo/geo_mapper.dart';
import '../../../core/geo/ubicacion_service.dart';
import '../../../core/state/base_store.dart';
import '../../../core/state/view_state.dart';
import '../models/solicitud.dart';
import '../services/solicitud_service.dart';



class CrearSolicitudViewModel extends BaseStore<String> {
  CrearSolicitudViewModel({
    required SolicitudService solicitudService,
    required OficioService oficioService,
    required UbicacionService ubicacionService,
  })  : _solicitudes = solicitudService,
        _oficios = oficioService,
        _ubicacion = ubicacionService;

  static const int maximoFotos = 3;

  final SolicitudService _solicitudes;
  final OficioService _oficios;
  final UbicacionService _ubicacion;



  late final ValueNotifier<List<Oficio>> oficios = createField(const []);
  late final ValueNotifier<int?> oficioId = createField(null);
  late final ValueNotifier<LatLng> ubicacion = createField(GeoMapper.quito);
  late final ValueNotifier<bool> buscandoGps = createField(false);
  late final ValueNotifier<List<Uint8List>> fotos = createField(const []);

  Future<void> iniciar() async {
    try {
      oficios.value = await _oficios.listar();
    } on AppFailure catch (falla) {
      emit(ViewError(falla.message));
    }
    await usarMiUbicacion();
  }


  Future<bool> usarMiUbicacion() async {
    buscandoGps.value = true;
    final actual = await _ubicacion.obtenerActual();
    if (isDisposed) return false;
    buscandoGps.value = false;
    if (actual != null) ubicacion.value = actual;
    return actual != null;
  }

  void seleccionarOficio(int? id) => oficioId.value = id;

  void moverPin(LatLng punto) => ubicacion.value = punto;

  int get fotosDisponibles => maximoFotos - fotos.value.length;

  void agregarFotos(List<Uint8List> nuevas) {
    fotos.value = [...fotos.value, ...nuevas].take(maximoFotos).toList();
  }

  void quitarFoto(int indice) {
    fotos.value = [...fotos.value]..removeAt(indice);
  }

  Future<void> enviar({required String descripcion, String? direccion}) {
    final oficio = oficioId.value;
    if (oficio == null) {
      emit(const ViewError('Selecciona el tipo de servicio.'));
      return Future.value();
    }
    return execute(
      () => _solicitudes.crear(
        NuevaSolicitud(
          oficioId: oficio,
          descripcion: descripcion,
          ubicacion: ubicacion.value,
          direccionReferencia:
              (direccion?.trim().isEmpty ?? true) ? null : direccion,
          fotos: fotos.value,
        ),
      ),
    );
  }
}
