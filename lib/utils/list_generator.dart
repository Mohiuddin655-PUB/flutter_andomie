import 'dart:math';

/// A utility class for creating and managing lists in chunks.
class ListGenerator<T> {
  final int capacity;

  /// Creates a new instance of [ListGenerator] with the specified capacity.
  ListGenerator(this.capacity);

  List<List<T>> _collections = [];
  int _index = 0;

  /// Gets the current index of the [ListGenerator].
  int get index => _index;

  /// Gets all the collections (chunks) created by the [ListGenerator].
  List<List<T>> get collections => _collections;

  /// Gets the current collection (chunk) from the [ListGenerator].
  ///
  /// Example:
  ///
  /// ```dart
  /// List<int> myList = [1, 2, 3, 4, 5, 6, 7, 8];
  /// ListGenerator<int> generator = ListGenerator.init("numbers", 3, myList);
  /// List<int> currentCollection = generator.collection();
  /// print(currentCollection);  // Output: [1, 2, 3]
  /// ```
  List<T> chunk([int? position]) {
    final i = position ?? index;
    final data = collections.length > i ? collections[i] : <T>[];
    _index++;
    return data;
  }

  /// Loads a list into the [ListGenerator] and divides it into chunks.
  ///
  /// Example:
  ///
  /// ```dart
  /// List<int> myList = [1, 2, 3, 4, 5, 6, 7, 8];
  /// ListGenerator<int> generator = ListGenerator<int>(3);
  /// List<List<int>> parts = generator.load(myList);
  ///
  /// Output: [[1, 2, 3],[4, 5, 6],[7, 8]]
  /// ```
  List<List<T>> load(Iterable<T> list) {
    final limit = max(capacity, 1);
    final n = list.length;
    final parts = <List<T>>[];
    for (int i = 0; i < n; i += limit) {
      parts.add(List<T>.from(list).sublist(i, min(n, i + limit)));
    }
    _collections = parts;
    _index = 0;
    return _collections;
  }
}
