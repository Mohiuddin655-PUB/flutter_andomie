extension ListExtension<E> on List<E>? {
  bool get isValid => use.isNotEmpty;

  bool get isNotValid => !isValid;

  List<E> get use => this ?? [];

  List<E> get unify => List<E>.from(use.toSet());

  List<E> change(E value, [bool Function(E element)? test]) {
    final a = use;
    final index = test != null ? a.indexWhere(test) : a.indexOf(value);
    if (index >= 0) {
      a.removeAt(index);
      a.insert(index, value);
      return a;
    }
    return a;
  }

  List<E> toggle(
    E value, {
    bool? exist,
    int newIndex = 0,
    void Function(bool status)? callback,
  }) {
    final a = use;
    exist ??= a.contains(value);
    if (exist) {
      a.remove(value);
      if (callback != null) callback(false);
    } else {
      if (newIndex > -1) {
        a.insert(newIndex, value);
      } else {
        a.add(value);
      }
      if (callback != null) callback(true);
    }
    return a;
  }
}
