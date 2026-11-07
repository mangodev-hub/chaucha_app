// Gestor de estados propio del proyecto.
import 'dart:async';

import 'package:flutter/foundation.dart';

import '../errors/app_failure.dart';
import 'view_state.dart';


abstract class BaseStore<T> extends ValueNotifier<ViewState<T>> {
  BaseStore([ViewState<T>? initialState])
      : super(initialState ?? ViewInitial<T>());

  final List<FutureOr<void> Function()> _disposers = [];
  bool _isDisposed = false;

  bool get isDisposed => _isDisposed;


  @protected
  void emit(ViewState<T> newState) {
    if (_isDisposed) return;
    value = newState;
  }


  @protected
  Future<void> execute(Future<T> Function() action) async {
    emit(ViewLoading<T>());
    try {
      final data = await action();
      emit(ViewLoaded<T>(data));
    } on AppFailure catch (failure) {
      emit(ViewError<T>(failure.message, cause: failure));
    } catch (error, stackTrace) {
      debugPrint('[$runtimeType] Error inesperado: $error\n$stackTrace');
      emit(ViewError<T>(
        'Ocurrió un error inesperado. Inténtalo de nuevo.',
        cause: error,
      ));
    }
  }



  late final ValueNotifier<bool> procesando = createField(false);




  @protected
  Future<String?> ejecutarAccion(Future<void> Function() accion) async {
    if (procesando.value) return null; 
    procesando.value = true;
    try {
      await accion();
      return null;
    } on AppFailure catch (failure) {
      return failure.message;
    } catch (error, stackTrace) {
      debugPrint('[$runtimeType] Error inesperado: $error\n$stackTrace');
      return 'Ocurrió un error inesperado. Inténtalo de nuevo.';
    } finally {
      if (!_isDisposed) procesando.value = false;
    }
  }






  @protected
  ValueNotifier<V> createField<V>(V initialValue) {
    final field = ValueNotifier<V>(initialValue);
    addDisposer(field.dispose);
    return field;
  }


  @protected
  void addDisposer(FutureOr<void> Function() disposer) {
    _disposers.add(disposer);
  }


  @protected
  void addSubscription(StreamSubscription<dynamic> subscription) {
    addDisposer(subscription.cancel);
  }

  @override
  void dispose() {
    if (_isDisposed) return;
    _isDisposed = true;

    for (final disposer in _disposers.reversed) {
      disposer();
    }
    _disposers.clear();
    super.dispose();
  }
}
