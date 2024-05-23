import 'dart:math';

import 'package:flutter/material.dart';

/// A utility class for generating random colors.
class ColorGenerator {
  final Iterable<Color> _initial;

  /// Private constructor to prevent instantiation.
  ColorGenerator._(this._initial);

  int _index = -1;

  Color pick() {
    _index = _index + 1;
    if (_initial.length <= _index) {
      _index = _index - _initial.length;
    }
    return _initial.elementAt(_index);
  }

  static final _random = Random();

  static ColorGenerator? _i;

  static ColorGenerator get i => _i ??= ColorGenerator._(Colors.primaries);

  static void init(Iterable<Color> colors) => _i ??= ColorGenerator._(colors);

  /// Generates a random color with specified opacity range.
  ///
  /// The [minOpacity] and [maxOpacity] parameters define the range for the
  /// alpha (opacity) value of the color. The alpha value will be randomly
  /// chosen between these two values (inclusive).
  ///
  /// Example:
  /// ```dart
  /// Color color = ColorGenerator.generate(minOpacity: 100, maxOpacity: 200);
  /// print(color); // Output: Color(0xa5ff00ff) or similar
  /// ```
  ///
  /// - [minOpacity]: Minimum alpha value (0 to 255). Default is 150.
  /// - [maxOpacity]: Maximum alpha value (0 to 255). Default is 255.
  static Color generate({
    int minOpacity = 150,
    int maxOpacity = 255,
  }) {
    int alpha = minOpacity + _random.nextInt(maxOpacity - minOpacity + 1);
    int red = _random.nextInt(256);
    int green = _random.nextInt(256);
    int blue = _random.nextInt(256);
    return Color.fromARGB(alpha, red, green, blue);
  }

  /// Generates a list of random colors or colors from the given list with specified opacity range.
  ///
  /// The [minOpacity] and [maxOpacity] parameters define the range for the
  /// alpha (opacity) value of the colors. The alpha values will be randomly
  /// chosen between these two values (inclusive).
  ///
  /// The [length] parameter specifies the number of colors to generate.
  ///
  /// If [colors] list is provided, the colors will be selected from this list,
  /// with alpha values adjusted according to the specified range.
  /// If [colors] list is empty, new random colors will be generated.
  ///
  /// Example:
  /// ```dart
  /// // Generating a list of random colors
  /// List<Color> randomColors = ColorGenerator.generates(length: 5);
  /// randomColors.forEach((color) => print(color)); // Output: List of random colors
  ///
  /// // Generating a list of colors from a provided list with random alpha values
  /// List<Color> baseColors = [Color(0xFFFF0000), Color(0xFF00FF00), Color(0xFF0000FF)];
  /// List<Color> customColors = ColorGenerator.generates(length: 3, colors: baseColors);
  /// customColors.forEach((color) => print(color)); // Output: List of colors with random alpha
  /// ```
  ///
  /// - [minOpacity]: Minimum alpha value (0 to 255). Default is 150.
  /// - [maxOpacity]: Maximum alpha value (0 to 255). Default is 255.
  /// - [length]: Number of colors to generate. Default is 2.
  /// - [colors]: List of base colors to pick from. Default is an empty list.
  static List<Color> generates({
    int minOpacity = 150,
    int maxOpacity = 255,
    int length = 2,
    List<Color> colors = const [],
  }) {
    if (colors.isEmpty) {
      return List.generate(length, (_) {
        return generate(maxOpacity: maxOpacity, minOpacity: minOpacity);
      });
    } else {
      List<Color> list = [];
      for (int index = 0; index < length; index++) {
        int alpha = minOpacity + _random.nextInt(maxOpacity - minOpacity + 1);
        int i = _random.nextInt(colors.length);
        list.add(Color.fromARGB(
          alpha,
          colors[i].red,
          colors[i].green,
          colors[i].blue,
        ));
      }
      return list;
    }
  }
}
