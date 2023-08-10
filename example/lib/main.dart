import 'dart:developer';

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
    var a = Time(hour: 0, minute: 0, second: 0);
    var b = Date(year: 2022, month: 1, day: 2);
    var c = b.toDateTime(a);
    print(c);
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

class User extends Entity<UserKey> {
  final String? name;
  final String? photo;

  User({
    super.id,
    super.timeMills,
    this.name,
    this.photo,
  });

  factory User.from(dynamic source) {
    var keys = UserKey.i;
    return User(
      id: source.entityId,
      timeMills: source.entityTimeMills,
      name: source.entityValue(keys.name),
      photo: source.entityValue(keys.photo),
    );
  }

  @override
  Map<String, dynamic> get source => super.source.attach({
        key.name: name,
        key.photo: photo,
      });

  static User get i => Singleton.instanceOf(() => User());

  @override
  UserKey makeKey() {
    log("makeKey");
    return UserKey();
  }
}

class UserKey extends EntityKey {
  final String name = "name";
  final String photo = "photo";

  static UserKey get i => Singleton.instanceOf(() => UserKey());
}
