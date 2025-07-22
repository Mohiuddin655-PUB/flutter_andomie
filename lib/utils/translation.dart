import 'dart:async';

import 'package:flutter/material.dart';

import '../contents/country_flags.dart';
import '../contents/language_numerical_digits.dart';
import '../contents/rtl_directional_languages.dart';
import '../enums/texture_icons.dart';
import '../models/language.dart';
import '../utils/text_replacer.dart';
import 'map_reader.dart';
import 'remote.dart';
import 'translator.dart';

const kDefaultTranslationName = "translations";
const kDefaultTranslationPath = "localizations";

abstract class TranslationDelegate extends RemoteDelegate {
  const TranslationDelegate();

  Future<void> changed(Locale locale);

  Future<Locale?> select(BuildContext context, String? reason);
}

class Translation extends Remote<TranslationDelegate> {
  Translation._();

  static Translation? _i;

  static Translation get i => _i ??= Translation._();

  // ---------------------------------------------------------------------------
  // INITIAL PART
  // ---------------------------------------------------------------------------

  String _defaultPath = kDefaultTranslationPath;
  Translator? _translator;

  bool _autoTranslateEnable = false;

  bool get autoTranslateEnable => _translator != null && _autoTranslateEnable;

  set autoTranslateEnable(bool value) => _autoTranslateEnable = value;

  static Future<void> init({
    String? name,
    required bool connected,
    TranslationDelegate? delegate,
    TranslatorDelegate? translator,
    Set<String>? paths,
    bool listening = true,
    bool showLogs = false,
    bool autoTranslateMode = true,
    VoidCallback? onReady,
    String defaultPath = kDefaultTranslationPath,
    Object? locale,
    Object? defaultLocale,
    Object? fallbackLocale,
    Iterable? supportedLocales,
  }) async {
    paths ??= {};
    paths.add(defaultPath);
    i._defaultPath = defaultPath;
    i.defaultLocaleOrNull = parseLocale(defaultLocale);
    i.fallbackLocaleOrNull = parseLocale(fallbackLocale);
    i.localeOrNull = parseLocale(locale);
    i._supportedLocales = parseLocales(supportedLocales);
    i._autoTranslateEnable = autoTranslateMode;
    await i.initialize(
      name: name ?? kDefaultTranslationName,
      connected: connected,
      delegate: delegate,
      paths: paths,
      listening: listening,
      showLogs: showLogs,
      onReady: () {
        if (translator != null) {
          i._translator = Translator(
            defaultLocale: i.locale,
            fallbackLocale: i.fallbackLocale,
            delegate: translator,
          );
        }
        if (onReady != null) onReady();
      },
    );
  }

  // ---------------------------------------------------------------------------
  // LOCALE PART
  // ---------------------------------------------------------------------------

  Locale? defaultLocaleOrNull;

  Locale get defaultLocale => defaultLocaleOrNull ?? fallbackLocale;

  set defaultLocale(Locale? value) {
    if (value == null) return;
    if (value.toString() == defaultLocaleOrNull.toString()) return;
    defaultLocaleOrNull = value;
    notifyListeners();
  }

  Locale? fallbackLocaleOrNull;

  Locale get fallbackLocale {
    return fallbackLocaleOrNull ?? Locale("en", "US");
  }

  Locale? localeOrNull;

  Locale get locale => localeOrNull ?? defaultLocale;

  set locale(Locale? value) {
    if (value == null) return;
    if (value.toString() == localeOrNull.toString()) return;
    localeOrNull = value;
    notifyListeners();
    if (delegate == null) return;
    delegate!.changed(value);
  }

  Iterable<Locale> _supportedLocales = [];

  Iterable<Locale> get supportedLocales {
    if (_supportedLocales.isEmpty) return [locale];
    return _supportedLocales;
  }

  set supportedLocales(Iterable? values) {
    _supportedLocales = parseLocales(values);
    notifyListeners();
  }

  static String get languageCode {
    return (i.localeOrNull ?? i.defaultLocale).formatedLanguageCode;
  }

  static TextDirection get textDirection {
    final locale = i.localeOrNull ?? i.defaultLocaleOrNull;
    if (kRtlLocales.contains(locale?.languageCode)) return TextDirection.rtl;
    return TextDirection.ltr;
  }

