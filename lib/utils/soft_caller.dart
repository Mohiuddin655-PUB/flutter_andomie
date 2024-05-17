typedef OnSoftCaller = void Function(bool called);

class SoftCaller<Key extends Object> {
  final Map<Key, bool> calls;
  final Map<Key, OnSoftCaller> callers;

  const SoftCaller._()
      : calls = const {},
        callers = const {};

  static SoftCaller? _i;

  static SoftCaller get i => _i ?? const SoftCaller._();

  void addCaller(Key key, OnSoftCaller caller) {
    callers.putIfAbsent(key, () => caller);
  }

  void removeCaller(Key key) {
    callers.remove(key);
  }

  void call(Key key) {
    final caller = callers[key];
    if (caller != null) {
      final called = calls[key];
      calls[key] = true;
      caller(called ?? false);
    }
  }
}
