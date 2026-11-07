// Estados posibles de una pantalla.
sealed class ViewState<T> {
  const ViewState();
}


final class ViewInitial<T> extends ViewState<T> {
  const ViewInitial();
}


final class ViewLoading<T> extends ViewState<T> {
  const ViewLoading();
}


final class ViewLoaded<T> extends ViewState<T> {
  const ViewLoaded(this.data);

  final T data;
}


final class ViewError<T> extends ViewState<T> {
  const ViewError(this.message, {this.cause});

  final String message;


  final Object? cause;
}
