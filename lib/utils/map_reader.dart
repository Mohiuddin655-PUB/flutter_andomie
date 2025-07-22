class MapReader {
  const MapReader._();

  static Object? _read(String key, Map map, String separator, [Object? root]) {
    List<String> keys = key.split(separator);
    if (keys.length > 1) {
      final firstKey = keys.first;
      if (map.containsKey(firstKey) && map[firstKey] is! String) {
        final current = map[keys.last] ?? map[key];
        return _read(
          key.substring(key.indexOf(separator) + 1),
          map[firstKey],
          separator,
          current is String ? current : root,
        );
      }
    }
    return map[key] ?? root;
  }

  static T? read<T extends Object?>(
    String key,
    Map data, {
    String separator = "/",
  }) {
    if (key.isEmpty || data.isEmpty || separator.isEmpty) return null;
    final x = _read(key, data, separator);
    if (x is T) return x;
    return null;
  }
}

extension MapReaderHelper on Map {
  T? read<T extends Object?>(String key, {String separator = "/"}) {
    return MapReader.read(
      key,
      this,
      separator: separator,
    );
  }
}
