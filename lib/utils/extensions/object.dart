part of 'extensions.dart';

extension ObjectExtension on Object? {
  bool get isValid => this != null;

  bool get isNotValid => !isValid;

  bool get isMap => this is Map<String, dynamic>;

  bool equals(dynamic compare) => this != null && this == compare;
}
