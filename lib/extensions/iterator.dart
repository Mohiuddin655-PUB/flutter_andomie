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

  R reduceAs<R>(R initial, R Function(R value, E element) combine) {
    Iterator<E> iterator = this.iterator;
    if (!iterator.moveNext()) return initial;
    R value = combine(initial, iterator.current);
    while (iterator.moveNext()) {
      value = combine(value, iterator.current);
    }
    return value;
  }

  Future<R> reduceAsyncAs<R>(
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
}
