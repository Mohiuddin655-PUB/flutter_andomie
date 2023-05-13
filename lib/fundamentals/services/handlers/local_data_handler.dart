import '../../index.dart';

abstract class LocalDataHandler<T extends Entity> {
  final LocalDataRepository<T> repository;

  const LocalDataHandler({
    required this.repository,
  });

  bool isAvailable(String key, List<T>? list);

  Future<bool?> exists({required String id});

  Future<Response<void>> insert({required T data});

  Future<Response<void>> inserts({required List<T> data});

  Future<Response<void>> delete({required String id});

  Future<Response<void>> update({required T data});

  Future<Response<T>> get({required String id});

  Future<Response<T>> gets();

  Future<Response<void>> clear();
}
