part of 'extensions.dart';

extension IntExtension on int? {
  int get use => this ?? 0;

  bool get isValid => use > 0;

  bool get isNotValid => !isValid;
}
