class IndexProvider {
  final String name;
  final int _capacity;

  IndexProvider._(this.name, this._capacity);

  int _index = -1;

  int get index {
    _index = _index + 1;
    if (_capacity <= _index) {
      _index = _index - _capacity;
    }
    return _index;
  }

  int _indexAsReverse = -1;

  int get indexAsReverse {
    _indexAsReverse = _indexAsReverse - 1;
    if (_indexAsReverse < 0) {
      _indexAsReverse = _capacity - 1;
    }
    return _indexAsReverse;
  }

  static final Map<String, IndexProvider> _proxy = {};

  static IndexProvider get i => init(10);

  static IndexProvider of(String name) {
    final x = _proxy[name];
    if (x != null) {
      return x;
    } else {
      throw UnimplementedError(
        "IndexProvider not initialized yet for this $name",
      );
    }
  }

  static IndexProvider init<T>(int capacity, {String name = "auto"}) {
    return _proxy[name] ??= IndexProvider._(name, capacity);
  }

  static int indexOf(String name) => of(name).index;

  static int indexAsReverseOf(String name) => of(name).indexAsReverse;
}

extension IndexProviderHelper<E> on Iterable<E> {
  E get autoElement => elementAt(IndexProvider.init(length).index);

  E get autoElementAsReverse {
    return elementAt(IndexProvider.init(length).indexAsReverse);
  }

  E getElement(String name) {
    return elementAt(IndexProvider.init(length, name: name).index);
  }

  E getElementAsReverse(String name) {
    return elementAt(IndexProvider.init(length, name: name).indexAsReverse);
  }
}
