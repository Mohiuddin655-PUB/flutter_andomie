part of 'helpers.dart';

class ClipboardHelper {
  static Future<String> get text async {
    var data = await Clipboard.getData(
      Clipboard.kTextPlain,
    );
    return data?.text ?? "";
  }

  static setText(String value) async {
    await Clipboard.setData(
      ClipboardData(text: value),
    );
  }
}
