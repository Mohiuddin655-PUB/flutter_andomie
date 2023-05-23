part of 'sources.dart';

abstract class ApiDataSourceImpl<T extends Entity> extends RemoteDataSource<T> {
  final Api api;
  final String path;

  ApiDataSourceImpl({
    required this.api,
    required this.path,
  });

  dio.Dio? _db;

  dio.Dio get database => _db ??= dio.Dio();

  String currentSource<R>(
    R? Function(R parent)? source,
  ) {
    final reference = "${api.api}/$path";
    dynamic current = source?.call(reference as R);
    if (current is String) {
      return current;
    } else {
      return reference;
    }
  }

  String currentUrl<R>(String id, R? Function(R parent)? source) {
    return "${currentSource(source)}/$id";
  }

  @override
  Future<Response<T>> create<R>(
    T data, {
    bool cacheMode = false,
    bool onlyCache = false,
    R? Function(R parent)? source,
  }) async {
    final response = Response<T>();
    if (data.source.isNotEmpty) {
      final url = data.id.isNotEmpty
          ? currentUrl(data.id, source)
          : currentSource(source);
      final reference = await database.post(url, data: data.source);
      final code = reference.statusCode;
      if (code == 200 || code == 201 || code == api.status.created) {
        final result = reference.data;
        return response.copy(result: result);
      } else {
        final error = "Data unmodified [${reference.statusCode}]";
        return response.copy(snapshot: reference, error: error);
      }
    } else {
      final error = "Undefined data $data";
      return response.copy(error: error);
    }
  }

  @override
  Future<Response<T>> update<R>(
    String id,
    Map<String, dynamic> data, {
    bool cacheMode = false,
    bool forCache = false,
    R? Function(R parent)? source,
  }) async {
    Response<T> response = const Response();
    try {
      if (data.isNotEmpty) {
        final url = currentUrl(id, source);
        final reference = await database.put(url, data: data);
        final code = reference.statusCode;
        if (code == 200 || code == 201 || code == api.status.updated) {
          final result = reference.data;
          return response.copy(result: result);
        } else {
          final error = "Data unmodified [${reference.statusCode}]";
          return response.copy(snapshot: reference, error: error);
        }
      } else {
        final error = "Undefined data $data";
        return response.copy(error: error);
      }
    } catch (_) {
      return response.copy(error: _.toString());
    }
  }

  @override
  Future<Response<T>> delete<R>(
    String id, {
    bool cacheMode = false,
    bool fromCache = false,
    R? Function(R parent)? source,
  }) async {
    Response<T> response = const Response();
    try {
      if (id.isNotEmpty) {
        final url = currentUrl(id, source);
        final reference = await database.delete(url);
        final code = reference.statusCode;
        if (code == 200 || code == 201 || code == api.status.deleted) {
          final result = reference.data;
          return response.copy(result: result);
        } else {
          final error = "Data unmodified [${reference.statusCode}]";
          return response.copy(snapshot: reference, error: error);
        }
      } else {
        final error = "Undefined ID [$id]";
        return response.copy(error: error);
      }
    } catch (_) {
      return response.copy(error: _.toString());
    }
  }

  @override
  Future<Response<T>> get<R>(
    String id, {
    bool fromCache = false,
    R? Function(R parent)? source,
  }) async {
    final response = Response<T>();
    try {
      if (id.isNotEmpty) {
        final url = currentUrl(id, source);
        final reference = await database.get(url);
        final data = reference.data;
        final code = reference.statusCode;
        if ((code == 200 || code == api.status.ok) && data is Map) {
          final result = build(data);
          return response.copy(data: result);
        } else {
          final error = "Data unmodified [${reference.statusCode}]";
          return response.copy(snapshot: reference, error: error);
        }
      } else {
        final error = "Undefined ID [$id]";
        return response.copy(error: error);
      }
    } catch (_) {
      return response.copy(error: _.toString());
    }
  }

  @override
  Future<Response<T>> gets<R>({
    bool fromCache = false,
    bool forUpdates = false,
    R? Function(R parent)? source,
  })async {
    final response = Response<T>();
    try {
      final url = currentSource(source);
      final reference = await database.get(url);
      final data = reference.data;
      final code = reference.statusCode;
      if ((code == 200 || code == api.status.ok) && data is List<dynamic>) {
        List<T> result = data.map((item) {
          return build(item);
        }).toList();
        return response.copy(result: result);
      } else {
        final error = "Data unmodified [${reference.statusCode}]";
        return response.copy(snapshot: reference, error: error);
      }
    } catch (_) {
      return response.copy(error: _.toString());
    }
  }

  @override
  Future<Response<T>> getUpdates<R>({
    Map<String, dynamic>? extra,
    R? Function(R parent)? source,
  }) {
    return gets(
      forUpdates: true,
      source: source,
    );
  }

  @override
  Stream<Response<T>> live<R>(
    String id, {
    Map<String, dynamic>? extra,
    R? Function(R parent)? source,
  }) {
    final controller = StreamController<Response<T>>();
    final response = Response<T>();
    try {
      if (id.isNotEmpty) {
        final url = currentUrl(id, source);
        Timer.periodic(const Duration(milliseconds: 3000), (timer) async {
          final reference = await database.get(url);
          final data = reference.data;
          final code = reference.statusCode;
          if ((code == 200 || code == api.status.ok) && data is Map) {
            final result = build(data);
            controller.add(
              response.copy(data: result),
            );
          } else {
            final error = "Data unmodified [${reference.statusCode}]";
            controller.addError(
              response.copy(snapshot: reference, error: error),
            );
          }
        });
      } else {
        final error = "Undefined ID [$id]";
        controller.addError(
          response.copy(error: error),
        );
      }
    } catch (_) {
      controller.addError(_);
    }
    return controller.stream;
  }

  @override
  Stream<Response<T>> lives<R>({
    bool onlyUpdatedData = false,
    Map<String, dynamic>? extra,
    R? Function(R parent)? source,
  }) {
    final controller = StreamController<Response<T>>();
    final response = Response<T>();
    try {
      final url = currentSource(source);
      Timer.periodic(const Duration(milliseconds: 3000), (timer) async {
        final reference = await database.get(url);
        final data = reference.data;
        final code = reference.statusCode;
        if ((code == 200 || code == api.status.ok) && data is List<dynamic>) {
          List<T> result = data.map((item) {
            return build(item);
          }).toList();
          controller.add(
            response.copy(result: result),
          );
        } else {
          final error = "Data unmodified [${reference.statusCode}]";
          controller.addError(
            response.copy(snapshot: reference, error: error),
          );
        }
      });
    } catch (_) {
      controller.addError(_);
    }

    return controller.stream;
  }
}

class Api {
  final String api;
  final ApiStatus status;

  const Api({
    required this.api,
    this.status = const ApiStatus(),
  });
}

class ApiStatus {
  final int ok;
  final int canceled;
  final int created;
  final int updated;
  final int deleted;

  const ApiStatus({
    this.ok = 200,
    this.created = 201,
    this.updated = 202,
    this.deleted = 203,
    this.canceled = 204,
  });
}

enum ApiRequest { get, post }
