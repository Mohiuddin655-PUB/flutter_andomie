import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_andomie/widgets.dart';

void main() {
  runApp(const Application());
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

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FrameView(
          width: double.infinity,
          height: double.infinity,
          itemBackground: Colors.black.withOpacity(0.05),
          items: const [
            "Layer 1",
            "Layer 2",
            "Layer 3",
            "Layer 4",
            "Layer 5",
            "Layer 6",
            "Layer 7",
            "Layer 8",
            "Layer 9",
          ],
          frameBuilder: (context, layer, item) {
            return TextView(
              text: item,
              gravity: Alignment.center,
            );
          },
        ),
      ),
    );
  }

  Stream<List<String>> get items {
    List<String> list = [""];
    final controller = StreamController<List<String>>();
    controller.add(list);
    Timer.periodic(const Duration(seconds: 5), (timer) {
      if (list.length == 9) {
        list.clear();
      }
      list.add("");
      controller.add(list);
    });
    return controller.stream;
  }
}