  static Locale? parseLocale(Object? locale) {
    if (locale is Locale) return locale;
    if (locale is! String || locale.isEmpty) return null;
    final codes = locale.split("_");
    if (codes.isEmpty) return null;
    String? countryCode = codes.length == 2 ? codes.last : null;
    return Locale(codes.first, countryCode);
  }

  static Iterable<Locale> parseLocales(Iterable? values) {
    if (values == null || values.isEmpty) return [];
    final locales = values.map(parseLocale).whereType<Locale>();
    return locales;
  }

  static void changeLocale(Object? value) {
    Translation.i.locale = parseLocale(value);
    Translation.i._translator?.locale = i.locale;
  }

  static void changeDefaultLocale(Object? value) {
    Translation.i.defaultLocale = parseLocale(value);
  }

  static void changeSupportedLocales(Iterable value) {
    Translation.i.supportedLocales = value;
  }

  static void selectLocale(BuildContext context, [String? reason]) async {
    try {
      if (i.delegate == null) return null;
      final locale = await i.delegate!.select(context, reason);
      if (locale == null) return null;
      changeLocale(locale);
    } catch (msg) {
      i.log(msg);
    }
  }

  static Future<Locale?> showLocales(
    BuildContext context, [
    String? reason,
  ]) async {
    try {
      if (i.delegate == null) return null;
      return i.delegate!.select(context, reason);
    } catch (msg) {
      i.log(msg);
      return null;
    }
  }

  // ---------------------------------------------------------------------------
  // FINAL PART
  // ---------------------------------------------------------------------------

  Object? _f(Map data, bool translate) {
    String? code = locale.toString();
    if (data.containsKey(code)) return data[code];

    code = locale.languageCode;
    if (data.containsKey(code)) return data[code];

    if (translate) return null;

    code = fallbackLocale.toString();
    if (data.containsKey(code)) return data[code];

    code = fallbackLocale.languageCode;
    if (data.containsKey(code)) return data[code];

    return null;
  }

  Object? _l({String? path, bool? translate}) {
    path ??= _defaultPath;
    final data = props[path];
    if (data is! Map) return data;
    final ld = _f(data, translate ?? false);
    if (ld is Map && ld.isNotEmpty) return ld;
    if (ld is List && ld.isNotEmpty) return ld;
    return null;
  }

  String separator = ":";

  Object? _find(
    String key, {
    String? name,
    String? path,
    bool? applyTranslator,
  }) {
    key = name == null || name.isEmpty ? key : "$name$separator$key";
    Object? data = _l(path: path, translate: applyTranslator);
    if (data is! Map) return null;
    if (data.containsKey(key)) return data[key];
    return data.read(key, separator: separator);
  }

  String _ln(String value, {bool applyRtl = true}) {
    if (!RegExp(r'\d').hasMatch(value)) return value;

    String digits = kDigits[languageCode] ?? "0123456789";

    Map<String, String> mDigits = {
      '0': digits[0],
      '1': digits[1],
      '2': digits[2],
      '3': digits[3],
      '4': digits[4],
      '5': digits[5],
      '6': digits[6],
      '7': digits[7],
      '8': digits[8],
      '9': digits[9],
    };

    final words = RegExp(r'\d+|\D+').allMatches(value).map((m) {
      return m.group(0);
    }).whereType<String>();

    final output = words.map((e) {
      if (!RegExp(r'^\d+$').hasMatch(e)) return e;
      String digits = e.replaceAllMapped(RegExp(r'\d'), (m) {
        return mDigits[m.group(0)] ?? '';
      });
      if (applyRtl && digits.length > 1 && textDirection == TextDirection.rtl) {
        return digits.split('').reversed.join();
      }
      return digits;
    });

    return output.join();
  }

  bool get isAutoTranslatedMode {
    if (!autoTranslateEnable || _translator == null) return false;
    if (languageCode == fallbackLocale.languageCode) return false;
    return true;
  }

  Object? _tr(
    Object? value,
    bool enabled, {
    List<String> autoTranslatorFields = const [],
    String? key,
  }) {
    if (value == null) return value;
    if (!isAutoTranslatedMode || !enabled) return value;
    if (value is String) {
      if (value.isEmpty) return value;
      if (key != null &&
          autoTranslatorFields.isNotEmpty &&
          !autoTranslatorFields.contains(key)) {
        return value;
      }
      return _translator!.tr(value);
    }
    if (value is Iterable) {
      if (value.isEmpty) return value;
      final x = value.map((e) {
        return _tr(e, enabled, autoTranslatorFields: autoTranslatorFields);
      });
      if (value is Set) return x.toSet();
      return value.toList();
    }
    if (value is Map) {
      if (value.isEmpty) return value;
      return value.map((k, v) {
        return MapEntry(
          k,
          _tr(
            v,
            enabled,
            autoTranslatorFields: autoTranslatorFields,
            key: k.toString(),
          ),
        );
      });
    }
    return value;
  }

