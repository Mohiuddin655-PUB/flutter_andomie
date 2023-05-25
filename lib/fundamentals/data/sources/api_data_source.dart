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
  Future<Response<T>> clear<R>({
    bool isActiveNetwork = false,
    R? Function(R parent)? source,
  }) async {
    final response = Response<T>();
    if (isActiveNetwork) {
      return response.withException(
        status: ResponseStatus.undefined,
        exception: "Currently not initialized!",
      );
    } else {
      return response.withStatus(
        ResponseStatus.networkError,
      );
    }
  }

  @override
  Future<Response<T>> delete<R>(
    String id, {
    bool isActiveNetwork = false,
    R? Function(R parent)? source,
  }) async {
    final response = Response<T>();
    if (isActiveNetwork) {
      try {
        if (id.isNotEmpty) {
          final url = currentUrl(id, source);
          final reference = await database.delete(url);
          final code = reference.statusCode;
          if (code == 200 || code == 201 || code == api.status.deleted) {
            return response.withFeedback(
              feedback: reference.data,
            );
          } else {
            return response.withFeedback(
              feedback: reference,
              exception: "Data unmodified [${reference.statusCode}]",
              status: ResponseStatus.unmodified,
            );
          }
        } else {
          return response.withException(
            exception: "Undefined ID [$id]",
            status: ResponseStatus.invalid,
          );
        }
      } catch (_) {
        return response.withException(
          exception: _.toString(),
          status: ResponseStatus.failure,
        );
      }
    } else {
      return response.withStatus(
        ResponseStatus.networkError,
      );
    }
  }

  @override
  Future<Response<T>> get<R>(
    String id, {
    bool isActiveNetwork = false,
    R? Function(R parent)? source,
  }) async {
    final response = Response<T>();
    if (isActiveNetwork) {
      try {
        if (id.isNotEmpty) {
          final url = currentUrl(id, source);
          final reference = await database.get(url);
          final data = reference.data;
          final code = reference.statusCode;
          if ((code == 200 || code == api.status.ok) && data is Map) {
            final result = build(data);
            return response.attach(data: result);
          } else {
            return response.attach(
              snapshot: reference,
              exception: "Data unmodified [${reference.statusCode}]",
              status: ResponseStatus.unmodified,
            );
          }
        } else {
          return response.withException(
            exception: "Undefined ID [$id]",
            status: ResponseStatus.invalid,
          );
        }
      } catch (_) {
        return response.withException(
          exception: _.toString(),
          status: ResponseStatus.failure,
        );
      }
    } else {
      return response.withStatus(
        ResponseStatus.networkError,
      );
    }
  }

  @override
  Future<Response<T>> getUpdates<R>({
    bool isActiveNetwork = false,
    R? Function(R parent)? source,
  }) {
    return gets(
      forUpdates: true,
      isActiveNetwork: isActiveNetwork,
      source: source,
    );
  }

  @override
  Future<Response<T>> gets<R>({
    bool isActiveNetwork = false,
    R? Function(R parent)? source,
    bool forUpdates = false,
  }) async {
    final response = Response<T>();
    if (isActiveNetwork) {
      try {
        final url = currentSource(source);
        final reference = await database.get(url);
        final data = reference.data;
        final code = reference.statusCode;
        if ((code == 200 || code == api.status.ok) && data is List<dynamic>) {
          List<T> result = data.map((item) {
            return build(item);
          }).toList();
          return response.withResult(result);
        } else {
          return response.attach(
            snapshot: reference,
            exception: "Data unmodified [${reference.statusCode}]",
            status: ResponseStatus.unmodified,
          );
        }
      } catch (_) {
        return response.withException(
          status: ResponseStatus.failure,
          exception: _.toString(),
        );
      }
    } else {
      return response.withStatus(
        ResponseStatus.networkError,
      );
    }
  }

  @override
  Future<Response<T>> insert<R>(
    T data, {
    bool isActiveNetwork = false,
    R? Function(R parent)? source,
  }) async {
    final response = Response<T>();
    if (isActiveNetwork) {
      if (data.source.isNotEmpty) {
        final url = data.id.isNotEmpty
            ? currentUrl(data.id, source)
            : currentSource(source);
        final reference = await database.post(url, data: data.source);
        final code = reference.statusCode;
        if (code == 200 || code == 201 || code == api.status.created) {
          final result = reference.data;
          return response.attach(result: result);
        } else {
          return response.attach(
            snapshot: reference,
            exception: "Data unmodified [${reference.statusCode}]",
            status: ResponseStatus.unmodified,
          );
        }
      } else {
        return response.withException(
          status: ResponseStatus.invalid,
          exception: "Undefined data $data",
        );
      }
    } else {
      return response.withStatus(
        ResponseStatus.networkError,
      );
    }
  }

  @override
  Future<Response<T>> inserts<R>(
    List<T> data, {
    bool isActiveNetwork = false,
    R? Function(R parent)? source,
  }) async {
    final response = Response<T>();
    if (isActiveNetwork) {
      return response.withException(
        status: ResponseStatus.undefined,
        exception: "Currently not initialized!",
      );
    } else {
      return response.withStatus(
        ResponseStatus.networkError,
      );
    }
  }

  @override
  Future<Response<T>> isAvailable<R>(
    String id, {
    bool isActiveNetwork = false,
    R? Function(R parent)? source,
  }) async {
    final response = Response<T>();
    if (isActiveNetwork) {
      return response.withException(
        status: ResponseStatus.undefined,
        exception: "Currently not initialized!",
      );
    } else {
      return response.withStatus(
        ResponseStatus.networkError,
      );
    }
  }

  @override
  Stream<Response<T>> live<R>(
    String id, {
    bool isActiveNetwork = false,
    R? Function(R parent)? source,
  }) {
    final controller = StreamController<Response<T>>();
    final response = Response<T>();
    if (isActiveNetwork) {
      try {
        if (id.isNotEmpty) {
          final url = currentUrl(id, source);
          Timer.periodic(const Duration(milliseconds: 3000), (timer) async {
            final reference = await database.get(url);
            final data = reference.data;
            final code = reference.statusCode;
            if ((code == 200 || code == api.status.ok) && data is Map) {
              final result = build(data);
              controller.add(response.withData(result));
            } else {
              controller.add(response.attach(
                snapshot: reference,
                exception: "Data unmodified [${reference.statusCode}]",
                status: ResponseStatus.unmodified,
              ));
            }
          });
        } else {
          controller.add(response.attach(
            exception: "Undefined ID [$id]",
            status: ResponseStatus.undefined,
          ));
        }
      } catch (_) {
        controller.add(response.withException(
          exception: _,
          status: ResponseStatus.failure,
        ));
      }
    } else {
      controller.add(response.withStatus(
        ResponseStatus.networkError,
      ));
    }
    return controller.stream;
  }

  @override
  Stream<Response<T>> lives<R>({
    bool isActiveNetwork = false,
    R? Function(R parent)? source,
  }) {
    final controller = StreamController<Response<T>>();
    final response = Response<T>();

    if (isActiveNetwork) {
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
            controller.add(response.withResult(result));
          } else {
            controller.add(response.attach(
              snapshot: reference,
              exception: "Data unmodified [${reference.statusCode}]",
              status: ResponseStatus.unmodified,
            ));
          }
        });
      } catch (_) {
        controller.add(response.withException(
          exception: _,
          status: ResponseStatus.failure,
        ));
      }
    } else {
      controller.add(response.withStatus(
        ResponseStatus.networkError,
      ));
    }

    return controller.stream;
  }

  @override
  Future<Response<T>> update<R>(
    T data, {
    bool isActiveNetwork = false,
    R? Function(R parent)? source,
  }) async {
    final response = Response<T>();
    if (isActiveNetwork) {
      try {
        if (data.source.isNotEmpty) {
          final url = currentUrl(data.id, source);
          final reference = await database.put(url, data: data);
          final code = reference.statusCode;
          if (code == 200 || code == 201 || code == api.status.updated) {
            return response.withStatus(ResponseStatus.ok);
          } else {
            return response.attach(
              status: ResponseStatus.unmodified,
              snapshot: reference,
              exception: "Data unmodified [${reference.statusCode}]",
            );
          }
        } else {
          return response.withException(
            status: ResponseStatus.undefined,
            exception: "Undefined data $data",
          );
        }
      } catch (_) {
        return response.withException(
          status: ResponseStatus.failure,
          exception: _.toString(),
        );
      }
    } else {
      return response.withStatus(
        ResponseStatus.networkError,
      );
    }
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
