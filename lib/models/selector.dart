class Selector<T extends Object?> {
  final T primary;
  final T? secondary;
  final T? ternary;

  const Selector({
    required this.primary,
    this.secondary,
    this.ternary,
  });

  T get secondaryOrUse => secondary ?? primary;

  T get ternaryOrUse => ternary ?? secondaryOrUse;

  T select(
    bool selected, {
    bool disabled = false,
  }) {
    return disabled
        ? ternaryOrUse
        : selected
            ? secondaryOrUse
            : primary;
  }
}
