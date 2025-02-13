import 'dart:ui';

final kLanguages = [
  {"name": "Afrikaans", "native": "Afrikaans", "code": "af_ZA"},
  {"name": "Albanian", "native": "Shqip", "code": "sq_AL"},
  {"name": "Amharic", "native": "አማርኛ", "code": "am_ET"},
  {"name": "Arabic", "native": "العربية", "code": "ar_SA"},
  {"name": "Armenian", "native": "Հայերեն", "code": "hy_AM"},
  {"name": "Azerbaijani", "native": "Azərbaycan dili", "code": "az_AZ"},
  {"name": "Basque", "native": "Euskara", "code": "eu_ES"},
  {"name": "Belarusian", "native": "Беларуская", "code": "be_BY"},
  {"name": "Bengali", "native": "বাংলা", "code": "bn_BD"},
  {"name": "Bosnian", "native": "Bosanski", "code": "bs_BA"},
  {"name": "Bulgarian", "native": "Български", "code": "bg_BG"},
  {"name": "Catalan", "native": "Català", "code": "ca_ES"},
  {"name": "Cebuano", "native": "Cebuano", "code": "ceb_PH"},
  {"name": "Chinese (Simplified)", "native": "简体中文", "code": "zh_CN"},
  {"name": "Chinese (Traditional)", "native": "繁體中文", "code": "zh_TW"},
  {"name": "Corsican", "native": "Corsu", "code": "co_FR"},
  {"name": "Croatian", "native": "Hrvatski", "code": "hr_HR"},
  {"name": "Czech", "native": "Čeština", "code": "cs_CZ"},
  {"name": "Danish", "native": "Dansk", "code": "da_DK"},
  {"name": "Dutch", "native": "Nederlands", "code": "nl_NL"},
  {"name": "English", "native": "English", "code": "en_US"},
  {"name": "Esperanto", "native": "Esperanto", "code": "eo"},
  {"name": "Estonian", "native": "Eesti", "code": "et_EE"},
  {"name": "Finnish", "native": "Suomi", "code": "fi_FI"},
  {"name": "French", "native": "Français", "code": "fr_FR"},
  {"name": "Frisian", "native": "Frysk", "code": "fy_NL"},
  {"name": "Galician", "native": "Galego", "code": "gl_ES"},
  {"name": "Georgian", "native": "ქართული", "code": "ka_GE"},
  {"name": "German", "native": "Deutsch", "code": "de_DE"},
  {"name": "Greek", "native": "Ελληνικά", "code": "el_GR"},
  {"name": "Gujarati", "native": "ગુજરાતી", "code": "gu_IN"},
  {"name": "Haitian Creole", "native": "Kreyòl ayisyen", "code": "ht_HT"},
  {"name": "Hausa", "native": "Hausa", "code": "ha_NG"},
  {"name": "Hawaiian", "native": "ʻŌlelo Hawaiʻi", "code": "haw_US"},
  {"name": "Hebrew", "native": "עברית", "code": "he_IL"},
  {"name": "Hindi", "native": "हिन्दी", "code": "hi_IN"},
  {"name": "Hmong", "native": "Hmoob", "code": "hmn"},
  {"name": "Hungarian", "native": "Magyar", "code": "hu_HU"},
  {"name": "Icelandic", "native": "Íslenska", "code": "is_IS"},
  {"name": "Igbo", "native": "Asụsụ Igbo", "code": "ig_NG"},
  {"name": "Indonesian", "native": "Bahasa Indonesia", "code": "id_ID"},
  {"name": "Irish", "native": "Gaeilge", "code": "ga_IE"},
  {"name": "Italian", "native": "Italiano", "code": "it_IT"},
  {"name": "Japanese", "native": "日本語", "code": "ja_JP"},
  {"name": "Javanese", "native": "ꦧꦱꦗꦮ", "code": "jv_ID"},
  {"name": "Kannada", "native": "ಕನ್ನಡ", "code": "kn_IN"},
  {"name": "Kazakh", "native": "Қазақ тілі", "code": "kk_KZ"},
  {"name": "Khmer", "native": "ភាសាខ្មែរ", "code": "km_KH"},
  {"name": "Kinyarwanda", "native": "Ikinyarwanda", "code": "rw_RW"},
  {"name": "Korean", "native": "한국어", "code": "ko_KR"},
  {"name": "Kurdish", "native": "Kurdî", "code": "ku_TR"},
  {"name": "Kyrgyz", "native": "Кыргызча", "code": "ky_KG"},
  {"name": "Lao", "native": "ພາສາລາວ", "code": "lo_LA"},
  {"name": "Latin", "native": "Latina", "code": "la"},
  {"name": "Latvian", "native": "Latviešu", "code": "lv_LV"},
  {"name": "Lithuanian", "native": "Lietuvių", "code": "lt_LT"},
  {"name": "Luxembourgish", "native": "Lëtzebuergesch", "code": "lb_LU"},
  {"name": "Macedonian", "native": "Македонски", "code": "mk_MK"},
  {"name": "Malagasy", "native": "Malagasy", "code": "mg_MG"},
  {"name": "Malay", "native": "Bahasa Melayu", "code": "ms_MY"},
  {"name": "Malayalam", "native": "മലയാളം", "code": "ml_IN"},
  {"name": "Maltese", "native": "Malti", "code": "mt_MT"},
  {"name": "Maori", "native": "Māori", "code": "mi_NZ"},
  {"name": "Marathi", "native": "मराठी", "code": "mr_IN"},
  {"name": "Mongolian", "native": "Монгол хэл", "code": "mn_MN"},
  {"name": "Myanmar (Burmese)", "native": "မြန်မာ", "code": "my_MM"},
  {"name": "Nepali", "native": "नेपाली", "code": "ne_NP"},
  {"name": "Norwegian", "native": "Norsk", "code": "no_NO"},
  {"name": "Nyanja (Chichewa)", "native": "Chichewa", "code": "ny_MW"},
  {"name": "Odia (Oriya)", "native": "ଓଡ଼ିଆ", "code": "or_IN"},
  {"name": "Pashto", "native": "پښتو", "code": "ps_AF"},
  {"name": "Persian", "native": "فارسی", "code": "fa_IR"},
  {"name": "Polish", "native": "Polski", "code": "pl_PL"},
  {"name": "Portuguese", "native": "Português", "code": "pt_PT"},
  {"name": "Punjabi", "native": "ਪੰਜਾਬੀ", "code": "pa_IN"},
  {"name": "Romanian", "native": "Română", "code": "ro_RO"},
  {"name": "Russian", "native": "Русский", "code": "ru_RU"},
  {"name": "Samoan", "native": "Gagana Sāmoa", "code": "sm_WS"},
  {"name": "Scots Gaelic", "native": "Gàidhlig", "code": "gd_GB"},
  {"name": "Serbian", "native": "Српски", "code": "sr_RS"},
  {"name": "Sesotho", "native": "Sesotho", "code": "st_ZA"},
  {"name": "Shona", "native": "ChiShona", "code": "sn_ZW"},
  {"name": "Sindhi", "native": "سنڌي", "code": "sd_PK"},
  {"name": "Sinhala (Sinhalese)", "native": "සිංහල", "code": "si_LK"},
  {"name": "Slovak", "native": "Slovenčina", "code": "sk_SK"},
  {"name": "Slovenian", "native": "Slovenščina", "code": "sl_SI"},
  {"name": "Somali", "native": "Soomaali", "code": "so_SO"},
  {"name": "Spanish", "native": "Español", "code": "es_ES"},
  {"name": "Sundanese", "native": "Basa Sunda", "code": "su_ID"},
  {"name": "Swahili", "native": "Kiswahili", "code": "sw_KE"},
  {"name": "Swedish", "native": "Svenska", "code": "sv_SE"},
  {"name": "Tagalog (Filipino)", "native": "Tagalog", "code": "tl_PH"},
  {"name": "Tajik", "native": "Тоҷикӣ", "code": "tg_TJ"},
  {"name": "Tamil", "native": "தமிழ்", "code": "ta_IN"},
  {"name": "Tatar", "native": "Татар", "code": "tt_RU"},
  {"name": "Telugu", "native": "తెలుగు", "code": "te_IN"},
  {"name": "Thai", "native": "ไทย", "code": "th_TH"},
  {"name": "Turkish", "native": "Türkçe", "code": "tr_TR"},
  {"name": "Ukrainian", "native": "Українська", "code": "uk_UA"},
  {"name": "Urdu", "native": "اردو", "code": "ur_PK"},
  {"name": "Uyghur", "native": "ئۇيغۇرچە", "code": "ug_CN"},
  {"name": "Uzbek", "native": "Oʻzbek", "code": "uz_UZ"},
  {"name": "Vietnamese", "native": "Tiếng Việt", "code": "vi_VN"},
  {"name": "Welsh", "native": "Cymraeg", "code": "cy_GB"},
  {"name": "Xhosa", "native": "isiXhosa", "code": "xh_ZA"},
  {"name": "Yiddish", "native": "ייִדיש", "code": "yi"},
  {"name": "Yoruba", "native": "Èdè Yorùbá", "code": "yo_NG"},
  {"name": "Zulu", "native": "isiZulu", "code": "zu_ZA"}
];

