part of 'enums.dart';

enum SearchType {
  none("none"),
  audio("audio"),
  photo("photo"),
  post("post"),
  user("user"),
  video("video"),
  wallpaper("wallpaper");

  final String value;

  const SearchType(this.value);
}
