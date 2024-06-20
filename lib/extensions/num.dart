extension NumExtension on num? {
  num get use => this ?? 0;

  int get asInt => use.toInt();

  double get asDouble => use.toDouble();

  bool get isValid => use > 0;

  bool get isNotValid => !isValid;

  String toLimitation(
    int limit, {
    String limitSign = "+",
    LimitPosition limitPosition = LimitPosition.end,
  }) {
    if (use > limit) {
      return limitPosition == LimitPosition.start
          ? "$limitSign$limit"
          : "$limit$limitSign";
    } else {
      return "$this";
    }
  }
}

enum LimitPosition { start, end }
