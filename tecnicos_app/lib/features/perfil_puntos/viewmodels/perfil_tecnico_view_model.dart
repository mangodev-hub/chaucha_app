// Perfil del técnico: puntos/nivel (solo lectura) y datos editables.
import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/catalogo/oficio.dart';
import '../../../core/geo/geo_mapper.dart';
import '../../../core/geo/ubicacion_service.dart';
import '../../../core/state/base_store.dart';
import '../models/perfil_tecnico.dart';
import '../services/perfil_service.dart';


class PerfilTecnicoViewModel extends BaseStore<PerfilTecnico> {
  PerfilTecnicoViewModel({
    required PerfilService perfilService,
    required OficioService oficioService,
    required UbicacionService ubicacionService,
  })  : _perfil = perfilService,
        _oficios = oficioService,
        _ubicacion = ubicacionService;

  static const double radioMinimo = 1000;
  static const double radioMaximo = 20000;

  final PerfilService _perfil;
  final OficioService _oficios;
  final UbicacionService _ubicacion;

  late final ValueNotifier<List<Oficio>> catalogo = createField(const []);
  late final ValueNotifier<Set<int>> seleccionados = createField(const {});
  late final ValueNotifier<LatLng> ubicacion = createField(GeoMapper.quito);
  late final ValueNotifier<double> radio = createField(5000);

  Future<void> cargar() {
    return execute(() async {
      final resultados = await Future.wait([
        _perfil.miPerfilTecnico(),
        _oficios.listar(),
      ]);
      final perfil = resultados[0] as PerfilTecnico;
      catalogo.value = resultados[1] as List<Oficio>;
      seleccionados.value = perfil.oficioIds.toSet();
      radio.value = perfil.rangoCoberturaM
          .clamp(radioMinimo, radioMaximo)
          .toDouble();
      final guardada = perfil.ubicacionActual;
      if (guardada != null) {
        ubicacion.value = guardada;
      } else {
        await usarMiUbicacion();
      }
      return perfil;
    });
  }

  void alternarOficio(int id) {
    final nuevo = {...seleccionados.value};
    if (!nuevo.remove(id)) nuevo.add(id);
    seleccionados.value = nuevo;
  }

  void moverPin(LatLng punto) => ubicacion.value = punto;

  void cambiarRadio(double metros) => radio.value = metros;

  Future<bool> usarMiUbicacion() async {
    final actual = await _ubicacion.obtenerActual();
    if (actual != null && !isDisposed) ubicacion.value = actual;
    return actual != null;
  }

  Future<String?> guardar({required double tarifaBase}) async {
    if (seleccionados.value.isEmpty) return 'Selecciona al menos un oficio.';
    final error = await ejecutarAccion(
      () => _perfil.guardar(
        CambiosPerfil(
          tarifaBase: tarifaBase,
          rangoCoberturaM: radio.value.round(),
          ubicacion: ubicacion.value,
          oficioIds: seleccionados.value,
        ),
      ),
    );
    if (error == null && !isDisposed) await cargar();
    return error;
  }
}
