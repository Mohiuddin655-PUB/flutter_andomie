# flutter_andomie

Collection of utils with advanced style and controlling system.

### UTILS

#### APP_ICON

```dart
void main() {
  // Using AppIconBuilder to create an instance of AppIcon
  AppIconBuilder iconBuilder = AppIconBuilder();
  AppIcon customIcon = iconBuilder.build(
    regular: 'custom_regular.svg',
    solid: 'custom_solid.svg',
    bold: 'custom_bold.svg',
  );

  // Using automatic naming convention to create an instance of AppIcon
  AppIcon autoIcon = AppIcon.auto('auto_icon');

  print('Regular Icon Path: ${customIcon.regular}');
  print('Solid Icon Path: ${customIcon.solid}');
  print('Bold Icon Path: ${customIcon.bold}');
}
```

#### CONNECTIVITY_PROVIDER

```dart
void main() async {
  // Using ConnectivityProvider to check connectivity status
  bool isWifiConnected = await ConnectivityProvider.I.isWifi;
  print('Is Wi-Fi Connected: $isWifiConnected');

  // Using ConnectivityService to monitor connectivity changes
  bool isConnected = await ConnectivityService.I.onChangedStatus();
  print('Is Connected: $isConnected');

  // Using ConnectivityService to monitor network connection
  bool isConnectedNetwork = await ConnectivityService.I.isConnected;
  print('Is Connected Network: $isConnectedNetwork');
}
```

#### CONVERTER

```dart
void main() {
  // Example for asString method
  List<String> stringList = ['apple', 'orange', 'banana'];
  String formattedString = Converter.asString(stringList);
  print('Formatted String: $formattedString');
  // Output: Formatted String: apple, orange and banana

  // Example for toCountingNumber method
  List<int> numberList = [1, 2, 3, 4, 5];
  int countingNumber = Converter.toCountingNumber(numberList);
  print('Counting Number: $countingNumber');
  // Output: Counting Number: 5

  // Example for toCountingState method
  int current = 2;
  int total = 5;
  String countingState = Converter.toCountingState(current, total);
  print('Counting State: $countingState');
  // Output: Counting State: 2/5

  // Example for toCountingText method
  List<String> textList = ['one', 'two', 'three'];
  String countingText = Converter.toCountingText(textList);
  print('Counting Text: $countingText');
  // Output: Counting Text: 3

  // Example for toCountingWithPlus method
  int size = 8;
  int limit = 5;
  String countingWithPlus = Converter.toCountingWithPlus(size, limit);
  print('Counting With Plus: $countingWithPlus');
  // Output: Counting With Plus: 5+

  // Example for toLetter method
  String stringWithDigits = 'abc123';
  String lettersOnly = Converter.toLetter(stringWithDigits);
  print('Letters Only: $lettersOnly');
  // Output: Letters Only: abc

  // Example for toDigitWithLetter method
  String stringWithSpecialChars = 'abc123!@#';
  String digitWithLetter = Converter.toDigitWithLetter(stringWithSpecialChars);
  print('Digits with Letters: $digitWithLetter');
  // Output: Digits with Letters: abc123

  // Example for toDigitWithPlus method
  String stringWithPlus = '123abc!@#';
  String digitWithPlus = Converter.toDigitWithPlus(stringWithPlus);
  print('Digits with Plus: $digitWithPlus');
  // Output: Digits with Plus: 123+

  // Example for toDouble method
  dynamic doubleValue = '3.14';
  double convertedDouble = Converter.toDouble(doubleValue);
  print('Converted Double: $convertedDouble');
  // Output: Converted Double: 3.14

  // Example for toInt method
  dynamic intValue = '42';
  int convertedInt = Converter.toInt(intValue);
  print('Converted Int: $convertedInt');
  // Output: Converted Int: 42
}
```

#### COUNTER

```dart
void main() {
  // Using the Counter enum to convert counting values
  String kCount = Counter.toKCount(1500); // Output: "1.5K"
  String kmCount = Counter.toKMCount(1200000); // Output: "1.2M"
  String kmbCount = Counter.toKMBCount(1500000000); // Output: "1.5B"

  // Using the CounterExtension on an integer to convert counting values
  int value = 2500;
  String kCountValue = value.toKCount; // Output: "2.5K"
  String kmCountValue = value.toKMCount; // Output: "2.5K"
  String kmbCountValue = value.toKMBCount; // Output: "2.5K"
}
```

#### DATE_PROVIDER

```dart
void main() {
  // Example: Using Realtime and DateProvider classes
  int currentTimeMillis = DateProvider.currentMS;
  print(currentTimeMillis);

  DateTime someDateTime = DateTime(2023, 5, 15, 10, 30);
  Realtime realtime = Realtime.fromDateTime(someDateTime);
  print(realtime.isToday); // Output: false

  print(currentTimeMillis.toRealtime()); // Output: Now

  print(someDateTime.toDate()); // Output: 15-05-2023
}
```

#### DEVICE_CONFIG

