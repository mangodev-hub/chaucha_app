import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Permite que una vista pida al shell cambiar de pestaña por su título.
class PestanaSolicitada extends Notifier<String?> {
  @override
  String? build() => null;

  void pedir(String titulo) => state = titulo;

  void limpiar() => state = null;
}

final pestanaSolicitadaProvider =
    NotifierProvider<PestanaSolicitada, String?>(PestanaSolicitada.new);

/// Sección del perfil del técnico a la que hay que bajar ('oficios' o 'zona').
class SeccionPerfil extends Notifier<String?> {
  @override
  String? build() => null;

  void pedir(String seccion) => state = seccion;

  void limpiar() => state = null;
}

final seccionPerfilProvider =
    NotifierProvider<SeccionPerfil, String?>(SeccionPerfil.new);
