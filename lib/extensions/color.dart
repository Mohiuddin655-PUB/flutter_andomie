import 'package:flutter/material.dart';

import '../utils/provider.dart';

extension ColorExtension on Color? {
  Color get use => this ?? Colors.transparent;

  bool get isLight => Provider.isLight(use);

  bool get isDark => !isLight;
}
