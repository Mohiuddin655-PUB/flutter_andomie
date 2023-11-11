part of '../utils.dart';

class AppIcon {
  final String regular;
  final String solid;
  final String bold;

  const AppIcon({
    String? regular,
    String? solid,
    String? bold,
    String package = "assets",
    String path = "icons",
  })  : regular = "$package/$path/${regular ?? bold ?? solid}",
        solid = "$package/$path/${solid ?? bold ?? regular}",
        bold = "$package/$path/${bold ?? solid ?? regular}";

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

class AppIconBuilder {
  final String package;
  final String path;

  const AppIconBuilder({
    this.package = "assets",
    this.path = "icons",
  });

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
