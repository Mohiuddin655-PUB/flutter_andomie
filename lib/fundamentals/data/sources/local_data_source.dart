part of 'sources.dart';

abstract class LocalDataSourceImpl<T extends Entity>
    extends LocalDataSource<T> {
  final SharedPreferences db;
  final String path;

  LocalDataSourceImpl({
    required this.db,
    required this.path,
  });

  bool isExisted(String id, List<T>? data) {
    if (data != null && data.isNotEmpty) {
      for (var value in data) {
        if (id.equals(value.id)) {
          return true;
        }
      }
      return false;
    } else {
      return false;
    }
  }

  @override
  Future<Response<T>> clear<R>({
    R? Function(R parent)? source,
  }) async {
    final response = Response<T>();
    try {
      final isSaved = await db.remove(path);
      return response.attach(data: null, isSuccessful: isSaved);
    } catch (_) {
      return response.attach(exception: "Failed to clean data!");
    }
  }

  @override
  Future<Response<T>> delete<R>(
    String id, {
    R? Function(R parent)? source,
  }) async {
    final response = await gets();
    final list = response.result ?? [];
    for (int index = 0; index < list.length; index++) {
      final x = list[index];
      if (id.equals(x.id)) {
        list.removeAt(index);
      }
    }
    return inserts(list);
  }

  @override
  Future<Response<T>> get<R>(
    String id, {
    R? Function(R parent)? source,
  }) async {
    final response = await gets();
    final list = response.result ?? [];
    for (int index = 0; index < list.length; index++) {
      final x = list[index];
      if (id.equals(x.id)) {
        return response.attach(data: x);
      }
    }
    return response.attach(exception: "Data not found!");
  }

  @override
  Future<Response<T>> getUpdates<R>({
    R? Function(R parent)? source,
  }) {
    return Future.error("Current not initialized!");
  }

  @override
  Future<Response<T>> gets<R>({
    R? Function(R parent)? source,
  }) async {
    final response = Response<T>();
    try {
      final source = db.getString(path);
      if (source != null) {
        final json = jsonDecode(source) as List;
        final data = json.map((e) {
          return build(e);
        }).toList();
        return response.attach(result: data);
      } else {
        return response.attach(exception: "Data not found!");
      }
    } catch (e) {
      return response.attach(exception: "Failed to load data!");
    }
  }

  @override
  Future<Response<T>> insert<R>(
    T data, {
    R? Function(R parent)? source,
  }) async {
    final response = await gets();
    final list = response.result ?? [];
    final isInsertable = !isExisted(data.id, list);
    if (isInsertable) {
      list.add(data);
      final request = await inserts(list);
      return response.attach(result: request.result);
    } else {
      return response.attach(message: "Already data added!");
    }
  }

  @override
  Future<Response<T>> inserts<R>(
    List<T> data, {
    R? Function(R parent)? source,
  }) async {
    final response = Response<T>();
    try {
      if (data.isNotEmpty) {
        final currentMap = data.map((e) => e.source).toList();
        final String value = jsonEncode(currentMap);
        final saved = await db.setString(path, value);
        return response.attach(result: data, isSuccessful: saved);
      } else {
        return response.attach(exception: "Data not valid!");
      }
    } catch (_) {
      return response.attach(exception: "Failed to upload data!");
    }
  }

  @override
  Future<bool> isAvailable<R>(
    String id, {
    R? Function(R parent)? source,
  }) async {
    final response = await gets();
    return isExisted(path, response.result);
  }

  @override
  Stream<Response<T>> live<R>(
    String id, {
    R? Function(R parent)? source,
  }) {
    return Stream.error("Current not initialized!");
  }

  @override
  Stream<Response<T>> lives<R>({
    R? Function(R parent)? source,
  }) {
    return Stream.error("Current not initialized!");
  }

  @override
  Future<Response<T>> update<R>(
    T data, {
    R? Function(R parent)? source,
  }) async {
    final response = Response<T>();
    final fetch = await gets();
    final list = fetch.result ?? [];
    int index = list.indexWhere((element) => element.id == data.id);
    if (index > -1) {
      list.removeAt(index);
      list.add(data);
      final request = await inserts(list);
      return response.attach(result: request.result);
    } else {
      return response.attach(message: "Data not inserted!");
    }
  }
}
