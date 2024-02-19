/// A utility class for handling application icons.
part of '../utils.dart';

/// Represents an application icon with regular, solid, and bold variants.
class AppIcon {
  final String regular;
  final String solid;
  final String bold;

  /// Creates an instance of [AppIcon].
  ///
  /// Parameters:
  /// - [regular]: The path to the regular variant of the icon.
  /// - [solid]: The path to the solid variant of the icon.
  /// - [bold]: The path to the bold variant of the icon.
  /// - [package]: The package where the icons are located (default is "assets").
  /// - [path]: The path to the icons directory (default is "icons").
  const AppIcon({
    String? regular,
    String? solid,
    String? bold,
    String package = "assets",
    String path = "icons",
  })  : regular = "$package/$path/${regular ?? bold ?? solid}",
        solid = "$package/$path/${solid ?? bold ?? regular}",
        bold = "$package/$path/${bold ?? solid ?? regular}";

  /// Creates an instance of [AppIcon] using an automatic naming convention.
  ///
  /// Parameters:
  /// - [name]: The base name of the icon.
  /// - [package]: The package where the icons are located (default is "assets").
  /// - [path]: The path to the icons directory (default is "icons").
  /// - [prefix]: The prefix to be added to the icon name (default is "ic").
  /// - [extension]: The file extension of the icon (default is "svg").
  factory AppIcon.auto(
    String name, {
    String package = "assets",
    String path = "icons",
    String prefix = "ic",
    String extension = "svg",
  }) {
    return AppIcon(
      package: package,
      path: path,
      regular: "${prefix}_${name}_regular.$extension",
      solid: "${prefix}_${name}_solid.$extension",
      bold: "${prefix}_${name}_bold.$extension",
    );
  }
}

/// A builder class for creating instances of [AppIcon].
class AppIconBuilder {
  final String package;
  final String path;

  /// Creates an instance of [AppIconBuilder].
  ///
  /// Parameters:
  /// - [package]: The package where the icons are located (default is "assets").
  /// - [path]: The path to the icons directory (default is "icons").
  const AppIconBuilder({
    this.package = "assets",
    this.path = "icons",
  });

  /// Creates an instance of [AppIcon] using automatic naming convention.
  ///
  /// Parameters:
  /// - [name]: The base name of the icon.
  /// - [prefix]: The prefix to be added to the icon name (default is "ic").
  /// - [extension]: The file extension of the icon (default is "svg").
  AppIcon auto(
    String name, {
    String prefix = "ic",
    String extension = "svg",
  }) {
    return AppIcon.auto(
      name,
      package: package,
      path: path,
      prefix: prefix,
      extension: extension,
    );
  }

  /// Creates an instance of [AppIcon].
  ///
  /// Parameters:
  /// - [regular]: The path to the regular variant of the icon.
  /// - [solid]: The path to the solid variant of the icon.
  /// - [bold]: The path to the bold variant of the icon.
  AppIcon build({
    String? regular,
    String? solid,
    String? bold,
  }) {
    return AppIcon(
      package: package,
      path: path,
      regular: regular,
      solid: solid,
      bold: bold,
    );
  }
}
