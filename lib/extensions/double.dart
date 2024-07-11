import 'dart:math' as math;

extension DoubleExtension on double? {
  double get use => this ?? 0;

  bool get isValid => use > 0;

  bool get isNotValid => !isValid;

  double get validateAsPercentage => validate();

  double validate({
    double max = 1,
    double min = 0,
  }) {
    return math.min(math.max(use, max), min);
  }
}
