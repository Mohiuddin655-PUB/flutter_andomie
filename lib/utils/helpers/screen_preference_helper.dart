part of 'helpers.dart';

class ScreenPreferenceHelper {
  static const String _tag = "screen_preference_loader";

  final PreferenceHelper helper;

  const ScreenPreferenceHelper(
    this.helper,
  );

  void setPreference({
    required String key,
    dynamic value,
  }) {
    if (value is bool) {
      helper.setBoolean(key, value);
    } else if (value is int) {
      helper.setInt(key, value);
    } else if (value is String) {
      helper.setString(key, value);
    }
  }

  dynamic getPreference({
    required String screen,
    required DataType type,
  }) {
    switch (type) {
      case DataType.boolean:
        return helper.getBoolean(screen);
      case DataType.int:
        return helper.getInt(screen);
      case DataType.string:
        return helper.getString(screen);
      default:
        return null;
    }
  }

  Future<bool> isExisted(
    String screen,
  ) async {
    return helper.getBoolean(screen);
  }

  bool _isExisted<T>(Value<T> value) {
    final key = value.mScreenName;
    final type = value.mDataType;

    try {
      if (type == DataType.boolean) {
        return helper.getBoolean(key);
      } else if (type == DataType.int) {
        return helper.getInt(key) != 0;
      } else if (type == DataType.string) {
        return helper.getString(key) != null;
      } else {
        return false;
      }
    } on Exception catch (e) {
      log("isExisted: $e", name: _tag, error: e);
      return false;
    }
  }

  void load<T>({
    required OnScreenPreferenceListener<T> listener,
    required List<Value<T>> values,
  }) {
    if (values.isNotEmpty) {
      for (int index = 0; index < values.length; index++) {
        final value = values[index];

        final event = SPLEvent<T>(helper, value);

        if (_isExisted(value)) {
          if (listener.onExisted(event)) break;
        } else {
          if (listener.onUnExisted(event)) break;
        }

        if (values.length == index + 1) listener.onDefault(helper);
      }
    }
  }
}

abstract class OnScreenPreferenceListener<T> {
  void onDefault(PreferenceHelper helper) {}

  bool onExisted(SPLEvent<T> event) => false;

  bool onUnExisted(SPLEvent<T> event);
}

class SPLEvent<T> {
  final PreferenceHelper helper;
  late String name;
  late DataType type;
  late T? data;

  SPLEvent(this.helper, Value<T> value) {
    name = value.mScreenName;
    type = value.mDataType;
    data = value.mData;
  }
}
