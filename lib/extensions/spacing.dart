import 'dart:math';

import 'package:flutter/material.dart';

extension Spacing on num {
  SizedBox get w => SizedBox(width: toDouble());

  SizedBox get h => SizedBox(height: toDouble());

  SizedBox get wh => SizedBox.square(dimension: toDouble());

  SizedBox hx(BuildContext context) => context.hx(this);

  SizedBox hhx(BuildContext context) => context.hhx(this);

  SizedBox wx(BuildContext context) => context.wx(this);

  SizedBox wwx(BuildContext context) => context.wwx(this);
}

extension SpacingFromScreen on BuildContext {
  Size get size => MediaQuery.sizeOf(this);

  double get width => size.width;

  double get height => size.height;

  num _x(num value) {
    if (value is int && value > 1) {
      return min(value, 100) / 100;
    } else {
      return value;
    }
  }

  SizedBox hx(num value) => SizedBox(height: height * _x(value));

  SizedBox hhx(num value) => SizedBox.square(dimension: height * _x(value));

  SizedBox wx(num value) => SizedBox(width: width * _x(value));

  SizedBox wwx(num value) => SizedBox.square(dimension: width * _x(value));
}
