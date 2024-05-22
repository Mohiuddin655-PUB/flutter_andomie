class UndoManager<T> {
  UndoManager();

  final List<T> _children = [];

  /// Returns the number of items in the manager.
  int get length => _children.length;

  /// Adds a new item to the manager.
  void add(T value) => _children.add(value);

  /// Inserts an item at the specified index. If the index is out of range, adds to the end.
  void insert(int index, T value) {
    if (index >= 0 && index < length) {
      _children.insert(index, value);
    } else {
      _children.add(value);
    }
  }

  /// Removes and returns the last item added to the manager. Returns null if empty.
  T? undo() {
    if (_children.isNotEmpty) {
      return _children.removeLast();
    } else {
      return null;
    }
  }
}
