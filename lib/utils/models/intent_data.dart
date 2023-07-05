part of 'models.dart';

class IntentData {
  late final dynamic _data;
  late final List<dynamic> _list;

  IntentData({dynamic data, List<dynamic> list = const []}) {
    _data = list.isNotEmpty ? list[0] : data;
    _list = list;
  }

  bool get isExist => data() != null;

  bool get isExists => _list.isNotEmpty;

  bool forData<T>(T instance) {
    return isExists && instance.runtimeType == data.runtimeType;
  }

  bool forList<T>(T instance) {
    return isExists && instance.runtimeType == _list[0].runtimeType;
  }

  T? data<T>() {
    final current = _data ?? (_list.isNotEmpty ? _list[0] : null);
    return current != null && current is T ? current : null;
  }

  List<T> list<T>(T cls) {
    final List<T> list = [];
    if (_list.isNotEmpty) {
      for (dynamic value in _list) {
        if (cls.runtimeType == value.runtimeType) {
          list.add(value as T);
        }
      }
    }
    return list;
  }
}
