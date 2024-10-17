typedef ObjectBuilder<T> = T Function(dynamic value);

extension ObjectExtension on Object? {
  bool get isValid => this != null;

  bool get isNotValid => !isValid;

  bool get isMap => this is Map;

  bool get isList => this is List;

  bool equals(dynamic compare) {
    return this != null &&
        this == compare &&
        runtimeType == compare.runtimeType;
  }

  T? _v<T extends Object?>(
    dynamic source, [
    ObjectBuilder<T>? builder,
  ]) {
    if (source == null) return null;
    if (builder != null) return builder(source);
    if (source is T) return source;
    if (source is num) {
      if (T == int) return source.toInt() as T;
      if (T == double) return source.toDouble() as T;
      if (T == String) return source.toString() as T;
    }
    if (source is String) {
      if (T == num || T == int || T == double) {
        final number = num.tryParse(source);
        if (number != null) {
          if (T == int) return number.toInt() as T;
          if (T == double) return number.toDouble() as T;
          return number as T;
        }
      }
      if (T == bool) {
        final boolean = bool.tryParse(source);
        if (boolean != null) return boolean as T;
      }
    }
    return null;
  }

  Iterable<T>? _vs<T>(
    dynamic source, [
    ObjectBuilder<T>? builder,
  ]) {
    if (source == null || source is! Iterable) return null;
    return source.map((e) => _v(e, builder)).whereType<T>();
  }

  T find<T extends Object?>({
    Object? key,
    T? defaultValue,
    ObjectBuilder<T>? builder,
  }) {
    final T? arguments = findOrNull(
      key: key,
      defaultValue: defaultValue,
      builder: builder,
    );
    if (arguments != null) {
      return arguments;
    } else {
      throw UnimplementedError("$T didn't find from this object");
    }
  }

  T findByKey<T extends Object?>(
    String key,
    T defaultValue, [
    ObjectBuilder<T>? builder,
  ]) {
    return find(key: key, defaultValue: defaultValue, builder: builder);
  }

  T? findOrNull<T extends Object?>({
    Object? key,
    T? defaultValue,
    ObjectBuilder<T>? builder,
  }) {
    final root = this;
    final value = key == null
        ? root
        : root is Map
            ? root[key]
            : null;

    return _v(value, builder) ?? defaultValue;
  }

  List<T> finds<T extends Object?>({
    Object? key,
    List<T>? defaultValue,
    ObjectBuilder<T>? builder,
  }) {
    final List<T>? arguments = findsOrNull(
      key: key,
      defaultValue: defaultValue,
      builder: builder,
    );
    if (arguments != null) {
      return arguments;
    } else {
      throw UnimplementedError("List<$T> didn't find from this object");
    }
  }

  List<T> findsByKey<T extends Object?>(
    String key,
    List<T> defaultValue, [
    ObjectBuilder<T>? builder,
  ]) {
    return finds(key: key, defaultValue: defaultValue, builder: builder);
  }

  List<T>? findsOrNull<T extends Object?>({
    Object? key,
    List<T>? defaultValue,
    ObjectBuilder<T>? builder,
  }) {
    final root = this;
    final data = key == null
        ? root
        : root is Map
            ? root[key]
            : null;
    final iterable = _vs(data, builder);
    if (iterable == null) return defaultValue;
    return List.from(iterable);
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