  Object? _trx(
    String key, {
    String? name,
    Object? defaultValue,
    bool applyTranslator = false,
    List<String> autoTranslatorFields = const [],
  }) {
    Object? data = _find(key, name: name, applyTranslator: applyTranslator);
    if (data != null) return data;
    data ??= defaultValue;
    if (!isAutoTranslatedMode) return data;
    if (data is String) {
      if (data.isEmpty) return data;
      return _tr(
        data,
        applyTranslator,
        autoTranslatorFields: autoTranslatorFields,
      );
    }
    if (data is Map) {
      if (data.isEmpty) return data;
      return data.map((k, v) {
        return MapEntry(
          k,
          _tr(
            v,
            applyTranslator,
            autoTranslatorFields: autoTranslatorFields,
            key: k,
          ),
        );
      });
    }
    if (data is Iterable) {
      if (data.isEmpty) return data;
      return data.map((e) {
        return _tr(
          e,
          applyTranslator,
          autoTranslatorFields: autoTranslatorFields,
        );
      });
    }
    return data;
  }

  String _lt(
    String key, {
    String? name,
    String? defaultValue,
    bool applyNumber = false,
    bool applyRtl = false,
    bool applyTranslator = false,
    String Function(String)? replace,
    Map<String, Object?>? args,
  }) {
    Object? value = _find(key, name: name, applyTranslator: applyTranslator);
    applyTranslator = applyTranslator && value == null && defaultValue != null;
    if (value is! String) value = defaultValue ?? key;
    if (args != null) value = value.replace(args);
    if (replace != null) value = replace(value);
    if (applyTranslator) {
      final x = _tr(value, true);
      if (x is String) value = x;
    }
    if (applyNumber) value = _ln(value, applyRtl: applyRtl);
    return value;
  }

  Iterable? _lts(
    String key, {
    String? name,
    List? defaultValue,
    bool applyTranslator = false,
    List<String> autoTranslatorFields = const [],
  }) {
    Object? data = _trx(
      key,
      name: name,
      defaultValue: defaultValue,
      applyTranslator: applyTranslator,
      autoTranslatorFields: autoTranslatorFields,
    );
    if (data is! Iterable) return defaultValue ?? [];
    return data;
  }

  static String trNum(String value, {bool applyRtl = false}) {
    return i._ln(value, applyRtl: applyRtl);
  }

  /// ```
  /// final inp1 = "There {NUMBER > 1 ? \"are NUMBER items\" : \"is an item\"} in stock";
  /// Translation.lt("key", defaultValue: inp1, args: {'NUMBER': 1}); // There is an item in stock
  /// Translation.lt("key", defaultValue: inp1, args: {'NUMBER': 2}); // There are 2 items in stock
  ///
  /// final inp2 = "Status: {STATUS == active ? \"activated!\" : \"canceled!\"}";
  /// Translation.lt("key", defaultValue: inp2, args: {'STATUS': "active"}); // Status: activated!
  /// Translation.lt("key", defaultValue: inp2, args: {'STATUS': "inactive"}); // Status: canceled!
  ///
  /// final inp3 = "Status: {IS_ACTIVATED ? \"activated!\" : \"inactivated!\"}";
  /// Translation.lt("key", defaultValue: inp3, args: {'IS_ACTIVATED': true}); // Status: activated!
  /// Translation.lt("key", defaultValue: inp3, args: {'IS_ACTIVATED': false}); // Status: inactivated!
  ///
  /// final inp4 = "Last seen: {TIME: {a:now, b:3 min ago}}";
  /// Translation.lt("key", defaultValue: inp4, args: {"TIME": "a"}); // Last seen: now
  /// Translation.lt("key", defaultValue: inp4, args: {"TIME": "b"}); // Last seen: 3 min ago
  ///```
  static String localize(
    String key, {
    String? name,
    String? defaultValue,
    bool applyNumber = false,
    bool applyRtl = false,
    bool applyTranslator = false,
    String Function(String)? replace,
    Map<String, Object?>? args,
  }) {
    return i._lt(
      key,
      name: name,
      defaultValue: defaultValue,
      applyNumber: applyNumber,
      applyTranslator: applyTranslator,
      applyRtl: applyRtl,
      replace: replace,
      args: args,
    );
  }

