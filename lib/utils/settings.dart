import 'dart:developer';

import '../enums/data_type.dart';

class SettingsReadRequest {
  final String path;
  final DataType type;
  final Object? defaultValue;
  final Object? options;

  const SettingsReadRequest._({
    required this.path,
    required this.defaultValue,
    required this.type,
    required this.options,
  });

  @override
  String toString() {
    return "$SettingsReadRequest(path: $path, type: $type, defaultValue: $defaultValue, options: $options)";
  }
}

class SettingsWriteRequest {
  final String path;
  final Object? value;
  final DataType type;
  final Map<String, dynamic> props;
  final Object? options;

  const SettingsWriteRequest._({
    required this.path,
    required this.value,
    required this.type,
    required this.props,
    required this.options,
  });

  @override
  String toString() {
    return "$SettingsWriteRequest(path: $path, type: $type, value: $value, props: $props, options: $options)";
  }
}

class SettingsBackupResponse {
  final Map<String, dynamic>? _data;
  final String? error;

  const SettingsBackupResponse.ok(Map<String, dynamic> value)
      : _data = value,
        error = null;

  const SettingsBackupResponse.failure(this.error) : _data = null;
}

class SettingsBackupDelegate {
  final Future<SettingsBackupResponse> Function() read;
  final Future<void> Function(SettingsWriteRequest request) write;
  final Future<void> Function() clean;

  const SettingsBackupDelegate({
    required this.read,
    required this.write,
    required this.clean,
  });
}

class SettingsCachedDelegate {
  final Object? Function(SettingsReadRequest request) read;
  final bool Function(SettingsWriteRequest request) write;

  const SettingsCachedDelegate({
    required this.read,
    required this.write,
  });
}

class Settings {
  Settings._();

  static Settings? _i;

  static Settings get i => _i ??= Settings._();

  bool _showLogs = false;
  Map<String, dynamic> _props = {};

  SettingsBackupDelegate? _backup;
  SettingsCachedDelegate? _cached;

  bool initialized = false;

  bool get _local => _backup == null && _cached == null;

  static Future<void> init({
    bool showLogs = false,
    Map<String, dynamic>? initial,
    SettingsBackupDelegate? backup,
    SettingsCachedDelegate? cached,
  }) async {
    i._showLogs = showLogs;
    i._backup = backup;
    i._cached = cached;
    if (initial != null) i._props = initial;
    i.initialized = true;
    await load();
  }

  static T _execute<T>(T Function(Settings) callback) {
    if (i.initialized) return callback(i);
    throw "$Settings hasn't initialized yet!";
  }

  static void _log(Object? msg) {
    if (!i._showLogs) return;
    log(msg.toString(), name: "$Settings");
  }

  static Future<void> load() async {
    try {
      if (i._backup == null) return;
      final response = await i._backup!.read();
      if (response._data == null) return _log(response.error);
      i._props.addAll(response._data!);
    } catch (msg) {
      _log(msg);
    }
  }

  static Future<bool> clear() async {
    try {
      if (i._backup == null) return false;
      await i._backup!.clean();
      i._props.clear();
      return true;
    } catch (msg) {
      _log(msg);
      return false;
    }
  }

  static T get<T>(String key, T defaultValue, {Object? options}) {
    try {
      if (i._local) {
        final data = i._props[key];
        return data is T ? data : defaultValue;
      }
      return _execute((i) {
        Object? cached;
        final request = SettingsReadRequest._(
          path: key,
          type: defaultValue.dataType,
          defaultValue: defaultValue,
          options: options,
        );
        if (i._cached != null) {
          cached = i._cached?.read(request);
        }
        cached ??= i._props[key];
        if (cached is T) {
          return cached;
        }
        return defaultValue;
      });
    } catch (msg) {
      _log(msg);
      return defaultValue;
    }
  }

  static bool set(String key, Object? value, {Object? options}) {
    try {
      i._props[key] = value;
      if (i._local) return true;
      return _execute((i) {
        final request = SettingsWriteRequest._(
          path: key,
          value: value,
          type: value.dataType,
          props: i._props,
          options: options,
        );
        final feedback = i._cached?.write(request);
        i._backup?.write(request);
        return feedback ?? i._cached == null;
      });
    } catch (msg) {
      _log(msg);
      return false;
    }
  }

  static bool increment(String key, num value, {Object? options}) {
    try {
      value = value + get(key, 0, options: options);
      return set(key, value, options: options);
    } catch (msg) {
      _log(msg);
      return false;
    }
  }

  static bool arrayUnion(String key, Iterable value, {Object? options}) {
    try {
      Set current = Set.of(get(key, [], options: options));
      current.addAll(value);
      return set(key, current.toList(), options: options);
    } catch (msg) {
      _log(msg);
      return false;
    }
  }

  static bool arrayRemove(String key, Iterable value, {Object? options}) {
    try {
      Set current = Set.of(get(key, [], options: options));
      current.removeAll(value);
      return set(key, current.toList(), options: options);
    } catch (msg) {
      _log(msg);
      return false;
    }
  }
}
