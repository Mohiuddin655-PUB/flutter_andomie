part of 'handlers.dart';

abstract class LocalDataHandler<T extends Entity> {
  final LocalDataRepository<T> repository;

  const LocalDataHandler({
    required this.repository,
  });

  bool isAvailable(String key, List<T>? list);

  Future<bool?> exists({required String id});

  Future<Response<T>> insert({required T data});

  Future<Response<T>> inserts({required List<T> data});

  Future<Response<T>> delete({required String id});

  Future<Response<T>> update({required T data});

  Future<Response<T>> get({required String id});

  Future<Response<T>> gets();

  Future<Response<T>> clear();
}
