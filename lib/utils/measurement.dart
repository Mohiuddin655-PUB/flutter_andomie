extension MeasurementHelper on num {
  double get inToCm => this * 2.54;

  double get toFt => this / 30.48;

  double get toLb => this * 2.20462;

  double get toKg => this * 0.45359237;
}
