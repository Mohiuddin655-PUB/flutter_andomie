import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';

class Assets {
  final Map<String, bool> _ignores = {};
  final Map<String, dynamic> _assets = {};

  Assets._();

  bool _showLogs = false;
  String _package = "assets";
  String _icons = "icons";
  String _images = "images";

  static Assets? _i;

  static Assets get _ii => _i ??= Assets._();

  static set showLogs(bool value) => _ii._showLogs = value;

  static set package(String value) => _ii._package = value;

  static set icons(String value) => _ii._icons = value;

  static set images(String value) => _ii._images = value;

  static void _log(msg) {
    if (!_ii._showLogs) return;
    log(msg.toString(), name: "ASSETS");
  }

  static Future<void> preload(List<String> paths) async {
    for (var path in paths) {
      _load(path);
    }
  }

  static Future<Object?> _load(String path) async {
    if (_ii._ignores[path] == true) return null;
    try {
      if (path.endsWith('.json')) {
        final json = await rootBundle.loadString(path);
        final data = jsonDecode(json);
        _ii._assets[path] = data;
        return data;
      } else if (path.endsWith('.txt')) {
        final data = await rootBundle.loadString(path);
        _ii._assets[path] = data;
        return data;
      } else if (path.endsWith('.csv') || path.endsWith(".svg")) {
        return rootBundle.loadString(path).then((data) {
          _ii._assets[path] = data;
          return data;
        });
      } else {
        return rootBundle.load(path).then((data) {
          _ii._assets[path] = data;
          return data;
        });
      }
    } catch (e) {
      _log('Error loading asset: $path - $e');
      _ii._ignores[path] = true;
      return null;
    }
  }

  static T get<T>(String path, T defaultValue) {
    final data = _ii._assets[path];
    if (data is T) return data;
    _load(path);
    return defaultValue;
  }

  static Future<T> getAsync<T>(String path, T defaultValue) async {
    Object? data = _ii._assets[path];
    if (data is T) return data;
    data = await _load(path);
    if (data is T) return data;
    return defaultValue;
  }

  static String? ic(String? name) {
    if (name == null || name.isEmpty) return null;
    return "${_ii._package}/${_ii._icons}/$name";
  }

  static String? img(String? name) {
    if (name == null || name.isEmpty) return null;
    return "${_ii._package}/${_ii._images}/$name";
  }
}

extension AssetsHelper on String? {
  String get ic => icOrNull ?? '';

  String get img => imgOrNull ?? '';

  String? get icOrNull => Assets.ic(this);

  String? get imgOrNull => Assets.img(this);
}
