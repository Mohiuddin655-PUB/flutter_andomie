part of 'sources.dart';

abstract class RealtimeDataSourceImpl<T extends Entity>
    extends RemoteDataSource<T> {
  final String path;

  RealtimeDataSourceImpl({required this.path});

  FirebaseDatabase? _db;

  FirebaseDatabase get database => _db ??= FirebaseDatabase.instance;

  DatabaseReference _source<R>(
    OnDataSourceBuilder<R>? source,
  ) {
    final parent = database.ref(path);
    dynamic current = source?.call(parent as R);
    if (current is DatabaseReference) {
      return current;
    } else {
      return parent;
    }
  }

  String get uid => FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  Future<Response<T>> clear<R>({
    bool isConnected = false,
    OnDataSourceBuilder<R>? source,
  }) {
    return Future.error("Currently not initialized!");
  }

  @override
  Future<Response<T>> delete<R>(
    String id, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? source,
  }) async {
    final response = Response<T>();
    try {
      await _source(source).child(id).remove();
      return response.modify(successful: true);
    } catch (_) {
      return response.modify(exception: _.toString());
    }
  }

  @override
  Future<Response<T>> get<R>(
    String id, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? source,
  }) async {
    final response = Response<T>();
    try {
      final result = await _source(source).child(id).get();
      if (result.exists && result.value != null) {
        return response.modify(data: build(result.value));
      } else {
        return response.modify(exception: "Data not found!");
      }
    } catch (_) {
      return response.modify(exception: _.toString());
    }
  }

  @override
  Future<Response<T>> getUpdates<R>({
    bool isConnected = false,
    OnDataSourceBuilder<R>? source,
  }) {
    return gets(
      isConnected: isConnected,
      forUpdates: true,
      source: source,
    );
  }

  @override
  Future<Response<T>> gets<R>({
    bool isConnected = false,
    OnDataSourceBuilder<R>? source,
    bool forUpdates = false,
  }) async {
    final response = Response<T>();
    try {
      final result = await _source(source).get();
      if (result.exists) {
        List<T> list = result.children.map((e) {
          return build(e.value);
        }).toList();
        return response.modify(result: list);
      } else {
        return response.modify(exception: "Data not found!");
      }
    } catch (_) {
      return response.modify(exception: _.toString());
    }
  }

  @override
  Future<Response<T>> insert<R>(
    T data, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? source,
  }) async {
    final response = Response<T>();
    if (data.id.isNotEmpty) {
      final ref = _source(source).child(data.id);
      return await ref.get().then((value) async {
        if (!value.exists) {
          await ref.set(data);
          return response.modify(data: data);
        } else {
          return response.modify(
            snapshot: value,
            message: 'Already inserted!',
          );
        }
      });
    } else {
      return response.modify(exception: "ID isn't valid!");
    }
  }

  @override
  Future<Response<T>> inserts<R>(
    List<T> data, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? source,
  }) {
    return Future.error("Currently not initialized!");
  }

  @override
  Future<Response<T>> isAvailable<R>(
    String id, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? source,
  }) {
    return Future.error("Currently not initialized!");
  }

  @override
  Stream<Response<T>> live<R>(
    String id, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? source,
  }) {
    final controller = StreamController<Response<T>>();
    final response = Response<T>();
    try {
      _source(source).child(id).onValue.listen((event) {
        if (event.snapshot.exists || event.snapshot.value != null) {
          controller.add(response.modify(data: build(event.snapshot.value)));
        } else {
          controller.addError("Data not found!");
        }
      });
    } catch (_) {
      controller.addError(_);
    }
    return controller.stream;
  }

  @override
  Stream<Response<T>> lives<R>({
    bool isConnected = false,
    OnDataSourceBuilder<R>? source,
  }) {
    final controller = StreamController<Response<T>>();
    final response = Response<T>();
    try {
      _source(source).onValue.listen((result) {
        if (result.snapshot.exists) {
          List<T> list = result.snapshot.children.map((e) {
            return build(e.value);
          }).toList();
          controller.add(response.modify(result: list));
        } else {
          controller.addError("Data not found!");
        }
      });
    } catch (_) {
      controller.addError(_);
    }

    return controller.stream;
  }

  @override
  Future<Response<T>> update<R>(
    T data, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? source,
  }) async {
    final response = Response<T>();
    try {
      await _source(source).child(data.id).update(data.source);
      return response.modify(successful: true);
    } catch (_) {
      return response.modify(exception: _.toString());
    }
  }
}
