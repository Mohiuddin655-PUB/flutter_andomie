import '../../index.dart';

class DataRepositoryImpl<T extends Entity> extends DataRepository<T> {
  DataRepositoryImpl({
    required super.remote,
  });

  @override
  Future<Response<T>> create<R>(
    T entity, [
    R? Function(R parent)? source,
  ]) {
    return remote.create(
      data: entity,
      source: source,
    );
  }

  @override
  Future<Response<T>> update<R>(
    String id,
    Map<String, dynamic> data, [
    R? Function(R parent)? source,
  ]) {
    return remote.update(
      id,
      data,
      source: source,
    );
  }

  @override
  Future<Response<T>> delete<R>(
    String id, [
    R? Function(R parent)? source,
  ]) {
    return remote.delete(
      id,
      source: source,
    );
  }

  @override
  Future<Response<T>> get<R>(
    String id, [
    R? Function(R parent)? source,
  ]) {
    return remote.get(
      id,
      source: source,
    );
  }

  @override
  Future<Response<T>> gets<R>([
    R? Function(R parent)? source,
  ]) {
    return remote.gets(
      source: source,
    );
  }

  @override
  Future<Response<T>> getUpdates<R>([
    R? Function(R parent)? source,
  ]) {
    return remote.getUpdates(
      source: source,
    );
  }

  @override
  Stream<Response<T>> live<R>(
    String id, [
    R? Function(R parent)? source,
  ]) {
    return remote.live(
      id,
      source: source,
    );
  }

  @override
  Stream<Response<T>> lives<R>([
    R? Function(R parent)? source,
  ]) {
    return remote.lives(
      source: source,
    );
  }
}
