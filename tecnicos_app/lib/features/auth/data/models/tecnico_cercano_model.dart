import 'package:latlong2/latlong.dart';

import '../../../../core/utils/json_utils.dart';
import '../../domain/entities/tecnico_cercano.dart';

class TecnicoCercanoModel {
  const TecnicoCercanoModel(this._json);

  factory TecnicoCercanoModel.fromJson(Map<String, dynamic> json) =>
      TecnicoCercanoModel(json);

  final Map<String, dynamic> _json;

  TecnicoCercano aEntidad() {
    final oficios = _json['oficios'];
    return TecnicoCercano(
      id: _json['tecnico_id'] as String,
      nombres: _json['nombres'] as String? ?? '',
      apellidos: _json['apellidos'] as String? ?? '',
      oficios: [
        if (oficios is List)
          for (final o in oficios) o.toString(),
      ],
      calificacion: aDouble(_json['calificacion']),
      totalResenas: aInt(_json['total_resenas']),
      metros: aInt(_json['metros']),
      ubicacion: LatLng(aDouble(_json['lat']), aDouble(_json['lng'])),
      tarifaBase: aDouble(_json['tarifa_base']),
      nivel: _json['nivel'] as String? ?? '',
    );
  }
}