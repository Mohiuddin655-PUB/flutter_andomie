import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../contents/country_flags.dart';
import '../contents/language_numerical_digits.dart';
import '../contents/rtl_directional_languages.dart';
import '../models/language.dart';
import '../utils/text_replacer.dart';
import 'internet.dart';

const kDefaultTranslationName = "translations";
const kDefaultTranslationPath = "localizations";

abstract class TranslationDelegate {
  const TranslationDelegate();

  Set<String> get paths => {};

  Future<String> asset(String path) async {
    return rootBundle.loadString("assets/$path.json");
  }

  Future<Map?> cache(String path);

  Future<void> changed(Locale locale);

  Future<bool> save(String path, Map? data);

  Future<Map?> fetch(String path);

  Future<Locale?> select(BuildContext context, String? reason);
}

class _Delegate extends LocalizationsDelegate<Translation> {
  @override
  bool isSupported(Locale locale) {
    return Translation.i.supportedLocales.contains(locale);
  }

  @override
  Future<Translation> load(Locale locale) async {
    Translation.i.locale = locale;
    Translation.i._loads(fetch: false);
    return Translation.i;
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<Translation> old) => false;
}

class Translation extends ChangeNotifier {
  Translation._();

  static Translation? _i;

  static Translation get i => _i ??= Translation._();

  static LocalizationsDelegate<Translation> get delegate => _Delegate();

  // ---------------------------------------------------------------------------
  // INITIAL PART
  // ---------------------------------------------------------------------------

  final Map _props = {};
  Iterable<String> _paths = {};
  bool _showLogs = false;
  String _name = kDefaultTranslationName;
  String _defaultPath = kDefaultTranslationPath;
  TranslationDelegate? _delegate;

  void _log(msg) {
    if (!i._showLogs) return;
    log(msg.toString(), name: "$Translation".toUpperCase());
  }

  Future<void> _load(
    String path, {
    bool refresh = false,
    bool fetch = true,
  }) async {
    try {
      if (!refresh && fetch) await _fetch(path);
      Map data = {};
      final local = _props[path];
      if (local is Map) data.addAll(local);
      if (!refresh) {
        Map? asset = await _assets(path);
        if (asset != null) data.addAll(asset);
      }
      Map? cache = await _cached(path);
      if (cache != null) data.addAll(cache);
      if (data.isEmpty) {
        _props.remove(path);
        return;
      }
      _props[path] = data;
    } catch (msg) {
      _log(msg);
    }
  }

  Future<void> _loads({bool fetch = true}) async {
    try {
      await Future.wait(_paths.map((e) => _load(e, fetch: fetch)));
    } catch (msg) {
      _log(msg);
    }
  }

  static Future<void> init({
    bool showLogs = false,
    Map? initial,
    String name = kDefaultTranslationName,
    String defaultPath = kDefaultTranslationPath,
    Set<String>? paths,
    Object? defaultLocale,
    Iterable? supportedLocales,
    TranslationDelegate? delegate,
  }) async {
    paths ??= {};
    if (delegate != null && delegate.paths.isNotEmpty) {
      paths.addAll(delegate.paths);
    }
    paths.add("$name/$defaultPath");
    i._paths = paths;
    i._showLogs = showLogs;
    i._name = name;
    i._defaultPath = defaultPath;
    i._delegate = delegate;
    i.defaultLocaleOrNull = parseLocale(defaultLocale);
    i._supportedLocales = parseLocales(supportedLocales);
    await i._loads();
  }

  // ---------------------------------------------------------------------------
  // LOCALE PART
  // ---------------------------------------------------------------------------

  Locale? localeOrNull;

  Locale get locale => localeOrNull ?? defaultLocale;

  set locale(Locale? value) {
    if (value == null) return;
    if (value.toString() == localeOrNull.toString()) return;
    localeOrNull = value;
    notifyListeners();
    if (_delegate == null) return;
    _delegate!.changed(value);
  }

  Locale? defaultLocaleOrNull;

  Locale get defaultLocale {
    return defaultLocaleOrNull ?? Locale("en", "US");
  }

