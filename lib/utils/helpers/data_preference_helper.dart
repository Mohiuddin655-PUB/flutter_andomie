part of 'helpers.dart';

class DataPreferenceHelper {
  static const String _tag = 'data_preference_loader';

  final PreferenceHelper helper;

  const DataPreferenceHelper(this.helper);

  void setPreference({
    required String key,
    bool value = true,
  }) {
    helper.setBoolean(key, value);
  }

  void load({
    required OnDataPreferenceLoaderListener listener,
    required List<KeyValue> keyValues,
  }) {
    if (keyValues.isNotEmpty) {
      for (int index = 0; index < keyValues.length; index++) {
        final keyValue = keyValues[index];

        final event = DPLEvent(helper, keyValue);

        if (_isExisted(keyValue)) {
          if (listener.onExisted(event)) break;
        } else {
          if (listener.onUnExisted(event)) break;
        }

        if (keyValues.length == index + 1) listener.onDefault(helper);
      }
    }
  }

  bool _isExisted(KeyValue keyValue) {
    final String key = keyValue.mKey;

    try {
      switch (keyValue.mType) {
        case DataType.boolean:
          return helper.getBoolean(key);
        case DataType.int:
          return helper.getInt(key) != 0;
        case DataType.string:
          return helper.getString(key) != null;
        default:
          return false;
      }
    } on Exception catch (e) {
      log("isExisted: $e", name: _tag, error: e);
      return false;
    }
  }
}

abstract class OnDataPreferenceLoaderListener {
  void onDefault(PreferenceHelper helper) {}

  bool onExisted(DPLEvent event) => false;

  bool onUnExisted(DPLEvent event);
}

class DPLEvent {
  final PreferenceHelper helper;
  late String mKey;
  late DataType mType;
  late dynamic mValue;

  DPLEvent(this.helper, KeyValue result) {
    mKey = result.mKey;
    mType = result.mType;
    mValue = result.mValue;
  }
}
