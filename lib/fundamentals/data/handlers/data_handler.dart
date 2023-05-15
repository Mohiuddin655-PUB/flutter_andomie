part of 'handlers.dart';

class DataHandlerImpl<T extends Entity> extends DataHandler<T> {
  const DataHandlerImpl({
    required super.repository,
  });

  @override
  Future<Response<T>> create<R>(
    T entity, [
    R? Function(R parent)? source,
  ]) {
    return repository.create(entity, source);
  }

  @override
  Future<Response<T>> update<R>(
    String id,
    Map<String, dynamic> data, [
    R? Function(R parent)? source,
  ]) {
    return repository.update(id, data, source);
  }

  @override
  Future<Response<T>> delete<R>(
    String id, [
    R? Function(R parent)? source,
  ]) {
    return repository.delete(id, source);
  }

  @override
  Future<Response<T>> get<R>(
    String id, [
    R? Function(R parent)? source,
  ]) {
    return repository.get(id, source);
  }

  @override
  Future<Response<T>> gets<R>([
    R? Function(R parent)? source,
  ]) {
    return repository.gets(source);
  }

  @override
  Future<Response<T>> getUpdates<R>([
    R? Function(R parent)? source,
  ]) {
    return repository.getUpdates(source);
  }

  @override
  Stream<Response<T>> live<R>(
    String id, [
    R? Function(R parent)? source,
  ]) {
    return repository.live(id, source);
  }

  @override
  Stream<Response<T>> lives<R>([
    R? Function(R parent)? source,
  ]) {
    return repository.lives(source);
  }
}
