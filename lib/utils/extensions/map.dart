part of 'extensions.dart';

extension MapExtension on Map<String, dynamic>? {
  T? getValue<T>(String key) {
    var data = this != null ? this![key] : null;
    if (data is T) {
      return data;
    } else {
      return null;
    }
  }
}
