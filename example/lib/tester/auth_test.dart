import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_andomie/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../di.dart';

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
                          'Message : ${state.message}\n Error: ${state.exception}',
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
