// Para `RefreshIndicator.onRefresh`: espera la recarga de un provider sin
// propagar su error, que ya lo muestra la vista (AsyncValueView).
Future<void> esperarSinError(Future<Object?> recarga) async {
  try {
    await recarga;
  } on Object {
    // El error queda en el AsyncValue del provider.
  }
}
