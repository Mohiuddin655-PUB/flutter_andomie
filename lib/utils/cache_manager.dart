class CacheManager {
  static CacheManager? _i;

  static CacheManager get i => _i ??= CacheManager._();

  final Map<String, dynamic> _db = {};

  Iterable<String> get keys => _db.keys;

  Iterable<dynamic> get values => _db.values;

  CacheManager._();

  String hashKey(
    Type type,
    String name, [
    Iterable<Object?> props = const [],
  ]) {
    if (props.isEmpty) return "$name:$type";
    final code = props
        .map((e) {
          if (e == null) return '';
          return e.toString();
        })
        .where((e) => e.isNotEmpty)
        .join("_")
        .hashCode;
    return "$name:$type#$code";
  }

  Future<T> request<T>(
    String name, {
    bool? cached,
    Iterable<Object?> keyProps = const [],
    required Future<T> Function() callback,
  }) async {
    cached ??= false;
    if (!cached) return callback();
    final k = hashKey(T, name, keyProps);
    final x = _db[k];
    if (x is T) return x;
    return _db[k] ??= await callback();
  }

  T? pick<T>(String key) {
    final x = _db[key];
    if (x is T) return x;
    return null;
  }

  dynamic remove(String key) => _db.remove(key);

  void clear() => _db.clear();
}
