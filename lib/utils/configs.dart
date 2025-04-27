import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../extensions/object.dart';
import 'map_converter.dart';

const _kApplication = "application";
const _kRandomNotification = "random_notifications";
const _kThemes = "themes";
const _kSecrets = "secrets";
const kDefaultConfigName = "configs";

const kDefaultConfigPaths = {
  _kApplication,
  _kRandomNotification,
  _kSecrets,
  _kThemes,
};

enum PlatformType {
  android,
  ios,
  web,
  fuchsia,
  macos,
  windows,
  linux,
  wasm,
  system,
}

enum EnvironmentType { live, test, system }

abstract class ConfigDelegate {
  const ConfigDelegate();

  Set<String> get paths => {};

  Future<String> asset(String path) => rootBundle.loadString(path);

  Future<Map?> cache(String path);

  Future<bool> save(String path, Map? data);

  Future<Map?> fetch(String path);

  Stream<Map?> listen(String path) {
    return Stream.error("Stream not implemented for $path");
  }

  Future<void> ready(String path) async {}

  Future<void> changes(String path) async {}
}

class Configs extends ChangeNotifier {
  Configs._();

  static Configs? _i;

  static Configs get i => _i ??= Configs._();

  // ---------------------------------------------------------------------------
  // INITIAL PART
  // ---------------------------------------------------------------------------

  final Map _props = {};
  String _defaultPath = _kApplication;
  Set<String> _paths = {};

  bool _connected = false;
  bool _showLogs = false;
  String _name = kDefaultConfigName;
  EnvironmentType? _environment;
  PlatformType? _platform;
  ConfigDelegate? _delegate;

  EnvironmentType get environment {
    if (i._environment != null && i._environment != EnvironmentType.system) {
      return i._environment!;
    }
    if (kDebugMode) return EnvironmentType.test;
    if (kReleaseMode) return EnvironmentType.live;
    return EnvironmentType.system;
  }

  PlatformType get platform {
    if (i._platform != null && i._platform != PlatformType.system) {
      return i._platform!;
    }
    if (kIsWeb) return PlatformType.web;
    if (kIsWasm) return PlatformType.wasm;
    if (Platform.isAndroid) return PlatformType.android;
    if (Platform.isIOS) return PlatformType.ios;
    if (Platform.isFuchsia) return PlatformType.fuchsia;
    if (Platform.isMacOS) return PlatformType.macos;
    if (Platform.isWindows) return PlatformType.windows;
    if (Platform.isLinux) return PlatformType.linux;
    return PlatformType.system;
  }

  set environment(EnvironmentType type) {
    i._environment = type;
    i.notifyListeners();
  }

  set platform(PlatformType type) {
    i._platform = type;
    i.notifyListeners();
  }

  void _log(msg) {
    if (!i._showLogs) return;
    log(msg.toString(), name: _name.toUpperCase());
  }

  static Future<void> init({
    Map? initial,
    String defaultPath = _kApplication,
    Set<String>? paths,
    ConfigDelegate? delegate,
    bool showLogs = false,
    required bool connected,
    String name = kDefaultConfigName,
    PlatformType platform = PlatformType.system,
    EnvironmentType environment = EnvironmentType.system,
  }) async {
    paths ??= {...kDefaultConfigPaths, ...delegate?.paths ?? {}};
    i._defaultPath = defaultPath;
    i._paths = paths;
    i._name = name;
    i._showLogs = showLogs;
    i._environment = environment;
    i._platform = platform;
    i._delegate = delegate;
    i._connected = connected;
    await i._loads();
    i._subscribes();
  }

  // ---------------------------------------------------------------------------
  // CONNECTION PART
  // ---------------------------------------------------------------------------

  static Future<void> reload() async {
    try {
      await Future.wait(i._paths.map((e) => i._load(e, reload: true)));
    } catch (msg) {
      i._log(msg);
    }
  }

  static void resubscribes() async {
    try {
      i._subscribes();
    } catch (msg) {
      i._log(msg);
    }
  }

  static void cancelSubscriptions() {
    i._subscriptionsCancel();
  }

  static Future<void> changeConnection(bool value) async {
    if (i._connected == value) return;
    i._connected = value;
    if (!value) {
      i._subscriptionsCancel();
      return;
    }
    await reload();
    resubscribes();
  }

  // ---------------------------------------------------------------------------
  // ASSET PART
  // ---------------------------------------------------------------------------

