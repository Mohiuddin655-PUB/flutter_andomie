part of 'sources.dart';

abstract class RemoteDataSource<T extends Entity> {
  Future<Response<T>> clear<R>({
    bool isActiveNetwork = false,
    R? Function(R parent)? source,
  });

  Future<Response<T>> delete<R>(
    String id, {
    bool isActiveNetwork = false,
    R? Function(R parent)? source,
  });

  Future<Response<T>> get<R>(
    String id, {
    bool isActiveNetwork = false,
    R? Function(R parent)? source,
  });

  Future<Response<T>> getUpdates<R>({
    bool isActiveNetwork = false,
    R? Function(R parent)? source,
  });

  Future<Response<T>> gets<R>({
    bool isActiveNetwork = false,
    R? Function(R parent)? source,
  });

  Future<Response<T>> insert<R>(
    T data, {
    bool isActiveNetwork = false,
    R? Function(R parent)? source,
  });

  Future<Response<T>> inserts<R>(
    List<T> data, {
    bool isActiveNetwork = false,
    R? Function(R parent)? source,
  });

  Future<Response<T>> isAvailable<R>(
    String id, {
    bool isActiveNetwork = false,
    R? Function(R parent)? source,
  });

  Stream<Response<T>> live<R>(
    String id, {
    bool isActiveNetwork = false,
    R? Function(R parent)? source,
  });

  Stream<Response<T>> lives<R>({
    bool isActiveNetwork = false,
    R? Function(R parent)? source,
  });

  Future<Response<T>> update<R>(
    T data, {
    bool isActiveNetwork = false,
    R? Function(R parent)? source,
  });

  T build(dynamic source);
}
