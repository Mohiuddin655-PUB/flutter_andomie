class TextReplacer {
  const TextReplacer._();

  static bool _e(String expr) {
    final numeric = RegExp(r'^(\d+)\s*(==|!=|>=|<=|>|<)\s*(\d+)$');
    final string = RegExp(r"^(.+?)\s*(==|!=)\s*(.+?)$");

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
    } else if (string.hasMatch(expr)) {
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

    return false;
  }

  static String _v(String input, Map<String, Object?> args, bool replace) {
    return input.replaceAllMapped(RegExp(r'\b[A-Z_]+\b'), (m) {
      final key = m.group(0);
      if (args.containsKey(key)) {
        return args[key].toString();
      }
      return replace ? key ?? '' : '';
    });
  }

  static String replace(String input, Map<String, Object?> args) {
    if (args.isEmpty) return input;

    final p = RegExp(r"{(.*?)\?(.*?):(.*?)}");

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
  /// void main() {
  ///   print("There {NUMBER > 1 ? are NUMBER items : is an item} in stock".replace(
  ///     args: {'NUMBER': 13},
  ///   ));
  ///
  ///   print("You are {AGE >= 18 ? AGE years old (Adult) : AGE (Minor)}".replace(
  ///     args: {'AGE': 19},
  ///   ));
  ///
  ///   print('User status: {STATUS == "active" ? "Welcome STATUS" : "Access denied"}'
  ///       .replace(
  ///     args: {'STATUS': "active"},
  ///   ));
  ///
  ///   print("There {COUNT > 1 ? 'are COUNT items' : 'is 1 item'} available".replace(
  ///     args: {'COUNT': 4},
  ///   ));
  ///
  ///   print(
  ///       "Role: {ROLE != admin ? 'Guest' : 'Admin Panel'} and User status: {STATUS == active ? Welcome STATUS : Access denied}"
  ///           .replace(
  ///     args: {
  ///       'ROLE': 'admin',
  ///       'STATUS': 'active',
  ///     },
  ///   ));
  /// }
  String replace({
    Map<String, Object?> args = const {},
  }) {
    return TextReplacer.replace(this, args);
  }
}
