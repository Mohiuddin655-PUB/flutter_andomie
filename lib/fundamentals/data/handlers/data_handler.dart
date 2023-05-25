part of 'handlers.dart';

class DataHandlerImpl<T extends Entity> extends DataHandler<T> {
  const DataHandlerImpl({
    required super.repository,
  });

  @override
  Future<Response<T>> clear<R>({
    R? Function(R parent)? source,
    SourceType sourceType = SourceType.remote,
  }) {
    return repository.clear(
      source: source,
      sourceType: sourceType,
    );
  }

  @override
  Future<Response<T>> delete<R>(
    String id, {
    R? Function(R parent)? source,
    SourceType sourceType = SourceType.remote,
  }) {
    return repository.delete(
      id,
      source: source,
      sourceType: sourceType,
    );
  }

  @override
  Future<Response<T>> get<R>(
    String id, {
    R? Function(R parent)? source,
    SourceType sourceType = SourceType.remote,
  }) {
    return repository.get(
      id,
      source: source,
      sourceType: sourceType,
    );
  }

  @override
  Future<Response<T>> getUpdates<R>({
    R? Function(R parent)? source,
    SourceType sourceType = SourceType.remote,
  }) {
    return repository.getUpdates(
      source: source,
      sourceType: sourceType,
    );
  }

  @override
  Future<Response<T>> gets<R>({
    R? Function(R parent)? source,
    SourceType sourceType = SourceType.remote,
  }) {
    return repository.gets(
      source: source,
      sourceType: sourceType,
    );
  }

  @override
  Future<Response<T>> insert<R>(
    T data, {
    R? Function(R parent)? source,
    SourceType sourceType = SourceType.remote,
  }) {
    return repository.insert(
      data,
      source: source,
      sourceType: sourceType,
    );
  }

  @override
  Future<Response<T>> inserts<R>(
    List<T> data, {
    R? Function(R parent)? source,
    SourceType sourceType = SourceType.remote,
  }) {
    return repository.inserts(
      data,
      source: source,
      sourceType: sourceType,
    );
  }

  @override
  Future<bool> isAvailable<R>(
    String id, {
    R? Function(R parent)? source,
    SourceType sourceType = SourceType.remote,
  }) {
    return repository.isAvailable(
      id,
      source: source,
      sourceType: sourceType,
    );
  }

  @override
  Stream<Response<T>> live<R>(
    String id, {
    R? Function(R parent)? source,
    SourceType sourceType = SourceType.remote,
  }) {
    return repository.live(
      id,
      source: source,
      sourceType: sourceType,
    );
  }

  @override
  Stream<Response<T>> lives<R>({
    R? Function(R parent)? source,
    SourceType sourceType = SourceType.remote,
  }) {
    return repository.lives(
      source: source,
      sourceType: sourceType,
    );
  }

  @override
  Future<Response<T>> update<R>(
    T data, {
    R? Function(R parent)? source,
    SourceType sourceType = SourceType.remote,
  }) {
    return repository.update(
      data,
      source: source,
      sourceType: sourceType,
    );
  }
}
