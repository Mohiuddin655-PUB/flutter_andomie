import 'utils/assets.dart';

typedef OnAndomieDateFormatter = String Function(
  String format,
  String? local,
  DateTime date,
);

class Andomie {
  final AndomieAssets? assets;
  final OnAndomieDateFormatter dateFormatter;

  const Andomie._({
    required this.dateFormatter,
    this.assets,
  });

  static Andomie? _i;

  static Andomie? get iOrNull => _i;

  static Andomie get i {
    if (_i != null) return _i!;
    throw UnimplementedError(
      "$Andomie hasn't initialized yet, Firstly initialize $Andomie.init() then use.",
    );
  }

  static void init({
    required OnAndomieDateFormatter dateFormatter,
    AndomieAssets? assets,
  }) {
    _i = Andomie._(
      dateFormatter: dateFormatter,
      assets: assets,
    );
  }
}