```dart
import '../utils.dart'; // Import the file containing DeviceConfig

void main() {
  // Create an instance of DeviceConfig
  DeviceConfig deviceConfig = DeviceConfig();

  // Example 1: Check platform type
  print('Is Android? ${deviceConfig.isAndroid}');
  print('Is iOS? ${deviceConfig.isIOS}');
  print('Is Windows? ${deviceConfig.isWindows}');

  // Example 2: Determine device type based on screen dimensions
  double screenWidth = 360; // Example screen width in logical pixels
  double screenHeight = 640; // Example screen height in logical pixels

  DeviceType currentDeviceType = deviceConfig.deviceType(screenWidth, screenHeight);

  print('Current Device Type: $currentDeviceType');

  // Example 3: Check if the screen represents a mobile device
  bool isMobileDevice = deviceConfig.isMobile(screenWidth, screenHeight);
  print('Is Mobile Device? $isMobileDevice');

  // Example 4: Access device information
  print('Mobile Device Width: ${deviceConfig.mobile.width}');
  print('Mobile Device Height: ${deviceConfig.mobile.height}');
  print('Mobile Device Font Variant: ${deviceConfig.mobile.fontVariant}');

  // Example 5: Check if the screen represents a desktop device
  bool isDesktopDevice = deviceConfig.isDesktop(screenWidth, screenHeight);
  print('Is Desktop Device? $isDesktopDevice');
}
```

#### ENCRYPTOR

```dart
void main() async {
  // Create an instance of Encryptor with default values.
  Encryptor encryptor = Encryptor();

  // Example input data to be encrypted.
  Map<String, dynamic> inputData = {
    "username": "john_doe",
    "password": "secure_password",
  };

  try {
    // Encrypt the input data.
    Map<String, dynamic> encryptedRequest = await encryptor.input(inputData);
    print(
        "Encrypted Request: $encryptedRequest"); // Encrypted Request: {data: U2FsdGVkX1+1/vzorN1cnBQHK6TZYz2oh6Y7B8+CpeEFiUjxkN6RsbO4RYgSTN3RTawmAT3OXi4=, passcode: passcode}

    // Decrypt the response.
    Map<String, dynamic> decryptedResponse = await encryptor.output(encryptedRequest);
    print(
        "Decrypted Response: $decryptedResponse"); // Decrypted Response: {username: john_doe, password: secure_password}
  } catch (e) {
    print("Encryption/Decryption error: $e");
  }
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

#### KEY_PROVIDER

```dart
void main() {
  // Using imgKey to generate a unique image key
  String imageKey = KeyProvider.imgKey;
  print(imageKey); // Output: Current date and time formatted as 'yyyyMMddHHmmss'.

// Using generateKey with a name
  String keyWithName = KeyProvider.generateKey(name: 'MyImage');
  print(keyWithName); // Output: 'myimage'

// Using generateKey with a timestamp
  String timestampKey = KeyProvider.generateKey(timeMills: 1644613725000);
  print(timestampKey); // Output: '1644613725000xxxxx' (xxxxx is a random string of 5 characters)

}
```

#### LIST_CREATOR

```dart
void main() {
  // Sample list of integers
  List<int> myList = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];

  // Create a ListCreator with a capacity of 3
  ListCreator<int> creator = ListCreator(3);

  // Load the sample list into the ListCreator
  creator.load(myList);

  // Get the first collection (chunk) from the ListCreator
  List<int> firstCollection = creator.collection();
  print("First Collection: $firstCollection"); // First Collection: [1, 2, 3]

  // Get the second collection from the ListCreator
  List<int> secondCollection = creator.collection();
  print("Second Collection: $secondCollection"); // Second Collection: [4, 5, 6]

  // Get all collections created by the ListCreator
  List<List<int>> allCollections = creator.collections;
  print(
      "All Collections: $allCollections"); // All Collections: [[1, 2, 3], [4, 5, 6], [7, 8, 9], [10, 11]]
}
```

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

#### URL_PROVIDER

```dart
void main() {
  // Example using UrlProvider.createByBase
  String fullUrlByBase = UrlProvider.createByBase("https://example.com", "api/data");
  print("Using UrlProvider.createByBase: $fullUrlByBase"); // Output: https://example.com/api/data

  // Example using UrlProvider.createByCustom
  String fullUrlByCustom = UrlProvider.createByCustom("ftp", "example.org", "files/docs");
  print(
      "Using UrlProvider.createByCustom: $fullUrlByCustom"); // Output: ftp://example.org/files/docs

  // Example using UrlProvider.createByHttp
  String fullUrlByHttp = UrlProvider.createByHttp("example.com", "api/data");
  print("Using UrlProvider.createByHttp: $fullUrlByHttp"); // Output: http://example.com/api/data

  // Example using UrlProvider.createByHttps
  String fullUrlByHttps = UrlProvider.createByHttps("example.com", "api/data");
  print("Using UrlProvider.createByHttps: $fullUrlByHttps"); // Output: https://example.com/api/data

  // Example using UrlBuilder
  UrlBuilder urlBuilder = UrlBuilder("https", "example.com");
  String fullUrlByBuilder = urlBuilder.create("api/data");
  print("Using UrlBuilder: $fullUrlByBuilder"); // Output: https://example.com/api/data
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