import '../instance.dart';
import 'icon.dart';

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

  String? ic(String? name) {
    if (name == null || name.isEmpty) return null;
    return "$package/$icons/$name";
  }

  String? img(String? name) {
    if (name == null || name.isEmpty) return null;
    return "$package/$images/$name";
  }
}

class AssetIcon extends AndomieIcon<String> {
  @override
  String get regular => regularOrNull ?? '';

  @override
  String get solid => solidOrNull ?? '';

  @override
  String get bold => boldOrNull ?? '';

  @override
  String? get regularOrNull => AndomieAssets.i.ic(super.regularOrNull);

  @override
  String? get solidOrNull => AndomieAssets.i.ic(super.solidOrNull);

  @override
  String? get boldOrNull => AndomieAssets.i.ic(super.boldOrNull);

  const AssetIcon({
    super.regular,
    super.solid,
    super.bold,
  });

  @override
  String toString() => "$AssetIcon#$hashCode($stringify)";
}

extension AndomieAssetsHelper on String? {
  String get ic => icOrNull ?? '';

  String get img => imgOrNull ?? '';

  String? get icOrNull => AndomieAssets.i.ic(this);

  String? get imgOrNull => AndomieAssets.i.img(this);
}
