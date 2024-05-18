import 'package:flutter/foundation.dart';

class ExecutedData<A, B> {
  final Iterable<A> base;
  final Iterable<B> modified;

  bool get isEmpty => base.isEmpty;

  bool get isNotEmpty => base.isNotEmpty;

  bool get isBase => modified.isEmpty;

  bool get isModified => modified.isNotEmpty;

  ExecutedData({
    required this.base,
    required this.modified,
  });

  ExecutedData.initial() : this(base: [], modified: []);

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

abstract class DataExecutor<A, B> extends ValueNotifier<ExecutedData<A, B>> {
  bool loading = false;
  bool converting = false;

  bool get isBase => value.isBase;

  bool get isModified => value.isModified;

  Iterable<A> get base => value.base;

  Iterable<B> get modified => value.modified;

  DataExecutor([ExecutedData<A, B>? data])
      : super(data ?? ExecutedData.initial());

  Future<Iterable<B>> convert(Iterable<A> root);

  Future<Iterable<A>> fetch();

  void listen(void Function(ExecutedData<A, B> value) callback) {
    if (value.isEmpty) load();
    addListener(() => callback(value));
  }

  void listenOnlyModified(void Function(Iterable<B> value) callback) {
    if (value.isEmpty) load();
    addListener(() => callback(modified));
  }

  void load() {
    if (!loading) {
      loading = true;
      fetch().then((base) {
        loading = false;
        value = value.copy(base: base);
        if (!converting) {
          converting = true;
          convert(base).then((modified) {
            converting = false;
            return value = value.copy(modified: modified);
          });
        }
      });
    }
  }

  void refresh([bool reload = false]) {
    if (reload) load();
    notifyListeners();
  }
}
