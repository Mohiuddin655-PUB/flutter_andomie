import '../../index.dart';

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
  Future<Response<void>> insert({required T data}) {
    return repository.insert(data: data);
  }

  @override
  Future<Response<void>> inserts({required List<T> data}) {
    return repository.inserts(data: data);
  }

  @override
  Future<Response<void>> update({required T data}) {
    return repository.update(data: data);
  }

  @override
  Future<Response<void>> delete({required String id}) {
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
  Future<Response<void>> clear() {
    return repository.clear();
  }
}
