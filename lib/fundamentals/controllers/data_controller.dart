part of 'controllers.dart';

class DataController<T extends Entity> extends Cubit<Response<T>> {
  final DataHandler<T> handler;

  DataController({
    required this.handler,
  }) : super(Response<T>());

  Future<void> create<R>(T data) async {
    emit(state.copy(isLoading: true));
    try {
      var result = await handler.create(data);
      emit(state.copy(result: result.result));
    } catch (_) {
      emit(state.copy(error: "Something went wrong!"));
    }
  }

  Future<void> update<R>(T data) async {
    emit(state.copy(isLoading: true));
    try {
      var result = await handler.update(data);
      emit(state.copy(result: result.result));
    } catch (_) {
      emit(state.copy(error: "Something went wrong!"));
    }
  }

  Future<void> delete<R>(String id) async {
    emit(state.copy(isLoading: true));
    try {
      var result = await handler.delete(id);
      emit(state.copy(result: result.result));
    } catch (_) {
      emit(state.copy(error: "Something went wrong!"));
    }
  }

  Future<void> get<R>(
    String id, [
    R? Function(R parent)? source,
  ]) async {
    emit(state.copy(isLoading: true));
    try {
      var result = await handler.get(id);
      emit(state.copy(result: result.result));
    } catch (_) {
      emit(state.copy(error: "Something went wrong!"));
    }
  }

  Future<void> gets<R>([
    R? Function(R parent)? source,
  ]) async {
    emit(state.copy(isLoading: true));
    try {
      var result = await handler.gets(
        source: source,
      );
      emit(state.copy(result: result.result));
    } catch (_) {
      emit(state.copy(error: "Something went wrong!"));
    }
  }

  Future<void> getUpdates<R>([
    R? Function(R parent)? source,
  ]) async {
    emit(state.copy(isLoading: true));
    try {
      var result = await handler.getUpdates(
        source: source,
      );
      emit(state.copy(result: result.result));
    } catch (_) {
      emit(state.copy(error: "Something went wrong!"));
    }
  }

  dynamic value;

  void setData(dynamic data) {
    value = data;
  }
}
