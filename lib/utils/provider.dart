/// Utility class for providing common functionality related to data lists.
///
/// The [Provider] class includes static methods to retrieve the suggested
/// position of an item in a list based on a query. This can be useful, for
/// example, in autocomplete scenarios where you want to suggest a position
/// in the list for a given query.
///
/// Example usage:
/// ```dart
/// List<String> fruits = ['Apple', 'Banana', 'Orange', 'Grapes'];
/// String query = 'Banana';
/// int suggestedPosition = Provider.getSuggestedPosition(query, fruits);
/// print('Suggested position for $query: $suggestedPosition');
/// ```
///
/// In this example, the `getSuggestedPosition` method will return the index
/// of the item 'Banana' in the list of fruits. If the item is not found, it
/// will return the default index, which is the length of the list.
class Provider {
  /// Gets the suggested position of the given query in the provided list.
  ///
  /// The method iterates through the list and returns the index of the first
  /// occurrence of the query. If the query is not found, it returns the
  /// default index, which is the length of the list.
  ///
  /// Parameters:
  /// - `query`: The item to search for in the list.
  /// - `list`: The list of items where the query will be searched.
  ///
  /// Returns:
  /// The suggested position (index) of the query in the list.
  static int getSuggestedPosition<T>(T query, List<T>? list) {
    int index = 0;
    if (list != null && list.isNotEmpty) {
      for (index = 0; index < list.length; index++) {
        if (query == list[index]) {
          return index;
        }
      }
    }
    return index;
  }
}
