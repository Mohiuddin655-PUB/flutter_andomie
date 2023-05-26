part of 'repositories.dart';

abstract class DataRepository<T extends Entity> extends Repository {
  final LocalDataSource<T> local;
  final RemoteDataSource<T> remote;

  DataRepository({
    super.connectivity,
    required this.local,
    required this.remote,
  });

  Future<Response<T>> clear<R>({
    bool cacheMode = false,
    bool localMode = false,
    OnDataSourceBuilder<R>? source,
  });

  Future<Response<T>> delete<R>(
    String id, {
    bool cacheMode = false,
    bool localMode = false,
    OnDataSourceBuilder<R>? source,
  });

  Future<Response<T>> get<R>(
    String id, {
    bool cacheMode = false,
    bool localMode = false,
    OnDataSourceBuilder<R>? source,
  });

  Future<Response<T>> getUpdates<R>({
    bool cacheMode = false,
    bool localMode = false,
    OnDataSourceBuilder<R>? source,
  });

  Future<Response<T>> gets<R>({
    bool cacheMode = false,
    bool localMode = false,
    OnDataSourceBuilder<R>? source,
  });

  Future<Response<T>> insert<R>(
    T data, {
    bool cacheMode = false,
    bool localMode = false,
    OnDataSourceBuilder<R>? source,
  });

  Future<Response<T>> inserts<R>(
    List<T> data, {
    bool cacheMode = false,
    bool localMode = false,
    OnDataSourceBuilder<R>? source,
  });

  Future<Response<T>> isAvailable<R>(
    String id, {
    bool cacheMode = false,
    bool localMode = false,
    OnDataSourceBuilder<R>? source,
  });

  Stream<Response<T>> live<R>(
    String id, {
    bool cacheMode = false,
    bool localMode = false,
    OnDataSourceBuilder<R>? source,
  });

  Stream<Response<T>> lives<R>({
    bool cacheMode = false,
    bool localMode = false,
    OnDataSourceBuilder<R>? source,
  });

  Future<Response<T>> update<R>(
    T data, {
    bool cacheMode = false,
    bool localMode = false,
    OnDataSourceBuilder<R>? source,
  });
}
