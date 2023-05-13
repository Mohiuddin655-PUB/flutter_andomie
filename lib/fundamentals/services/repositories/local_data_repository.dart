import '../../index.dart';

abstract class LocalDataRepository<T extends Entity> {
  bool isAvailable(String id, List<T>? data);

  Future<bool> exists({required String id});

  Future<Response<void>> insert({required T data});

  Future<Response<void>> inserts({required List<T> data});

  Future<Response<void>> update({required T data});

  Future<Response<T>> get({required String id});

  Future<Response<T>> gets();

  Future<Response<void>> delete({required String id});

  Future<Response<void>> clear();
}
