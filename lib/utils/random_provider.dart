part of '../utils.dart';

class RandomProvider {
  static int getRandomInt(int max) {
    final Random random = Random();
    return random.nextInt(max);
  }

  static String getRandomString(String keyFormat, int max) {
    final Random random = Random();
    var characters = keyFormat.characters;
    var value = '';
    for (int i = 0; i < max; ++i) {
      final a = characters.elementAt(random.nextInt(characters.length));
      value = "$value$a";
    }
    return value;
  }

  static T? getRandomValue<T>(List<T> ts) {
    if (Validator.isValidList(ts)) {
      final Random random = Random();
      return ts[random.nextInt(ts.length)];
    } else {
      return null;
    }
  }

  static List<T> getRandomList<T>(List<T> ts, int size) {
    final List<T> list = [];
    for (int i = 0; i < size; ++i) {
      list.add(getRandomValue(ts) as T);
    }
    return list;
  }
}
