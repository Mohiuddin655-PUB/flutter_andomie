import 'dart:convert';

extension EDStringHelper on String? {
  Map<String, dynamic> get decode {
    final root = jsonDecode(this ?? "{}");
    if (root is Map<String, dynamic>) return root;
    return {};
  }
}

extension EDMapHelper on Map<String, dynamic>? {
  String get encode {
    final root = jsonEncode(this ?? "{}");
    return root;
  }
}
