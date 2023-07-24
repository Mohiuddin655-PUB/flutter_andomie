part of '../utils.dart';

class TextFormat {
  final String singular;
  final String plural;

  const TextFormat({
    required this.singular,
    String? plural,
  }) : plural = plural ?? singular;

  String getText(int counter) {
    return counter > 1 ? plural : singular;
  }
}
