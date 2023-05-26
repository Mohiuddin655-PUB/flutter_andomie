part of 'controllers.dart';

class DefaultDataController<T extends Entity> extends Cubit<Response<T>> {
  final DataHandler<T> handler;

  DefaultDataController({
    required this.handler,
  }) : super(Response<T>());

  void clear<R>({
    bool cacheMode = false,
    bool localMode = false,
    OnDataSourceBuilder<R>? source,
  }) async {
    emit(state.copy(loading: true));
    try {
      var result = await handler.clear(
        cacheMode: cacheMode,
        localMode: localMode,
        source: source,
      );
      emit(state.from(result));
    } catch (_) {
      emit(state.copy(exception: "Something went wrong!"));
    }
  }

  void delete<R>(
    String id, {
    bool cacheMode = false,
    bool localMode = false,
    OnDataSourceBuilder<R>? source,
  }) async {
    emit(state.copy(loading: true));
    try {
      var result = await handler.delete(
        id,
        cacheMode: cacheMode,
        localMode: localMode,
        source: source,
      );
      emit(state.from(result));
    } catch (_) {
      emit(state.copy(exception: "Something went wrong!"));
    }
  }

  void get<R>(
    String id, {
    bool cacheMode = false,
    bool localMode = false,
    OnDataSourceBuilder<R>? source,
  }) async {
    emit(state.copy(loading: true));
    try {
      var result = await handler.get(
        id,
        cacheMode: cacheMode,
        localMode: localMode,
        source: source,
      );
      emit(state.from(result));
    } catch (_) {
      emit(state.copy(exception: "Something went wrong!"));
    }
  }

  void getUpdates<R>({
    bool cacheMode = false,
    bool localMode = false,
    OnDataSourceBuilder<R>? source,
  }) async {
    emit(state.copy(loading: true));
    try {
      var result = await handler.getUpdates(
        cacheMode: cacheMode,
        localMode: localMode,
        source: source,
      );
      emit(state.from(result));
    } catch (_) {
      emit(state.copy(exception: "Something went wrong!"));
    }
  }

  void gets<R>({
    bool cacheMode = false,
    bool localMode = false,
    OnDataSourceBuilder<R>? source,
  }) async {
    emit(state.copy(loading: true));
    try {
      var result = await handler.gets(
        cacheMode: cacheMode,
        localMode: localMode,
        source: source,
      );
      emit(state.from(result));
    } catch (_) {
      emit(state.copy(exception: "Something went wrong!"));
    }
  }

  void insert<R>(
    T data, {
    bool cacheMode = false,
    bool localMode = false,
    OnDataSourceBuilder<R>? source,
  }) async {
    emit(state.copy(loading: true));
    try {
      var result = await handler.insert(
        data,
        cacheMode: cacheMode,
        localMode: localMode,
        source: source,
      );
      emit(state.from(result));
    } catch (_) {
      emit(state.copy(exception: "Something went wrong!"));
    }
  }

  void inserts<R>(
    List<T> data, {
    bool cacheMode = false,
    bool localMode = false,
    OnDataSourceBuilder<R>? source,
  }) async {
    emit(state.copy(loading: true));
    try {
      var result = await handler.inserts(
        data,
        cacheMode: cacheMode,
        localMode: localMode,
        source: source,
      );
      emit(state.from(result));
    } catch (_) {
      emit(state.copy(exception: "Something went wrong!"));
    }
  }

  void isAvailable<R>(
    String id, {
    bool cacheMode = false,
    bool localMode = false,
    OnDataSourceBuilder<R>? source,
  }) async {
    emit(state.copy(loading: true));
    try {
      var result = await handler.isAvailable(
        id,
        cacheMode: cacheMode,
        localMode: localMode,
        source: source,
      );
      emit(state.from(result));
    } catch (_) {
      emit(state.copy(exception: "Something went wrong!"));
    }
  }

  void update<R>(
    T data, {
    bool cacheMode = false,
    bool localMode = false,
    OnDataSourceBuilder<R>? source,
  }) async {
    emit(state.copy(loading: true));
    try {
      var result = await handler.update(
        data,
        cacheMode: cacheMode,
        localMode: localMode,
        source: source,
      );
      emit(state.from(result));
    } catch (_) {
      emit(state.copy(exception: "Something went wrong!"));
    }
  }

  Stream<Response<T>> live<R>(
    String id, {
    bool cacheMode = false,
    bool localMode = false,
    OnDataSourceBuilder<R>? source,
  }) {
    return handler.live(
      id,
      cacheMode: cacheMode,
      localMode: localMode,
      source: source,
    );
  }

  Stream<Response<T>> lives<R>({
    bool cacheMode = false,
    bool localMode = false,
    OnDataSourceBuilder<R>? source,
  }) {
    return handler.lives(
      cacheMode: cacheMode,
      localMode: localMode,
      source: source,
    );
  }
}
