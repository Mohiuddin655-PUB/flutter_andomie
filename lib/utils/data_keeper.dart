typedef DataKeeperCallback<T> = Future<T> Function();

class DataKeeper {
  static DataKeeper? _i;

  static DataKeeper get i => _i ??= DataKeeper._();

  final Map<String, dynamic> _db = {};

  DataKeeper._();

  String _key(String name, [Iterable<Object?> props = const []]) {
    if (props.isEmpty) return name;
    final generated = props
        .map((e) {
          if (e == null) return null;
          return e.toString().toLowerCase();
        })
        .where((e) => e != null)
        .join("_");
    return "${name}_$generated";
  }

  Future<T> put<T>(
    String name, {
    Iterable<Object?> keyProps = const [],
    required DataKeeperCallback<T> callback,
  }) async {
    final reference = "${_key(name, keyProps)}_${T.toString().toLowerCase()}";
    return _db[reference] ??= await callback();
  }

  void clear() => _db.clear();
}
