import 'package:flutter/services.dart';

class ClipboardHelper {
  const ClipboardHelper._();

  static Future<String> get text async {
    var data = await Clipboard.getData(Clipboard.kTextPlain);
    return data?.text ?? "";
  }

  static void setText(String value) async {
    await Clipboard.setData(ClipboardData(text: value));
  }
}
