import 'dart:math';

import 'package:flutter/material.dart';

import 'device_config.dart';

/// Utility class for handling size-related configurations in a Flutter application.
class SizeConfig {
  final BuildContext context;
  final DeviceConfig config;
  final bool detectScreen;
  final Size? _requireSize;
  final Size screenSize;

  /// Creates a [SizeConfig] instance with the provided [context], [detectScreen], [config], and optional [_requireSize].
  SizeConfig(
    this.context, [
    this.detectScreen = true,
    this.config = const DeviceConfig(),
    this._requireSize,
  ]) : screenSize = MediaQuery.of(context).size;

  /// Creates a [SizeConfig] instance with the provided parameters.
  ///
  /// Example:
  /// ```dart
  /// SizeConfig sizeConfig = SizeConfig.of(context, detectScreen: true, config: DeviceConfig(), size: customSize);
  /// ```
  static SizeConfig of(
    BuildContext context, {
    bool detectScreen = true,
    DeviceConfig config = const DeviceConfig(),
    Size? size,
  }) {
    return SizeConfig(context, detectScreen, config, size);
  }

  /// Returns the specified [_requireSize] or the screen [size].
  Size get size => _requireSize ?? screenSize;

  /// Returns the width of the screen or the specified [_requireSize].
  double get width => size.width;

  /// Returns the height of the screen or the specified [_requireSize].
  double get height => size.height;

  /// Returns the diagonal size of the screen or the specified [_requireSize].
  double get diagonal => sqrt((width * width) + (height * height));

  /// Returns the width of the screen.
  double get screenWidth => screenSize.width;

  /// Returns the height of the screen.
  double get screenHeight => screenSize.height;

  /// Returns the diagonal size of the screen.
  double get screenDiagonal =>
      sqrt((screenWidth * screenWidth) + (screenHeight * screenHeight));

  /// Returns `true` if the screen is considered a mobile device.
  bool get isMobile =>
      config.isMobile(screenWidth, screenHeight) && screenWidth < 500;

  /// Returns `true` if the screen is considered a tablet device.
  bool get isTab =>
      config.isTab(screenWidth, screenHeight) && screenWidth >= 500;

  /// Returns `true` if the screen is considered a laptop device.
  bool get isLaptop =>
      config.isLaptop(screenWidth, screenHeight) && screenWidth > 1020;

  /// Returns `true` if the screen is considered a desktop device.
  bool get isDesktop =>
      config.isDesktop(screenWidth, screenHeight) && screenWidth > 1366;

  /// Returns `true` if the screen width is greater than the desktop width.
  bool get isTV => screenWidth > config.desktop.width && screenWidth > 1800;

  /// Returns the [DeviceType] based on the screen width and height.
  DeviceType get deviceType => config.deviceType(screenWidth, screenHeight);

  /// Returns the detected pixel size or the specified [_requireSize] pixel size.
  double get _detectedPixel => detectScreen ? _suggestedPixel : width;

  /// Returns the detected space size or the specified [_requireSize] space size.
  double get _detectedSpace => detectScreen ? _suggestedSpace : width;

  /// Returns a constant screen variant value.
  double get _screenVariant {
    return 4;
  }

  /// Returns a variant value for font size based on device type.
  double get _fontVariant {
    if (isTV) {
      return 100;
    } else if (isDesktop) {
      return 75;
    } else if (isLaptop) {
      return 50;
    } else if (isTab) {
      return 25;
    } else {
      return 0;
    }
  }

  /// Returns the suggested pixel size based on screen orientation.
  double get _suggestedPixel {
    if (width > height) {
      return height;
    } else {
      return width;
    }
  }

  /// Returns the suggested space size based on screen orientation.
  double get _suggestedSpace {
    if (width > height) {
      return height;
    } else {
      return width;
    }
  }

  /// Calculates the size based on a percentage of the total size.
  ///
  /// Example:
  /// ```dart
  /// double result = sizeConfig.percentageSize(totalSize, percentageSize);
  /// ```
  double percentageSize(double totalSize, double percentageSize) {
    if (percentageSize > 100) return totalSize;
    if (percentageSize < 0) return 0;
    return totalSize * (percentageSize / 100);
  }

  /// Calculates the size by dividing the total size by the specified divided length.
  ///
  /// Example:
  /// ```dart
  /// double result = sizeConfig.dividedSize(totalSize, dividedLength);
  /// ```
  double dividedSize(double totalSize, double dividedLength) {
    if (dividedLength > totalSize) return totalSize;
    if (dividedLength < 0) return 0;
    return totalSize / dividedLength;
  }

  /// Converts the initial font size to pixels based on the device type.
  ///
  /// Example:
  /// ```dart
  /// double result = sizeConfig.fontSize(initialSize);
  /// ```
  double fontSize(double initialSize) => px(initialSize);

  /// Converts the initial pixel size to pixels based on the device type.
  ///
  /// Example:
  /// ```dart
  /// double result = sizeConfig.px(initialSize);
  /// ```
  double px(double? initialSize, [bool any = true]) {
    return value(initialSize, any);
  }