  set defaultLocale(Locale? value) {
    if (value == null) return;
    if (value.toString() == defaultLocaleOrNull.toString()) return;
    defaultLocaleOrNull = value;
    notifyListeners();
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
    final locale = i.localeOrNull ?? i.defaultLocale;
    String l = locale.languageCode;
    if (l == "zh") {
      String? c = locale.countryCode?.toUpperCase();
      if (c == null || c.isEmpty) c = "CN";
      l = "${l}_$c";
    }
    return l;
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
  }

  static void changeDefaultLocale(Object? value) {
    Translation.i.defaultLocale = parseLocale(value);
  }

  static void changeSupportedLocales(Iterable value) {
    Translation.i.supportedLocales = value;
  }

  static void selectLocale(BuildContext context, [String? reason]) async {
    try {
      if (i._delegate == null) return null;
      final locale = await i._delegate!.select(context, reason);
      if (locale == null) return null;
      changeLocale(locale);
    } catch (msg) {
      i._log(msg);
    }
  }

  static Future<Locale?> showLocales(
    BuildContext context, [
    String? reason,
  ]) async {
    try {
      if (i._delegate == null) return null;
      return i._delegate!.select(context, reason);
    } catch (msg) {
      i._log(msg);
      return null;
    }
  }

  // ---------------------------------------------------------------------------
  // ASSET PART
  // ---------------------------------------------------------------------------

  Future<Map?> _assets(String path) async {
    try {
      String data;
      if (_delegate != null) {
        data = await _delegate!.asset(path);
      } else {
        data = await rootBundle.loadString("assets/$path.json");
      }
      if (data.isEmpty) return null;
      final decoded = jsonDecode(data);
      if (decoded is! Map) return null;
      return decoded;
    } catch (msg) {
      _log(msg);
      return null;
    }
  }

  // ---------------------------------------------------------------------------
  // CACHE PART
  // ---------------------------------------------------------------------------

  Future<Map?> _cached(String path) async {
    if (_delegate == null) return null;
    try {
      Map? cache = await _delegate!.cache("--tr905849-$path");
      return cache;
    } catch (msg) {
      _log(msg);
      return null;
    }
  }

