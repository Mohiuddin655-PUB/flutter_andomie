import 'package:flutter/foundation.dart';

/// A class that represents data with base and modified states.
class ExecutedData<A, B> {
  final Iterable<A> base;
  final Iterable<B> modified;

  /// Returns true if the base data is empty.
  bool get isEmpty => base.isEmpty;

  /// Returns true if the base data is not empty.
  bool get isNotEmpty => base.isNotEmpty;

  /// Returns true if there are no modified data.
  bool get isBase => modified.isEmpty;

  /// Returns true if there are modified data.
  bool get isModified => modified.isNotEmpty;

  /// Creates an instance of [ExecutedData] with the provided base and modified data.
  ExecutedData({
    required this.base,
    required this.modified,
  });

  /// Creates an initial instance of [ExecutedData] with empty base and modified data.
  ExecutedData.initial() : this(base: [], modified: []);

  /// Creates a copy of the current [ExecutedData] with optional new base or modified data.
  ExecutedData<A, B> copy({Iterable<A>? base, Iterable<B>? modified}) {
    return ExecutedData(
        base: base ?? this.base, modified: modified ?? this.modified);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ExecutedData<A, B> &&
        _equal(base, other.base) &&
        _equal(modified, other.modified);
  }

  @override
  int get hashCode => _hashCode(base) ^ _hashCode(modified);

  bool _equal(Iterable? a, Iterable? b) {
    if (a == null || b == null) return false;
    var ait = a.iterator;
    var bit = b.iterator;
    while (ait.moveNext()) {
      if (!bit.moveNext() || ait.current != bit.current) return false;
    }
    return !bit.moveNext();
  }

  int _hashCode(Iterable? iterable) {
    if (iterable == null) return 0;
    return iterable.fold(0, (hash, element) => hash ^ element.hashCode);
  }

  @override
  String toString() => "ExecutedData(base: $base, modified: $modified)";
}

/// An abstract class that manages the execution and modification of data.
abstract class DataExecutor<A, B> extends ValueNotifier<ExecutedData<A, B>> {
  bool loading = false;
  bool converting = false;

  /// Returns true if the current value is in its base state.
  bool get isBase => value.isBase;

  /// Returns true if the current value is in its modified state.
  bool get isModified => value.isModified;

  /// Returns the base data.
  Iterable<A> get base => value.base;

  /// Returns the modified data.
  Iterable<B> get modified => value.modified;

  /// Constructs a [DataExecutor] with an optional initial state.
  DataExecutor([ExecutedData<A, B>? state])
      : super(state ?? ExecutedData.initial());

  /// Converts a single item of type [A] to type [B].
  Future<B> convert(A root);

  /// Converts a list of items of type [A] to a list of items of type [B].
  Future<Iterable<B>> converts(Iterable<A> root) {
    return Future.wait(root.map(convert));
  }

  /// Fetches the base data.
  Future<Iterable<A>> fetch();

  /// Listens for changes in the data and calls the provided callback with the new value.
  void listen(void Function(ExecutedData<A, B> value) callback) {
    if (value.isEmpty) load();
    addListener(() => callback(value));
  }

  Iterable<B> _proxyModified = [];

  /// Listens for changes in the modified data and calls the provided callback with the new modified data.
  void listenOnlyModified(void Function(Iterable<B> value) callback) {
    if (value.isEmpty) load();
    addListener(() {
      if (_proxyModified != modified) {
        _proxyModified = modified;
        callback(modified);
      }
    });
  }

  /// Executes the conversion of the base data.
  void execute(Iterable<A> root) {
    if (!converting && root.isNotEmpty) {
      converting = true;
      converts(root).then((modified) {
        converting = false;
        return value = value.copy(modified: modified);
      });
    }
  }

  /// Loads the base data and executes the conversion.
  void load() {
    if (!loading) {
      loading = true;
      fetch().then((base) {
        loading = false;
        value = value.copy(base: base);
        execute(base);
      });
    }
  }

  /// Refreshes the data and optionally reloads the base data.
  void refresh([bool reload = false]) {
    if (reload) load();
    notifyListeners();
  }
}
