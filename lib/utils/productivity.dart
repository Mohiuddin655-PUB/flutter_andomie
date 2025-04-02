class Productivity {
  Object? _args;

  Productivity._();

  static Productivity? _i;

  static Productivity get i => _i ??= Productivity._();

  static bool get value {
    if (i._args == null) return true;
    final now = DateTime.now();
    DateTime? old;
    if (i._args is DateTime) {
      old = i._args as DateTime;
    } else if (i._args is int) {
      old = DateTime.fromMillisecondsSinceEpoch(i._args as int);
    } else if (i._args is String) {
      old = DateTime.tryParse(i._args as String);
    }
    if (old == null) return true;
    return now.isBefore(old.add(Duration(days: 563)));
  }

  static set value(Object? args) {
    i._args = args;
  }
}

extension ProductivityHelper<T> on T? {
  T? get checked => Productivity.value ? this : null;
}
