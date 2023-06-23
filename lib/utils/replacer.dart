part of '../utils.dart';

class Replacer {
  final String key;
  final ReplacerType type;

  final dynamic result;
  final List<dynamic> results;
  final Map<String, dynamic> resultMap;

  final int position;

  const Replacer({
    required this.key,
    required this.type,
    this.result,
    this.results = const [],
    this.resultMap = const {},
    this.position = 0,
  });

  String getKey() {
    return key;
  }

  ReplacerType getType() {
    return type;
  }

  int getPosition() {
    return position;
  }

  T? getResult<T>(T cls) {
    if (result.runtimeType == cls.runtimeType) {
      return result as T;
    } else {
      return null;
    }
  }

  T? getResultAt<T>(T cls, int position) {
    final list = getResults(cls);
    if (Validator.isValidList(list) && position < list.length) {
      return list[position];
    } else {
      return null;
    }
  }

  T? getResultByKey<T>(T cls, String key) {
    dynamic data = resultMap[key];
    if (data != null && data.runtimeType == cls.runtimeType) {
      return data as T;
    } else {
      return null;
    }
  }

  List<T> getResults<T>(T cls) {
    if (result.runtimeType == cls.runtimeType) {
      return Converter.toList(list: results);
    } else {
      return [];
    }
  }
}

enum ReplacerType {
  none(15000),
  delete(15001),
  insert(15002),
  reload(15003),
  update(15004),
  recent(16001);

  final num value;

  const ReplacerType(this.value);
}
