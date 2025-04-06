String parse(String input, Map<String, Object?> args) {
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
    return replace ? key ?? '' : '';
  });
}

bool _e(String expr) {
  final numeric = RegExp(r'^(\d+)\s*(==|!=|>=|<=|>|<)\s*(\d+)$');
  final string = RegExp(r'^"?(.*?)"?\s*(==|!=)\s*"?(.+?)"?$');

  if (numeric.hasMatch(expr)) {
    final m = numeric.firstMatch(expr)!;
    final l = num.tryParse(m.group(1) ?? '') ?? -1;
    final o = m.group(2) ?? '';
    final r = num.tryParse(m.group(3) ?? '') ?? -1;

    switch (o) {
      case '==': return l == r;
      case '!=': return l != r;
      case '>': return l > r;
      case '<': return l < r;
      case '>=': return l >= r;
      case '<=': return l <= r;
    }
  } else if (string.hasMatch(expr)) {
    final m = string.firstMatch(expr)!;
    final l = m.group(1);
    final o = m.group(2);
    final r = m.group(3);

    switch (o) {
      case '==': return l == r;
      case '!=': return l != r;
    }
  }

  return false;
}

void main() {
  print(parse(
    "There {NUMBER > 1 ? \"are NUMBER items\" : \"is an item\"} in stock",
    {'NUMBER': 13},
  ));

  print(parse(
    "You are {AGE >= 18 ? 'AGE years old (Adult)' : 'AGE (Minor)'}",
    {'AGE': 19},
  ));

  print(parse("User status: {STATUS == 'active' ? 'Welcome STATUS' : 'Access denied'}", {
    'STATUS': 'active',
  }));

  print(parse("There {COUNT > 1 ? 'are COUNT items' : 'is 1 item'} available", {
    'COUNT': 4,
  }));
}
