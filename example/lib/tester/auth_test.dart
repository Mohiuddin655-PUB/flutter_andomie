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
  var controller = locator<DefaultAuthController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => controller,
      child: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              EditText(
                controller: email,
                hint: "Email",
                initialValue: '',
              ),
              const SizedBox(height: 12),
              EditText(
                controller: password,
                hint: "Password",
                initialValue: '',
              ),
              const SizedBox(height: 12),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 16,
                runSpacing: 8,
                children: [
                  ElevatedButton(
                    child: const RawTextView(text: "Login"),
                    onPressed: () => controller.signInByEmail(
                      AuthInfo(
                        email: email.text,
                        password: password.text,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    child: const RawTextView(text: "Register"),
                    onPressed: () => controller.signUpByEmail(
                      AuthInfo(
                        email: email.text,
                        password: password.text,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    child: const RawTextView(text: "Logout"),
                    onPressed: () => controller.signOut(),
                  ),
                  ElevatedButton(
                    child: const RawTextView(text: "Is Logged in"),
                    onPressed: () => controller.isLoggedIn,
                  ),
                  ElevatedButton(
                    child: const RawTextView(text: "Login with Google"),
                    onPressed: () => controller.signInByGoogle(
                      AuthInfo(
                        email: email.text,
                        password: password.text,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    child: const RawTextView(text: "Login with Facebook"),
                    onPressed: () => controller.signInByFacebook(
                      AuthInfo(
                        email: email.text,
                        password: password.text,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    child: const RawTextView(text: "Login with Apple"),
                    onPressed: () => controller.signInByEmail(
                      AuthInfo(
                        email: email.text,
                        password: password.text,
                      ),
                    ),
                  ),
                ],
              ),
              BlocBuilder<DefaultAuthController, AuthResponse<AuthInfo>>(
                  builder: (context, state) {
                var value = state.data;
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  alignment: Alignment.center,
                  child: RawTextView(
                    text: state.beautify,
                    textAlign: TextAlign.center,
                  ),
                );
              }),
            ],
          ),
        ),
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
