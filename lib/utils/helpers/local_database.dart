part of 'helpers.dart';

typedef OnLocalDataBuilder<T extends Entity> = T Function(dynamic);

class LocalDatabase extends PreferenceHelper {
  const LocalDatabase(super.preferences);

  static SharedPreferences? _proxy;

  static Future<LocalDatabase> get instance async {
    return LocalDatabase(
      _proxy ??= await SharedPreferences.getInstance(),
    );
  }

  static Future<LocalDatabase> get I => instance;

  static Future<LocalDatabase> getInstance() => instance;

  Future<bool> input<T extends Entity>(
    String key,
    List<T>? data,
  ) async {
    try {
      final db = this;
      if (data.isValid) {
        return db.setString(key, data._);
      } else {
        return db.removeItem(key);
      }
    } catch (_) {
      return Future.error(_);
    }
  }

  Future<List<T>> output<T extends Entity>(
    String key,
    OnLocalDataBuilder<T> builder,
  ) async {
    try {
      final db = this;
      return db.getString(key)._.map((E) => builder(E)).toList();
    } catch (_) {
      return Future.error(_);
    }
  }
}

extension _LocalListExtension<T extends Entity> on List<T>? {
  List<T> get use => this.use;

  String get _ => jsonEncode(use.map((_) => _.source).toList());
}

extension _LocalStringExtension on String? {
  List get _ => isValid ? jsonDecode(this ?? "[]") : [];
}
