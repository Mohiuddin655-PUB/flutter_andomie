part of '../utils.dart';

class RandomProvider {
  static int getRandomInt(int max, {int? seed}) {
    final Random random = Random(seed);
    return random.nextInt(max);
  }

  static String getRandomString(String keyFormat, int max, {int? seed}) {
    final Random random = Random(seed);
    var characters = keyFormat.characters;
    var value = '';
    for (int i = 0; i < max; ++i) {
      final a = characters.elementAt(random.nextInt(characters.length));
      value = "$value$a";
    }
    return value;
  }

  static T? getRandomValue<T>(List<T> ts, {int? seed}) {
    if (Validator.isValidList(ts)) {
      final Random random = Random(seed);
      return ts[random.nextInt(ts.length)];
    } else {
      return null;
    }
  }

  static List<T> getRandomList<T>(List<T> ts, int size, {int? seed}) {
    final List<T> list = [];
    for (int i = 0; i < size; ++i) {
      list.add(getRandomValue(ts, seed: seed) as T);
    }
    return list;
  }
}
