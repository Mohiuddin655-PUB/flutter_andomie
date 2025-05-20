extension EnumHelper on Enum {
  bool isSameAs(Object? source) {
    if (this == source) return true;
    if (name.toLowerCase() == source.toString().trim().toLowerCase()) {
      return true;
    }
    if (index == source) return true;
    if (toString().toLowerCase() == source.toString().trim().toLowerCase()) {
      return true;
    }
    return false;
  }
}

extension EnumsHelper<T extends Enum> on Iterable<T> {
  T? _lookup(Object? source, int index) {
    if (index >= length) return null;
    final x = elementAtOrNull(index);
    if (x != null && x.isSameAs(source)) {
      return x;
    }
    return _lookup(source, index + 1);
  }

  T find(Object? source) => findOrNull(source) ?? first;

  T? findOrNull(Object? source) => _lookup(source, 0);
}
