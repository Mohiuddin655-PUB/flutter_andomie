extension EnumHelper on Enum {
  bool isSameAs(Object? source) {
    if (this == source) return true;
    if (name.toLowerCase() == source.toString().trim().toLowerCase()) {
      return true;
    }
    if (index == source) return true;
    if (toString().toLowerCase() == source.toString().trim().toLowerCase()) {
      return true;
    }
    return false;
  }
}
