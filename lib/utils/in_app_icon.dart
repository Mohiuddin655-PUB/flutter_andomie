/// A utility class for handling application icons.
/// Represents an application icon with regular, solid, and bold variants.
class InAppIcon {
  final String regular;
  final String solid;
  final String bold;

  /// Creates an instance of [InAppIcon].
  ///
  /// Parameters:
  /// - [regular]: The path to the regular variant of the icon.
  /// - [solid]: The path to the solid variant of the icon.
  /// - [bold]: The path to the bold variant of the icon.
  /// - [package]: The package where the icons are located (default is "assets").
  /// - [path]: The path to the icons directory (default is "icons").
  const InAppIcon({
    String? regular,
    String? solid,
    String? bold,
    String package = "assets",
    String path = "icons",
  })  : regular = "$package/$path/${regular ?? bold ?? solid}",
        solid = "$package/$path/${solid ?? bold ?? regular}",
        bold = "$package/$path/${bold ?? solid ?? regular}";

  /// Creates an instance of [InAppIcon] using an automatic naming convention.
  ///
  /// Parameters:
  /// - [name]: The base name of the icon.
  /// - [package]: The package where the icons are located (default is "assets").
  /// - [path]: The path to the icons directory (default is "icons").
  factory InAppIcon.svg(
    String name, {
    String package = "assets",
    String path = "icons",
  }) {
    return InAppIcon(
      package: package,
      path: path,
      regular: "${name}_regular.svg",
      solid: "${name}_solid.svg",
      bold: "${name}_bold.svg",
    );
  }

  /// Creates an instance of [InAppIcon] using an automatic naming convention.
  ///
  /// Parameters:
  /// - [name]: The base name of the icon.
  /// - [package]: The package where the icons are located (default is "assets").
  /// - [path]: The path to the icons directory (default is "icons").
  factory InAppIcon.png(
    String name, {
    String package = "assets",
    String path = "icons",
  }) {
    return InAppIcon(
      package: package,
      path: path,
      regular: "${name}_regular.png",
      solid: "${name}_solid.png",
      bold: "${name}_bold.png",
    );
  }
}
