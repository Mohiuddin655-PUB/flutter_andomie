import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';

import 'internet.dart';

abstract class RemoteDelegate<T extends Object?> {
  const RemoteDelegate();

  /// ```
  /// Future<Map?> cache() async {
  ///   final data = Preferences.getOrNull(_kLocalConfigKey);
  ///   return data;
  /// }
  Future<T?> cache();

  /// ```
  /// Future<Map?> local() async {
  ///   final raw = await rootBundle.loadString("assets/settings/configs.json");
  ///   final data = jsonDecode(raw);
  ///   if (data is! Map) return null;
  ///   return data;
  /// }
  Future<T?> local();

  ///```
  /// Future<Map?> remote() async {
  ///   return FirebaseDatabase.instance.ref("configs").get().then((value) {
  ///     if (!value.exists) return null;
  ///     final data = value.value;
  ///     if (data is! Map) return null;
  ///     return data;
  ///   });
  /// }
  Future<T?> remote();

  /// ```
  /// Future<bool> save(Map? value) async {
  ///   return Preferences.set(_kLocalConfigKey, value);
  /// }
  Future<bool> save(T? value);

  /// ```
  /// Stream<Map?> stream() {
  ///   return FirebaseDatabase.instance.ref("configs").onValue.map((value) {
  ///     if (!value.snapshot.exists) return null;
  ///     final data = value.snapshot.value;
  ///     if (data is! Map) return null;
  ///     return data;
  ///   });
  /// }
  Stream<T?> stream();

  Future<void> ready(T? data);

  Future<void> changes(T? data);
}

class Remote<T extends Object?> extends ChangeNotifier {
  T? _data;
  bool _showLogs = false;
  RemoteDelegate<T>? _delegate;

  StreamSubscription? _connectivity;
  StreamSubscription? _subscription;

  Remote._();

  static final Map<String, Remote> _proxies = {};

  static Future<void> init<T extends Object?>(
    String name,
    RemoteDelegate<T> delegate, {
    bool showLogs = false,
    T? initial,
  }) async {
    final i = Remote<T>._();
    i._data = initial;
    i._showLogs = showLogs;
    i._delegate = delegate;
    _proxies[name] = i;
    await i._load();
    i._listen();
  }

  static Remote<T> of<T extends Object?>(String name) {
    final x = _proxies[name];
    if (x is Remote<T>) return x;
    throw UnimplementedError("$Remote<$T> isn't initialized yet for $name!");
  }

  void _log(msg) {
    if (!_showLogs) return;
    log(msg.toString(), name: "$Remote");
  }

  Future<void> _load() async {
    try {
      if (_delegate == null) return;
      final connected = await Internet.connected;
      T? remote;
      if (connected) {
        remote = await _delegate!.remote();
        await _delegate!.save(remote);
      }
      T? value;
      value ??= await _delegate!.cache();
      value ??= await _delegate!.local();
      _data = value ?? remote;
      await _delegate!.ready(_data);
      notify();
    } catch (msg) {
      _log(msg);
    }
  }

  Future<void> _subscribe() async {
    if (_delegate == null) return;
    try {
      _subscription?.cancel();
      _subscription = _delegate!.stream().listen((remote) async {
        final kept = await _delegate!.save(remote);
        if (!kept) return;
        T? value;
        value ??= await _delegate!.cache();
        value ??= await _delegate!.local();
        _data = value ?? remote;
        await _delegate!.changes(_data);
        notify();
      });
    } catch (msg) {
      _log(msg);
    }
  }

  Future<void> _listen() async {
    if (_delegate == null) return;
    try {
      _connectivity?.cancel();
      _connectivity = Internet.connection.listen((connected) {
        _subscription?.cancel();
        if (!connected) return;
        _load();
        _subscribe();
      });
    } catch (msg) {
      _log(msg);
    }
  }

  Future<void> notify() async => notifyListeners();

  @override
  void dispose() {
    _connectivity?.cancel();
    _subscription?.cancel();
    super.dispose();
  }
}
