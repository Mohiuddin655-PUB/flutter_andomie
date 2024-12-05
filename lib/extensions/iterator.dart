import 'dart:math';

extension IterableExtension<E> on Iterable<E> {
  E get random => elementAt(Random().nextInt(length));

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

  bool isLookup(Iterable<E> other, String Function(E element) checker) {
    return lookup(other, checker).isNotEmpty;
  }

  bool isSame(Iterable<E> other) => toString() == other.toString();

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

  Iterable<int> findIndexes<B>(
    List<B> value,
    bool Function(E a, B b) test,
  ) {
    return map((a) {
      return value.indexWhere((b) => test(a, b));
    }).where((e) => e > -1);
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

  E? firstWhereOrNull(bool Function(E) test) {
    try {
      return firstWhere(test);
    } catch (e) {
      return null;
    }
  }

  E? lastWhereOrNull(bool Function(E) test) {
    try {
      return lastWhere(test);
    } catch (e) {
      return null;
    }
  }

  Iterable<E> lookup(Iterable<E> other, String Function(E element) checker) {
    return where((e) {
      final a = checker(e);
      return other.map(checker).where((b) => a == b).isEmpty;
    });
  }

  List<E> mergeByTags(List<String> tags, String Function(E) matcher) {
    final List<E> orderedItems = [];
    final List<E> remainingItems = [];

    // Separate the items in value based on tags
    for (var e in this) {
      if (tags.contains(matcher(e))) {
        orderedItems.add(e);
      } else {
        remainingItems.add(e);
      }
    }

    // Arrange orderedItems in the same order as tags
    orderedItems.sort((a, b) {
      return tags.indexOf(matcher(a)).compareTo(tags.indexOf(matcher(b)));
    });

    // Combine the ordered items with the remaining items
    return [...orderedItems, ...remainingItems];
  }

  /// Rearranges the sequence of a list based on a 0-based index.
  ///
  /// The function takes an index and a list of items. It returns a new list
  /// where the items are rearranged, starting from the specified index
  /// and wrapping around to the beginning.
  ///
  /// Throws an [ArgumentError] if the index is out of range.
  ///
  /// Example:
  /// ```
  /// final data = ['a', 'b', 'c', 'd', 'e'];
  /// final result = data.sequence(2); // ['c', 'd', 'e', 'a', 'b']
  /// ```
  List<E> sequence(int index) {
    final items = toList();
    if (index < 0 || index >= items.length) {
      throw ArgumentError(
        'Index must be between 0 and the length of the items list minus one.',
      );
    }
    return [...items.sublist(index), ...items.sublist(0, index)];
  }

  List<R> to<R>(
    R Function(int index, E element) combine, {
    bool reverse = false,
    int limit = 0,
  }) {
    List<R> initial = [];
    if (isEmpty) return initial;
    int index = reverse ? length - 1 : 0;
    while (index >= 0 && index < length && elementAtOrNull(index) != null) {
      if (initial.length >= limit) break;
      initial.add(combine(index, elementAt(index)));
      index = reverse ? index - 1 : index + 1;
    }
    return initial;
  }

  Future<List<R>> toAsync<R>(
    Future<R> Function(int index, E element) combine, {
    bool reverse = false,
    int limit = 0,
  }) async {
    List<R> initial = [];
    if (isEmpty) return initial;
    int index = reverse ? length - 1 : 0;
    while (index >= 0 && index < length && elementAtOrNull(index) != null) {
      if (initial.length >= limit) break;
      initial.add(await combine(index, elementAt(index)));
      index = reverse ? index - 1 : index + 1;
    }
    return initial;
  }
}

extension IterableStringExtension on Iterable<String> {
  String get text {
    final items = this;
    if (items.isEmpty) return '';
    if (items.length == 1) return items.first;

    final itemList = items.toList();
    final lastItem = itemList.removeLast();

    return '${itemList.join(', ')} and $lastItem';
  }
}

extension IterableNumExtension on Iterable<num> {
  num get sum => reduce((a, b) => a + b);

  num get sub => reduce((a, b) => a - b);

  num get mul => reduce((a, b) => a * b);

  num get div => reduce((a, b) => a / b);

  num get mod => reduce((a, b) => a % b);
}
