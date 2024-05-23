import 'package:flutter/material.dart';
import 'package:flutter_andomie/utils/color_generator.dart';

void main() {
  // Example 1: Generate a single random color
  Color randomColor = ColorGenerator.generate(minOpacity: 100, maxOpacity: 200);
  print(randomColor); // Output: Color with random ARGB values

  // Example 2: Generate a list of random colors
  List<Color> randomColors = ColorGenerator.generates(length: 5);
  randomColors
      .forEach((color) => print(color)); // Output: List of random colors

  // Example 3: Generate a list of colors from a provided list with random alpha values
  List<Color> baseColors = [
    Color(0xFFFF0000),
    Color(0xFF00FF00),
    Color(0xFF0000FF)
  ];
  List<Color> customColors =
      ColorGenerator.generates(length: 3, colors: baseColors);
  customColors.forEach(
      (color) => print(color)); // Output: List of colors with random alpha

  // Example 3: Pick a color from existing colors by sequence or index
  ColorGenerator.init([Colors.red, Colors.blue, Colors.green]);
  Color pickedColor = ColorGenerator.i.pick(); // Sequence ways
  print(pickedColor);
}
