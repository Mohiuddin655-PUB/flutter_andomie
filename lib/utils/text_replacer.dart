class TextReplacer {
  const TextReplacer._();

  static String _v(String input, Map<String, Object?> args, bool replace) {
    return input.replaceAllMapped(RegExp(r'\b[A-Z_]+\b'), (m) {
      final key = m.group(0);
      if (args.containsKey(key)) {
        return args[key].toString();
      }
      return replace ? key ?? '' : '';
    });
  }

  static bool _e(String expr) {
    final numeric = RegExp(r'^(\d+)\s*(==|!=|>=|<=|>|<)\s*(\d+)$');

    if (numeric.hasMatch(expr)) {
      final m = numeric.firstMatch(expr)!;
      final l = num.tryParse(m.group(1) ?? '') ?? -1;
      final o = m.group(2) ?? '';
      final r = num.tryParse(m.group(3) ?? '') ?? -1;

      switch (o) {
        case '==':
          return l == r;
        case '!=':
          return l != r;
        case '>':
          return l > r;
        case '<':
          return l < r;
        case '>=':
          return l >= r;
        case '<=':
          return l <= r;
        default:
          return false;
      }
    }

    final boolean = RegExp(r"^(true|false)\s*(==|!=)\s*(true|false)$",
        caseSensitive: false);

    if (boolean.hasMatch(expr)) {
      final m = boolean.firstMatch(expr)!;
      final l = m.group(1)!.toLowerCase() == 'true';
      final o = m.group(2)!;
      final r = m.group(3)!.toLowerCase() == 'true';

      switch (o) {
        case '==':
          return l == r;
        case '!=':
          return l != r;
        default:
          return false;
      }
    }

    final string = RegExp(r"^(.+?)\s*(==|!=)\s*(.+?)$");

    if (string.hasMatch(expr)) {
      final m = string.firstMatch(expr)!;
      final l = m.group(1)!.trim().replaceAll("'", '').replaceAll('"', '');
      final o = m.group(2)!;
      final r = m.group(3)!.trim().replaceAll("'", '').replaceAll('"', '');

      switch (o) {
        case '==':
          return l == r;
        case '!=':
          return l != r;
        default:
          return false;
      }
    }

    if (expr.trim().toLowerCase() == 'true') return true;

    return false;
  }

  /// ```
  /// final inp1 = "There {NUMBER > 1 ? \"are NUMBER items\" : \"is an item\"} in stock";
  /// TextReplacer.replace(inp1, {'NUMBER': 1}); // There is an item in stock
  /// TextReplacer.replace(inp1, {'NUMBER': 2}); // There are 2 items in stock
  /// inp1.replace({'NUMBER': 1}); // There is an item in stock
  /// inp1.replace({'NUMBER': 2}); // There are 2 items in stock
  ///
  /// final inp2 = "Status: {STATUS == active ? \"activated!\" : \"canceled!\"}";
  /// TextReplacer.replace(inp2, {'STATUS': "active"}); // Status: activated!
  /// TextReplacer.replace(inp2, {'STATUS': "inactive"}); // Status: canceled!
  /// inp2.replace({'STATUS': "active"}); // Status: activated!
  /// inp2.replace({'STATUS': "inactive"}); // Status: canceled!
  ///
  /// final inp3 = "Status: {IS_ACTIVATED ? \"activated!\" : \"inactivated!\"}";
  /// TextReplacer.replace(inp3, {'IS_ACTIVATED': true}); // Status: activated!
  /// TextReplacer.replace(inp3, {'IS_ACTIVATED': false}); // Status: inactivated!
  /// inp3.replace({'IS_ACTIVATED': true}); // Status: activated!
  /// inp3.replace({'IS_ACTIVATED': false}); // Status: inactivated!
  ///
  static String replace(String input, Map<String, Object?> args) {
    final p = RegExp(r'\{([^?]+)\?\s*"([^"]+)"\s*:\s*"([^"]+)"}');

    return input.replaceAllMapped(p, (m) {
      final condition = m.group(1)!.trim();
      final a = m.group(2)!.trim().replaceAll("'", '').replaceAll('"', '');
      final b = m.group(3)!.trim().replaceAll("'", '').replaceAll('"', '');

      final resolvedCondition = _v(condition, args, false);
      final result = _e(resolvedCondition);

      final chosen = result ? a : b;
      final output = _v(chosen, args, true);
      return output;
    });
  }
}

extension TextReplacerHelper on String {
  /// ```
  /// final inp1 = "There {NUMBER > 1 ? \"are NUMBER items\" : \"is an item\"} in stock";
  /// TextReplacer.replace(inp1, {'NUMBER': 1}); // There is an item in stock
  /// TextReplacer.replace(inp1, {'NUMBER': 2}); // There are 2 items in stock
  /// inp1.replace({'NUMBER': 1}); // There is an item in stock
  /// inp1.replace({'NUMBER': 2}); // There are 2 items in stock
  ///
  /// final inp2 = "Status: {STATUS == active ? \"activated!\" : \"canceled!\"}";
  /// TextReplacer.replace(inp2, {'STATUS': "active"}); // Status: activated!
  /// TextReplacer.replace(inp2, {'STATUS': "inactive"}); // Status: canceled!
  /// inp2.replace({'STATUS': "active"}); // Status: activated!
  /// inp2.replace({'STATUS': "inactive"}); // Status: canceled!
  ///
  /// final inp3 = "Status: {IS_ACTIVATED ? \"activated!\" : \"inactivated!\"}";
  /// TextReplacer.replace(inp3, {'IS_ACTIVATED': true}); // Status: activated!
  /// TextReplacer.replace(inp3, {'IS_ACTIVATED': false}); // Status: inactivated!
  /// inp3.replace({'IS_ACTIVATED': true}); // Status: activated!
  /// inp3.replace({'IS_ACTIVATED': false}); // Status: inactivated!
  ///
  String replace({
    Map<String, Object?> args = const {},
  }) {
    return TextReplacer.replace(this, args);
  }
}
