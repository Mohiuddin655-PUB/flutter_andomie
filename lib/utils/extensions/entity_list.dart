part of 'extensions.dart';

extension EntityListExtension<E extends Entity> on List<E>? {
  List<Map<String, dynamic>> get convertAsMappableList {
    return use.map((e) => e.source).toList();
  }
}
