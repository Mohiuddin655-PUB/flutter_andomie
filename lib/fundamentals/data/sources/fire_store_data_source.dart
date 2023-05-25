part of 'sources.dart';

abstract class FireStoreDataSourceImpl<T extends Entity> extends RemoteDataSource<T> {
  final String path;

  FireStoreDataSourceImpl({
    required this.path,
  });

  FirebaseFirestore? _db;

  FirebaseFirestore get database => _db ??= FirebaseFirestore.instance;

  CollectionReference _source<R>(
    R? Function(R parent)? source,
  ) {
    final parent = database.collection(path);
    dynamic current = source?.call(parent as R);
    if (current is CollectionReference) {
      return current;
    } else {
      return parent;
    }
  }

  String get uid => FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  Future<Response<T>> clear<R>({
    R? Function(R parent)? source,
  }) {
    return Future.error("Currently not initialized!");
  }

  @override
  Future<Response<T>> delete<R>(
    String id, {
    R? Function(R parent)? source,
  }) async {
    final response = Response<T>();
    try {
      await _source(source).doc(id).delete();
      return response.attach(isSuccessful: true);
    } catch (_) {
      return response.attach(exception: _.toString());
    }
  }

  @override
  Future<Response<T>> get<R>(
    String id, {
    R? Function(R parent)? source,
  }) async {
    final response = Response<T>();
    try {
      final result = await _source(source).doc(id).get();
      if (result.exists && result.data() != null) {
        return response.attach(data: build(result.data()));
      } else {
        return response.attach(exception: "Data not found!");
      }
    } catch (_) {
      return response.attach(exception: _.toString());
    }
  }

  @override
  Future<Response<T>> getUpdates<R>({
    R? Function(R parent)? source,
  }) {
    return gets(
      forUpdates: true,
      source: source,
    );
  }

  @override
  Future<Response<T>> gets<R>({
    R? Function(R parent)? source,
    bool forUpdates = false,
  }) async {
    final response = Response<T>();
    try {
      final result = await _source(source).get();
      if (result.docs.isNotEmpty || result.docChanges.isNotEmpty) {
        if (forUpdates) {
          List<T> list = result.docChanges.map((e) {
            return build(e.doc.data());
          }).toList();
          return response.attach(result: list);
        } else {
          List<T> list = result.docs.map((e) {
            return build(e.data());
          }).toList();
          return response.attach(result: list);
        }
      } else {
        return response.attach(exception: "Data not found!");
      }
    } catch (_) {
      return response.attach(exception: _.toString());
    }
  }

  @override
  Future<Response<T>> insert<R>(
    T data, {
    R? Function(R parent)? source,
  }) async {
    final response = Response<T>();
    if (data.id.isNotEmpty) {
      final reference = _source(source).doc(data.id);
      return await reference.get().then((value) async {
        if (!value.exists) {
          await reference.set(data.source, SetOptions(merge: true));
          return response.attach(data: data);
        } else {
          return response.attach(
            snapshot: value,
            message: 'Already inserted!',
          );
        }
      });
    } else {
      return response.attach(exception: "Id isn't valid!");
    }
  }

  @override
  Future<Response<T>> inserts<R>(
    List<T> data, {
    R? Function(R parent)? source,
  }) {
    return Future.error("Currently not initialized!");
  }

  @override
  Future<bool> isAvailable<R>(
    String id, {
    R? Function(R parent)? source,
  }) {
    return Future.error("Currently not initialized!");
  }

  @override
  Stream<Response<T>> live<R>(
    String id, {
    R? Function(R parent)? source,
  }) {
    final controller = StreamController<Response<T>>();
    final response = Response<T>();
    try {
      _source(source).doc(id).snapshots().listen((event) {
        if (event.exists || event.data() != null) {
          controller.add(response.attach(data: build(event.data())));
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
    R? Function(R parent)? source,
    bool forUpdates = false,
  }) {
    final controller = StreamController<Response<T>>();
    final response = Response<T>();
    try {
      _source(source).snapshots().listen((event) {
        if (event.docs.isNotEmpty || event.docChanges.isNotEmpty) {
          if (forUpdates) {
            List<T> list = event.docChanges.map((e) {
              return build(e.doc.data());
            }).toList();
            controller.add(response.attach(result: list));
          } else {
            List<T> list = event.docs.map((e) {
              return build(e.data());
            }).toList();
            controller.add(response.attach(result: list));
          }
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
    R? Function(R parent)? source,
  }) async {
    final response = Response<T>();
    try {
      await _source(source).doc(data.id).update(data.source);
      return response.attach(isSuccessful: true);
    } catch (_) {
      return response.attach(exception: _.toString());
    }
  }
}
