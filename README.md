# flutter_andomie

Collection of utils with advanced style and controlling system.

### UTILS

#### TRANSLATION
```dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart' hide Translation;

class ITranslationDelegate extends TranslationDelegate {
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
  Future<void> changed(Locale locale) async {}

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
  void translated(TranslationCache value) async {
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
    String title = translate("title", defaultValue: "Counter Game");
    String status = localize(
      "goals_status",
      applyNumber: true,
      applyTranslator: true,
      args: {
        "IS_LOADING": isLoading,
        "COUNT": count,
      },
      defaultValue:
          "{IS_LOADING ? \"Preparing...\" : \"{COUNT > 0 ? \"You have pushed this times\" : \"Game Finished!\"}\"}",
    );

    String button = translate(
      "goals_button",
      args: {
        "COUNT": count,
        "TOTAL": total,
      },
      defaultValue: "{COUNT < TOTAL ? \"Continue\" : \"Finish\"}",
    );

    List<String> goals = localizes(
      "goals",
      applyTranslator: true,
      defaultValue: ["1st Round", "2nd Round", "3rd Round"],
    );

    Map? nav = get(
      key: "animations",
      defaultValue: {
        "basic_hold": {"name": "Basic Hold"},
        "front_clamp": {"name": "Front Clamp"}
      },
      autoTranslatorFields: ["name"],
      applyTranslator: true,
    );

    List<Map> navigation = gets(
      key: "navigation",
      applyTranslator: true,
      autoTranslatorFields: ["label"],
      defaultValue: [
        {"icon": "home", "id": "home", "label": "Home"},
        {"icon": "history", "id": "history", "label": "History"},
        {"icon": "settings", "id": "settings", "label": "Settings"}
      ],
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
```

#### MAP_COMPARISON
```dart
void main() {
  final oldData = {
    "launch_mode": true,
    "secrets": {
      "object": {
        "active": "v1",
        "versions": {
          "v1": {
            "version": "v1",
            "key": "OLD_DOC_KEY",
            "iv": "OLD_DOC_IV",
            "secret": "OLD_DOC_SECRET"
          }
        }
      },
      "password": {
        "active": "v1",
        "versions": {
          "v1": {
            "version": "v1",
            "key": "OLD_PASSWORD_KEY",
            "iv": "OLD_PASSWORD_IV",
            "secret": "OLD_PASSWORD_SECRET"
          }
        }
      }
    },
    "notifications": {
      "status": false,
      "channels": [
        {"id": "old_channel_id", "schedule": 12345}
      ],
      "basics": [
        {"id": "old_notification_id", "channel_id": 42}
      ]
    }
  };

  final newData = {
    "launch_mode": true,
    "secrets": {
      "object": {
        "active": "v1",
        "versions": {
          "v1": {
            "version": "v1",
            "key": "THIS_IS_DOC_KEY",
            "iv": "THIS_IS_DOC_IV",
            "secret": "THIS_IS_DOC_SECRET"
          }
        }
      },
      "password": {
        "active": "v1",
        "versions": {
          "v1": {
            "version": "v1",
            "key": "THIS_IS_PASSWORD_KEY",
            "iv": "THIS_IS_PASSWORD_IV",
            "secret": "THIS_IS_PASSWORD_SECRET"
          }
        }
      }
    },
    "notifications": {
      "status": true,
      "channels": [
        {
          "id": "old_channel_id",
          "schedule": 12345,
        }
      ],
      "basics": [
        {
          "id": "notification_id",
          "channel_id": 95,
        }
      ],
      "randoms": [
        [
          {"id": "notification_id", "channel_id": 474}
        ]
      ]
    }
  };

  // Basic comparison
  final changes = MapComparison.compare(oldData, newData);
  print('Basic changes:');
  print('Added: ${changes['added']}');
  print('Removed: ${changes['removed']}');
  print('Modified: ${changes['modified']}');

  // Detailed path comparison
  final pathChanges = MapComparison.changes(oldData, newData);

  print('\nPath changes: $pathChanges');

  print('\isChanged: ${pathChanges.isChanged("notifications/randoms")}');
  print('\isChanged: ${pathChanges.isChanged("secrets/object/")}');
  print(
      '\isChanged: ${pathChanges.isChanged("secrets/object/versions/v1/iv")}');
  print('\nDetailed changes:');
  print('Added paths:');
  for (final path in pathChanges.added) {
    print('  $path');
  }
  print('Removed paths:');
  for (final path in pathChanges.removed) {
    print('  $path');
  }
  print('Modified paths:');
  for (final path in pathChanges.modified) {
    print('  $path');
  }
}
```

