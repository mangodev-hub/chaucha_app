Future<void> esperarSinError(Future<Object?> recarga) async {
  try {
    await recarga;
  } on Object {
    // El error queda en el AsyncValue del provider.
  }
}
