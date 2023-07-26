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
    var timeMills = DateTime.now().add(const Duration(
      days: 0,
      hours: 0,
      minutes: 0,
      seconds: 0,
    ));
    return Scaffold(
      body: SafeArea(
        child: Text(timeMills.toRealtime(
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
        keys.name: name,
        keys.photo: photo,
      });

  @override
  UserKey get keys => UserKey.i;
}

class UserKey extends EntityKey {
  final String name = "name";
  final String photo = "photo";

  const UserKey._();

  static UserKey? _proxy;

  static UserKey get i => _proxy ??= const UserKey._();
}
