part of '../utils.dart';

/// A utility class for creating and managing lists in chunks.
class ListCreator<T> {
  final int _capacity;
  List<List<T>> _collections = [];
  int _index = 0;

  /// Creates a new instance of [ListCreator] with the specified capacity.
  ListCreator(this._capacity);

  /// Divides a list into chunks of a specified [limit].
  ///
  /// Example:
  ///
  /// ```dart
  /// List<int> myList = [1, 2, 3, 4, 5, 6, 7, 8];
  /// List<List<int>> chunks = ListCreator.chopped(myList, 3);
  /// print(chunks);  // Output: [[1, 2, 3], [4, 5, 6], [7, 8]]
  /// ```
  static List<List<T>> chopped<T>(List<T> list, int limit) {
    final parts = <List<T>>[];
    final int N = list.length;
    for (int i = 0; i < N; i += limit) {
      List<T> li = list.sublist(i, min(N, i + limit));
      parts.add(li);
    }
    return parts;
  }

  /// Gets the current index of the [ListCreator].
  int get index => _index;

  /// Loads a list into the [ListCreator] and divides it into chunks.
  ///
  /// Example:
  ///
  /// ```dart
  /// List<int> myList = [1, 2, 3, 4, 5, 6, 7, 8];
  /// ListCreator<int> creator = ListCreator(3);
  /// creator.load(myList);
  /// ```
  ListCreator<T> load(List<T> list) {
    _collections = chopped(list, max(_capacity, 1));
    _index = 0;
    return this;
  }

  /// Gets the current collection (chunk) from the [ListCreator].
  ///
  /// Example:
  ///
  /// ```dart
  /// List<int> myList = [1, 2, 3, 4, 5, 6, 7, 8];
  /// ListCreator<int> creator = ListCreator(3);
  /// creator.load(myList);
  /// List<int> currentCollection = creator.collection();
  /// print(currentCollection);  // Output: [1, 2, 3]
  /// ```
  List<T> collection([int? position]) {
    final i = position ?? index;
    final data = collections.length > i ? collections[i] : <T>[];
    _index++;
    return data;
  }

  /// Gets all the collections (chunks) created by the [ListCreator].
  List<List<T>> get collections => _collections;
}