  /// Converts the initial pixel size to pixels based on the device type, considering the screen variant.
  ///
  /// Example:
  /// ```dart
  /// double result = sizeConfig.dx(initialSize);
  /// ```
  double dx(double? initialSize, [bool any = true]) {
    final x = (initialSize ?? 0) / _screenVariant;
    final v = !any && x < 0 ? 1.0 : x;
    return percentageSize(diagonal, v);
  }

  /// Converts the initial pixel size to pixels based on the device type, considering the screen variant.
  ///
  /// Example:
  /// ```dart
  /// double result = sizeConfig.pixel(initialSize);
  /// ```
  double pixel(double? initialSize, [bool any = true]) {
    final x = (initialSize ?? 0) / _screenVariant;
    final v = !any && x < 0 ? 1.0 : x;
    return percentageSize(_detectedPixel, v);
  }

  /// Converts the initial size to pixels based on the device type and font variant.
  ///
  /// Example:
  /// ```dart
  /// double result = sizeConfig.value(initialSize);
  /// ```
  double value(double? initialSize, [bool any = true]) {
    final x = (initialSize ?? 0) * (_fontVariant / 100);
    final v = !any && x < 0 ? 1.0 : x;
    final r = ((initialSize ?? 0) + v);
    return r;
  }

  /// Converts the initial pixel size to pixels based on the device type, considering the screen variant.
  ///
  /// Example:
  /// ```dart
  /// double result = sizeConfig.pixelPercentage(percentage);
  /// ```
  double pixelPercentage(double percentage) {
    if (percentage > 100) return _detectedPixel;
    if (percentage < 0) return 0;
    return _detectedPixel * (percentage / 100);
  }

  /// Converts the initial size to pixels based on the device type and font variant.
  ///
  /// Example:
  /// ```dart
  /// double result = sizeConfig.space(initialSize);
  /// ```
  double space(double? initialSize) {
    final x = (initialSize ?? 0) / _screenVariant;
    final v = x < 0 ? 1.0 : x;
    return percentageSize(_detectedSpace, v);
  }

  /// Converts the initial size to pixels based on the device type and font variant.
  ///
  /// Example:
  /// ```dart
  /// double result = sizeConfig.spacePercentage(percentage);
  /// ```
  double spacePercentage(double percentage) {
    if (percentage > 100) return _detectedSpace;
    if (percentage < 0) return 0;
    return _detectedSpace * (percentage / 100);
  }

  /// Returns the square of the specified percentage of the detected pixel size.
  ///
  /// Example:
  /// ```dart
  /// double result = sizeConfig.squire(percentage: 100);
  /// ```
  double squire({double percentage = 100}) =>
      percentageSize(_detectedPixel, percentage);

  /// Returns the width calculated as a percentage of the total width.
  ///
  /// Example:
  /// ```dart
  /// double result = sizeConfig.percentageWidth(50);
  /// ```
  double percentageWidth(double percentage) =>
      percentageSize(width, percentage);

  /// Returns the height calculated as a percentage of the total height.
  ///
  /// Example:
  /// ```dart
  /// double result = sizeConfig.percentageHeight(50);
  /// ```
  double percentageHeight(double percentage) =>
      percentageSize(height, percentage);

  /// Returns the font size calculated as a percentage of the detected pixel size.
  ///
  /// Example:
  /// ```dart
  /// double result = sizeConfig.percentageFontSize(50);
  /// ```
  double percentageFontSize(double percentage) =>
      percentageSize(_detectedPixel, percentage);

  /// Returns the space calculated as a percentage of the detected pixel size.
  ///
  /// Example:
  /// ```dart
  /// double result = sizeConfig.percentageSpace(50);
  /// ```
  double percentageSpace(double percentage) =>
      percentageSize(_detectedPixel, percentage);

  /// Returns the horizontal space calculated as a percentage of the detected pixel size.
  ///
  /// Example:
  /// ```dart
  /// double result = sizeConfig.percentageSpaceHorizontal(50);
  /// ```
  double percentageSpaceHorizontal(double percentage) =>
      percentageSpace(percentage);

  /// Returns the vertical space calculated as a percentage of the total height.
  ///
  /// Example:
  /// ```dart
  /// double result = sizeConfig.percentageSpaceVertical(50);
  /// ```
  double percentageSpaceVertical(double percentage) =>
      percentageSize(height, percentage);

  /// Returns the space calculated by dividing the detected pixel size by the specified divided length.
  ///
  /// Example:
  /// ```dart
  /// double result = sizeConfig.dividedSpace(2);
  /// ```
  double dividedSpace(double dividedLength) =>
      dividedSize(_detectedPixel, dividedLength);

  /// Returns the horizontal space calculated by dividing the detected pixel size by the specified divided length.
  ///
  /// Example:
  /// ```dart
  /// double result = sizeConfig.dividedSpaceHorizontal(2);
  /// ```
  double dividedSpaceHorizontal(double dividedLength) =>
      dividedSpace(dividedLength);

  /// Returns the vertical space calculated by dividing the total height by the specified divided length.
  ///
  /// Example:
  /// ```dart
  /// double result = sizeConfig.dividedSpaceVertical(2);
  /// ```
  double dividedSpaceVertical(double dividedLength) =>
      dividedSize(height, dividedLength);
}
