extension DoubleExtension on double? {
  double get use => this ?? 0;

  bool get isValid => use > 0;

  bool get isNotValid => !isValid;

  double get validateAsPercentage => validate();

  double validate({
    double max = 1,
    double min = 0,
  }) {
    final x = use;
    if (x < min) {
      return min;
    } else if (x > max) {
      return max;
    } else {
      return x;
    }
  }
}
