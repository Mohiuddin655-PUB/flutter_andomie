extension BoolHelper on bool? {
  bool get use => this ?? false;

  bool? get verified => isValid ? this : null;

  bool get isValid => this != null;

  bool get isNotValid => !isValid;
}
