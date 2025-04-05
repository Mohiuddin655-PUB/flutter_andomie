class LocalizedString {
  final Map<String, String> _strings;

  bool get isEmpty => _strings.isEmpty;

  bool get isNotEmpty => _strings.isNotEmpty;

  const LocalizedString(this._strings);

  const LocalizedString.empty() : this(const {});

  factory LocalizedString.from(Object? source) {
    if (source is! Map) return LocalizedString.empty();
    final entries = source.entries.map((e) {
      final key = e.key.toString();
      final value = e.value.toString();
      if (key.isEmpty || value.isEmpty) return null;
      return MapEntry(key, value);
    }).whereType<MapEntry<String, String>>();
    return LocalizedString(Map.fromEntries(entries));
  }

  LocalizedString copyWith({Map<String, String>? strings}) {
    return LocalizedString(strings ?? _strings);
  }

  LocalizedString modifyWith({Map<String, String> strings = const {}}) {
    if (strings.isEmpty) return this;
    _strings.addAll(strings);
    return this;
  }

  String? localize(String language) => _strings[language] ?? _strings["en"];

  @override
  int get hashCode => _strings.hashCode;

  @override
  bool operator ==(Object other) {
    return other is LocalizedString && other._strings == _strings;
  }

  @override
  String toString() => "$_strings";
}

extension LocalizedStringHelper on LocalizedString? {
  LocalizedString get use => this ?? LocalizedString.empty();

  LocalizedString? get verified => use.isNotEmpty ? this : null;

  String? localize(String language) => use.localize(language);
}
