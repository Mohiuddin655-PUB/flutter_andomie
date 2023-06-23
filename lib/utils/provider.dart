part of '../utils.dart';

class Provider {
  static int getSuggestedPosition<T>(T query, List<T>? list) {
    int index = 0;
    if (list != null && list.isNotEmpty) {
      for (index = 0; index < list.length; index++) {
        if (Validator.equals(query, list[index])) {
          return index;
        }
      }
    }
    return index;
  }
}
