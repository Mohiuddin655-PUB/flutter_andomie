import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var a = DateTime.timestamp();
    return Scaffold(
      body: SafeArea(
        child: Text(a.toRealtime(
          showRealtime: true,
          whenShowNow: 10,
        )),
      ),
    );
  }
}