  Future<Map?> _assets(String path) async {
    try {
      path = "assets/$_name/$path.json";
      String data;
      if (_delegate != null) {
        data = await _delegate!.asset(path);
      } else {
        data = await rootBundle.loadString(path);
      }
      if (data.isEmpty) return null;
      final decoded = jsonDecode(data);
      if (decoded is! Map) return null;
      return decoded;
    } catch (msg) {
      _log(msg);
      return null;
    }
  }

  // ---------------------------------------------------------------------------
  // CACHE PART
  // ---------------------------------------------------------------------------

  Future<Map?> _cached(String path) async {
    if (_delegate == null) return null;
    try {
      Map? cache = await _delegate!.cache("--$_name-$path");
      return cache;
    } catch (msg) {
      _log(msg);
      return null;
    }
  }

  Future<bool> _save(String path, Map? data) async {
    if (_delegate == null) return false;
    try {
      final feedback = await _delegate!.save("--$_name-$path", data);
      return feedback;
    } catch (msg) {
      _log(msg);
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
      final data = await _delegate!.fetch(path);
      await _save(path, data);
    } on TimeoutException catch (_) {
      _log(
        "Timeout while connecting to $path. Please check your connection.",
      );
    } catch (msg) {
      _log(msg);
    }
  }

  // ---------------------------------------------------------------------------
  // LOADING PART
  // ---------------------------------------------------------------------------

  bool loading = false;

