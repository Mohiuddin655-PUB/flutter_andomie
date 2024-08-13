typedef OnAndomieDateFormatter = String Function(
  String format,
  String? local,
  DateTime date,
);

class Andomie {
  final OnAndomieDateFormatter dateFormatter;

  const Andomie._({
    required this.dateFormatter,
  });

  static Andomie? _i;

  static Andomie get i {
    if (_i != null) return _i!;
    throw UnimplementedError(
      "$Andomie hasn't initialized yet, Firstly initialize $Andomie.init() then use.",
    );
  }

  static void init({
    required OnAndomieDateFormatter dateFormatter,
  }) {
    _i = Andomie._(dateFormatter: dateFormatter);
  }
}
