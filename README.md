# flutter_andomie
Collection of utils with advanced style and controlling system.

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