  Future<bool> _save(String path, Map? data) async {
    if (_delegate == null) return false;
    try {
      final feedback = await _delegate!.save("--tr905849-$path", data);
      return feedback;
    } catch (msg) {
      _log(msg);
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // REMOTE PART
  // ---------------------------------------------------------------------------

  Future<void> _fetch(String path) async {
    if (_delegate == null) return;
    try {
      final connected = await Internet.connected;
      if (!connected) return;
      final data = await _delegate!.fetch(path);
      await _save(path, data);
    } catch (msg) {
      _log(msg);
    }
  }

  // ---------------------------------------------------------------------------
  // FINAL PART
  // ---------------------------------------------------------------------------

  Object? _filter(Map data) {
    String? code = locale.toString();
    if (data.containsKey(code)) return data[code];

    code = defaultLocale.toString();
    if (data.containsKey(code)) return data[code];

    code = locale.languageCode;
    if (data.containsKey(code)) return data[code];

    code = defaultLocale.languageCode;
    if (data.containsKey(code)) return data[code];

    return null;
  }

  Object? _t([String? path]) {
    path ??= "$_name/$_defaultPath";
    final data = _props[path];
    if (data is! Map) return data;
    final ld = _filter(data);
    if (ld is Map && ld.isNotEmpty) return ld;
    if (ld is List && ld.isNotEmpty) return ld;
    return data;
  }

  Object? _tr(
    String key, {
    String? name,
    Object? defaultValue,
  }) {
    Object? data = _t();
    if (data is! Map) return defaultValue ?? key;
    if (name != null && name.isNotEmpty) {
      Object? x = data[name];
      if (x is Map) x = x[key];
      if (x is String) {
        data = x;
      } else {
        data = data[key];
      }
    } else {
      data = data[key];
    }
    return data;
  }

  String _trN(String value, {bool applyRtl = true}) {
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

  Iterable? _trs(
    String key, {
    String? name,
    List? defaultValue,
  }) {
    Object? data = _t();
    if (data is! Map) return defaultValue;
    if (name != null && name.isNotEmpty) {
      Object? x = data[name];
      if (x is Map) x = x[key];
      if (x is Iterable) {
        data = x;
      } else {
        data = data[key];
      }
    } else {
      data = data[key];
    }
    if (data is! Iterable) return defaultValue;
    return data;
  }

  static String trNum(String value, {bool applyRtl = false}) {
    return i._trN(value, applyRtl: applyRtl);
  }

  /// ```
  /// final inp1 = "There {NUMBER > 1 ? \"are NUMBER items\" : \"is an item\"} in stock";
  /// Translation.localize("key", defaultValue: inp1, args: {'NUMBER': 1}); // There is an item in stock
  /// Translation.localize("key", defaultValue: inp1, args: {'NUMBER': 2}); // There are 2 items in stock
  ///
  /// final inp2 = "Status: {STATUS == active ? \"activated!\" : \"canceled!\"}";
  /// Translation.localize("key", defaultValue: inp2, args: {'STATUS': "active"}); // Status: activated!
  /// Translation.localize("key", defaultValue: inp2, args: {'STATUS': "inactive"}); // Status: canceled!
  ///
  /// final inp3 = "Status: {IS_ACTIVATED ? \"activated!\" : \"inactivated!\"}";
  /// Translation.localize("key", defaultValue: inp3, args: {'IS_ACTIVATED': true}); // Status: activated!
  /// Translation.localize("key", defaultValue: inp3, args: {'IS_ACTIVATED': false}); // Status: inactivated!
  ///
  /// final inp4 = "Last seen: {TIME: {a:now, b:3 min ago}}";
  /// Translation.localize("key", defaultValue: inp4, args: {"TIME": "a"}); // Last seen: now
  /// Translation.localize("key", defaultValue: inp4, args: {"TIME": "b"}); // Last seen: 3 min ago
  ///```
  static String localize(
    String key, {
    String? name,
    String? defaultValue,
    bool applyNumber = false,
    bool applyRtl = false,
    String Function(String)? replace,
    Map<String, Object?>? args,
  }) {
    Object? value = i._tr(key, name: name, defaultValue: defaultValue);
    if (value is! String) value = defaultValue ?? key;
    if (applyNumber) value = i._trN(value, applyRtl: applyRtl);
    if (args != null) value = value.replace(args);
    if (replace != null) value = replace(value);
    return value;
  }

  static List<String> localizes(
    String key, {
    String? name,
    List<String>? defaultValue,
    bool applyNumber = false,
    bool applyRtl = false,
    String Function(String)? replace,
    Map<String, Object?>? args,
  }) {
    Iterable<String>? value = i
        ._trs(
          key,
          name: name,
          defaultValue: defaultValue,
        )
        ?.whereType<String>();
    if (value == null || value.isEmpty) value = defaultValue ?? [];
    if (applyNumber) value = value.map((e) => i._trN(e, applyRtl: applyRtl));
    if (args != null) value = value.map((e) => e.replace(args));
    if (replace != null) value = value.map(replace);
    return value.toList();
  }

  static T? get<T extends Object?>({
    String? key,
    String? path,
    String? name,
    T? defaultValue,
    T? Function(Object?)? parser,
  }) {
    Object? localed;
    if ((key ?? '').isNotEmpty) {
      localed = i._tr(key!, name: name, defaultValue: defaultValue);
      localed ??= i._t(path);
    } else {
      localed = i._t(path);
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
    T? Function(Object?)? parser,
  }) {
    Object? localed;
    if ((key ?? '').isNotEmpty) {
      localed = i._trs(key!, name: name, defaultValue: defaultValue);
      localed ??= i._t(path);
    } else {
      localed = i._t(path);
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
}

extension TranslationStringHelper on String {
  String get tr => trWithOption();

  String get trNumber => trNumWithOption();

  String trWithOption({
    String? name,
    String? defaultValue,
    String Function(String)? replace,
    bool applyNumber = false,
    bool applyRtl = false,
  }) {
    return Translation.localize(
      this,
      name: name,
      defaultValue: defaultValue,
      replace: replace,
      applyNumber: applyNumber,
      applyRtl: applyRtl,
    );
  }

  String trNumWithOption({bool applyRtl = true}) {
    return Translation.trNum(this, applyRtl: applyRtl);
  }
}

extension TranslationNumberHelper on num {
  String get tr => trWithOption();

  String get trNumber => trNumWithOption();

  String trWithOption({
    String? name,
    String? defaultValue,
    String Function(String)? replace,
    bool applyNumber = false,
    bool applyRtl = false,
  }) {
    return Translation.localize(
      toString(),
      name: name,
      defaultValue: defaultValue,
      replace: replace,
      applyNumber: applyNumber,
      applyRtl: applyRtl,
    );
  }

  String trNumWithOption({bool applyRtl = true}) {
    return Translation.trNum(toString(), applyRtl: applyRtl);
  }
}

mixin TranslationMixin<S extends StatefulWidget> on State<S> {
  String get name;

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

  String localize(
    String key, {
    String? defaultValue,
    String Function(String)? replace,
    bool applyNumber = false,
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
      args: args,
    );
  }

  List<String> localizes(
    String key, {
    List<String>? defaultValue,
    String Function(String)? replace,
    bool applyNumber = false,
    bool applyRtl = false,
    Map<String, Object?>? args,
  }) {
    return Translation.localizes(
      key,
      name: name,
      defaultValue: defaultValue,
      replace: replace,
      applyNumber: applyNumber,
      applyRtl: applyRtl,
      args: args,
    );
  }

  E? get<E extends Object?>({
    String? key,
    String? path,
    E? defaultValue,
    E? Function(Object?)? parser,
  }) {
    return Translation.get(
      key: key,
      path: path,
      name: name,
      defaultValue: defaultValue,
      parser: parser,
    );
  }

  List<E> gets<E extends Object?>({
    String? key,
    String? path,
    List<E>? defaultValue,
    E? Function(Object?)? parser,
  }) {
    return Translation.gets(
      key: key,
      path: path,
      name: name,
      defaultValue: defaultValue,
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
    if (translationChangedMode) {
      Translation.i.addListener(translationChanged);
    }
  }

  @override
  void dispose() {
    if (translationChangedMode) {
      Translation.i.removeListener(translationChanged);
    }
    super.dispose();
  }
}

class TranslationProvider extends StatefulWidget {
  final Object? defaultLocale;
  final Iterable supportedLocales;
  final Map? initial;
  final bool notifiable;
  final bool showLogs;
  final Set<String>? paths;
  final TranslationDelegate? delegate;
  final Widget child;

  const TranslationProvider({
    super.key,
    this.initial,
    this.delegate,
    this.defaultLocale,
    this.notifiable = false,
    this.showLogs = false,
    this.supportedLocales = const [],
    this.paths,
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
      showLogs: widget.showLogs,
      initial: widget.initial,
      paths: widget.paths,
      delegate: widget.delegate,
      defaultLocale: widget.defaultLocale ??
          WidgetsBinding.instance.platformDispatcher.locales.firstOrNull,
      supportedLocales: widget.supportedLocales,
    );
    if (widget.notifiable) Translation.i.addListener(changed);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (widget.notifiable) Translation.i.removeListener(changed);
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
}

class TranslationButton extends StatefulWidget {
  final String reason;
  final bool ignorePointer;
  final EdgeInsets? padding;
  final BoxDecoration? decoration;
  final TranslationButtonType mode;
  final TextStyle? textStyle;
  final Widget Function(BuildContext context, Widget child)? builder;
  final ValueChanged<Locale>? onChanged;

  const TranslationButton({
    super.key,
    this.reason = "bottom_sheet",
    this.ignorePointer = false,
    this.decoration,
    this.padding,
    this.mode = TranslationButtonType.flagAndCode,
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
    Widget child = Container(
      decoration: widget.decoration ?? BoxDecoration(color: Colors.transparent),
      padding: widget.padding,
      child: Text(
        widget.mode._(Language.fromCode(
          locale.languageCode,
          locale.countryCode,
        )),
        textDirection: textDirection,
        style: widget.textStyle,
      ),
    );
    if (widget.builder != null) {
      child = widget.builder!(context, child);
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
