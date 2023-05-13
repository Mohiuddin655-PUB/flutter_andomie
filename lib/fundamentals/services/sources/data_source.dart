import '../../index.dart';

abstract class DataSource<T extends Entity> {
  Future<Response<T>> create<R>({
    required T data,
    R? Function(R parent)? source,
  });

  Future<Response<T>> update<R>(
    String id,
    Map<String, dynamic> data, {
    R? Function(R parent)? source,
  });

  Future<Response<T>> delete<R>(
    String id, {
    Map<String, dynamic>? extra,
    R? Function(R parent)? source,
  });

  Future<Response<T>> get<R>(
    String id, {
    Map<String, dynamic>? extra,
    R? Function(R parent)? source,
  });

  Future<Response<T>> gets<R>({
    Map<String, dynamic>? extra,
    R? Function(R parent)? source,
  });

  Future<Response<T>> getUpdates<R>({
    Map<String, dynamic>? extra,
    R? Function(R parent)? source,
  });

  Stream<Response<T>> live<R>(
    String id, {
    Map<String, dynamic>? extra,
    R? Function(R parent)? source,
  });

  Stream<Response<T>> lives<R>({
    Map<String, dynamic>? extra,
    R? Function(R parent)? source,
  });

  T build(dynamic source);
}
