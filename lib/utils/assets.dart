import '../instance.dart';

class AndomieAssets {
  final String package;
  final String icons;
  final String images;

  const AndomieAssets({
    this.package = "assets",
    this.icons = "icons",
    this.images = "images",
  });

  static AndomieAssets get i {
    return Andomie.iOrNull?.assets ?? const AndomieAssets();
  }

  String ic(String name) => "$package/$icons/$name";

  String img(String name) => "$package/$images/$name";
}

class AssetIcon {
  final String _regular;
  final String _solid;
  final String _bold;

  String get regular => AndomieAssets.i.ic(_regular);

  String get solid => AndomieAssets.i.ic(_solid);

  String get bold => AndomieAssets.i.ic(_bold);

  String regularBold(bool selected) {
    if (selected) return bold;
    return regular;
  }

  String regularSolid(bool selected) {
    if (selected) return solid;
    return regular;
  }

  const AssetIcon({
    String? regular,
    String? solid,
    String? bold,
  })  : _regular = regular ?? bold ?? solid ?? "",
        _solid = solid ?? bold ?? regular ?? "",
        _bold = bold ?? solid ?? regular ?? "";
}

extension AndomieAssetsHelper on String {
  String get ic => AndomieAssets.i.ic(this);

  String get img => AndomieAssets.i.img(this);
}
