import 'dart:developer';
import 'dart:math' as m;

import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';

void main() async {
  HitLogger.init("EXAMPLE");
  final random = m.Random();
  final list = ["a", "b", "c", "d", "e"];

  for (var i = 0; i < 100; i++) {
    final index = random.nextInt(5);
    final value = list[2];
    HitLogger.hit(value);
  }
  // WidgetsFlutterBinding.ensureInitialized();
  // runApp(const Application());
}

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var a = Time(hour: 0, minute: 0, second: 0);
    var b = Date(year: 2022, month: 1, day: 2);
    var c = b.toDateTime(a);
    log(c.toString());
    return Scaffold(
      body: SafeArea(
        child: Text(c.toRealtime(
          showRealtime: true,
          whenShowNow: 10,
        )),
      ),
    );
  }
}
