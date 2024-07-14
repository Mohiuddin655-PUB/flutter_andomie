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
    var root = this;
    if (root is Map) {
      var arguments = root[key];
      if (arguments is T) {
        return arguments;
      } else {
        return defaultValue;
      }
    } else {
      if (key == null && root is T) {
        return root;
      } else {
        return defaultValue;
      }
    }
  }
}
