part of 'sources.dart';

abstract class FireStoreDataSourceImpl<T extends Entity> extends RemoteDataSource<T> {
  final String path;
  final LocalDataHandler<T>? local;

  FireStoreDataSourceImpl({
    required this.path,
    this.local,
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
  Future<Response<T>> create<R>(
    T data, {
    bool cacheMode = false,
    bool onlyCache = false,
    R? Function(R parent)? source,
  }) async {
    final response = Response<T>();
    if (data.id.isNotEmpty) {
      final reference = _source(source).doc(data.id);
      return await reference.get().then((value) async {
        if (!value.exists) {
          await reference.set(data.source, SetOptions(merge: true));
          return response.copy(data: data);
        } else {
          return response.copy(
            snapshot: value,
            message: 'Already inserted!',
          );
        }
      });
    } else {
      return response.copy(error: "Id isn't valid!");
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
    final response = Response<T>();
    try {
      await _source(source).doc(id).update(data);
      return response.copy(isSuccessful: true);
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
    final response = Response<T>();
    try {
      await _source(source).doc(id).delete();
      return response.copy(isSuccessful: true);
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
      final result = await _source(source).doc(id).get();
      if (result.exists && result.data() != null) {
        return response.copy(data: build(result.data()));
      } else {
        return response.copy(error: "Data not found!");
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
  }) async {
    final response = Response<T>();
    try {
      final result = await _source(source).get();
      if (result.docs.isNotEmpty || result.docChanges.isNotEmpty) {
        if (forUpdates) {
          List<T> list = result.docChanges.map((e) {
            return build(e.doc.data());
          }).toList();
          return response.copy(result: list);
        } else {
          List<T> list = result.docs.map((e) {
            return build(e.data());
          }).toList();
          return response.copy(result: list);
        }
      } else {
        return response.copy(error: "Data not found!");
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
      _source(source).doc(id).snapshots().listen((event) {
        if (event.exists || event.data() != null) {
          controller.add(response.copy(data: build(event.data())));
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
    bool onlyUpdatedData = false,
    Map<String, dynamic>? extra,
    R? Function(R parent)? source,
  }) {
    final controller = StreamController<Response<T>>();
    final response = Response<T>();
    try {
      _source(source).snapshots().listen((event) {
        if (event.docs.isNotEmpty || event.docChanges.isNotEmpty) {
          if (onlyUpdatedData) {
            List<T> list = event.docChanges.map((e) {
              return build(e.doc.data());
            }).toList();
            controller.add(response.copy(result: list));
          } else {
            List<T> list = event.docs.map((e) {
              return build(e.data());
            }).toList();
            controller.add(response.copy(result: list));
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
}
