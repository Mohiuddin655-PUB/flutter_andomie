extension NumExtension on num? {
  num get use => this ?? 0;

  String get twoFixedDigit => use >= 10 ? "$use" : "0$use";

  String get threeFixedDigit {
    if (use >= 100) {
      return "$use";
    } else if (use >= 10) {
      return "0$use";
    } else {
      return "00$use";
    }
  }
}