#### TRANSLATOR
```dart
void main() {
  final digits = "1234567890.05";

  // USE CASE 1
  Translator.language = 'bn';
  final a = digits.trNumber;
  print(a); // ১২৩৪৫৬৭৮৯০.০৫

  // USE CASE 2
  final b = digits.translate(language: "ar");
  print(b); // ١٢٣٤٥٦٧٨٩٠.٠٥
}
```

#### ROUTE_MANAGER
```dart
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';

void main() async {
  /// SEPARATOR:
  /// '/'=> home/profile/details
  /// '>'=> home>profile>details
  RouteManager.separator = '/';

  /// FILTER:
  /// filter mode=> //home/profile/details///
  /// normal mode=> home/profile/details
  RouteManager.allowFilter = true;

  /// MULTIPLE:
  /// enabled=> home/details/details/details
  /// disabled=> home/details
  RouteManager.allowMultiple = true;
  // RouteManager.ignorableRoutes = ['/notification']; // OPTIONAL
  // RouteManager.supportedRoutes = ['/home', 'profile']; // OPTIONAL
  // RouteManager.initialRoutes = 'home/'; // OPTIONAL
  RouteManager.listen((value) {
    log("ROUTE_MANAGER: $value");
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: "/main",
      routes: {
        '/main': (context) => const Home(),
        "/details": (context) => const DetailsPage(),
      },
      navigatorObservers: [RouteMonitor()],
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  int currentIndex = 0;

  void _change(int index) {
    final previous = ['home', 'notification', 'profile'][currentIndex];
    final current = ['home', 'notification', 'profile'][index];
    RouteManager.replace(current, previous);
    setState(() => currentIndex = index);
  }

  @override
  void initState() {
    super.initState();
    RouteManager.push("home");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ROUTE MANAGER"),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: _change,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: "Notification",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
      body: IndexedStack(
        index: currentIndex,
        children: List.generate(3, (index) {
          return Center(
            child: Text(
              "TAB-${index + 1}\n${RouteManager.routes}",
              textAlign: TextAlign.center,
            ),
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/details'),
        child: const Icon(Icons.ads_click, color: Colors.white),
      ),
    );
  }
}

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Details Page"),
      ),
      body: Container(
        padding: const EdgeInsets.all(32),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "DETAILS\n${RouteManager.routes}",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/details'),
              child: const Text("See details"),
            ),
          ],
        ),
      ),
    );
  }
}
```

