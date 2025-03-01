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

  const SettingsBackupResponse.all(Map<String, dynamic> value)
      : _data = value,
        error = null;

  const SettingsBackupResponse.failure(this.error) : _data = null;

  SettingsBackupResponse.value(String key, Object? value)
      : _data = {key: value},
        error = null;
}

class SettingsBackupDelegate {
  final Future<SettingsBackupResponse> Function() read;
  final Future<void> Function(SettingsWriteRequest request) write;

  const SettingsBackupDelegate({
    required this.read,
    required this.write,
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

  static Settings get _ii => _i ??= Settings._();

  bool _showLogs = false;
  Map<String, dynamic> _props = {};

  SettingsBackupDelegate? _backup;
  SettingsCachedDelegate? _cached;

  bool initialized = false;

  static Future<void> init({
    bool showLogs = false,
    Map<String, dynamic>? initial,
    required SettingsBackupDelegate backup,
    required SettingsCachedDelegate cached,
  }) async {
    _ii._showLogs = showLogs;
    _ii._backup = backup;
    _ii._cached = cached;
    if (initial != null) _ii._props = initial;
    _ii.initialized = true;
    await _ii._load();
  }

  static T _execute<T>(T Function(Settings) callback) {
    if (_ii.initialized) return callback(_ii);
    throw "$Settings hasn't initialized yet!";
  }

  static void _log(msg) {
    if (!_ii._showLogs) return;
    log(msg.toString(), name: "$Settings");
  }

  Future<void> _load() async {
    try {
      if (_backup == null) return;
      final response = await _backup!.read();
      if (response._data == null) return _log(response.error);
      _props.addAll(response._data!);
    } catch (msg) {
      _log(msg);
    }
  }

  static T get<T>(String key, T defaultValue, {Object? options}) {
    try {
      return _execute((i) {
        Object? cached;
        final request = SettingsReadRequest._(
          path: key,
          type: defaultValue.dataType,
          defaultValue: defaultValue,
          options: options,
        );
        if (i._cached != null) {
          cached = i._cached!.read(request);
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
      return _execute((i) {
        final props = _ii._props;
        props[key] = value;
        final request = SettingsWriteRequest._(
          path: key,
          value: value,
          type: value.dataType,
          props: props,
          options: options,
        );
        final feedback = _ii._cached!.write(request);
        _ii._backup!.write(request);
        return feedback;
      });
    } catch (msg) {
      _log(msg);
      return false;
    }
  }
}

// void main() async {
//   Map<String, dynamic> server = {
//     "settings": {
//       "onboarding_name": "server",
//     }
//   };
//
//   Map<String, dynamic> cached = {};
//
//   Settings.init(
//     showLogs: true,
//     initial: {"onboarding_name": "initial"},
//     backup: SettingsBackupDelegate(
//       read: () async {
//         await Future.delayed(const Duration(seconds: 2));
//         final data = server["settings"];
//         return SettingsBackupResponse.all(data);
//       },
//       write: (request) async {
//         server["settings"] = request.props;
//       },
//     ),
//     cached: SettingsCachedDelegate(
//       read: (request) {
//         final data = cached[request.key];
//         return data;
//       },
//       write: (request) {
//         cached[request.key] = request.value;
//         return true;
//       },
//     ),
//   );
//
//   print("Initial: ${Settings._ii._props}");
//   await Future.delayed(const Duration(seconds: 3));
//   print("SERVER: ${Settings._ii._props}");
//   Settings.set("onboarding_name", "custom");
//   print("CUSTOM: ${Settings._ii._props}");
//   Settings.set("onboarding_name", true);
//   print("CUSTOM_INVALID: ${Settings._ii._props}");
// }
