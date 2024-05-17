import 'dart:math';

/// A utility class for creating and managing lists in chunks.
class ListGenerator<T> {
  /// Creates a new instance of [ListGenerator] with the specified capacity.
  ListGenerator._();

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

  static final Map<String, ListGenerator> _proxies = {};

  /// Loads a list into the [ListGenerator] and divides it into chunks.
  ///
  /// Example:
  ///
  /// ```dart
  /// List<int> myList = [1, 2, 3, 4, 5, 6, 7, 8];
  /// ListGenerator<int> generator = ListGenerator.init("numbers", 3, myList);
  /// ```
  static ListGenerator<T> init<T>(String name, int capacity, List<T> list) {
    final instance = ListGenerator<T>._();
    final limit = max(capacity, 1);
    final n = list.length;
    final parts = <List<T>>[];
    for (int i = 0; i < n; i += limit) {
      parts.add(list.sublist(i, min(n, i + limit)));
    }
    instance._collections = parts;
    instance._index = 0;
    _proxies[name] = instance;
    return instance;
  }

  /// Loads a list into the [ListGenerator] and divides it into chunks.
  ///
  /// Example:
  ///
  /// ```dart
  /// List<int> myList = [1, 2, 3, 4, 5, 6, 7, 8];
  /// ListGenerator.init("numbers", 3, myList);
  /// ListGenerator<int> generator = ListGenerator.of("numbers");
  /// ```
  static ListGenerator<T> of<T>(String name) {
    final instance = _proxies[name];
    if (instance is ListGenerator<T>) {
      return instance;
    } else {
      throw UnimplementedError(
        "ListGenerator not initialize yet for $name\n"
        "You should initialize for $name like:\n\n"
        "List<int> myList = [1, 2, 3, 4, 5, 6, 7, 8];\n"
        "ListGenerator.init('numbers', 3, myList)\n",
      );
    }
  }
}
