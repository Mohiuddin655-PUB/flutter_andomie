part of 'handlers.dart';

abstract class UserHandler<T extends UserEntity> {
  final DataRepository<T> repository;
  final LocalDataRepository<T> localDataRepository;

  const UserHandler({
    required this.repository,
    required this.localDataRepository,
  });

  Future<Response<T>> create<R>(
    T entity, {
    R? Function(R parent)? source,
  });

  Future<Response<T>> update<R>(
    String id,
    Map<String, dynamic> data, {
    R? Function(R parent)? source,
  });

  Future<Response<T>> delete<R>(
    String id, {
    R? Function(R parent)? source,
  });

  Future<Response<T>> get<R>(
    String id, {
    bool fromCache = false,
    R? Function(R parent)? source,
  });

  Future<Response<T>> gets<R>({
    bool fromCache = false,
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
