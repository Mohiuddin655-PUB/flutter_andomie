extension NumExtension on num? {
  num get use => this ?? 0;

  int get toInt => use.toInt();

  double get toDouble => use.toDouble();

  bool get isValid => use > 0;

  bool get isNotValid => !isValid;

  String toLimitation(int limit, [String limitSign = "+"]) {
    if (use > limit) {
      return "$limit$limitSign";
    } else {
      return "$this";
    }
  }
}
