part of '../utils.dart';

class Patterns {
  static final RegExp digit = RegExp(Regs.digit.value);
  static final RegExp numeric = RegExp(Regs.numeric.value);
  static final RegExp letter = RegExp(Regs.letter.value);
  static final RegExp email = RegExp(Regs.email.value);
  static final RegExp path = RegExp(Regs.path.value);
  static final RegExp phone = RegExp(Regs.phone3.value);
  static final RegExp url = RegExp(Regs.url.value);
  static final RegExp username = RegExp(Regs.username.value);
  static final RegExp usernameWithDot = RegExp(Regs.usernameWithDot.value);
}

enum Regs {
  digit(r'^\d+(.\d{1,2})?$'),
  numeric(r'^-?[0-9]+$'),
  letter(r'^[a-z A-Z]+$'),
  email(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"),
  username(r"^[a-zA-Z0-9_]{3,16}$"),
  usernameWithDot(r"^[a-zA-Z0-9_.]{3,16}$"),
  phone(r'^[+]*[(]{0,1}[0-9]{1,4}+$'),
  phone2(r'^(?:[+0][1-9])?[0-9]{10,12}$'),
  phone3(r'^\+?[0-9]{7,15}$'),
  url(r'(http|https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?'),
  path(r"^[a-zA-Z_]\w*(/[a-zA-Z_]\w*)*$"),
  path2(r"^[a-zA-Z0-9_]+(?:/[a-zA-Z0-9_]+)*$"),
  path3(r"^[a-zA-Z_][a-zA-Z0-9_]*(/[a-zA-Z_][a-zA-Z0-9_]*)*$");

  const Regs(this.value);

  final String value;
}
