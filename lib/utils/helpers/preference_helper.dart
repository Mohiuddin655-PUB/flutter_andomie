part of 'helpers.dart';

class PreferenceHelper {
  final SharedPreferences preferences;

  const PreferenceHelper(
    this.preferences,
  );

  static PreferenceHelper of({
    required SharedPreferences preferences,
  }) {
    return PreferenceHelper(preferences);
  }

  bool isExists(String key) {
    return preferences.containsKey(key);
  }

  Object getItem(String key, [dynamic defaultValue]) {
    return preferences.get(key) ?? defaultValue;
  }

  Set<String> getKeys() {
    return preferences.getKeys();
  }

  bool getBoolean(String key, [bool defaultValue = false]) {
    final value = preferences.getBool(key);
    return value ?? defaultValue;
  }

  double getDouble(String key, [double defaultValue = 0.0]) {
    final value = preferences.getDouble(key);
    return value ?? defaultValue;
  }

  int getInt(String key, [int defaultValue = 0]) {
    final value = preferences.getInt(key);
    return value ?? defaultValue;
  }

  String? getString(String key, [String? defaultValue]) {
    final value = preferences.getString(key);
    return value ?? defaultValue;
  }

  Map<String, dynamic> getData(
    String key, [
    Map<String, dynamic>? defaultValue,
  ]) {
    final value = preferences.getString(key);
    final data = jsonDecode(value ?? "{}");
    return data ?? defaultValue;
  }

  Future<bool> setData(
    String key,
    Map<String, dynamic>? value,
  ) {
    return preferences.setString(key, jsonEncode(value ?? {}));
  }

  List<String> getStrings(String key, [List<String> defaultValue = const []]) {
    return preferences.getStringList(key) ?? defaultValue;
  }

  Future<bool> setBoolean(String key, bool value) {
    return preferences.setBool(key, value);
  }

  Future<bool> setDouble(String key, double value) {
    return preferences.setDouble(key, value);
  }

  Future<bool> setInt(String key, int value) {
    return preferences.setInt(key, value);
  }

  Future<bool> setString(String key, String? value) {
    return preferences.setString(key, value ?? "");
  }

  Future<bool> setStrings(String key, List<String>? values) {
    return preferences.setStringList(key, values ?? []);
  }

  Future<bool> removeItem(String key) {
    return preferences.remove(key);
  }

  Future<bool> clearItems() {
    return preferences.clear();
  }

  Future<void> reloadItems() {
    return preferences.reload();
  }
}
