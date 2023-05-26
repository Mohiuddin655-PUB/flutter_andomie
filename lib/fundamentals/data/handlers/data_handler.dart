part of 'handlers.dart';

class DataHandlerImpl<T extends Entity> extends DataHandler<T> {
  const DataHandlerImpl({
    required super.repository,
  });

  @override
  Future<Response<T>> clear<R>({
    OnDataSourceBuilder<R>? source,
    bool cacheMode = false,
    bool localMode = false,
  }) {
    return repository.clear(
      cacheMode: cacheMode,
      localMode: localMode,
      source: source,
    );
  }

  @override
  Future<Response<T>> delete<R>(
    String id, {
    OnDataSourceBuilder<R>? source,
    bool cacheMode = false,
    bool localMode = false,
  }) {
    return repository.delete(
      id,
      cacheMode: cacheMode,
      localMode: localMode,
      source: source,
    );
  }

  @override
  Future<Response<T>> get<R>(
    String id, {
    OnDataSourceBuilder<R>? source,
    bool cacheMode = false,
    bool localMode = false,
  }) {
    return repository.get(
      id,
      source: source,
      cacheMode: cacheMode,
      localMode: localMode,
    );
  }

  @override
  Future<Response<T>> getUpdates<R>({
    OnDataSourceBuilder<R>? source,
    bool cacheMode = false,
    bool localMode = false,
  }) {
    return repository.getUpdates(
      source: source,
      cacheMode: cacheMode,
      localMode: localMode,
    );
  }

  @override
  Future<Response<T>> gets<R>({
    OnDataSourceBuilder<R>? source,
    bool cacheMode = false,
    bool localMode = false,
  }) {
    return repository.gets(
      source: source,
      cacheMode: cacheMode,
      localMode: localMode,
    );
  }

  @override
  Future<Response<T>> insert<R>(
    T data, {
    OnDataSourceBuilder<R>? source,
    bool cacheMode = false,
    bool localMode = false,
  }) {
    return repository.insert(
      data,
      source: source,
      cacheMode: cacheMode,
      localMode: localMode,
    );
  }

  @override
  Future<Response<T>> inserts<R>(
    List<T> data, {
    OnDataSourceBuilder<R>? source,
    bool cacheMode = false,
    bool localMode = false,
  }) {
    return repository.inserts(
      data,
      source: source,
      cacheMode: cacheMode,
      localMode: localMode,
    );
  }

  @override
  Future<Response<T>> isAvailable<R>(
    String id, {
    OnDataSourceBuilder<R>? source,
    bool cacheMode = false,
    bool localMode = false,
  }) {
    return repository.isAvailable(
      id,
      source: source,
      cacheMode: cacheMode,
      localMode: localMode,
    );
  }

  @override
  Stream<Response<T>> live<R>(
    String id, {
    OnDataSourceBuilder<R>? source,
    bool cacheMode = false,
    bool localMode = false,
  }) {
    return repository.live(
      id,
      source: source,
      cacheMode: cacheMode,
      localMode: localMode,
    );
  }

  @override
  Stream<Response<T>> lives<R>({
    OnDataSourceBuilder<R>? source,
    bool cacheMode = false,
    bool localMode = false,
  }) {
    return repository.lives(
      source: source,
      cacheMode: cacheMode,
      localMode: localMode,
    );
  }

  @override
  Future<Response<T>> update<R>(
    T data, {
    OnDataSourceBuilder<R>? source,
    bool cacheMode = false,
    bool localMode = false,
  }) {
    return repository.update(
      data,
      source: source,
      cacheMode: cacheMode,
      localMode: localMode,
    );
  }
}
