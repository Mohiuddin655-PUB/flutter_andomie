import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart' hide Translation;

class ITranslationDelegate extends TranslationDelegate {
  @override
  Future<Object?> get defaultLocale {
    return SharedPreferences.getInstance().then((instance) {
      return instance.getString("locale");
    });
  }

  /// Retrieves cached translation data for the given [name] and [path].
  /// Returns a `Map` if found, otherwise `null`.
  @override
  Future<Map?> cache(String name, String path) async {
    final shared = await SharedPreferences.getInstance();
    final source = shared.getString("$name/$path");
    if (source == null || source.isEmpty) return null;
    return jsonDecode(source);
  }

  /// Called when the locale is changed.
  /// Can be used to perform any logic needed after locale update (e.g. logging or reloading).
  @override
  Future<void> changed(Locale locale) async {
    SharedPreferences.getInstance().then((instance) {
      instance.setString("locale", locale.toString());
    });
  }

  /// Fetches translation data from the source specified by [name] and [path].
  /// Typically used to load new translations from assets or remote APIs.
  @override
  Future<Map?> fetch(String name, String path) async {
    // apply cloud localization logic to control cloud based localization
    // like firebase, restapi
    return null;
  }

  @override
  Stream<Map?> listen(String name, String path) {
    // apply cloud localization logic to control cloud based localization
    // like firebase, restapi
    return Stream.value(null);
  }

  /// Saves the provided translation [data] to a storage location defined by [name] and [path].
  /// Returns `true` if the data is saved successfully, otherwise `false`.
  @override
  Future<bool> save(String name, String path, Map? data) async {
    final shared = await SharedPreferences.getInstance();
    return shared.setString("$name/$path", jsonEncode(data));
  }

  /// Lets the user select a new [Locale], optionally passing a [reason] for the change.
  /// Returns the selected locale, or `null` if no change occurred.
  @override
  Future<Locale?> select(BuildContext context, String? reason) async {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            width: double.infinity,
            height: double.infinity,
            child: ListView(
              children: [
                Text(Translation.localize("title",
                    name: "dialog:language",
                    defaultValue: "Select your language")),
                ...kFilteredLocales.map((e) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(context, e);
                    },
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.only(
                        left: 24,
                        top: 16,
                        bottom: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Stack(
                        children: [
                          Text(e.textWithOptions(
                            selectedIcon: TextureIcons.checkMarkBoxGreen,
                            markAsDefault: true,
                          )),
                          if (!Translation.i.supportedLocales.contains(e))
                            const Positioned(
                              right: 24,
                              child: Icon(
                                Icons.download,
                                color: Colors.grey,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    Translation.localize("dialog:button:negative",
                        defaultValue: "Cancel"),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class IAutoTranslateDelegate extends TranslatorDelegate {
  @override
  Future<String?> cache() async {
    final shared = await SharedPreferences.getInstance();
    return shared.getString("auto_translations_cache");
  }

  @override
  void save(String value) async {
    final shared = await SharedPreferences.getInstance();
    await shared.setString("auto_translations_cache", value);
  }

  @override
  void translated(String key, String value) async {
    final shared = await SharedPreferences.getInstance();
    await shared.setString("auto_translations_cache", jsonEncode(value));
  }

  @override
  Future<String> translate(String text, Locale locale) async {
    try {
      final x = await text.translate(
        to: locale.formatedLanguageCode.replaceAll("_", "-").toLowerCase(),
      );
      return x.text;
    } catch (_) {
      return text;
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Translation.init(
    connected: true,
    delegate: ITranslationDelegate(),
    translator: IAutoTranslateDelegate(),
    listening: true,
    autoTranslateMode: true,
    defaultLocale: const Locale("en", "US"),
    defaultPath: "localizations",
    fallbackLocale: const Locale("en", "US"),
    locale: const Locale("en", "US"),
    name: "translations",
    onReady: () {
      // apply if need
    },
    paths: {
      "animations",
      "hourly_notifications",
    },
    showLogs: true,
    supportedLocales: ["en_US", "zh_CN"],
  );
  runApp(const TranslationsApp());
}

class TranslationsApp extends StatelessWidget {
  const TranslationsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TranslationMixin {
  bool isLoading = false;

  int total = 3;

  int count = 0;

  void _incrementCounter() async {
    if (count >= total) {
      setState(() {
        isLoading = true;
      });
      await Future.delayed(const Duration(milliseconds: 150));
      setState(() {
        isLoading = false;
        count = 0;
      });
    } else {
      setState(() {
        count++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String title = localize("title");
    String status = localize(
      "goals_status",
      applyNumber: true,
      args: {"IS_LOADING": isLoading, "COUNT": count},
    );

    String button = localize(
      "goals_button",
      applyNumber: true,
      args: {"COUNT": count, "TOTAL": total},
    );

    List<String> goals = localizes("goals");

    Map? nav = get(
      path: "animations",
      autoTranslatorFields: ["name"],
    );

    List<Map> navigation = gets(
      key: "navigation",
      autoTranslatorFields: ["label"],
    );

    return DefaultTabController(
      length: goals.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          bottom: TabBar(tabs: goals.map((e) => Tab(text: e)).toList()),
        ),
        floatingActionButton: const TranslationButton(
          type: TranslationButtonType.flagAndNameInEn,
          markAsDefault: true,
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                count.trNumber,
                style: const TextStyle(fontSize: 50),
              ),
              const SizedBox(height: 24),
              Text(
                status,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 24),
              Text(
                nav.toString(),
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  _incrementCounter();
                },
                child: Text(button),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: navigation.map(
            (nav) {
              return BottomNavigationBarItem(
                icon: Icon({
                  "home": Icons.home,
                  "history": Icons.history,
                  "settings": Icons.settings,
                }[nav["icon"]]),
                label: nav["label"],
              );
            },
          ).toList(),
        ),
      ),
    );
  }

  @override
  String get name => "main";
}
