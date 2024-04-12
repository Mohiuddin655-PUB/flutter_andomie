typedef OnSoftCaller = void Function(bool called);

class SoftCaller<T extends Object> {
  final Map<T, bool> calls;
  final Map<T, OnSoftCaller> callers;

  const SoftCaller._()
      : calls = const {},
        callers = const {};

  static SoftCaller? _i;

  static SoftCaller get i => _i ?? const SoftCaller._();

  void addCaller(T tag, OnSoftCaller caller) {
    callers.putIfAbsent(tag, () => caller);
  }

  void removeCaller(T tag) {
    callers.remove(tag);
  }

  void call(T tag) {
    final caller = callers[tag];
    if (caller != null) {
      final called = calls[tag];
      calls[tag] = true;
      caller(called ?? false);
    }
  }
}
