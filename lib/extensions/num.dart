extension NumExtension on num? {
  num get use => this ?? 0;

  num? get verified => isValid ? this : null;

  int get asInt => use.toInt();

  double get asDouble => use.toDouble();

  bool get isValid => use > 0;

  bool get isNotValid => !isValid;

  int asMinPoint(int step) => (use ~/ step) * step;

  int asMaxPoint(int step) => asMinPoint(step) + step;

  String toLimitation(
    int limit, {
    String limitSign = "+",
    bool signAsEnd = true,
  }) {
    if (use > limit) {
      return signAsEnd ? "$limitSign$limit" : "$limit$limitSign";
    } else {
      return "$this";
    }
  }
}
