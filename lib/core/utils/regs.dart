import 'index.dart';

class Regs {
  static final RegExp numeric = RegExp(Patterns.numeric);
  static final RegExp letter = RegExp(Patterns.letter);
  static final RegExp email = RegExp(Patterns.email);
  static final RegExp phone = RegExp(Patterns.phone);
  static final RegExp url = RegExp(Patterns.url);
}
