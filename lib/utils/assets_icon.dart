import 'assets.dart';
import 'icon.dart';

class AssetIcon extends AndomieIcon<String> {
  @override
  String get regular => regularOrNull ?? '';

  @override
  String get solid => solidOrNull ?? '';

  @override
  String get bold => boldOrNull ?? '';

  @override
  String? get regularOrNull => Assets.ic(super.regularOrNull);

  @override
  String? get solidOrNull => Assets.ic(super.solidOrNull);

  @override
  String? get boldOrNull => Assets.ic(super.boldOrNull);

  const AssetIcon({
    super.regular,
    super.solid,
    super.bold,
  });

  @override
  String toString() => "$AssetIcon#$hashCode($stringify)";
}
