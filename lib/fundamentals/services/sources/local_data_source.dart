import '../../index.dart';

abstract class LocalDataSource<T extends Entity> {
  final String path;

  LocalDataSource({
    required this.path,
  });

  bool isAvailable(String id, List<T>? data);

  Future<bool> exists({required String id});

  Future<Response<T>> insert({required T data});

  Future<Response<T>> inserts({required List<T> data});

  Future<Response<T>> update({required T data});

  Future<Response<T>> delete({required String id});

  Future<Response<T>> get({required String id});

  Future<Response<T>> gets();

  Future<Response<T>> clear();

  T build(Map<String, dynamic> source);
}
