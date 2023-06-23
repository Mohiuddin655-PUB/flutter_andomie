part of 'helpers.dart';

class BooleanPreferenceHelper {
  static const String _tag = "boolean_preference_loader";

  final PreferenceHelper helper;

  const BooleanPreferenceHelper(this.helper);

  void setPreference({
    required Type runtimeType,
    bool value = true,
  }) {
    final String key = '$runtimeType';
    helper.setBoolean(key, value);
  }

  void load<T>({
    required OnBooleanPreferenceLoaderListener<T> listener,
    required List<T> types,
  }) {
    if (types.isNotEmpty) {
      for (int index = 0; index < types.length; index++) {
        T type = types[index];

        if (type != null) {
          final event = BPLEvent<T>(helper, type, types);

          if (isExisted(type)) {
            if (listener.onExisted(event)) break;
          } else {
            if (listener.onUnExisted(event)) break;
          }

          if (types.length == index + 1) listener.onDefault(helper);
        }
      }
    }
  }

  bool isExisted<T>(T t) {
    try {
      return helper.getBoolean(t.runtimeType.toString());
    } on Exception catch (e) {
      log("isExisted: $e", name: _tag, error: e);
      return false;
    }
  }
}

abstract class OnBooleanPreferenceLoaderListener<T> {
  void onDefault(PreferenceHelper helper) {}

  bool onExisted(BPLEvent<T> event) {
    return false;
  }

  bool onUnExisted(BPLEvent<T> event);
}

class BPLEvent<T> {
  final PreferenceHelper helper;
  final T result;
  final List<T> types;

  const BPLEvent(this.helper, this.result, this.types);
}
