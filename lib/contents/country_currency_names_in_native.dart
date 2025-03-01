const kCountryCurrencyNamesInNative = {
  "IN": "भारतीय रुपया",
  "CN": "人民币",
  "US": "Dollar",
  "ID": "Rupiah Indonesia",
  "PK": "پاکستانی روپیہ",
  "NG": "Naira",
  "BR": "Real Brasileiro",
  "BD": "টাকা",
  "RU": "Рубль",
  "ET": "Birr",
  "MX": "Peso Mexicano",
  "JP": "円",
  "EG": "جنيه مصري",
  "PH": "Piso",
  "CD": "Franc Congolais",
  "VN": "Đồng",
  "IR": "ریال",
  "TR": "Türk Lirası",
  "DE": "Euro",
  "TH": "บาท",
  "GB": "Pound Sterling",
  "TZ": "Shilling Tanzanian",
  "FR": "Euro",
  "ZA": "Rand",
  "IT": "Euro",
  "KE": "Shilling Kenyalı",
  "MM": "ကျပ်",
  "CO": "Peso Colombiano",
  "KR": "원",
  "SD": "جنيه سوداني",
  "UG": "Shilling Ugandan",
  "ES": "Euro",
  "DZ": "دينار جزائري",
  "IQ": "دينار عراقي",
  "AR": "Peso Argentino",
  "AF": "افغانی",
  "YE": "ريال يمني",
  "CA": "Dollar canadien",
  "PL": "Złoty",
  "MA": "درهم مغربي",
  "AO": "Kwanza Angolano",
  "UA": "Гривня",
  "UZ": "Oʻzbek so‘mi",
  "MY": "Ringgit Malaysia",
  "MZ": "Metical Moçambicano",
  "GH": "Cedi",
  "PE": "Nuevo Sol",
  "SA": "ريال سعودي",
  "MG": "Ariary",
  "CI": "Franc CFA",
  "NP": "रुपैया",
  "CM": "Franc CFA",
  "VE": "Bolívar venezolano",
  "NE": "Franc CFA",
  "AU": "Dollar australien",
  "KP": "원",
  "SY": "ليرة سورية",
  "ML": "Franc CFA",
  "BF": "Franc CFA",
  "LK": "රුපියල්",
  "MW": "Kwacha",
  "ZM": "Kwacha",
  "KZ": "Теңге",
  "TD": "Franc CFA",
  "CL": "Peso Chileno",
  "RO": "Leu",
  "SO": "Shilling Soomali",
  "SN": "Franc CFA",
  "GT": "Quetzal Guatemalteco",
  "NL": "Euro",
  "EC": "Dollar estadounidense",
  "KH": "Riel Camboyano",
  "ZW": "Dollar zimbabuense",
  "GN": "Franco guineano",
  "BJ": "Franc CFA",
  "RW": "Franco ruandese",
  "BI": "Franco burundés",
  "BO": "Boliviano",
  "TN": "Dinar tunecino",
  "SS": "South Sudanese Pound",
  "HT": "Gourde haïtien",
  "BE": "Euro",
  "JO": "دينار أردني",
  "DO": "Peso Dominicano",
  "AE": "درهم إماراتي",
  "CU": "Peso cubano",
  "HN": "Lempira",
  "CZ": "Koruna",
  "SE": "Krona",
  "TJ": "Somoni",
  "PG": "Kina",
  "PT": "Euro",
  "AZ": "Manat Azərbaycan",
  "GR": "Ευρώ",
  "HU": "Forint",
  "TG": "Franc CFA",
  "IL": "שקל חדש",
  "AT": "Euro",
  "BY": "Рубель",
  "CH": "Franken",
  "SL": "Leone",
  "LA": "Kip",
  "TM": "Manat Türkmenistan",
  "LY": "دينار ليبي",
  "KG": "Сом",
  "PY": "Guaraní paraguayo",
  "NI": "Córdoba",
  "BG": "Лев",
  "RS": "Динар",
  "SV": "Colón",
  "CG": "Franc CFA",
  "DK": "Krone",
  "SG": "Dollar Singapura",
  "LB": "جنيه لبناني",
  "FI": "Euro",
  "LR": "Dollar liberiano",
  "NO": "Krone",
  "SK": "Koruna slovenská",
  "PS": "שקל חדש",
  "CF": "Franc CFA",
  "OM": "ريال عماني",
  "IE": "Euro",
  "NZ": "Dollar néo-zélandais",
  "MR": "ريال عماني",
  "CR": "Colón costarricense",
  "KW": "دينار كويتي",
  "PA": "Balboa",
  "HR": "Kuna",
  "GE": "lari",
  "ER": "Nakfa",
  "MN": "Tugrik",
  "UY": "Peso uruguayo",
  "BA": "Konvertibilna marka",
  "QA": "ريال قطري",
  "MD": "Leu moldovenesc",
  "NA": "Dollar namibio",
  "AM": "դրամ",
  "LT": "Euras",
  "JM": "Dollar jamaïcain",
  "AL": "Leku",
  "GM": "Dalasi",
  "GA": "Franc CFA",
  "BW": "Pula",
  "LS": "Loti",
  "GW": "Franco guineano",
  "SI": "Euro",
  "GQ": "Franc CFA",
  "LV": "Euro",
  "MK": "Денар",
  "BH": "دينار بحريني",
  "TT": "Dollar de Trinité-et-Tobago",
  "TL": "Metical",
  "EE": "Euro",
  "CY": "Pound chypriote",
  "MU": "Roupie mauricienne",
  "SZ": "Lilangeni",
  "DJ": "Franc djiboutien",
  "FJ": "Dollar fidjien",
  "KM": "Franc comorien",
  "GY": "Dollar guyanien",
  "SB": "Dollar des îles Salomon",
  "BT": "Ngultrum",
  "LU": "Franc luxembourgeois",
  "ME": "Euro",
  "SR": "Dollar surinamien",
  "MT": "Euro",
  "MV": "Rufiyaa",
  "FM": "Dollar micronésien",
  "CV": "Escudo caboverdiano",
  "BN": "Dollar de Brunei",
  "BZ": "Dollar bélizien",
  "BS": "Dollar bahaméen",
  "IS": "Króna",
  "VU": "Vatu",
  "BB": "Dollar barbadien",
  "ST": "Dobra",
  "WS": "Tala",
  "LC": "Dollar des Caraïbes orientales",
  "KI": "Dollar australien",
  "SC": "Roupie seychelloise",
  "GD": "Dollar des Caraïbes orientales",
  "TO": "Paʻanga",
  "VC": "Dollar des Caraïbes orientales",
  "AG": "Dollar des Caraïbes orientales",
  "AD": "Euro",
  "DM": "Dollar des Caraïbes orientales",
  "KN": "Dollar des Caraïbes orientales",
  "LI": "Franc suisse",
  "MC": "Euro",
  "MH": "Dollar des États-Unis",
  "SM": "Euro",
  "PW": "Dollar des États-Unis",
  "NR": "Dollar australien",
  "TV": "Dollar australien",
  "VA": "Euro",
  "TW": "新臺幣"
};
