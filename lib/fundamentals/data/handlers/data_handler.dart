part of 'handlers.dart';

class DataHandlerImpl<T extends Entity> extends DataHandler<T> {
  const DataHandlerImpl({
    required super.repository,
  });

  @override
  Future<Response<T>> create<R>(
    T data, {
    bool cacheMode = false,
    bool localMode = false,
    R? Function(R parent)? source,
  }) {
    return repository.create(
      data,
      cacheMode: cacheMode,
      localMode: localMode,
      source: source,
    );
  }

  @override
  Future<Response<T>> update<R>(
    T data, {
    bool cacheMode = false,
    bool localMode = false,
    R? Function(R parent)? source,
  }) {
    return repository.update(
      data,
      cacheMode: cacheMode,
      localMode: localMode,
      source: source,
    );
  }

  @override
  Future<Response<T>> delete<R>(
    String id, {
    bool cacheMode = false,
    bool localMode = false,
    R? Function(R parent)? source,
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
    bool localMode = false,
    R? Function(R parent)? source,
  }) {
    return repository.get(
      id,
      localMode: localMode,
      source: source,
    );
  }

  @override
  Future<Response<T>> gets<R>({
    bool localMode = false,
    R? Function(R parent)? source,
  }) {
    return repository.gets(
      localMode: localMode,
      source: source,
    );
  }

  @override
  Future<Response<T>> getUpdates<R>({
    R? Function(R parent)? source,
  }) {
    return repository.getUpdates(
      source: source,
    );
  }

  @override
  Stream<Response<T>> live<R>(
    String id, {
    R? Function(R parent)? source,
  }) {
    return repository.live(
      id,
      source: source,
    );
  }

  @override
  Stream<Response<T>> lives<R>({
    R? Function(R parent)? source,
  }) {
    return repository.lives(
      source: source,
    );
  }
}
