import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../extensions/object.dart';
import 'internet.dart';
import 'map_comparison.dart';

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

  /// ```
  /// Future<Map?> cache() async {
  ///   final data = Preferences.getOrNull(_kLocalConfigKey);
  ///   return data;
  /// }
  Future<Map?> cache();

  /// ```
  /// Future<Map?> local() async {
  ///   final raw = await rootBundle.loadString("assets/settings/configs.json");
  ///   final data = jsonDecode(raw);
  ///   if (data is! Map) return null;
  ///   return data;
  /// }
  Future<Map?> local();

  ///```
  /// Future<Map?> remote() async {
  ///   return FirebaseDatabase.instance.ref("configs").get().then((value) {
  ///     if (!value.exists) return null;
  ///     final data = value.value;
  ///     if (data is! Map) return null;
  ///     return data;
  ///   });
  /// }
  Future<Map?> remote();

  /// ```
  /// Future<bool> save(Map? value) async {
  ///   return Preferences.set(_kLocalConfigKey, value);
  /// }
  Future<bool> save(Map? value);

  /// ```
  /// Stream<Map?> stream() {
  ///   return FirebaseDatabase.instance.ref("configs").onValue.map((value) {
  ///     if (!value.snapshot.exists) return null;
  ///     final data = value.snapshot.value;
  ///     if (data is! Map) return null;
  ///     return data;
  ///   });
  /// }
  Stream<Map?> stream();

  /// ```
  /// Future<void> ready(Configs configs) => Application.i.ready(configs);
  Future<void> ready(Configs configs);

  /// ```
  /// Future<void> changes(Configs configs, MapChanges changes) => Application.i.changes(configs, changes);
  Future<void> changes(Configs configs, MapChanges changes);

  /// ```
  /// void dispose() => Application.i.dispose();
  void dispose() {}
}

class Configs extends ChangeNotifier {
  Map _props = {};
  MapChanges _changes = MapChanges();
  bool _showLogs = false;
  EnvironmentType? _environment;
  PlatformType? _platform;
  ConfigDelegate? _delegate;
  bool _initialized = false;

  StreamSubscription? _connectivity;
  StreamSubscription? _subscription;

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
    i.notify();
  }

  set platform(PlatformType type) {
    i._platform = type;
    i.notify();
  }

  void _log(msg) {
    if (!i._showLogs) return;
    log(msg.toString(), name: "$Configs");
  }

  T _execute<T>(
    Object? key,
    PlatformType? platform,
    EnvironmentType? environment,
    T Function(Object?) callback,
  ) {
    if (!i._initialized) throw "$Configs hasn't initialized yet!";
    Object? p = i._props[(platform ?? i.platform).name];
    Object? e;
    if (p is Map) e = p[key];
    e ??= i._props[key];
    Object? config;
    if (e is Map) {
      config = e[(environment ?? i.environment).name] ??
          e[EnvironmentType.live.name];
    }
    config ??= e;
    return callback(config);
  }

  Future<void> _subscribe() async {
    if (_delegate == null) return;
    try {
      _subscription?.cancel();
      _subscription = _delegate!.stream().listen((remote) async {
        if (remote == null || remote.isEmpty) return;
        final kept = await _delegate!.save(remote);
        if (!kept) return;
        _changes = MapChanges.changes(_props, remote);
        _props = remote;
        await _delegate!.changes(this, _changes);
        await notify();
        _changes = MapChanges();
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

  Future<void> _load() async {
    try {
      if (_delegate == null) return;
      final connected = await Internet.connected;
      if (connected) {
        final remote = await _delegate!.remote();
        await _delegate!.save(remote);
      }
      Map? value;
      value ??= await _delegate!.cache();
      value ??= await _delegate!.local();
      if (value == null || value.isEmpty) return;
      _props = value;
      await _delegate!.ready(this);
      await notify();
    } catch (msg) {
      _log(msg);
    }
  }

  Configs._();

  static Configs? _i;

  static Configs get i => _i ??= Configs._();

  /// ```
  /// await Configs.init(
  ///   showLogs: true,
  ///   delegate: InAppConfigDelegate(
  ///     connected: ConnectivityProvider.I.isConnected,
  ///     connection: ConnectivityProvider.I.connection,
  ///   ),
  /// );
  static Future<void> init({
    bool showLogs = false,
    PlatformType platform = PlatformType.system,
    EnvironmentType environment = EnvironmentType.system,
    Map? initial,
    required ConfigDelegate delegate,
  }) async {
    i._showLogs = showLogs;
    i.environment = environment;
    i.platform = platform;
    i._delegate = delegate;
    i._initialized = true;
    await i._load();
    i._listen();
  }

  bool isChanged(
    String key, {
    PlatformType? platform,
    EnvironmentType? environment,
  }) {
    final p = (platform ?? this.platform).name;
    final e = (environment ?? this.environment).name;
    return _changes.modified.any((path) {
      if (path.startsWith("$p/$key/$e")) return true;
      if (path.startsWith("$p/$key")) return true;
      if (path.startsWith("$key/$e")) return true;
      if (path.startsWith(key)) return true;
      return false;
    });
  }

  T get<T extends Object?>(
    Object? key,
    T defaultValue, {
    PlatformType? platform,
    EnvironmentType? environment,
    ObjectBuilder<T>? builder,
  }) {
    T? arguments = getOrNull(
      key,
      defaultValue: defaultValue,
      platform: platform,
      environment: environment,
      builder: builder,
    );
    if (arguments != null) return arguments;
    throw UnimplementedError("$T didn't get from this object");
  }

  T? getOrNull<T extends Object?>(
    Object? key, {
    T? defaultValue,
    PlatformType? platform,
    EnvironmentType? environment,
    ObjectBuilder<T>? builder,
  }) {
    try {
      return _execute(key, platform, environment, (config) {
        T? value = config.findOrNull(builder: builder);
        if (value is! T) return defaultValue;
        return value;
      });
    } catch (msg) {
      _log(msg);
      return defaultValue;
    }
  }

  Future<void> notify() async => notifyListeners();

  @override
  void dispose() {
    _connectivity?.cancel();
    _subscription?.cancel();
    _delegate?.dispose();
    super.dispose();
  }
}

class ConfigBuilder<T extends Object?> extends StatefulWidget {
  final String id;
  final bool validation;
  final PlatformType? platform;
  final EnvironmentType? environment;
  final ObjectBuilder<T>? parser;
  final Widget Function(BuildContext context, T? value) builder;

  const ConfigBuilder({
    super.key,
    required this.id,
    required this.builder,
    this.validation = true,
    this.platform,
    this.environment,
    this.parser,
  });

  @override
  State<ConfigBuilder<T>> createState() => _ConfigBuilderState<T>();
}

class _ConfigBuilderState<T extends Object?> extends State<ConfigBuilder<T>> {
  T? value;

  void _listen() {
    if (widget.validation && !Configs.i.isChanged(widget.id)) return;
    T? newValue = Configs.i.getOrNull(
      widget.id,
      platform: widget.platform,
      environment: widget.environment,
      builder: widget.parser,
    );
    if (value == newValue) return;
    setState(() => value = newValue);
  }

  @override
  void initState() {
    super.initState();
    Configs.i.addListener(_listen);
  }

  @override
  void dispose() {
    Configs.i.removeListener(_listen);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, value);
}
