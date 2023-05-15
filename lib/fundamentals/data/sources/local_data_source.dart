part of 'sources.dart';

abstract class LocalDataSourceImpl<T extends Entity>
    extends LocalDataSource<T> {
  final SharedPreferences db;

  LocalDataSourceImpl({
    required this.db,
    required super.path,
  });

  @override
  bool isAvailable(String id, List<T>? data) {
    if (data != null && data.isNotEmpty) {
      for (var value in data) {
        if (validator.equals(id, value.id)) {
          return true;
        }
      }
      return false;
    } else {
      return false;
    }
  }

  @override
  Future<bool> exists({required String id}) async {
    final response = await gets();
    return isAvailable(path, response.result);
  }

  @override
  Future<Response<T>> insert({required T data}) async {
    final response = await gets();
    final list = response.result ?? [];
    final isInsertable = !isAvailable(data.id, list);
    if (isInsertable) {
      list.add(data);
      final request = await inserts(data: list);
      return response.copy(result: request.result);
    } else {
      return response.copy(message: "Already data added!");
    }
  }

  @override
  Future<Response<T>> inserts({required List<T>? data}) async {
    final response = Response<T>();
    try {
      if (data != null) {
        final currentMap = data.map((e) => e.source).toList();
        final String value = jsonEncode(currentMap);
        final saved = await db.setString(path, value);
        return response.copy(result: data, isSuccessful: saved);
      } else {
        return response.copy(error: "Data not valid!");
      }
    } catch (_) {
      return response.copy(error: "Failed to upload data!");
    }
  }

  @override
  Future<Response<T>> update({required T data}) async {
    final response = Response<T>();
    final fetch = await gets();
    final list = fetch.result ?? [];
    int index = list.indexWhere((element) => element.id == data.id);
    if (index > -1) {
      list.removeAt(index);
      list.add(data);
      final request = await inserts(data: list);
      return response.copy(result: request.result);
    } else {
      return response.copy(message: "Data not inserted!");
    }
  }

  @override
  Future<Response<T>> delete({required String id}) async {
    final response = await gets();
    final list = response.result ?? [];
    for (int index = 0; index < list.length; index++) {
      final x = list[index];
      if (validator.equals(id, x.id)) {
        list.removeAt(index);
      }
    }
    return inserts(data: list);
  }

  @override
  Future<Response<T>> get({required String id}) async {
    final response = await gets();
    final list = response.result ?? [];
    for (int index = 0; index < list.length; index++) {
      final x = list[index];
      if (validator.equals(id, x.id)) {
        return response.copy(data: x);
      }
    }
    return response.copy(error: "Data not found!");
  }

  @override
  Future<Response<T>> gets() async {
    final response = Response<T>();
    try {
      final source = db.getString(path);
      if (source != null) {
        final json = jsonDecode(source) as List;
        final data = json.map((e) {
          return build(e);
        }).toList();
        return response.copy(result: data);
      } else {
        return response.copy(error: "Data not found!");
      }
    } catch (e) {
      return response.copy(error: "Failed to load data!");
    }
  }

  @override
  Future<Response<T>> clear() async {
    final response = Response<T>();
    try {
      final isSaved = await db.remove(path);
      return response.copy(data: null, isSuccessful: isSaved);
    } catch (_) {
      return response.copy(error: "Failed to clean data!");
    }
  }
}
