part of 'handlers.dart';

class LocalDataHandlerImpl<T extends Entity> extends LocalDataHandler<T> {
  LocalDataHandlerImpl({
    required super.repository,
  });

  @override
  bool isAvailable(String key, List<T>? list) {
    return repository.isAvailable(key, list);
  }

  @override
  Future<bool> exists({required String id}) {
    return repository.exists(id: id);
  }

  @override
  Future<Response<T>> insert({required T data}) {
    return repository.insert(data: data);
  }

  @override
  Future<Response<T>> inserts({required List<T> data}) {
    return repository.inserts(data: data);
  }

  @override
  Future<Response<T>> update({required T data}) {
    return repository.update(data: data);
  }

  @override
  Future<Response<T>> delete({required String id}) {
    return repository.delete(id: id);
  }

  @override
  Future<Response<T>> get({required String id}) {
    return repository.get(id: id);
  }

  @override
  Future<Response<T>> gets() {
    return repository.gets();
  }

  @override
  Future<Response<T>> clear() {
    return repository.clear();
  }
}
