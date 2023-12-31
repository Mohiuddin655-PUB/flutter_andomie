part of 'extensions.dart';

extension DurationException on Duration? {
  Duration get use => this ?? Duration.zero;

  bool get isValid => use != Duration.zero;

  bool get isNotValid => !isValid;

  int get inCurrentDays => use.inDays;

  int get inCurrentHours => use.inHours - (use.inDays * 24);

  int get inCurrentMinutes => use.inMinutes - (use.inHours * 60);

  int get inCurrentSeconds => use.inSeconds - (use.inMinutes * 60);

  int get inCurrentMilliseconds => use.inMilliseconds - (use.inSeconds * 1000);

  int get inCurrentMicroseconds {
    return use.inMicroseconds - (use.inMilliseconds * 1000);
  }

  String get text => toText();

  String toText({
    String separator = ":",
  }) {
    final m = use.inCurrentMinutes.x2D;
    final s = use.inCurrentSeconds.x2D;
    if (use.inHours > 0) {
      return "${use.inHours.x2D}$separator$m$separator$s";
    } else {
      return "$m$separator$s";
    }
  }
}