  static List<String> localizes(
    String key, {
    String? name,
    List<String>? defaultValue,
    bool applyNumber = false,
    bool applyRtl = false,
    bool applyTranslator = false,
    String Function(String)? replace,
    Map<String, Object?>? args,
  }) {
    Iterable<String>? value = i
        ._lts(
          key,
          name: name,
          defaultValue: defaultValue,
          applyTranslator: applyTranslator,
        )
        ?.whereType<String>();
    if (value == null || value.isEmpty) value = defaultValue ?? [];
    if (args != null) value = value.map((e) => e.replace(args));
    if (replace != null) value = value.map(replace);
    if (applyNumber) value = value.map((e) => i._ln(e, applyRtl: applyRtl));
    return value.toList();
  }

  static T? get<T extends Object?>({
    String? key,
    String? path,
    String? name,
    Object? defaultValue,
    bool applyTranslator = false,
    List<String> autoTranslatorFields = const [],
    T? Function(Object?)? parser,
  }) {
    Object? localed;
    if ((key ?? '').isNotEmpty) {
      localed = i._trx(
        key!,
        name: name,
        defaultValue: defaultValue,
        applyTranslator: applyTranslator,
        autoTranslatorFields: autoTranslatorFields,
      );
      applyTranslator = applyTranslator && localed == null;
      localed ??= i._l(path: path, translate: applyTranslator);
    } else {
      localed = i._l(path: path, translate: applyTranslator);
    }
    if (localed is! Map && localed is! Iterable && localed is T) return localed;
    if (localed == null) {
      if (defaultValue is T) return defaultValue;
      localed = defaultValue;
    }
    if (applyTranslator) {
      localed = i._tr(
        localed,
        true,
        autoTranslatorFields: autoTranslatorFields,
      );
    }
    if (localed is T) return localed;
    if (parser != null) return parser(localed);
    return null;
  }

  static List<T> gets<T extends Object?>({
    String? key,
    String? path,
    String? name,
    List<T>? defaultValue,
    bool applyTranslator = false,
    List<String> autoTranslatorFields = const [],
    T? Function(Object?)? parser,
  }) {
    Object? localed;
    if ((key ?? '').isNotEmpty) {
      localed = i._trx(
        key!,
        name: name,
        defaultValue: defaultValue,
        applyTranslator: applyTranslator,
        autoTranslatorFields: autoTranslatorFields,
      );
      applyTranslator = applyTranslator && localed == null;
      localed ??= i._l(path: path, translate: applyTranslator);
    } else {
      localed = i._l(path: path, translate: applyTranslator);
    }
    if (localed is Iterable &&
        localed.every((e) {
          return e is T && e is! Map && e is! List<Map>;
        })) {
      return localed.whereType<T>().toList();
    }
    if (localed == null) {
      if (defaultValue != null) return defaultValue;
      localed = defaultValue;
    }
    if (applyTranslator) {
      localed = i._tr(
        localed,
        true,
        autoTranslatorFields: autoTranslatorFields,
      );
    }
    if (localed is! Iterable) return defaultValue ?? [];
    final parsed = localed.map((e) {
      if (e is T) return e;
      if (parser != null) return parser(e);
      return null;
    });
    final filtered = parsed.whereType<T>().toList();
    return filtered;
  }

  @override
  void dispose() {
    _translator?.dispose();
    super.dispose();
  }
}

extension TranslationStringHelper on String {
  String get tr => trWithOption();

  String trWithOption({
    String? name,
    String? defaultValue,
    String Function(String)? replace,
    bool applyNumber = false,
    bool applyRtl = false,
    bool applyTranslator = false,
  }) {
    return Translation.localize(
      this,
      name: name,
      defaultValue: defaultValue,
      replace: replace,
      applyNumber: applyNumber,
      applyRtl: applyRtl,
      applyTranslator: applyTranslator,
    );
  }
}

extension TranslationNumberHelper on num {
  String get trNumber => trNumWithOption();

  String trNumWithOption({bool applyRtl = true}) {
    return Translation.trNum(toString(), applyRtl: applyRtl);
  }
}