class Locales {
  final String name;
  final String native;
  final String code;
  final Locale locale;

  const Locales({
    this.name = "English",
    this.native = "English",
    this.code = "en_US",
    this.locale = const Locale("en", "US"),
  });

  factory Locales.from(Object? source) {
    if (source is! Map || source.isEmpty) return const Locales();
    final name = source["name"];
    final native = source["native"];
    final code = source["code"];
    final c = code is String ? code : "";
    return Locales(
      name: name is String ? name : "",
      native: native is String ? native : "",
      code: c,
      locale: parse(c),
    );
  }

  static Locale parse(String source) {
    return tryParse(source) ?? const Locale("en", "US");
  }

  static Locale? tryParse(String source) {
    if (source.isEmpty || source.trim().length != 5) return null;
    List<String> codes = [];
    if (source.contains("_")) {
      codes = source.split("_");
    } else if (source.contains("-")) {
      codes = source.split("-");
    }
    if (codes.isEmpty) return null;
    final lc = codes.elementAt(0);
    final cc = codes.elementAtOrNull(1);
    return Locale(lc, cc);
  }

  static bool _filter(Map data, Locale locale) {
    final code = data['code'];
    if (code is! String) return false;
    final mLocale = parse(code);
    return mLocale.languageCode == locale.languageCode;
  }

