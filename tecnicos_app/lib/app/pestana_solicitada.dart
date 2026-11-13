import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Permite que una vista pida al shell cambiar de pestaña por su título.
class PestanaSolicitada extends Notifier<String?> {
  @override
  String? build() => null;

  void pedir(String titulo) => state = titulo;

  void limpiar() => state = null;
}

final pestanaSolicitadaProvider = NotifierProvider<PestanaSolicitada, String?>(
  PestanaSolicitada.new,
);

/// Sección del perfil del técnico a la que hay que bajar ('oficios' o 'zona').
class SeccionPerfil extends Notifier<String?> {
  @override
  String? build() => null;

  void pedir(String seccion) => state = seccion;

  void limpiar() => state = null;
}

final seccionPerfilProvider = NotifierProvider<SeccionPerfil, String?>(
  SeccionPerfil.new,
);

/// Pestaña abierta en el shell: la estructura web de una pantalla
/// secundaria marca ese ítem en el menú lateral (desde donde se llegó).
class PestanaActual extends Notifier<int> {
  @override
  int build() => 0;

  void fijar(int indice) => state = indice;
}

final pestanaActualProvider = NotifierProvider<PestanaActual, int>(
  PestanaActual.new,
);
