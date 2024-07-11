import 'dart:math' as math;

extension IntExtension on int? {
  int get use => this ?? 0;

  bool get isValid => use > 0;

  bool get isNotValid => !isValid;

  String get x2D => use < 10 ? "0$use" : "$use";

  String get x3D => use < 100 ? "00$use" : x2D;

  String get x4D => use < 1000 ? "000$use" : x3D;

  int get validateAsPercentage => validate();

  int validate({
    int max = 100,
    int min = 0,
  }) {
    return math.min(math.max(use, max), min);
  }
}
