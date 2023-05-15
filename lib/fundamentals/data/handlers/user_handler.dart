part of 'handlers.dart';

class UserHandlerImpl<T extends UserEntity> extends UserHandler {
  const UserHandlerImpl({
    required super.repository,
    required super.localDataRepository,
  });

  @override
  Future<Response<UserEntity>> create<R>(
    UserEntity entity, {
    R? Function(R parent)? source,
  }) async {
    try {
      var response = await repository.create(entity, source);
      if (response.isSuccessful) {
        final lr = await localDataRepository.insert(data: entity);
        return lr.isSuccessful ? response : response.copy(message: lr.error);
      }
      return response;
    } catch (_) {
      return Future.error("$_");
    }
  }

  @override
  Future<Response<UserEntity>> delete<R>(
    String id, {
    R? Function(R parent)? source,
  }) async {
    try {
      var response = await repository.delete(id, source);
      if (response.isSuccessful) {
        final lr = await localDataRepository.delete(id: id);
        return lr.isSuccessful ? response : response.copy(message: lr.error);
      }
      return response;
    } catch (_) {
      return Future.error("$_");
    }
  }

  @override
  Future<Response<UserEntity>> get<R>(
    String id, {
    bool fromCache = false,
    R? Function(R parent)? source,
  }) async {
    try {
      if (fromCache) {
        return localDataRepository.get(id: id);
      } else {
        return repository.get(id, source);
      }
    } catch (_) {
      return Future.error("$_");
    }
  }

  @override
  Future<Response<UserEntity>> getUpdates<R>({
    R? Function(R parent)? source,
  }) async {
    try {
      return repository.getUpdates(source);
    } catch (_) {
      return Future.error("$_");
    }
  }

  @override
  Future<Response<UserEntity>> gets<R>({
    bool fromCache = false,
    R? Function(R parent)? source,
  }) async {
    try {
      if (fromCache) {
        return localDataRepository.gets();
      } else {
        return repository.gets(source);
      }
    } catch (_) {
      return Future.error("$_");
    }
  }

  @override
  Stream<Response<UserEntity>> live<R>(
    String id, {
    R? Function(R parent)? source,
  }) {
    try {
      return repository.live(id, source);
    } catch (_) {
      return Stream.error("$_");
    }
  }

  @override
  Stream<Response<UserEntity>> lives<R>({
    R? Function(R parent)? source,
  }) {
    try {
      return repository.lives(source);
    } catch (_) {
      return Stream.error("$_");
    }
  }

  @override
  Future<Response<UserEntity>> update<R>(
    String id,
    Map<String, dynamic> data, {
    R? Function(R parent)? source,
  }) async {
    try {
      var response = await repository.update(id, data, source);
      if (response.isSuccessful) {
        final lr =
            await localDataRepository.update(data: UserEntity.from(data));
        return lr.isSuccessful ? response : response.copy(message: lr.error);
      }
      return response;
    } catch (_) {
      return Future.error("$_");
    }
  }
}
