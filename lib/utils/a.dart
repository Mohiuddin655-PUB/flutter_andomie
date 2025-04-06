String parse(String input, Map<String, int> args) {
  final p = RegExp(r"{(.*?)\?(.*?):(.*?)}");

  return input.replaceAllMapped(p, (m) {
    final condition = m.group(1)!.trim();
    final a = m.group(2)!.trim().replaceAll("'", '').replaceAll('"', '');
    final b = m.group(3)!.trim().replaceAll("'", '').replaceAll('"', '');

    final resolvedCondition = _v(condition, args);
    final result = _e(resolvedCondition);

    final chosen = result ? a : b;
    final output = _v(chosen, args, true);
    return output;
  });
}

String _v(String input, Map<String, Object?> args, [bool replace = false]) {
  return input.replaceAllMapped(RegExp(r'\b[A-Z_]+\b'), (m) {
    final key = m.group(0);
    if (args.containsKey(key)) {
      return args[key].toString();
    }
    return replace ? m.group(0) ?? '' : '';
  });
}

bool _e(String expr) {
  final p = RegExp(r"(\d+)\s*(==|!=|>=|<=|>|<)\s*(\d+)");
  final m = p.firstMatch(expr);
  if (m == null) return false;

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

void main() {
  print(parse(
    "There {NUMBER > 1 ? \"are NUMBER items\" : \"is an item\"} in stock",
    {'NUMBER': 15},
  ));

  print(parse(
    "You are {AGE >= 18 ? 'AGE years old (Adult)' : 'AGE (Minor)'}",
    {'AGE': 19},
  ));
}
