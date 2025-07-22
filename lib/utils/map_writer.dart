class MapWriter {
  const MapWriter._();

  static Map _combine(Map a, Map b) {
    final result = {};
    for (final key in {...a.keys, ...b.keys}) {
      final aVal = a[key];
      final bVal = b[key];
      if (aVal is Map && bVal is Map) {
        result[key] = combine(Map.from(aVal), Map.from(bVal));
      } else if (b.containsKey(key)) {
        result[key] = bVal;
      } else {
        result[key] = aVal;
      }
    }

    return result;
  }

  static Map combine(Map a, Map? b) {
    if (b == null || b.isEmpty) return a;
    return _combine(a, b);
  }
}

extension MapWriterHelper on Map {
  Map combine(Map? other) => MapWriter.combine(this, other);
}
