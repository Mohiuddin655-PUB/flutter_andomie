extension DoubleExtension on double? {
  double get use => this ?? 0;

  bool get isValid => use > 0;

  bool get isNotValid => !isValid;
}
