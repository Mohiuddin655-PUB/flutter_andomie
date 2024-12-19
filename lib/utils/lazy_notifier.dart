import 'package:flutter/foundation.dart';

class LazyNotifier extends ChangeNotifier {
  Object? args;

  LazyNotifier._();

  void _notify([Object? args]) {
    this.args = args;
    notifyListeners();
  }

  @override
  @protected
  void dispose() => super.dispose();

  static final Map<String, LazyNotifier> _proxies = {};

  static LazyNotifier of(String name) {
    return _proxies[name] ??= LazyNotifier._();
  }

  static T? value<T>(String name) {
    final notifier = of(name);
    final value = notifier.args;
    if (value is T) return value;
    return null;
  }

  static void notify(String name, {Object? value}) {
    final notifier = of(name);
    notifier._notify(value);
  }

  static void kill(String name) {
    final notifier = of(name);
    notifier.dispose();
  }
}
