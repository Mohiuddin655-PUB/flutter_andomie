part of 'repositories.dart';

abstract class DataRepository<T extends Entity> {
  final LocalDataSource<T> local;
  final RemoteDataSource<T> remote;

  DataRepository({
    required this.local,
    required this.remote,
  });

  Future<Response<T>> create<R>(
    T data, {
    bool cacheMode = false,
    bool localMode = false,
    R? Function(R parent)? source,
  });

  Future<Response<T>> update<R>(
    T data, {
    bool cacheMode = false,
    bool localMode = false,
    R? Function(R parent)? source,
  });

  Future<Response<T>> delete<R>(
    String id, {
    bool cacheMode = false,
    bool localMode = false,
    R? Function(R parent)? source,
  });

  Future<Response<T>> get<R>(
    String id, {
    bool localMode = false,
    R? Function(R parent)? source,
  });

  Future<Response<T>> gets<R>({
    bool localMode = false,
    R? Function(R parent)? source,
  });

  Future<Response<T>> getUpdates<R>({
    R? Function(R parent)? source,
  });

  Stream<Response<T>> live<R>(
    String id, {
    R? Function(R parent)? source,
  });

  Stream<Response<T>> lives<R>({
    R? Function(R parent)? source,
  });
}
