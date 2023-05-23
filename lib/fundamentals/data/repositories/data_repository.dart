part of 'repositories.dart';

class DataRepositoryImpl<T extends Entity> extends DataRepository<T> {
  DataRepositoryImpl({
    required super.local,
    required super.remote,
  });

  @override
  Future<Response<T>> create<R>(
    T data, {
    bool cacheMode = false,
    bool localMode = false,
    R? Function(R parent)? source,
  }) async {
    if (localMode) {
      return local.insert(data: data);
    } else {
      var response = await remote.create(data, source: source);
      if (response.isSuccessful && cacheMode) {
        local.insert(data: data);
      }
      return response;
    }
  }

  @override
  Future<Response<T>> update<R>(
    T data, {
    bool cacheMode = false,
    bool localMode = false,
    R? Function(R parent)? source,
  }) async {
    if (localMode) {
      return local.update(data: data);
    } else {
      var response = await remote.update(data.id, data.source, source: source);
      if (response.isSuccessful && cacheMode) {
        local.update(data: data);
      }
      return response;
    }
  }

  @override
  Future<Response<T>> delete<R>(
    String id, {
    bool cacheMode = false,
    bool localMode = false,
    R? Function(R parent)? source,
  }) async {
    if (localMode) {
      return local.delete(id: id);
    } else {
      var response = await remote.delete(id, source: source);
      if (response.isSuccessful && cacheMode) {
        local.delete(id: id);
      }
      return response;
    }
  }

  @override
  Future<Response<T>> get<R>(
    String id, {
    bool localMode = false,
    R? Function(R parent)? source,
  }) async {
    if (localMode) {
      return local.get(id: id);
    } else {
      return remote.get(id, source: source);
    }
  }

  @override
  Future<Response<T>> gets<R>({
    bool localMode = false,
    R? Function(R parent)? source,
  }) {
    if (localMode) {
      return local.gets();
    } else {
      return remote.gets(source: source);
    }
  }

  @override
  Future<Response<T>> getUpdates<R>({
    R? Function(R parent)? source,
  }) {
    return remote.getUpdates(source: source);
  }

  @override
  Stream<Response<T>> live<R>(
    String id, {
    R? Function(R parent)? source,
  }) {
    return remote.live(id, source: source);
  }

  @override
  Stream<Response<T>> lives<R>({
    R? Function(R parent)? source,
  }) {
    return remote.lives(source: source);
  }
}