##### SCREEN_SHOTS
[Screen_recording_20241226_032302.webm](https://github.com/user-attachments/assets/664563e0-fc8b-4be7-8595-a1dc329c21e0)


#### LAZY_NOTIFIER
```dart
class LazyNotifierExample extends StatefulWidget {
  const LazyNotifierExample({super.key});

  @override
  State<LazyNotifierExample> createState() => _LazyNotifierExampleState();
}

class _LazyNotifierExampleState extends State<LazyNotifierExample> {
  void _updateCounter() {
    final previousValue = LazyNotifier.value<int>("counter_notifier") ?? 0;
    LazyNotifier.notify("counter_notifier", value: previousValue + 1);
  }

  @override
  void dispose() {
    LazyNotifier.kill("counter_notifier");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lazy Notifier Example"),
      ),
      body: const Center(
        child: CounterWidget(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _updateCounter,
        child: const Icon(Icons.ads_click, color: Colors.white),
      ),
    );
  }
}

class CounterWidget extends StatelessWidget {
  const CounterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LazyNotifier.of("counter_notifier"),
      builder: (context, child) {
        final counter = LazyNotifier.value<int>("counter_notifier");
        return Text(
          counter.toString(),
          style: const TextStyle(
            fontSize: 80,
            fontWeight: FontWeight.bold,
          ),
        );
      },
    );
  }
}
```

#### TEXT_PARSER
```dart
void main() {
  String normalText = "My name is Mr. X. I'm <CUSTOM_TAG_1><CUSTOM_TAG_2>24</CUSTOM_TAG_2></CUSTOM_TAG_1> old.";
  List<SpanText> parsedText = TextParser.parse(normalText);
  print(parsedText); // OUTPUT: [NormalText(text: My name is Mr. X. I'm ), SpannedText(text: 24, types: [CUSTOM_TAG_1, CUSTOM_TAG_2]), NormalText(text:  old.)]
}
```

#### RAPID_CLICK
```dart
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';

class RapidClickTester extends StatefulWidget {
  const RapidClickTester({super.key});

  @override
  State<RapidClickTester> createState() => _RapidClickTesterState();
}

class _RapidClickTesterState extends State<RapidClickTester> {
  int counter = 0;

  void callback(bool rapid) {
    log(rapid ? "RAPID_CLICK" : "NORMAL_CLICK");
    setState(() => counter = RapidClick.count);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          counter.toString(),
          style: const TextStyle(
            fontSize: 80,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => RapidClick.click(callback),
        child: const Icon(Icons.ads_click, color: Colors.white),
      ),
    );
  }
}
```

#### ISOLATION
```dart
void main() async {
  final isolation = Isolation();
  await isolation.initialize();

  for (var i = 0; i < 10; i++) {
    isolation.isolate(_task, i).then((value) {
      print(value);
    });
  }
}

Future<Map> _task(index) async {
  for (var i = 0; i < 10; i++) {
    await Future.delayed(Duration(milliseconds: 10 * index as int));
    print("Task $index: $i");
  }
  return {"data": "Complete this task: $index"};
}
```

#### ORDERED_LIST_SEQUENCE
```dart
class OrderedListView extends StatelessWidget {
  final List<String> items;

  OrderedListView({required this.items, required this.orderedListStyle});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        // Format the index based on the selected ordered list style
        String listPrefix = OrderedListSequence.lowerRoman.sequence(index);

        return ListTile(
          title: Text('$listPrefix) ${items[index]}'),
        );
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: Text('Ordered List View')),
      body: OrderedListView(
        items: ['Item 1', 'Item 2', 'Item 3', 'Item 4'],// Choose the style here
      ),
    ),
  ));
}
```

#### DATA_EXECUTOR

- ExecutedData
    * Represents data with a base and modified state.
    * Provides methods to copy and modify the data.
    * Implements equality and hash code based on the data contents.

- DataExecutor
    * Abstract class extending ValueNotifier to manage ExecutedData.
    * Handles loading, converting, and fetching data.
    * Provides methods to listen for data changes and execute conversions.

```dart
class MyDataExecutor extends DataExecutor<int, String> {
  MyDataExecutor() : super();

  @override
  Future<String> convert(int root) async {
    // Example conversion logic
    return 'Converted $root';
  }

  @override
  Future<Iterable<int>> fetch() async {
    // Example fetch logic
    return [1, 2, 3, 4, 5];
  }
}

void main() {
  // Example implementation of DataExecutor

  final executor = MyDataExecutor();

  // Listening for data changes
  executor.listen((data) {
    print('Data changed: $data');
  });

  // Execute loading and converting data
  executor.load();

  // Only notify listeners mode
  executor.refresh();

  // Re-fetch api data, when complete all data modified then notify all listeners
  executor.refresh(true);

  executor.listen((value) {}); // The listener gives both data (ex. base, modified)
  executor.listenOnlyModified((value) {}); // The listener gives only modified data
}
```

#### SWIPE_LOCK_PROVIDER

* Initializes the swipe lock provider.
* Handles swipe actions and locks further swipes after a limit.
* Resets the swipe count and lockout status.
* Checks if swipe actions are locked and provides the remaining lockout duration.

```dart
late SharedPreferences _kPreferences;

// Mock implementations for reader and writer
int? mockReader(String key) {
  return _kPreferences.getInt(key); // Check previous lock from local db
}

void mockWriter(String key, int value) {
  _kPreferences.setInt(key, value); // Save lock instance in local db
}

void main() async {
  // Initialize SharedPreferences (Optional)
  _kPreferences = await SharedPreferences.getInstance();
  // Initialize SwipeLockProvider
  SwipeLockProvider.init(
    times: 5,
    lockoutDuration: Duration(hours: 8),
    reader: mockReader,
    writer: mockWriter,
  );

  // Example 1: Check if currently locked
  bool isLocked = SwipeLockProvider.instance.isLocked;
  print(isLocked); // Output: false

  // Example 2: Perform a swipe action
  SwipeLockProvider.instance.swipe();
  print(SwipeLockProvider.instance.isLocked); // Output depends on swipe count

  // Example 3: Reset the swipe count and lockout status
  SwipeLockProvider.instance.reset();
  print(SwipeLockProvider.instance.isLocked); // Output: false

  // Example 4: Get remaining lockout duration
  Duration remaining = SwipeLockProvider.instance.remaining;
  print(remaining.inMinutes); // Output: 480 (if locked) or 0 (if not locked)

  // Example 5: Listen provider change
  SwipeLockProvider.instance.addListener(_onLockChanged);

  // Example 5: Listen provider remove
  SwipeLockProvider.instance.removeListener(_onLockChanged);
}
```

#### UNDO MANAGER

* A simple undo manager to keep track of actions and allow undoing the last action.
* Adds, inserts, and removes actions in a list.
* Retrieves the length of the list.

```dart
void main() {
  // Example 1: Add and undo actions
  UndoManager<String> manager = UndoManager<String>();
  manager.add("Action 1");
  manager.add("Action 2");
  print(manager.undo()); // Output: Action 2
  print(manager.undo()); // Output: Action 1
  print(manager.undo()); // Output: null

  // Example 2: Insert and undo actions
  manager.add("Action 1");
  manager.insert(0, "Action 0");
  print(manager.undo()); // Output: Action 1
  print(manager.undo()); // Output: Action 0
}
```

#### NUMBER

* Real number to human readable numbers. (ex: 1.1K, 1.5M, 1B etc)
* Real bytes to human readable bytes. (ex: 120.56 KB, 117.74 MB, 11.5 GB, etc)
* Human readable number to real numbers. (ex: 10000, 1500000, 1000000000 etc)
* Human readable bytes to real bytes. (ex: 1024, 4759737, 8374587347 etc)

```dart
void main() {
  // Example 1: Convert number to readable bytes
  Readable readableBytes = Number.toReadableBytes(2048);
  print(readableBytes); // Output: 2.00 KB

  // Example 2: Convert number to readable number
  Readable readableNumber = Number.toReadableNumber(1500000);
  print(readableNumber); // Output: 1.5 M

  // Example 3: Use unit methods
  print(ByteUnits.auto.read(2048)); // Output: 2.00 KB
  print(NumberUnits.auto.read(1500000)); // Output: 1.5 M

  // Example 4: Use extension methods
  print(2048.toReadableBytes()); // Output: 2.00 KB
  print(1500000.toReadableNumber()); // Output: 1.5 M

  // Example 1: Convert readable bytes to real bytes
  double realBytes = Number.toRealBytes(2, ByteUnits.kb);
  print(realBytes); // Output: 2048.00

  // Example 2: Convert readable number to real number
  double realNumbers = Number.toRealNumber(1.5, NumberUnits.m);
  print(realNumbers); // Output: 1500000.00

  // Example 3: Use unit methods
  print(ByteUnits.kb.write(2)); // Output: 2048.00
  print(NumberUnits.m.write(1.5)); // Output: 1500000.00

  // Example 4: Use extension methods
  print(2.toRealBytes(ByteUnits.kb)); // Output: 2048.00
  print(1.5.toRealNumber(NumberUnits.m)); // Output: 1500000.00
}
```

#### COLOR_GENERATOR

* Generate a single random color
* Generate a list of random colors
* Generate a list of colors from a provided list with random alpha values
* Pick a color from existing colors by sequence or index

```dart
void main() {
  // Example 1: Generate a single random color
  Color randomColor = ColorGenerator.generate(minOpacity: 100, maxOpacity: 200);
  print(randomColor); // Output: Color with random ARGB values

  // Example 2: Generate a list of random colors
  List<Color> randomColors = ColorGenerator.generates(length: 5);
  randomColors.forEach((color) => print(color)); // Output: List of random colors

  // Example 3: Generate a list of colors from a provided list with random alpha values
  List<Color> baseColors = [Color(0xFFFF0000), Color(0xFF00FF00), Color(0xFF0000FF)];
  List<Color> customColors = ColorGenerator.generates(length: 3, colors: baseColors);
  customColors.forEach((color) => print(color)); // Output: List of colors with random alpha
  
  // Example 3: Pick a color from existing colors by sequence or index
  ColorGenerator.init([Colors.red, Colors.blue, Colors.green]);
  Color pickedColor = ColorGenerator.i.pick(); // Sequence ways
}
```

#### IN_APP_ICON

* Three state asset icon paths. (Ex. regular, solid, bold)

```dart

void main() {
  InAppIcon home = InAppIcon.svg("ic_home");
  print(home.regular); // assets/icons/ic_home_regular.svg
  print(home.solid); // assets/icons/ic_home_solid.svg
  print(home.bold); // assets/icons/ic_home_bold.svg

  InAppIcon notification = InAppIcon.png("ic_notification");
  print(notification.regular); // assets/icons/ic_notification_regular.png
  print(notification.solid); // assets/icons/ic_notification_solid.png
  print(notification.bold); // assets/icons/ic_notification_bold.png
}
```

#### ITERATOR_HELPER

```dart
void main() {
  final items = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];

  // Use convertAs operation to convert all data
  final allItemAsText = items.convertAs("", (value, element) {
    return "$value $element";
  });
  print("All number as text: $allItemAsText"); // All number as text:  0 1 2 3 4 5 6 7 8 9

  // Use convertAsyncAs operation to convert all future data
  items.convertAsyncAs(0, (value, element) async {
    return value + await Future.value(element);
  }).then((value) {
    print("Total: $value"); // Total: 45
  });

  // Use customizeAs operation to customize all data with validation check
  final allEvenNumbers = items.customizeAs((element) {
    return element;
  }, (value) {
    return value.isEven;
  });
  print("All even numbers: $allEvenNumbers"); // All even numbers: [0, 2, 4, 6, 8]

  // Use customizeAsyncAs operation to customize all future data with validation check
  items.customizeAsyncAs(
        (element) async {
      return await Future.value(element);
    },
        (value) {
      return value.isOdd;
    },
  ).then((value) {
    print("All odd numbers: $value"); // All odd numbers: [1, 3, 5, 7, 9]
  });

  List<String> cards = items.to(reverse: true, limit: 5, (index, element) {
    return element.toString();
  });
  print(cards); // [50, 49, 48, 47, 46]

  // Use findIndex operation to find index with null safety
  final index = items.findIndex(-1, (element) => element == 5);
  print("index: $index"); // index: 4
}
```

#### HIT_LOGGER

```dart
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';

void main() async {
  HitLogger.init(
    name: "LOGGER_APP",
    onCheck: (tag, value) {
      log("$tag => $value");
    },
    onListen: (value) {
      log(value);
    },
    onClientCheck: (value) {
      return value == "CLIENT-1";
    },
    onClientListen: (value) {
      log(value.toString());
    },
  );
  runApp(const Application());
}

Future<String> futureData() async {
  await Future.delayed(const Duration(seconds: 30));
  return "Hi, I'm a future data...!";
}

Stream<String> streamData() {
  return Stream.periodic(const Duration(seconds: 5), (event) {
    return "Hi, I'm a stream data... $event!";
  });
}

class Application extends StatefulWidget {
  const Application({super.key});

  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  @override
  void initState() {
    futureData().hitLogger("getMessage", "CLIENT-1").then((value) {
      // log(value);
    });
    streamData().hitLogger("listenMessage", "CLIENT-1").listen((event) {
      // log(event);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Api hit counter',
      home: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder(
              future: futureData().hitLogger("futureData", "CLIENT-2"),
              builder: (context, snapshot) {
                return Text(snapshot.data ?? "");
              },
            ),
            const SizedBox(height: 24),
            StreamBuilder(
              stream: streamData().hitLogger("streamData", "CLIENT-2"),
              builder: (context, snapshot) {
                return Text(snapshot.data ?? "");
              },
            ),
          ],
        ),
      ),
    );
  }
}

```

Fetching data...
Data fetched successfully!
Total Hits: API_HIT_LOGGER {
-> init     : 1
-> listen   : 1
-> request  : 1
-> response : 1
}
API_HIT_LOGGER (client_1) {
-> init

#### LOG_BUILDER

```dart
void main() {
  // Create a LogBuilder instance with the tag "ExampleTag"
  LogBuilder logger = LogBuilder.getInstance("ExampleTag");

  // Attach some name-value pairs
  logger.attach("Key1", "Value1")
      .attach("Key2", 42);

  // Start a new attachment section
  logger.attachStart("SectionName")
      .attach("SectionKey", "SectionValue")
      .attachEnd("SectionEndKey", 3.14);

  // Put a name-value pair directly
  logger.put("DirectKey", true);

  // Put a name and a list of data directly
  logger.puts("ListKey", [1, 2, 3, 4, 5]);

  // Build and log the final result
  logger.build();
}

```

ExampleTag
{
-> Key1 = Value1, Key2 = 42,
-> SectionName -> SectionKey : SectionValue, SectionEndKey = 3.14 ]
-> DirectKey : true
-> ListKey : [1, 2, 3... 5]
}

#### PAGINATION

```dart
void main() {
  // Example usage of PaginationController and Pagination
  PaginationController paginationController = PaginationController();

  // Simulate loading more data asynchronously
  Future<bool> simulateLoading() async {
    await Future.delayed(Duration(seconds: 2));
    return true;
  }

  // Callback triggered when loading is required
  void onLoadMore() {
    print("Loading more items...");
    // Add logic to load more items
  }

  // Enable pagination for the associated ListView
  paginationController.paginate(
    preload: 500, // Customize the preload distance
    onLoad: onLoadMore,
    onLoading: simulateLoading,
  );
}
```

#### PATH_FINDER

```dart
void main() {
  // Example 1: Valid path
  String validPath = "users/john/posts";
  PathInfo validPathInfo = PathFinder.info(validPath);
  print(validPathInfo); // Output: Invalid: false, Ending: posts, Pairs: [Pair(users : john)]

  // Example 2: Invalid path
  String invalidPath = "invalid path";
  PathInfo invalidPathInfo = PathFinder.info(invalidPath);
  print(invalidPathInfo); // Output: Invalid: true, Ending: , Pairs: []

  // Example 3: Extracting segments
  String pathWithSegments = "path/with/more/segments";
  List<String> pathSegments = PathFinder.segments(pathWithSegments);
  print(pathSegments); // Output: [path, with, more, segments]
}
```

#### PATH_REPLACER

```dart
void main() {
  // Using replace method
  Map<String, String> params = {'param1': 'value1', 'param2': 'value2'};
  String result = PathReplacer.replace('/path/{param1}/endpoint/{param2}', params);
  print(result); // Output: '/path/value1/endpoint/value2'

  // Using replaceByIterable method
  Iterable<String> iterableParams = ['value1', 'value2'];
  result = PathReplacer.replaceByIterable('/path/{param1}/endpoint/{param2}', iterableParams);
  print(result); // Output: '/path/value1/endpoint/value2'
}
```

#### PROVIDER

```dart
import '../utils.dart'; // Assuming the utils.dart file is in the parent directory

void main() {
  // Sample list of fruits
  List<String> fruits = ['Apple', 'Banana', 'Orange', 'Grapes'];

  // Query to find the suggested position
  String query = 'Banana';

  // Get the suggested position for the query in the list of fruits
  int suggestedPosition = Provider.getSuggestedPosition(query, fruits);

  // Display the result
  if (suggestedPosition < fruits.length) {
    print('Suggested position for "$query": $suggestedPosition');
  } else {
    print('Item "$query" not found in the list.');
  }
}

```

#### RANDOM_PROVIDER

```dart
void main() {
  // Using getInt method
  int randomInt = RandomProvider.getInt(max: 10, min: 5, seed: 42);
  print(randomInt); // Output: Random integer between 5 (inclusive) and 10 (exclusive).

  // Using getString method
  String randomString = RandomProvider.getString(data: 'abc123', max: 8, seed: 42);
  print(
      randomString); // Output: Random string of length 8 using characters 'a', 'b', 'c', '1', '2', '3'.

  // Using getValue method
  List<String> options = ['A', 'B', 'C', 'D'];
  String? randomValue = RandomProvider.getValue(data: options, max: 4, min: 1, seed: 42);
  print(randomValue); // Output: Random value from the list ['B', 'C', 'D'].

  // Using getList method
  List<String> randomList = RandomProvider.getList(data: options, size: 3, min: 1, seed: 42);
  print(randomList); // Output: List of 3 random values from the list ['B', 'C', 'D'].
}
```

#### RANK_GENERATOR

```dart
import '../utils.dart'; // Assuming this is the correct path to your utils.dart file

void main() {
  // Create a RankGenerator with a percentage threshold of 50%
  RankGenerator rankGenerator = RankGenerator(percentage: 50);

  // Initialize the RankGenerator with a total value
  rankGenerator.init(100);

  // Add a listener to be notified when a rank is generated
  rankGenerator.addListener((int value) {
    print('Rank $value generated!');
  });

  // Simulate progress updates
  for (int i = 0; i <= 100; i += 10) {
    // Update the RankGenerator with the current progress value
    rankGenerator.update(i);
  }
}
```

#### REPLACEMENT

```dart
void main() {
  // Using auto method for automatic replacements
  String autoResult = Replacement.auto("Hello! How are you?");
  print('Auto Result: $autoResult'); // Output: 'Hello How are you'

  // Using single method for specific character replacement
  String singleResult = Replacement.single("Hello, World!", "-", ["!"]);
  print('Single Result: $singleResult'); // Output: 'Hello, World-'

  // Using multiple method for multiple character replacements
  String multipleResult = Replacement.multiple("Hello, World!", ["_", "+"], [" ", "!"]);
  print('Multiple Result: $multipleResult'); // Output: 'Hello+_World_'
}
```

#### SINGLETON

```dart
class AppConfig {
  final String appName;
  final String version;

  AppConfig._(this.appName, this.version);

  static AppConfig get instance => Singleton.instanceOf(() => AppConfig._("MyApp", "1.0.0"));
}

void main() {
  // Get a singleton instance of AppConfig
  AppConfig appConfig = AppConfig.instance;

  // Access properties of the singleton instance
  print("App Name: ${appConfig.appName}");
  print("Version: ${appConfig.version}");
}
```

#### SIZE_CONFIG

```dart
import 'package:flutter/material.dart';

// Assume that SizeConfig is defined in '../utils.dart'

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Initializing SizeConfig
    SizeConfig sizeConfig = SizeConfig(context);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('SizeConfig Example'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Screen Width: ${sizeConfig.screenWidth}',
                style: TextStyle(fontSize: sizeConfig.fontSize(18)),
              ),
              Text(
                'Screen Height: ${sizeConfig.screenHeight}',
                style: TextStyle(fontSize: sizeConfig.fontSize(18)),
              ),
              Text(
                'Is Mobile: ${sizeConfig.isMobile}',
                style: TextStyle(fontSize: sizeConfig.fontSize(18)),
              ),
              Text(
                'Is Tablet: ${sizeConfig.isTab}',
                style: TextStyle(fontSize: sizeConfig.fontSize(18)),
              ),
              Text(
                'Is Desktop: ${sizeConfig.isDesktop}',
                style: TextStyle(fontSize: sizeConfig.fontSize(18)),
              ),
              Text(
                'Diagonal Size: ${sizeConfig.diagonal}',
                style: TextStyle(fontSize: sizeConfig.fontSize(18)),
              ),
              Text(
                'Percentage Width (50%): ${sizeConfig.percentageWidth(50)}',
                style: TextStyle(fontSize: sizeConfig.fontSize(18)),
              ),
              Text(
                'Suggested Pixel (50%): ${sizeConfig.pixelPercentage(50)}',
                style: TextStyle(fontSize: sizeConfig.fontSize(18)),
              ),
              Text(
                'Divided Space (2): ${sizeConfig.dividedSpace(2)}',
                style: TextStyle(fontSize: sizeConfig.fontSize(18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

#### SLEEPING_TIMER

```dart
void main() {
  SleepingTimer sleepingTimer = SleepingTimer(Duration(seconds: 5));

  // Set onComplete listener
  sleepingTimer.setOnCompleteListener(() {
    print('Sleep complete!');
  });

  // Set onRemaining listener
  sleepingTimer.setOnRemainingListener((remaining) {
    print('Time remaining: $remaining');
  });

  // Start the timer
  sleepingTimer.start();
}
```

#### TEXT_FORMAT

```dart
void main() {
  // Creating a TextFormat instance for 'apple' with a plural form 'apples'
  final like = TextFormat(singular: 'like', plural: 'likes');

  // Using the apply method to get the appropriate form based on the counter
  print('You have 1 ${like.apply(1)}'); // Output: You have 1 like
  print('You have 5 ${like.apply(5)}'); // Output: You have 5 likes
}
```

#### PATTERNS

```dart
void main() {
  // Example for checking if a string is a digit with up to two decimal places
  print(Patterns.digit.hasMatch('123')); // true
  print(Patterns.digit.hasMatch('123.45')); // true
  print(Patterns.digit.hasMatch('123.456')); // false (more than two decimal places)
  print(Patterns.digit.hasMatch('abc')); // false (non-digit characters)

  // Example for checking if a string is numeric (with an optional negative sign)
  print(Patterns.numeric.hasMatch('123')); // true
  print(Patterns.numeric.hasMatch('-456')); // true
  print(Patterns.numeric.hasMatch('12.34')); // false (contains decimal point)
  print(Patterns.numeric.hasMatch('abc')); // false (non-numeric characters)

  // Example for checking if a string contains only letters
  print(Patterns.letter.hasMatch('abc')); // true
  print(Patterns.letter.hasMatch('abc123')); // false (contains numeric characters)

  // Example for validating an email address
  print(Patterns.email.hasMatch('user@example.com')); // true
  print(Patterns.email.hasMatch('invalid-email')); // false (missing @ and domain)
  print(Patterns.email.hasMatch('user@.com')); // false (missing domain)

  // Example for validating a username (alphanumeric and underscores, length 3 to 16)
  print(Patterns.username.hasMatch('user123')); // true
  print(Patterns.username.hasMatch('user_name')); // true
  print(Patterns.username.hasMatch('u')); // false (less than 3 characters)
  print(Patterns.username.hasMatch('username_with_space')); // false (contains space)

  // Example for validating a username with dots (alphanumeric, underscores, and dots, length 3 to 16)
  print(Patterns.usernameWithDot.hasMatch('user.123')); // true
  print(Patterns.usernameWithDot.hasMatch('user_name.dot')); // true
  print(Patterns.usernameWithDot.hasMatch('u')); // false (less than 3 characters)
  print(
      Patterns.usernameWithDot.hasMatch('invalid.username')); // false (contains invalid characters)

  // Example for validating different phone number formats
  print(Patterns.phone2.hasMatch('1234567890')); // true
  print(Patterns.phone2.hasMatch('+123456789012')); // true
  print(Patterns.phone2.hasMatch('invalid-phone-number')); // false (contains invalid characters)

  // Example for validating a URL
  print(Patterns.url.hasMatch('https://www.example.com')); // true
  print(Patterns.url.hasMatch('invalid-url')); // false (missing protocol)

  // Example for validating a path with a hierarchical structure
  print(Patterns.path3.hasMatch('path/to/something')); // true
  print(Patterns.path3.hasMatch('invalid/path with spaces')); // false (contains spaces)
}
```

#### VALIDATOR

```dart
void main() {
  // Print function calls and expected output

  // Validator equals
  print("Validator equals: ${Validator.equals(42, 42)}"); // Output: true

  // Validator isChecked
  print(
      "Validator isChecked: ${Validator.isChecked("apple", ["apple", "banana"])}"); // Output: true

  // Validator isMatched
  print("Validator isMatched: ${Validator.isMatched("hello", "hello")}"); // Output: true

  // Validator isMatchedList
  print("Validator isMatchedList: ${Validator.isMatchedList(
      ["a", "b"], ["a", "b"])}"); // Output: true

  // Validator isDigit
  print("Validator isDigit: ${Validator.isDigit("123")}"); // Output: true

  // Validator isLetter
  print("Validator isLetter: ${Validator.isLetter("abc")}"); // Output: true

  // Validator isNumeric
  print("Validator isNumeric: ${Validator.isNumeric("42.5")}"); // Output: true

  // Validator isValidDay
  print("Validator isValidDay: ${5.isValidDay}"); // Output: true

  // Validator isValidDigit
  print("Validator isValidDigit: ${"42".isValidDigit}"); // Output: true

  // Validator isValidEmail
  print("Validator isValidEmail: ${"user@example.com".isValidEmail()}"); // Output: true

  // Validator isValidMonth
  print("Validator isValidMonth: ${12.isValidMonth}"); // Output: true

  // Validator isValidPath
  print("Validator isValidPath: ${"/path/to/resource".isValidPath()}"); // Output: true

  // Validator isValidPhone
  print("Validator isValidPhone: ${"+123456789".isValidPhone()}"); // Output: true

  // Validator isValidRetypePassword
  print("Validator isValidRetypePassword: ${Validator.isValidRetypePassword(
      "password", "password")}"); // Output: true

  // Validator isValidPassword
  print("Validator isValidPassword: ${"securePwd".isValidPassword()}"); // Output: true

  // Validator isValidUsername
  print("Validator isValidUsername: ${"user_123".isValidUsername()}"); // Output: true

  // Validator isValidYear
  print("Validator isValidYear: ${1990.isValidYear(18)}"); // Output: true

  // Validator isValidDigitWithLetter
  print("Validator isValidDigitWithLetter: ${"123abc".isValidDigitWithLetter}"); // Output: true

  // Validator isValidDigitWithPlus
  print("Validator isValidDigitWithPlus: ${"+123".isValidDigitWithPlus}"); // Output: true

  // Validator isValidLetter
  print("Validator isValidLetter: ${"abc".isValidLetter}"); // Output: true

  // Validator isValidList
  print("Validator isValidList: ${[1, 2, 3].isValidList}"); // Output: true

  // Validator isValidSet
  print("Validator isValidSet: ${{1, 2, 3}.isValidSet}"); // Output: true

  // Validator isValidObject
  print("Validator isValidObject: ${42.isValidObject}"); // Output: true

  // Validator isInstance
  print("Validator isInstance: ${42.isInstance<int>}"); // Output: true

  // Validator isValidString
  print("Validator isValidString: ${"Hello World".isValidString()}"); // Output: true

  // Validator isValidStrings
  print("Validator isValidStrings: ${["apple", "orange"].isValidStrings()}"); // Output: true

  // Validator isValidWebURL
  print("Validator isValidWebURL: ${"https://example.com".isValidWebURL}"); // Output: true

  // Validator isRank
  print("Validator isRank: ${4.5.isRank(4.0)}"); // Output: true
}
```

#### Read details here: https://github.com/Mohiuddin655-YMR/flutter_andomie/tree/main/example/lib
