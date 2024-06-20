import 'dart:convert';

extension EDStringHelper on String? {
  Map<String, dynamic> get decode => decodeAsMap;

  Map<String, dynamic> get decodeAsMap {
    final root = jsonDecode(this ?? "{}");
    if (root is Map<String, dynamic>) return root;
    return {};
  }

  List get decodeAsList {
    final root = jsonDecode(this ?? "[]");
    if (root is List) return root;
    return [];
  }
}

extension EDMapHelper on Map<String, dynamic>? {
  String get encode {
    final root = jsonEncode(this ?? "{}");
    return root;
  }
}

extension EDListHelper on List<Map<String, dynamic>>? {
  String get encode {
    final root = jsonEncode(this ?? "[]");
    return root;
  }
}
