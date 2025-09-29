import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'map_writer.dart';

abstract class RemoteDelegate {
  const RemoteDelegate();

  Future<String> asset(String name, String path) {
    return rootBundle.loadString("assets/$name/$path");
  }

  Future<Map?> cache(String name, String path);

  Future<bool> save(String name, String path, Map? data);

  Future<Map?> fetch(String name, String path);

  Stream<Map?> listen(String name, String path) {
    return Stream.error("Stream not implemented for $path");
  }

  Future<void> loading() async {}

  Future<void> loaded() async {}

  Future<void> ready(String name, String path) async {}

  Future<void> changes(String name, String path) async {}
}

class Remote<T extends RemoteDelegate> extends ChangeNotifier {
  Remote();

  // ---------------------------------------------------------------------------
  // INITIAL PART
  // ---------------------------------------------------------------------------

  final Map _props = {};
  Set<String> _paths = {};
  Set<String> _symmetricPaths = {};

  String _name = 'remote';
  bool _connected = false;
  bool _listening = false;
  bool _showLogs = false;
  T? _delegate;
  VoidCallback? _callback;

  String get name => _name;

  Map get props => _props;

  Set<String> get paths => _paths;

  bool get connected => _connected;

  bool get showLogs => _showLogs;

  T? get delegate => _delegate;

  void log(Object? msg) {
    if (!_showLogs) return;
    dev.log(msg.toString(), name: name.toUpperCase());
  }

  Future<void> initialize({
    required String name,
    T? delegate,
    Set<String>? paths,
    Set<String>? symmetricPaths,
    bool connected = false,
    bool listening = true,
    bool showLogs = true,
    VoidCallback? onReady,
  }) async {
    _name = name;
    _paths = paths ?? {};
    _symmetricPaths = symmetricPaths ?? {};
    _showLogs = showLogs;
    _delegate = delegate;
    _connected = connected;
    _listening = listening;
    _callback = onReady;
    await _loads();
    if (_listening) await _subscribes();
  }

  // ---------------------------------------------------------------------------
  // CONNECTION PART
  // ---------------------------------------------------------------------------

  Future<void> resubscribes() async {
    _listening = true;
    try {
      await _subscribes();
    } catch (msg) {
      log(msg);
    }
  }

  Future<void> cancelSubscriptions() {
    return _unsubscribes();
  }

  Future<void> changeConnection(bool value) async {
    if (_connected == value) return;
    _connected = value;
    if (!value) {
      return _unsubscribes();
    }
    await reload(notifiable: true);
    if (_listening) await resubscribes();
  }

  // ---------------------------------------------------------------------------
  // ASSET PART
  // ---------------------------------------------------------------------------

  Future<Map?> _assets(String path) async {
    try {
      path = "$path.json";
      String data;
      if (_delegate != null) {
        data = await _delegate!.asset(name, path);
      } else {
        data = await rootBundle.loadString(path);
      }
      if (data.isEmpty) return null;
      final decoded = jsonDecode(data);
      if (decoded is! Map) return null;
      return decoded;
    } catch (msg) {
      log(msg);
      return null;
    }
  }

  // ---------------------------------------------------------------------------
  // CACHE PART
  // ---------------------------------------------------------------------------

  Future<Map?> _cached(String path) async {
    if (_delegate == null) return null;
    try {
      Map? cache = await _delegate!.cache(name, path);
      return cache;
    } catch (msg) {
      log(msg);
      return null;
    }
  }

