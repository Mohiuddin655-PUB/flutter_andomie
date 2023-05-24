part of 'repositories.dart';

abstract class DataRepository<T extends Entity> extends Repository{
  final LocalDataSource<T> local;
  final RemoteDataSource<T> remote;

  DataRepository({
    required super.connectivity,
    required this.local,
    required this.remote,
  });

  Future<Response<T>> clear<R>({
    required R? Function(R parent)? source,
    required SourceType sourceType,
  });

  Future<Response<T>> delete<R>(
    String id, {
    required R? Function(R parent)? source,
    required SourceType sourceType,
  });

  Future<Response<T>> get<R>(
    String id, {
    required R? Function(R parent)? source,
    required SourceType sourceType,
  });

  Future<Response<T>> getUpdates<R>({
    required R? Function(R parent)? source,
    required SourceType sourceType,
  });

  Future<Response<T>> gets<R>({
    required R? Function(R parent)? source,
    required SourceType sourceType,
  });

  Future<Response<T>> insert<R>(
    T data, {
    required R? Function(R parent)? source,
    required SourceType sourceType,
  });

  Future<Response<T>> inserts<R>(
    List<T> data, {
    required R? Function(R parent)? source,
    required SourceType sourceType,
  });

  Future<Response<T>> isAvailable<R>(
    String id, {
    required R? Function(R parent)? source,
    required SourceType sourceType,
  });

  Stream<Response<T>> live<R>(
    String id, {
    required R? Function(R parent)? source,
    required SourceType sourceType,
  });

  Stream<Response<T>> lives<R>({
    required R? Function(R parent)? source,
    required SourceType sourceType,
  });

  Future<Response<T>> update<R>(
    T data, {
    required R? Function(R parent)? source,
    required SourceType sourceType,
  });
}

enum SourceType {
  local,
  remote,
  both;

  factory SourceType.from(bool offline) {
    if (offline) {
      return SourceType.local;
    } else {
      return SourceType.remote;
    }
  }
}

extension SourceTypeExtension on SourceType {
  bool get isBoth => this == SourceType.both;

  bool get isLocal => this == SourceType.local;

  bool get isLocalOrBoth {
    return this == SourceType.local || this == SourceType.both;
  }

  bool get isRemote => this == SourceType.remote;

  bool get isRemoteOrBoth {
    return this == SourceType.remote || this == SourceType.both;
  }
}