mixin TranslationMixin<S extends StatefulWidget> on State<S> {
  String get name;

  bool get translationAutoMode => true;

  bool get translationChangedMode => true;

  Locale get locale => Translation.i.locale;

  String get languageCode => Translation.languageCode;

  TextDirection get textDirection => Translation.textDirection;

  List<Locale> get supportedLocales => List.of(Translation.i.supportedLocales);

  void changeLocale(Locale? value) => Translation.changeLocale(value);

  void selectLocale(BuildContext context, [String? reason]) {
    Translation.selectLocale(context, reason);
  }

  String trNum(String value, {bool applyRtl = true}) {
    return Translation.trNum(value, applyRtl: applyRtl);
  }

  String translate(
    String key, {
    String? defaultValue,
    String Function(String)? replace,
    bool applyNumber = false,
    bool applyTranslator = true,
    bool applyRtl = false,
    Map<String, Object?>? args,
  }) {
    return Translation.localize(
      key,
      name: name,
      defaultValue: defaultValue,
      replace: replace,
      applyNumber: applyNumber,
      applyRtl: applyRtl,
      applyTranslator: applyTranslator,
      args: args,
    );
  }

  String localize(
    String key, {
    String? defaultValue,
    String Function(String)? replace,
    bool applyNumber = false,
    bool applyTranslator = false,
    bool applyRtl = false,
    Map<String, Object?>? args,
  }) {
    return Translation.localize(
      key,
      name: name,
      defaultValue: defaultValue,
      replace: replace,
      applyNumber: applyNumber,
      applyRtl: applyRtl,
      applyTranslator: applyTranslator,
      args: args,
    );
  }

  List<String> localizes(
    String key, {
    List<String>? defaultValue,
    String Function(String)? replace,
    bool applyNumber = false,
    bool applyRtl = false,
    bool applyTranslator = false,
    Map<String, Object?>? args,
  }) {
    return Translation.localizes(
      key,
      name: name,
      defaultValue: defaultValue,
      replace: replace,
      applyNumber: applyNumber,
      applyTranslator: applyTranslator,
      applyRtl: applyRtl,
      args: args,
    );
  }

  E? get<E extends Object?>({
    String? key,
    String? path,
    E? defaultValue,
    E? Function(Object?)? parser,
    bool applyTranslator = false,
    List<String> autoTranslatorFields = const [],
  }) {
    return Translation.get(
      key: key,
      path: path,
      name: name,
      defaultValue: defaultValue,
      parser: parser,
      applyTranslator: applyTranslator,
      autoTranslatorFields: autoTranslatorFields,
    );
  }

  List<E> gets<E extends Object?>({
    String? key,
    String? path,
    List<E>? defaultValue,
    bool applyTranslator = false,
    E? Function(Object?)? parser,
    List<String> autoTranslatorFields = const [],
  }) {
    return Translation.gets(
      key: key,
      path: path,
      name: name,
      defaultValue: defaultValue,
      applyTranslator: applyTranslator,
      autoTranslatorFields: autoTranslatorFields,
      parser: parser,
    );
  }

  void translationChanged() {
    if (!mounted) return;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    if (translationAutoMode) {
      Translation.i._translator?.addListener(translationChanged);
    }
    if (translationChangedMode) {
      Translation.i.addListener(translationChanged);
    }
  }

  @override
  void dispose() {
    if (translationAutoMode) {
      Translation.i._translator?.removeListener(translationChanged);
    }
    if (translationChangedMode) {
      Translation.i.removeListener(translationChanged);
    }
    super.dispose();
  }
}

class TranslationProvider extends StatefulWidget {
  final Object? defaultLocale;
  final Iterable supportedLocales;
  final bool connection;
  final bool listening;
  final bool notifiable;
  final bool showLogs;
  final Set<String>? paths;
  final TranslationDelegate? delegate;
  final Widget child;
  final VoidCallback? onReady;

  const TranslationProvider({
    super.key,
    this.delegate,
    this.defaultLocale,
    this.connection = false,
    this.listening = false,
    this.notifiable = false,
    this.showLogs = false,
    this.supportedLocales = const [],
    this.paths,
    this.onReady,
    required this.child,
  });

  @override
  State<TranslationProvider> createState() => _TranslationProviderState();
}

