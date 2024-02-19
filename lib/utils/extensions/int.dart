part of 'extensions.dart';

extension IntExtension on int? {
  int get use => this ?? 0;

  String get x2D => use < 10 ? "0$use" : "$use";

  String get x3D => use < 100 ? "00$use" : x2D;

  String get x4D => use < 1000 ? "000$use" : x3D;

  bool get isValid => use > 0;

  bool get isNotValid => !isValid;
}
