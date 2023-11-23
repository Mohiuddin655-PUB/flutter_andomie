import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';

void main() async {
  HitLogger.init(
    "MY_APP",
    printable: false,
    loggable: false,
    onListen: (value) {
      log(value.toString());
    },
  );

  runApp(const Application());
}

class Application extends StatefulWidget {
  const Application({super.key});

  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
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
              future: futureData().hitCounter("futureData"),
              builder: (context, snapshot) {
                return Text(snapshot.data ?? "");
              },
            ),
            const SizedBox(height: 24),
            StreamBuilder(
              stream: streamData().hitCounter("streamData"),
              builder: (context, snapshot) {
                return Text(snapshot.data ?? "");
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    initData();
    super.initState();
  }

  void initData() {
    futureData().hitCounter("getMessage").then((value) {
      // log(value);
    });
    streamData().hitCounter("listenMessage").listen((event) {
      // log(event);
    });
  }

  Future<String> futureData() async {
    await Future.delayed(Duration(seconds: 5));
    return "Hi, I'm a future data...!";
  }

  Stream<String> streamData() {
    return Stream.periodic(Duration(seconds: 2), (event) {
      return "Hi, I'm a stream data... $event!";
    });
  }
}
