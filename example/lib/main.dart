import 'dart:async';

import 'package:faker/faker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_andomie/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool selected = false;

  @override
  void initState() {
    var now = DateTime.now().subtract(const Duration(days: 1));
    Timer.periodic(const Duration(seconds: 2), (timer) {
      now = now.add(Duration(minutes: timer.tick * 5));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: AuthTest(),
      ),
    );
  }
}

class AuthTest extends StatefulWidget {
  const AuthTest({Key? key}) : super(key: key);

  @override
  State<AuthTest> createState() => _AuthTestState();
}

class _AuthTestState extends State<AuthTest> {
  var email = TextEditingController();
  var password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => locator<DefaultAuthController>(),
      child: BlocBuilder<DefaultAuthController, Response<AuthInfo>>(
        builder: (context, state) {
          var controller = context.read<DefaultAuthController>();
          var value = state.data;
          return SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  EditText(
                    controller: email,
                    hint: "Email",
                    initialValue: "mohin@gmail.com",
                  ),
                  const SizedBox(height: 12),
                  EditText(
                    controller: password,
                    hint: "Password",
                    initialValue: "123456",
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      controller.signInByEmail(
                        AuthInfo(
                          email: email.text,
                          password: password.text,
                        ),
                      );
                    },
                    child: const RawText(text: "Login"),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const RawText(text: "Register"),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const RawText(text: "Logout"),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const RawText(text: "Login with Google"),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const RawText(text: "Login with Facebook"),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const RawText(text: "Login with Apple"),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    alignment: Alignment.center,
                    child: RawText(
                      text:
                          'Message : ${state.message}\n Error: ${state.error}',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class EditText extends StatelessWidget {
  final TextEditingController controller;
  final String initialValue;
  final String hint;

  const EditText({
    Key? key,
    required this.controller,
    required this.hint,
    required this.initialValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.text = initialValue;
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
      ),
    );
  }
}

class FrameLayoutTest extends StatelessWidget {
  const FrameLayoutTest({Key? key}) : super(key: key);

  Stream<List<String>> get items {
    var faker = Faker(provider: FakerDataProviderFa());
    var list = <String>[
      faker.image.image(random: true),
    ];
    var controller = StreamController<List<String>>();
    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (list.length > 8) {
        list.clear();
      }
      list.add(faker.image.image(random: true));
      controller.add(list);
    });
    return controller.stream;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: items,
      builder: (context, snapshot) {
        return SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: FrameView<String>(
            items: snapshot.data ?? [],
            frameBuilder: (context, layer, item) {
              return ImageView(
                image: item,
                imageType: ImageType.network,
                scaleType: BoxFit.cover,
              );
            },
          ),
        );
      },
    );
  }
}