  static String? languageName(String locale) {
    final mLocale = parse(locale);
    return kLanguages.where((e) => _filter(e, mLocale)).firstOrNull?["name"];
  }

  static Iterable<String> languageNames() {
    return kLanguages.map((e) => e["name"] ?? "").where((e) => e.isNotEmpty);
  }

  static String? nativeName(String locale) {
    final mLocale = parse(locale);
    return kLanguages.where((e) => _filter(e, mLocale)).firstOrNull?["native"];
  }

  static Iterable<String> nativeNames() {
    return kLanguages.map((e) => e["native"] ?? "").where((e) => e.isNotEmpty);
  }

  static Iterable<String> codes() {
    return kLanguages.map((e) => e["code"] ?? "").where((e) => e.isNotEmpty);
  }

  Map<String, String> get source {
    return {
      "name": name,
      "native": native,
      "code": code,
    };
  }

  @override
  int get hashCode => name.hashCode ^ native.hashCode ^ locale.hashCode;

  @override
  bool operator ==(Object other) {
    return other is Locales &&
        other.name == name &&
        other.native == native &&
        other.locale == locale;
  }

  @override
  String toString() => "$Locales#$hashCode($code)";
}

extension LocaleHelper on Locale {
  String? get name {
    if (countryCode == null) return Locales.languageName(languageCode);
    return Locales.languageName("${languageCode}_$countryCode");
  }

  String? get nativeName {
    if (countryCode == null) return Locales.nativeName(languageCode);
    return Locales.nativeName("${languageCode}_$countryCode");
  }
}
