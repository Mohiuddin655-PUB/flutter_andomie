part of '../utils.dart';

class TranslateProvider {
  static Future<String> translate(
    String language,
    String? text,
  ) async {
    if (text != null && text.isNotEmpty) {
      final response = await TranslateApi.of()
          .withDefaultLang('en')
          .withTranslateLang(language)
          .withTranslateText(text)
          .execute;

      return response.data ?? '';
    } else {
      return '';
    }
  }
}
