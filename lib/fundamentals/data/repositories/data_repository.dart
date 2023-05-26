part of 'repositories.dart';

class DataRepositoryImpl<T extends Entity> extends DataRepository<T> {
  DataRepositoryImpl({
    super.connectivity,
    required super.local,
    required super.remote,
  });

  @override
  Future<Response<T>> clear<R>({
    bool cacheMode = false,
    bool localMode = false,
    OnDataSourceBuilder<R>? source,
  }) async {
    if (localMode) {
      return local.clear(source: source);
    } else {
      var connected = await isConnected;
      var response = await remote.clear(
        isConnected: connected,
        source: source,
      );
      if (response.isSuccessful && cacheMode) {
        await local.clear(source: source);
      }
      return response;
    }
  }

  @override
  Future<Response<T>> delete<R>(
    String id, {
    bool cacheMode = false,
    bool localMode = false,
    OnDataSourceBuilder<R>? source,
  }) async {
    if (localMode) {
      return local.delete(id, source: source);
    } else {
      var connected = await isConnected;
      var response = await remote.delete(
        id,
        isConnected: connected,
        source: source,
      );
      if (response.isSuccessful && cacheMode) {
        await local.delete(id, source: source);
      }
      return response;
    }
  }

  @override
  Future<Response<T>> get<R>(
    String id, {
    bool cacheMode = false,
    bool localMode = false,
    OnDataSourceBuilder<R>? source,
  }) async {
    if (localMode) {
      return local.get(id, source: source);
    } else {
      var connected = await isConnected;
      if (cacheMode && !connected) {
        return local.get(id, source: source);
      } else {
        return remote.get(
          id,
          isConnected: connected,
          source: source,
        );
      }
    }
  }

  @override
  Future<Response<T>> getUpdates<R>({
    bool cacheMode = false,
    bool localMode = false,
    OnDataSourceBuilder<R>? source,
  }) async {
    if (localMode) {
      return local.getUpdates(source: source);
    } else {
      var connected = await isConnected;
      if (cacheMode && !connected) {
        return local.getUpdates(
          source: source,
        );
      } else {
        return remote.getUpdates(
          isConnected: connected,
          source: source,
        );
      }
    }
  }

  @override
  Future<Response<T>> gets<R>({
    bool cacheMode = false,
    bool localMode = false,
    OnDataSourceBuilder<R>? source,
  }) async {
    if (localMode) {
      return local.gets(
        source: source,
      );
    } else {
      var connected = await isConnected;
      if (cacheMode && !connected) {
        return local.gets(
          source: source,
        );
      } else {
        return remote.gets(
          isConnected: connected,
          source: source,
        );
      }
    }
  }

  @override
  Future<Response<T>> insert<R>(
    T data, {
    bool cacheMode = false,
    bool localMode = true,
    OnDataSourceBuilder<R>? source,
  }) async {
    if (localMode) {
      return local.insert(data, source: source);
    } else {
      var connected = await isConnected;
      var response = await remote.insert(
        data,
        isConnected: connected,
        source: source,
      );
      if (response.isSuccessful && cacheMode) {
        await local.insert(data, source: source);
      }
      return response;
    }
  }

  @override
  Future<Response<T>> inserts<R>(
    List<T> data, {
    bool cacheMode = false,
    bool localMode = false,
    OnDataSourceBuilder<R>? source,
  }) async {
    if (localMode) {
      return local.inserts(data, source: source);
    } else {
      var connected = await isConnected;
      var response = await remote.inserts(
        data,
        isConnected: connected,
        source: source,
      );
      if (response.isSuccessful && cacheMode) {
        await local.inserts(data, source: source);
      }
      return response;
    }
  }

  @override
  Future<Response<T>> isAvailable<R>(
    String id, {
    bool cacheMode = false,
    bool localMode = false,
    OnDataSourceBuilder<R>? source,
  }) async {
    if (localMode) {
      return local.isAvailable(id, source: source);
    } else {
      var connected = await isConnected;
      if (cacheMode && !connected) {
        return local.isAvailable(
          id,
          source: source,
        );
      } else {
        return remote.isAvailable(
          id,
          isConnected: connected,
          source: source,
        );
      }
    }
  }

  @override
  Stream<Response<T>> live<R>(
    String id, {
    bool cacheMode = false,
    bool localMode = false,
    OnDataSourceBuilder<R>? source,
  }) async* {
    if (localMode) {
      yield* local.live(id, source: source);
    } else {
      var connected = await isConnected;
      if (cacheMode && !connected) {
        yield* local.live(
          id,
          source: source,
        );
      } else {
        yield* remote.live(
          id,
          isConnected: connected,
          source: source,
        );
      }
    }
  }

  @override
  Stream<Response<T>> lives<R>({
    bool cacheMode = false,
    bool localMode = false,
    OnDataSourceBuilder<R>? source,
  }) async* {
    if (localMode) {
      yield* local.lives(source: source);
    } else {
      var connected = await isConnected;
      if (cacheMode && !connected) {
        yield* local.lives(
          source: source,
        );
      } else {
        yield* remote.lives(
          isConnected: connected,
          source: source,
        );
      }
    }
  }

  @override
  Future<Response<T>> update<R>(
    T data, {
    bool cacheMode = false,
    bool localMode = false,
    OnDataSourceBuilder<R>? source,
  }) async {
    if (localMode) {
      return local.update(data, source: source);
    } else {
      var connected = await isConnected;
      var response = await remote.update(
        data,
        isConnected: connected,
        source: source,
      );
      if (response.isSuccessful && cacheMode) {
        await local.update(data, source: source);
      }
      return response;
    }
  }
}
