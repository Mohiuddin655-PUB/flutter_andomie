# flutter_andomie

Collection of utils with advanced style and controlling system.

### UTILS

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