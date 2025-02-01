extension MapExtension on Map<String, dynamic>? {
  Map<String, dynamic> get use => this ?? {};

  Map? get verified => isValid ? this : null;

  bool get isValid => use.isNotEmpty;

  bool get isNotValid => !isValid;

  bool isFound(String key, dynamic value) => use[key] != null;

  bool isNotFound(String key, dynamic value) => !use.isFound(value, value);

  T? getValue<T>(String key, [T? defaultValue]) {
    var data = this != null ? this![key] : null;
    if (data is T) {
      return data;
    } else {
      return defaultValue;
    }
  }

  Map<String, dynamic> attach(Map<String, dynamic> current) {
    final data = use;
    data.addAll(current);
    return data;
  }

  String get beautify {
    return toString()
        .replaceAll(",", "\n")
        .replaceAll("{", "")
        .replaceAll("}", "");
  }
}
