part of 'handlers.dart';

abstract class DataHandler<T extends Entity> {
  final DataRepository<T> repository;

  const DataHandler({
    required this.repository,
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
