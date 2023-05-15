part of 'controllers.dart';

class LocalDataController<T extends Entity> extends Cubit<Response<T>> {
  final String path;
  final LocalDataHandler<T> handler;

  LocalDataController({
    required this.path,
    required this.handler,
  }) : super(Response<T>());

  bool isAvailable(String key, List<T>? list) {
    return handler.isAvailable(key, list);
  }

  Future<bool?> isExists(String id) async {
    return handler.exists(id: id);
  }

  Future<void> setItem(T data) async {
    try {
      emit(state.copy(isLoading: true));
      await handler.insert(data: data);
      final result = await handler.gets();
      emit(result);
    } catch (_) {
      emit(state.copy(error: "Something went wrong!"));
      rethrow;
    }
  }

  Future<void> removeItem(T data) async {
    try {
      emit(state.copy(isLoading: true));
      await handler.delete(id: data.id);
      final result = await handler.gets();
      emit(state.copy(result: result.result, isLoading: false));
    } catch (_) {
      emit(state.copy(error: "Something went wrong!"));
      rethrow;
    }
  }

  Future<void> getItems() async {
    try {
      emit(state.copy(isLoading: true));
      final response = await handler.gets();
      emit(state.copy(result: response.result, isLoading: false));
    } catch (_) {
      emit(state.copy(error: "Something went wrong!"));
      rethrow;
    }
  }

  Future<void> setItems(List<T> items) async {
    try {
      emit(state.copy(isLoading: true));
      await handler.inserts(data: items);
      emit(state.copy(result: items, isLoading: false));
    } catch (_) {
      emit(state.copy(error: "Something went wrong!"));
      rethrow;
    }
  }

  Future<void> clear() async {
    try {
      emit(state.copy(isLoading: true));
      await handler.clear();
      emit(state.copy(result: [], isLoading: false));
    } catch (_) {
      emit(state.copy(error: "Something went wrong!"));
      rethrow;
    }
  }

  dynamic value;

  void setData(dynamic data) {
    value = data;
  }
}
