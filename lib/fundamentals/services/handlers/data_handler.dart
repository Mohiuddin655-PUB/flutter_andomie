part of 'handlers.dart';

abstract class DataHandler<T extends Entity> {
  final DataRepository<T> repository;

  const DataHandler({
    required this.repository,
  });

  Future<Response<T>> clear<R>({
    R? Function(R parent)? source,
    SourceType sourceType = SourceType.remote,
  });

  Future<Response<T>> delete<R>(
    String id, {
    R? Function(R parent)? source,
    SourceType sourceType = SourceType.remote,
  });

  Future<Response<T>> get<R>(
    String id, {
    R? Function(R parent)? source,
    SourceType sourceType = SourceType.remote,
  });

  Future<Response<T>> getUpdates<R>({
    R? Function(R parent)? source,
    SourceType sourceType = SourceType.remote,
  });

  Future<Response<T>> gets<R>({
    R? Function(R parent)? source,
    SourceType sourceType = SourceType.remote,
  });

  Future<Response<T>> insert<R>(
    T data, {
    R? Function(R parent)? source,
    SourceType sourceType = SourceType.remote,
  });

  Future<Response<T>> inserts<R>(
    List<T> data, {
    R? Function(R parent)? source,
    SourceType sourceType = SourceType.remote,
  });

  Future<bool> isAvailable<R>(
    String id, {
    R? Function(R parent)? source,
    SourceType sourceType = SourceType.remote,
  });

  Stream<Response<T>> live<R>(
    String id, {
    R? Function(R parent)? source,
    SourceType sourceType = SourceType.remote,
  });

  Stream<Response<T>> lives<R>({
    R? Function(R parent)? source,
    SourceType sourceType = SourceType.remote,
  });

  Future<Response<T>> update<R>(
    T data, {
    R? Function(R parent)? source,
    SourceType sourceType = SourceType.remote,
  });
}