  Future<void> _load(
    String path, {
    bool refresh = false,
    bool reload = false,
  }) async {
    try {
      if (!refresh || reload) await _fetch(path);
      Map data = {};
      final local = _props[path];
      if (local is Map) data = data.combine(local);
      if (!refresh) {
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
      if (refresh) notifyListeners();
      if (_delegate != null) {
        refresh || reload ? _delegate!.changes(path) : _delegate!.ready(path);
      }
    } catch (msg) {
      _log(msg);
    }
  }

  Future<void> _loads() async {
    try {
      loading = true;
      notifyListeners();
      await Future.wait(_paths.map(_load));
      loading = false;
      notifyListeners();
    } catch (msg) {
      _log(msg);
    }
  }

  // ---------------------------------------------------------------------------
  // SUBSCRIPTIONS PART
  // ---------------------------------------------------------------------------

  final Map<String, StreamSubscription?> _subscriptions = {};

  void _subscribe(String path) async {
    if (_delegate == null) return;
    try {
      _subscriptions[path]?.cancel();
      _subscriptions.remove(path);
      if (!_connected) return;
      _subscriptions[path] = _delegate!.listen(path).listen((data) async {
        if (data == null || data.isEmpty) return;
        if (data == _props[path]) return;
        final kept = await _save(path, data);
        if (!kept) return;
        _load(path, refresh: true);
      });
    } on TimeoutException catch (_) {
      _log(
        "Timeout while connecting to $path. Please check your connection.",
      );
    } catch (msg) {
      _log(msg);
    }
  }

  void _subscribes([Set<String>? paths]) {
    if (paths == null || paths.isEmpty) _subscriptionsCancel();
    for (var path in (paths ?? _paths)) {
      _subscribe(path);
    }
  }

  void _subscriptionsCancel() {
    _subscriptions.forEach((key, value) {
      value?.cancel();
      _subscriptions.remove(key);
    });
  }

  @override
  void dispose() {
    _subscriptionsCancel();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // FINAL PART
  // ---------------------------------------------------------------------------

  (String, String) _keys(String key) {
    if (!key.contains("/")) return (_defaultPath, key);
    List<String> keys = key.split("/");
    if (keys.length < 2) return (_defaultPath, key);
    final k = keys.last;
    keys.removeLast();
    final p = keys.join("/");
    return (p, k);
  }

  Map _env(
    Map data,
    EnvironmentType? environment,
  ) {
    Map value = {};
    final x = data["default"];
    if (x is Map) value = value.combine(x);
    environment ??= this.environment;
    if (environment == EnvironmentType.system) environment = this.environment;
    final y = data[environment.name];
    if (y is Map) value = value.combine(y);
    return value;
  }

  Object? _pla(
    Map data,
    Object? base,
    PlatformType? platform,
  ) {
    platform ??= this.platform;
    if (platform == PlatformType.system) platform = this.platform;
    Object? value = data[platform.name];
    if (value != null) return value;
    if (base is Map) value = base[platform.name];
    return value ?? base;
  }

  Object? _select(
    String key, {
    String? path,
    EnvironmentType? environment,
    PlatformType? platform,
  }) {
    final keys = path == null ? _keys(key) : (path, key);
    final data = _props[keys.$1];
    if (data is! Map) return null;
    final env = _env(data, environment);
    final x = env[keys.$2];
    if (x is! Map) return x;
    Object? mDefault = data['default'];
    if (mDefault is Map) mDefault = mDefault[keys.$2];
    final y = _pla(x, mDefault, platform);
    return y;
  }

  Object? _find(
    String name, {
    EnvironmentType? environment,
    PlatformType? platform,
  }) {
    final data = _props[name];
    if (data is! Map) return null;
    final env = _env(data, environment);
    return env;
  }

  static T? load<T extends Object?>({
    String? name,
    T? defaultValue,
    EnvironmentType? environment,
    PlatformType? platform,
    T? Function(Object?)? parser,
    T? Function(T)? modifier,
  }) {
    try {
      final raw = i._find(
        name ?? _kThemes,
        environment: environment,
        platform: platform,
      );
      T? value = raw?.findOrNull(builder: parser);
      if (value is! T) return defaultValue;
      if (modifier != null) value = modifier(value);
      return value;
    } catch (msg) {
      i._log(msg);
      return defaultValue;
    }
  }

  static T get<T extends Object?>(
    String key, {
    String? path,
    T? defaultValue,
    EnvironmentType? environment,
    PlatformType? platform,
    T? Function(Object?)? parser,
    T? Function(T)? modifier,
  }) {
    T? value = getOrNull(
      key,
      path: path,
      defaultValue: defaultValue,
      environment: environment,
      platform: platform,
      parser: parser,
      modifier: modifier,
    );
    if (value != null) return value;
    throw UnimplementedError("$T didn't get from this ${i._name}");
  }

  static T? getOrNull<T extends Object?>(
    String key, {
    String? path,
    T? defaultValue,
    EnvironmentType? environment,
    PlatformType? platform,
    T? Function(Object?)? parser,
    T? Function(T)? modifier,
  }) {
    try {
      final raw = i._select(
        key,
        path: path,
        environment: environment,
        platform: platform,
      );
      T? value = raw?.findOrNull(builder: parser);
      if (value is! T) return defaultValue;
      if (modifier != null) value = modifier(value);
      return value;
    } catch (msg) {
      i._log(msg);
      return defaultValue;
    }
  }

  static List<T> gets<T extends Object?>(
    String key, {
    String? path,
    List<T>? defaultValue,
    EnvironmentType? environment,
    PlatformType? platform,
    T? Function(Object?)? parser,
    T? Function(T)? modifier,
  }) {
    List<T>? value = getsOrNull(
      key,
      path: path,
      defaultValue: defaultValue,
      environment: environment,
      platform: platform,
      parser: parser,
      modifier: modifier,
    );
    if (value != null) return value;
    throw UnimplementedError("${List<T>} didn't get from this ${i._name}");
  }

  static List<T>? getsOrNull<T extends Object?>(
    String key, {
    String? path,
    List<T>? defaultValue,
    EnvironmentType? environment,
    PlatformType? platform,
    T? Function(Object?)? parser,
    T? Function(T)? modifier,
  }) {
    try {
      final raw = i._select(
        key,
        path: path,
        environment: environment,
        platform: platform,
      );
      List<T>? value = raw.findsOrNull(builder: parser);
      value ??= defaultValue;
      if (modifier != null) {
        value = value?.map(modifier).whereType<T>().toList();
      }
      return value;
    } catch (msg) {
      i._log(msg);
      return defaultValue;
    }
  }
}

class ConfigBuilder<T extends Object?> extends StatefulWidget {
  final String id;
  final String? name;
  final T? initial;
  final PlatformType? platform;
  final EnvironmentType? environment;
  final T? Function(Object?)? parser;
  final T? Function(T)? modifier;
  final Widget Function(BuildContext context, T? value) builder;

  const ConfigBuilder({
    super.key,
    required this.id,
    this.name,
    required this.builder,
    this.initial,
    this.platform,
    this.environment,
    this.parser,
    this.modifier,
  });

  @override
  State<ConfigBuilder<T>> createState() => _ConfigBuilderState<T>();
}

class _ConfigBuilderState<T extends Object?> extends State<ConfigBuilder<T>> {
  T? value;

  T? get _fetch {
    return Configs.getOrNull(
      widget.id,
      path: widget.name,
      platform: widget.platform,
      environment: widget.environment,
      parser: widget.parser,
      modifier: widget.modifier,
    );
  }

  void _listen() {
    T? newValue = _fetch;
    if (value == newValue) return;
    setState(() => value = newValue);
  }

  @override
  void initState() {
    super.initState();
    value = _fetch;
    Configs.i.addListener(_listen);
  }

  @override
  void dispose() {
    Configs.i.removeListener(_listen);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, value ?? widget.initial);
  }
}
