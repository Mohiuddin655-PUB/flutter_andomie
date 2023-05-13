import '../../index.dart';

class LocalDataRepositoryImpl<T extends Entity> extends LocalDataRepository<T> {
  final LocalDataSource<T> local;

  LocalDataRepositoryImpl({required this.local});

  @override
  bool isAvailable(String id, List<T>? data) => local.isAvailable(id, data);

  @override
  Future<bool> exists({required String id}) {
    return local.exists(id: id);
  }

  @override
  Future<Response<T>> insert({required T data}) {
    return local.insert(data: data);
  }

  @override
  Future<Response<T>> inserts({required List<T> data}) {
    return local.inserts(data: data);
  }

  @override
  Future<Response<T>> update({required T data}) {
    return local.update(data: data);
  }

  @override
  Future<Response<T>> get({required String id}) {
    return local.get(id: id);
  }

  @override
  Future<Response<T>> gets() {
    return local.gets();
  }

  @override
  Future<Response<T>> delete({required String id}) {
    return local.delete(id: id);
  }

  @override
  Future<Response<T>> clear() {
    return local.clear();
  }
}
