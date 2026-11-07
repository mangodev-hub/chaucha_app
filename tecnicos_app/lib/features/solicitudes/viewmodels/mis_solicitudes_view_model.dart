// Lista "Mis solicitudes" del cliente.
import '../../../core/state/base_store.dart';
import '../models/solicitud.dart';
import '../services/solicitud_service.dart';


class MisSolicitudesViewModel extends BaseStore<List<Solicitud>> {
  MisSolicitudesViewModel(this._service);

  final SolicitudService _service;

  Future<void> cargar() => execute(_service.misSolicitudes);
}


class MisTrabajosViewModel extends BaseStore<List<Solicitud>> {
  MisTrabajosViewModel(this._service);

  final SolicitudService _service;

  Future<void> cargar() => execute(_service.misTrabajos);
}
