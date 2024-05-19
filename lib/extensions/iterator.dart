extension IterableExtension<E> on Iterable<E> {
  bool isFound(bool Function(E element) checker) {
    Iterator<E> iterator = this.iterator;
    if (!iterator.moveNext()) return false;
    if (checker(iterator.current)) return true;
    while (iterator.moveNext()) {
      if (checker(iterator.current)) return true;
    }
    return false;
  }

  bool isNotFound(bool Function(E element) checker) => !isFound(checker);

  int findIndex(int initial, bool Function(E element) query) {
    Iterator<E> iterator = this.iterator;
    if (!iterator.moveNext()) return initial;
    int index = 0;
    if (query(iterator.current)) return index;
    while (iterator.moveNext()) {
      if (query(iterator.current)) return index;
      index++;
    }
    return initial;
  }

  R convertAs<R>(R initial, R Function(R value, E element) combine) {
    Iterator<E> iterator = this.iterator;
    if (!iterator.moveNext()) return initial;
    R value = combine(initial, iterator.current);
    while (iterator.moveNext()) {
      value = combine(value, iterator.current);
    }
    return value;
  }

  Future<R> convertAsyncAs<R>(
    R initial,
    Future<R> Function(R value, E element) combine,
  ) async {
    Iterator<E> iterator = this.iterator;
    if (!iterator.moveNext()) return initial;
    R value = await combine(initial, iterator.current);
    while (iterator.moveNext()) {
      value = await combine(value, iterator.current);
    }
    return value;
  }

  Iterable<R> customizeAs<R>(
    R Function(E element) combine, [
    bool Function(R value)? checker,
  ]) {
    List<R> initial = [];
    Iterator<E> iterator = this.iterator;
    if (!iterator.moveNext()) return initial;
    R value = combine(iterator.current);
    if (checker == null || checker(value)) initial.add(value);
    while (iterator.moveNext()) {
      R value = combine(iterator.current);
      if (checker == null || checker(value)) initial.add(value);
    }
    return initial;
  }

  Future<Iterable<R>> customizeAsyncAs<R>(
    Future<R> Function(E element) combine, [
    bool Function(R value)? checker,
  ]) async {
    List<R> initial = [];
    Iterator<E> iterator = this.iterator;
    if (!iterator.moveNext()) return initial;
    R value = await combine(iterator.current);
    if (checker == null || checker(value)) initial.add(value);
    while (iterator.moveNext()) {
      R value = await combine(iterator.current);
      if (checker == null || checker(value)) initial.add(value);
    }
    return initial;
  }

  List<R> to<R>(
    R Function(int index, E element) combine, {
    bool reverse = false,
    int limit = 0,
  }) {
    List<R> initial = [];
    if (isEmpty) return initial;
    int index = reverse ? length - 1 : 0;
    while (elementAtOrNull(index) != null) {
      if (limit > 0 && initial.length >= limit) break;
      initial.add(combine(index, elementAt(index)));
      index = reverse ? index - 1 : index + 1;
    }
    return initial;
  }
}
