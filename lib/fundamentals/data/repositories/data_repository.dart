part of 'repositories.dart';

class DataRepositoryImpl<T extends Entity> extends DataRepository<T> {
  DataRepositoryImpl({
    required super.connectivity,
    required super.local,
    required super.remote,
  });

  @override
  Future<Response<T>> clear<R>({
    R? Function(R parent)? source,
    SourceType sourceType = SourceType.remote,
  }) async {
    var connected = await isConnected;
    if (sourceType.isLocalOrBoth && !connected) {
      return local.clear(source: source);
    } else {
      return remote.clear(source: source);
    }
  }

  @override
  Future<Response<T>> delete<R>(
    String id, {
    R? Function(R parent)? source,
    SourceType sourceType = SourceType.remote,
  }) async {
    if (sourceType.isLocal) {
      return local.delete(id, source: source);
    } else {
      var response = await remote.delete(id, source: source);
      if (response.isSuccessful && sourceType.isBoth) {
        await local.delete(id, source: source);
      }
      return response;
    }
  }

  @override
  Future<Response<T>> get<R>(
    String id, {
    R? Function(R parent)? source,
    SourceType sourceType = SourceType.remote,
  }) async {
    if (sourceType.isLocalOrBoth) {
      return local.get(id, source: source);
    } else {
      return remote.get(id, source: source);
    }
  }

  @override
  Future<Response<T>> getUpdates<R>({
    R? Function(R parent)? source,
    SourceType sourceType = SourceType.remote,
  }) {
    if (sourceType.isLocalOrBoth) {
      return local.getUpdates(source: source);
    } else {
      return remote.getUpdates(source: source);
    }
  }

  @override
  Future<Response<T>> gets<R>({
    R? Function(R parent)? source,
    SourceType sourceType = SourceType.remote,
  }) {
    if (sourceType.isLocal) {
      return local.gets(source: source);
    } else {
      return remote.gets(source: source);
    }
  }

  @override
  Future<Response<T>> insert<R>(
    T data, {
    R? Function(R parent)? source,
    SourceType sourceType = SourceType.remote,
  }) async {
    if (sourceType.isLocal) {
      return local.insert(data, source: source);
    } else {
      var response = await remote.insert(data, source: source);
      if (response.isSuccessful && sourceType.isBoth) {
        await local.insert(data, source: source);
      }
      return response;
    }
  }

  @override
  Future<Response<T>> inserts<R>(
    List<T> data, {
    R? Function(R parent)? source,
    SourceType sourceType = SourceType.remote,
  }) async {
    if (sourceType.isLocal) {
      return local.inserts(data, source: source);
    } else {
      var response = await remote.inserts(data, source: source);
      if (response.isSuccessful && sourceType.isBoth) {
        await local.inserts(data, source: source);
      }
      return response;
    }
  }

  @override
  Future<Response<T>> isAvailable<R>(
    String id, {
    R? Function(R parent)? source,
    SourceType sourceType = SourceType.remote,
  }) async {
    if (sourceType.isLocal) {
      return local.isAvailable(id, source: source);
    } else {
      return remote.isAvailable(id, source: source);
    }
  }

  @override
  Stream<Response<T>> live<R>(
    String id, {
    R? Function(R parent)? source,
    SourceType sourceType = SourceType.remote,
  }) {
    if (sourceType.isLocalOrBoth) {
      return local.live(id, source: source);
    } else {
      return remote.live(id, source: source);
    }
  }

  @override
  Stream<Response<T>> lives<R>({
    R? Function(R parent)? source,
    SourceType sourceType = SourceType.remote,
  }) {
    if (sourceType.isLocalOrBoth) {
      return local.lives(source: source);
    } else {
      return remote.lives(source: source);
    }
  }

  @override
  Future<Response<T>> update<R>(
    T data, {
    R? Function(R parent)? source,
    SourceType sourceType = SourceType.remote,
  }) async {
    if (sourceType.isLocal) {
      return local.update(data, source: source);
    } else {
      var response = await remote.update(data, source: source);
      if (response.isSuccessful && sourceType.isBoth) {
        await local.update(data, source: source);
      }
      return response;
    }
  }
}
