class AndomieIcon<T extends Object?> {
  final T? _regular;
  final T? _solid;
  final T? _bold;

  T get regular => _regular!;

  T? get regularOrNull => _regular;

  T get solid => _solid!;

  T? get solidOrNull => _solid;

  T get bold => _bold!;

  T? get boldOrNull => _bold;

  T regularBold(bool selected) => regularBoldOrNull(selected)!;

  T? regularBoldOrNull(bool selected) {
    if (selected) return boldOrNull;
    return regularOrNull;
  }

  T regularSolid(bool selected) => regularSolidOrNull(selected)!;

  T? regularSolidOrNull(bool selected) {
    if (selected) return solidOrNull;
    return regularOrNull;
  }

  const AndomieIcon({
    T? regular,
    T? solid,
    T? bold,
  })  : _regular = regular ?? bold ?? solid,
        _solid = solid ?? bold ?? regular,
        _bold = bold ?? solid ?? regular;

  @override
  int get hashCode => _regular.hashCode ^ _solid.hashCode ^ _bold.hashCode;

  @override
  bool operator ==(Object other) {
    return other is AndomieIcon<T> &&
        other._regular == _regular &&
        other._solid == _solid &&
        other._bold == _bold;
  }

  String get stringify => "regular: $_regular, solid: $_solid, bold: $_bold";

  @override
  String toString() => "$AndomieIcon<$T>#$hashCode($stringify)";
}
