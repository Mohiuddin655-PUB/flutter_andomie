extension ObjectExtension on Object? {
  bool get isValid => this != null;

  bool get isNotValid => !isValid;

  bool get isMap => this is Map;

  bool get isList => this is List;

  bool equals(dynamic compare) => this != null && this == compare;

  T find<T extends Object?>({Object? key, T? defaultValue}) {
    final T? arguments = findOrNull(key: key, defaultValue: defaultValue);
    if (arguments != null) {
      return arguments;
    } else {
      throw UnimplementedError("$T didn't find from this object");
    }
  }

  T findByKey<T extends Object?>(String key, T defaultValue) {
    return find(key: key, defaultValue: defaultValue);
  }

  T? findOrNull<T extends Object?>({Object? key, T? defaultValue}) {
    final root = this;
    final value = root is Map && key != null ? root[key] : root;
    if (value is T) return value;
    if (value is num) {
      if (T == int) return value.toInt() as T;
      if (T == double) return value.toDouble() as T;
      if (T == String) return value.toString() as T;
    }
    if (value is String) {
      if (T == num || T == int || T == double) {
        final number = num.tryParse(value);
        if (number != null) {
          if (T == int) return number.toInt() as T;
          if (T == double) return number.toDouble() as T;
          return number as T;
        }
      }
      if (T == bool) {
        final boolean = bool.tryParse(value);
        if (boolean != null) return boolean as T;
      }
    }
    return defaultValue;
  }

  T get<T extends Object?>({Object? key, T? defaultValue}) {
    return find(key: key, defaultValue: defaultValue);
  }

  T getByKey<T extends Object?>(String key, T defaultValue) {
    return findByKey(key, defaultValue);
  }

  T? getOrNull<T extends Object?>({Object? key, T? defaultValue}) {
    return findOrNull(key: key, defaultValue: defaultValue);
  }
}
