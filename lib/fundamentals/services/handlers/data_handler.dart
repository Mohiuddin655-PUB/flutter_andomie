part of 'handlers.dart';

abstract class DataHandler<T extends Entity> {
  final DataRepository<T> repository;

  const DataHandler({
    required this.repository,
  });

  Future<Response<T>> create<R>(
    T entity, [
    R? Function(R parent)? source,
  ]);

  Future<Response<T>> update<R>(
    String id,
    Map<String, dynamic> data, [
    R? Function(R parent)? source,
  ]);

  Future<Response<T>> delete<R>(
    String id, [
    R? Function(R parent)? source,
  ]);

  Future<Response<T>> get<R>(
    String id, [
    R? Function(R parent)? source,
  ]);

  Future<Response<T>> gets<R>([
    R? Function(R parent)? source,
  ]);

  Future<Response<T>> getUpdates<R>([
    R? Function(R parent)? source,
  ]);

  Stream<Response<T>> live<R>(
    String id, [
    R? Function(R parent)? source,
  ]);

  Stream<Response<T>> lives<R>([
    R? Function(R parent)? source,
  ]);
}
