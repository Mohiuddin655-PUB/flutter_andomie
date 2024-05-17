extension EntityBoolHelper on bool? {
  bool get use => this ?? false;

  bool get isValid => this != null;

  bool get isNotValid => !isValid;
}