  Future<bool> _save(String path, Map? data) async {
    if (_delegate == null) return false;
    try {
      final feedback = await _delegate!.save(name, path, data);
      return feedback;
    } catch (msg) {
      log(msg);
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // REMOTE PART
  // ---------------------------------------------------------------------------

  Future<void> _fetch(String path) async {
    if (_delegate == null) return;
    try {
      if (!_connected) return;
      final data = await _delegate!.fetch(name, path);
      await _save(path, data);
    } on TimeoutException catch (_) {
      log(
        "Timeout while connecting to $path. Please check your connection.",
      );
    } catch (msg) {
      log(msg);
    }
  }

  // ---------------------------------------------------------------------------
  // LOADING PART
  // ---------------------------------------------------------------------------

  bool _loading = false;

  bool get loading => _loading;

  Future<void> _load(
    String path, {
    bool changed = false,
    bool reload = false,
  }) async {
    try {
      if (!changed || reload) await _fetch(path);
      Map data = {};
      final local = _props[path];
      if (local is Map) data = data.combine(local);
      if (!changed) {
        Map? asset = await _assets(path);
        if (asset != null) data = data.combine(asset);
      }
      Map? cache = await _cached(path);
      if (cache != null) data = data.combine(cache);
      if (data.isEmpty) {
        _props.remove(path);
        return;
      }
      _props[path] = data;
      if (changed) {
        notifyListeners();
        log("$path properties changed!");
      } else if (reload) {
        log("$path properties reloaded!");
      } else {
        log("$path properties loaded!");
      }
      if (_delegate != null) {
        changed ? _delegate!.changes(name, path) : _delegate!.ready(name, path);
      }
    } catch (msg) {
      log(msg);
    }
  }

  Future<void> _loads() async {
    try {
      _loading = true;
      notifyListeners();
      if (_delegate != null) await _delegate!.loading();
      for (final path in paths) {
        if (_symmetricPaths.contains(path)) {
          await _load(path);
        } else {
          _load(path);
        }
      }
      _loading = false;
      notifyListeners();
      log("all symmetric properties loaded!");
      if (_delegate != null) await _delegate!.loaded();
      if (_callback != null) _callback!();
    } catch (msg) {
      _loading = false;
      notifyListeners();
      log(msg);
    }
  }

  Future<void> reload({
    bool showLoading = false,
    bool notifiable = true,
  }) async {
    if (showLoading) {
      _loading = true;
      notifyListeners();
    }
    try {
      for (final path in paths) {
        if (_symmetricPaths.contains(path)) {
          await _load(path, reload: true);
        } else {
          _load(path, reload: true);
        }
      }
      if (showLoading) _loading = false;
      if (notifiable || showLoading) notifyListeners();
      log("all symmetric properties reloaded!");
      if (_delegate != null) await _delegate!.loaded();
      if (_callback != null) _callback!();
    } catch (msg) {
      log(msg);
    }
  }

  // ---------------------------------------------------------------------------
  // SUBSCRIPTIONS PART
  // ---------------------------------------------------------------------------

  final Map<String, StreamSubscription?> _subscriptions = {};

  Future<void> _subscribe(String path) async {
    if (_delegate == null) return;
    try {
      await _subscriptions[path]?.cancel();
      _subscriptions.remove(path);
      if (!_connected) return;
      _subscriptions[path] = _delegate!.listen(name, path).listen((data) async {
        if (data == _props[path]) return;
        final kept = await _save(path, data);
        if (!kept) return;
        await _load(path, changed: true);
      });
    } on TimeoutException catch (_) {
      log(
        "Timeout while connecting to $path. Please check your connection.",
      );
    } catch (msg) {
      log(msg);
    }
  }

  Future<void> _subscribes([Set<String>? paths]) async {
    if (paths == null || paths.isEmpty) await _unsubscribes();
    for (var path in (paths ?? _paths)) {
      if (_symmetricPaths.contains(path)) {
        await _subscribe(path);
      } else {
        _subscribe(path);
      }
      log("stream subscription[$path] created!");
    }
  }

  Future<void> _unsubscribes() async {
    try {
      for (var subscription in _subscriptions.entries) {
        try {
          await subscription.value?.cancel();
          log("stream subscription[${subscription.key}] canceled!");
        } catch (msg) {
          log(msg);
        }
      }
      _subscriptions.clear();
    } catch (msg) {
      log(msg);
    }
  }

  @override
  void dispose() {
    _unsubscribes().whenComplete(() {
      if (_listening) log("subscriptions canceled!");
    });
    super.dispose();
  }
}
