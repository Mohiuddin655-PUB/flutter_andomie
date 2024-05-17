/// A class for handling text formats with singular and optional plural forms.
class TextFormat {
  /// The singular form of the text.
  final String singular;

  /// The plural form of the text. If not provided, it defaults to the singular form.
  final String plural;

  /// Creates a [TextFormat] instance with the specified [singular] form and optional [plural] form.
  const TextFormat({
    required this.singular,
    String? plural,
  }) : plural = plural ?? singular;

  /// Gets the appropriate text form based on the provided [counter].
  /// If the counter is greater than 1, returns the plural form; otherwise, returns the singular form.
  String apply(int counter) => counter > 1 ? plural : singular;
}
