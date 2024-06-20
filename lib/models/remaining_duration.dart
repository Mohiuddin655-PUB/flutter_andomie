class RemainingDuration extends Duration {
  int get hours => inHours - (inDays * 24);

  int get minutes => inMinutes - (inHours * 60);

  int get seconds => inSeconds - (inMinutes * 60);

  int get milliseconds => inMilliseconds - (inSeconds * 1000);

  int get microseconds => inMicroseconds - (inMilliseconds * 1000);

  String get hoursAs2D => _x2D(hours);

  String get minutesAs2D => _x2D(minutes);

  String get secondsAs2D => _x2D(seconds);

  String get text => toString();

  const RemainingDuration({
    super.days,
    super.hours,
    super.minutes,
    super.seconds,
    super.milliseconds,
    super.microseconds,
  });

  factory RemainingDuration.from(Duration duration) {
    return RemainingDuration(microseconds: duration.inMicroseconds);
  }

  String _x2D(int value) => value < 10 ? "0$value" : "$value";

  @override
  String toString([String separator = ":"]) {
    final m = minutesAs2D;
    final s = secondsAs2D;
    if (hours > 0) {
      return "$hoursAs2D$separator$m$separator$s";
    } else {
      return "$m$separator$s";
    }
  }
}

extension RemainingDurationHelper on Duration? {
  RemainingDuration get use => RemainingDuration.from(this ?? Duration.zero);

  bool get isValid => use != Duration.zero;

  bool get isNotValid => !isValid;

  int get days => use.inDays;

  int get hours => use.hours;

  int get minutes => use.minutes;

  int get seconds => use.seconds;

  int get milliseconds => use.milliseconds;

  int get microseconds => use.microseconds;

  String get hoursAs2D => use.hoursAs2D;

  String get minutesAs2D => use.minutesAs2D;

  String get secondsAs2D => use.secondsAs2D;

  String get text => toText();

  String toText([String separator = ":"]) => use.toString(separator);
}
