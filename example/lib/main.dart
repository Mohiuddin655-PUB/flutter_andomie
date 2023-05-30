import 'package:example/tester/auth_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'di.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await diInit();
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
    return Scaffold(
      body: SafeArea(
        // child: ToggleView(
        //   width: 150,
        //   height: 50,
        //   background: Colors.red,
        //   borderRadius: 24,
        //   toggle: true,
        //   onClick: (c){
        //     print("object");
        //   },
        // ),
        child: AuthTest(),
      ),
    );
  }
}