class _TranslationProviderState extends State<TranslationProvider>
    with WidgetsBindingObserver {
  void changed() {
    if (!mounted) return;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Translation.init(
      connected: widget.connection,
      showLogs: widget.showLogs,
      listening: widget.listening,
      paths: widget.paths,
      delegate: widget.delegate,
      defaultLocale: widget.defaultLocale ??
          WidgetsBinding.instance.platformDispatcher.locales.firstOrNull,
      supportedLocales: widget.supportedLocales,
      onReady: widget.onReady,
    );
    if (widget.notifiable) {
      Translation.i.addListener(changed);
      Translation.i._translator?.addListener(changed);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (widget.notifiable) {
      Translation.i.removeListener(changed);
      Translation.i._translator?.removeListener(changed);
    }
    Translation.i.dispose();
    super.dispose();
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    super.didChangeLocales(locales);
    final currentLocale = locales?.firstOrNull;
    Translation.changeLocale(currentLocale);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

enum TranslationButtonType {
  flagOnly,
  nameOnly,
  nameInEnOnly,
  codeOnly,
  flagAndName,
  flagAndNameInEn,
  flagAndCode;

  String _(Language language) {
    final code = language.code.split("_").first.toUpperCase();
    final name = language.nameInNative ?? language.name ?? code;
    final nameInEn = language.name ?? language.nameInNative ?? code;
    final flag = kCountryFlags[language.countryCode] ?? kCountryFlags["US"]!;
    return switch (this) {
      TranslationButtonType.nameOnly => name,
      TranslationButtonType.nameInEnOnly => nameInEn,
      TranslationButtonType.codeOnly => code,
      TranslationButtonType.flagOnly => flag,
      TranslationButtonType.flagAndName => "$flag  $name",
      TranslationButtonType.flagAndNameInEn => "$flag  $nameInEn",
      TranslationButtonType.flagAndCode => "$flag  $code",
    };
  }

  String text(
    Locale locale, {
    bool markAsDefault = false,
    TextureIcons selectedIcon = TextureIcons.none,
  }) {
    String value = _(Language.fromCode(
      locale.languageCode,
      locale.countryCode,
    ));
    if (markAsDefault && Translation.i.defaultLocale == locale) {
      value = "$value (Default)";
    }
    if (!selectedIcon.isNone && Translation.i.locale == locale) {
      value = "$value ${selectedIcon.icon}";
    }
    return value;
  }
}

extension TranslationLocale on Locale {
  String get formatedLanguageCode {
    String l = languageCode;
    if (l == "zh") {
      String? c = countryCode?.toUpperCase();
      if (c == null || c.isEmpty) c = "CN";
      l = "${l}_$c";
    }
    return l;
  }

  String get text => textWithOptions();

  String textWithOptions({
    TranslationButtonType type = TranslationButtonType.flagAndNameInEn,
    bool markAsDefault = false,
    TextureIcons selectedIcon = TextureIcons.none,
  }) {
    return type.text(
      this,
      markAsDefault: markAsDefault,
      selectedIcon: selectedIcon,
    );
  }
}

class TranslationButton extends StatefulWidget {
  final String reason;
  final bool ignorePointer;
  final EdgeInsets? padding;
  final BoxDecoration? decoration;
  final TranslationButtonType type;
  final bool markAsDefault;
  final TextStyle? textStyle;
  final Widget Function(BuildContext context, String text)? builder;
  final ValueChanged<Locale>? onChanged;

  const TranslationButton({
    super.key,
    this.reason = "bottom_sheet",
    this.ignorePointer = false,
    this.decoration,
    this.padding,
    this.type = TranslationButtonType.flagAndCode,
    this.markAsDefault = false,
    this.textStyle,
    this.builder,
    this.onChanged,
  });

  @override
  State<TranslationButton> createState() => _TranslationButtonState();
}

class _TranslationButtonState extends State<TranslationButton>
    with TranslationMixin {
  @override
  void translationChanged() {
    super.translationChanged();
    if (widget.onChanged != null) widget.onChanged!(locale);
  }

  @override
  Widget build(BuildContext context) {
    final text = widget.type.text(
      locale,
      markAsDefault: widget.markAsDefault,
    );
    Widget child = Container(
      decoration: widget.decoration ?? BoxDecoration(color: Colors.transparent),
      padding: widget.padding,
      child: Text(
        text,
        textDirection: textDirection,
        style: widget.textStyle,
      ),
    );
    if (widget.builder != null) {
      child = widget.builder!(context, text);
    }
    if (!widget.ignorePointer) {
      return GestureDetector(
        onTap: () => Translation.selectLocale(context),
        child: child,
      );
    }
    return child;
  }

  @override
  String get name => "translation:button";
}
