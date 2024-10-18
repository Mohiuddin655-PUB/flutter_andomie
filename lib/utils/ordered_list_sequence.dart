enum OrderedListSequence {
  number("1.", "number"),
  lowerAlpha("a.", "lower alpha"),
  upperAlpha("A.", "upper alpha"),
  lowerRoman("i.", "lower roman"),
  upperRoman("I.", "upper roman"),
  lowerGreek("α.", "lower greek"),
  upperGreek("Α.", "upper greek");

  final String sign;
  final String name;

  const OrderedListSequence(this.sign, this.name);

  /// Use Case:
  /// ```dart
  /// OrderedListSequence.number.sequence(index)
  /// ```
  ///
  /// Example:
  ///
  /// Number sequence generation like: [OrderedListSequence.number]
  /// ```
  /// 1, 2, 3, ..., 97, 98, 99, ..., 100, 101, ...
  /// ```
  ///
  /// Lowercase alphabetic sequence generation like: [OrderedListSequence.lowerAlpha]
  /// ```
  /// a, b, c, ..., aa, ab, ac, ..., aba, abb, ...
  /// ```
  ///
  /// Uppercase alphabetic sequence generation like: [OrderedListSequence.upperAlpha]
  /// ```
  /// A, B, C, ..., AA, AB, AC, ..., ABA, ABB, ...
  /// ```
  ///
  /// Lowercase Roman numeral sequence generation like: [OrderedListSequence.lowerRoman]
  /// ```
  /// i, ii, iii, ..., xcvii, xcviii, xcix, ..., c, ci, ...
  /// ```
  ///
  /// Uppercase Roman numeral sequence generation like: [OrderedListSequence.upperRoman]
  /// ```
  /// I, II, III, ..., XCVII, XCVIII, XCIX, ..., C, CI, ...
  /// ```
  ///
  /// Lowercase Greek letter sequence generation like: [OrderedListSequence.lowerGreek]
  /// ```
  /// α, β, γ, ..., αα, αβ, αγ, ..., βα, ββ, ...
  /// ```
  ///
  /// Uppercase Greek letter sequence generation like: [OrderedListSequence.upperGreek]
  /// ```
  /// Α, Β, Γ, ..., ΑΑ, ΑΒ, ΑΓ, ..., ΒΑ, ΒΒ, ...
  /// ```
  String sequence(int index) {
    switch (this) {
      case OrderedListSequence.number:
        return '${index + 1}';
      case OrderedListSequence.lowerAlpha:
        return _alpha(index);
      case OrderedListSequence.upperAlpha:
        return _alpha(index, true);
      case OrderedListSequence.lowerRoman:
        return _roman(index + 1).toLowerCase();
      case OrderedListSequence.upperRoman:
        return _roman(index + 1);
      case OrderedListSequence.lowerGreek:
        return _greek(index);
      case OrderedListSequence.upperGreek:
        return _greek(index, true);
    }
  }

  /// Alphabetic sequence generation like a, b, c, ..., aa, ab, ac, ..., aba, abb, ...
  String _alpha(int index, [bool isUpperCase = false]) {
    String sequence = '';
    while (index >= 0) {
      int remainder = index % 26;
      sequence =
          String.fromCharCode((isUpperCase ? 65 : 97) + remainder) + sequence;
      index = (index ~/ 26) - 1;
    }
    return sequence;
  }

  /// Greek letter sequence generation like α, β, γ, ..., αα, αβ, αγ, ..., αβα, αββ, ...
  String _greek(int index, [bool isUpperCase = false]) {
    const both = [
      [
        'α',
        'β',
        'γ',
        'δ',
        'ε',
        'ζ',
        'η',
        'θ',
        'ι',
        'κ',
        'λ',
        'μ',
        'ν',
        'ξ',
        'ο',
        'π',
        'ρ',
        'σ',
        'τ',
        'υ',
        'φ',
        'χ',
        'ψ',
        'ω'
      ],
      [
        'Α',
        'Β',
        'Γ',
        'Δ',
        'Ε',
        'Ζ',
        'Η',
        'Θ',
        'Ι',
        'Κ',
        'Λ',
        'Μ',
        'Ν',
        'Ξ',
        'Ο',
        'Π',
        'Ρ',
        'Σ',
        'Τ',
        'Υ',
        'Φ',
        'Χ',
        'Ψ',
        'Ω'
      ],
    ];
    final letters = both[isUpperCase ? 0 : 1];
    String sequence = '';
    int base = letters.length;
    while (index >= 0) {
      int remainder = index % base;
      sequence = letters[remainder] + sequence;
      index = (index ~/ base) - 1;
    }
    return sequence;
  }

  /// Roman numerals sequence generation like i, ii, iii, ...
  String _roman(int number) {
    const numerals = {
      1000: 'M',
      900: 'CM',
      500: 'D',
      400: 'CD',
      100: 'C',
      90: 'XC',
      50: 'L',
      40: 'XL',
      10: 'X',
      9: 'IX',
      5: 'V',
      4: 'IV',
      1: 'I'
    };
    String result = '';
    numerals.forEach((value, numeral) {
      while (number >= value) {
        result += numeral;
        number -= value;
      }
    });
    return result;
  }
}
