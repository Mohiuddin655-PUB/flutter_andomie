import 'dart:math';

import 'package:flutter/material.dart';

extension Spacing on num {
  SizedBox get w => SizedBox(width: toDouble());

  SizedBox get h => SizedBox(height: toDouble());

  SizedBox hx(BuildContext context) => context.hx(this);

  SizedBox wx(BuildContext context) => context.wx(this);

  double hxp(BuildContext context) => context.hxp(this);

  double wxp(BuildContext context) => context.wxp(this);
}

extension SpacingFromScreen on BuildContext {
  Size get size => MediaQuery.sizeOf(this);

  double get w => size.width;

  double get h => size.height;

  num _x(num value) {
    if (value is int && value > 1) {
      return min(value, 100) / 100;
    } else {
      return value;
    }
  }

  double hxp(num value) => h * _x(value);

  double wxp(num value) => w * _x(value);

  SizedBox hx(num value) => SizedBox(height: hxp(value));

  SizedBox hhx(num value) => SizedBox.square(dimension: hxp(value));

  SizedBox wx(num value) => SizedBox(width: wxp(value));

  SizedBox wwx(num value) => SizedBox.square(dimension: wxp(value));
}
