part of '../utils.dart';

class RandomProvider {
  static int getInt({
    required int max,
    int min = 0,
    int? seed,
  }) {
    final Random random = Random(seed);
    return random.nextInt(max) + min;
  }

  static String getString({
    required String data,
    required int max,
    int? seed,
  }) {
    final Random random = Random(seed);
    var characters = data.characters;
    var value = '';
    for (int i = 0; i < max; ++i) {
      final a = characters.elementAt(random.nextInt(characters.length));
      value = "$value$a";
    }
    return value;
  }

  static T? getValue<T>({
    required List<T> data,
    required int max,
    int min = 0,
    int? seed,
  }) {
    if (Validator.isValidList(data)) {
      return data[getInt(max: data.length, min: min, seed: seed)];
    } else {
      return null;
    }
  }

  static List<T> getList<T>({
    required List<T> data,
    required int size,
    int min = 0,
    int? seed,
  }) {
    final List<T> list = [];
    for (int i = 0; i < size; ++i) {
      list.add(getValue(data: data, max: size, min: min, seed: seed) as T);
    }
    return list;
  }
}
