part of '../utils.dart';

class KeyProvider {
  const KeyProvider._();

  static String generateKey({
    String? name,
    int? timeMills,
    int extraKeySize = 5,
  }) {
    if (name != null) {
      return Replacement.auto(name).toLowerCase();
    } else {
      final ms = timeMills ?? DateProvider.currentMS;
      final extra = RandomProvider.getRandomString(
        KeyFormat.allowedNumbers,
        extraKeySize,
      );
      final key = "$ms$extra";
      return key;
    }
  }

  static String generateSearchableKey(String type, String query) {
    final date = generateDatableKey();
    final name = Replacement.auto(query).toLowerCase();
    var key = "$date-$type-$name";
    return key;
  }

  static String generateDatableKey([int? ms, String? dateFormat]) {
    // final time = DateProvider.toDateTime(ms);
    // return time
    //     .modify(dateFormat ?? KeyFormat.FORMAT_REFERENCE_DATE)
    //     .toLowerCase();
    return "";
  }
}
