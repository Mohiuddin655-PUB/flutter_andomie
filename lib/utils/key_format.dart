part of '../utils.dart';

class KeyFormat {
  const KeyFormat._();

  static const String allowCapitalCharacters = "QWERTYUIOPASDFGHJKLZXCVBNM";
  static const String allowedSmallCharacters = "qwertyuiopasdfghjklzxcvbn";
  static const String allowedSpecialCharacters = "!@%^&*()_+~`-={}|';:?.,<>";
  static const String allowedNumbers = "0123456789";
  static const String allowedCharacters =
      allowCapitalCharacters + allowedSmallCharacters;
  static const String allowedCharactersWithNumbers =
      allowedCharacters + allowedNumbers;
  static const String allowedCharactersWithSpecials =
      allowedCharacters + allowedSpecialCharacters;
  static const String allowedCapitalCharactersWithNumbers =
      allowCapitalCharacters + allowedNumbers;
  static const String allowedSmallCharactersWithNumbers =
      allowedSmallCharacters + allowedNumbers;
  static const String allowedAllFormat = allowCapitalCharacters +
      allowedSmallCharacters +
      allowedNumbers +
      allowedSpecialCharacters;

  static const String formatDate = "dd MMMM, yyyy";
  static const String formatYMD = "yyyy-MM-dd";

  static const String formatImageNamingDate = "yyMMddhhmmss";
  static const String formatReferenceDate = "yyyy-MM-dd";
}
