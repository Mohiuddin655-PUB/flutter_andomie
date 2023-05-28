import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'di.dart';
import 'tester/auth_test.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: kIsWeb
          ? const FirebaseOptions(
              apiKey: "AIzaSyAnDJmmToo0dPGEeAV9J-7bsghSaiByFjU",
              authDomain: "flutter-ui-kits.firebaseapp.com",
              databaseURL:
                  "https://flutter-ui-kits-default-rtdb.firebaseio.com",
              projectId: "flutter-ui-kits",
              storageBucket: "flutter-ui-kits.appspot.com",
              messagingSenderId: "807732577100",
              appId: "1:807732577100:web:c6e2766be76043102945e9",
              measurementId: "G-SW8PH1RQ0B",
            )
          : null);
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
    return const Scaffold(
      backgroundColor: Colors.white,
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
