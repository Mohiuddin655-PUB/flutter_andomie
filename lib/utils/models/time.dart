part of 'models.dart';

class Time {
  final int hour;
  final int minute;
  final int second;

  Time({
    int? hour,
    int? minute,
    int? second,
  })  : hour = hour ?? _current.hour,
        minute = minute ?? _current.minute,
        second = second ?? _current.second;

  const Time.none()
      : hour = 0,
        minute = 0,
        second = 0;

  factory Time.now() => Time();

  factory Time.last5M([
    int second = 0,
  ]) {
    return Time(
      minute: _current.minute - 5,
      second: _current.second - second,
    );
  }

  factory Time.next5M([
    int second = 0,
  ]) {
    return Time(
      minute: _current.minute + 5,
      second: _current.second + second,
    );
  }

  factory Time.last10M([
    int second = 0,
  ]) {
    return Time(
      minute: _current.minute - 10,
      second: _current.second - second,
    );
  }

  factory Time.next10M([
    int second = 0,
  ]) {
    return Time(
      minute: _current.minute + 10,
      second: _current.second + second,
    );
  }

  factory Time.last15M([
    int second = 0,
  ]) {
    return Time(
      minute: _current.minute - 15,
      second: _current.second - second,
    );
  }

  factory Time.next15M([
    int second = 0,
  ]) {
    return Time(
      minute: _current.minute + 15,
      second: _current.second + second,
    );
  }

  factory Time.lastHalfHour([
    int second = 0,
  ]) {
    return Time(
      minute: _current.minute - 30,
      second: _current.second - second,
    );
  }

  factory Time.nextHalfHour([
    int second = 0,
  ]) {
    return Time(
      minute: _current.minute + 30,
      second: _current.second + second,
    );
  }

  factory Time.lastHour({
    int minute = 0,
    int second = 0,
  }) {
    return Time(
      hour: _current.hour - 1,
      minute: _current.minute - minute,
      second: _current.second - second,
    );
  }

  factory Time.nextHour({
    int minute = 0,
    int second = 0,
  }) {
    return Time(
      hour: _current.hour + 1,
      minute: _current.minute + minute,
      second: _current.second + second,
    );
  }

  factory Time.lastTime({
    int hour = 0,
    int minute = 0,
    int second = 0,
  }) {
    return Time(
      hour: _current.hour - hour,
      minute: _current.minute - minute,
      second: _current.second - second,
    );
  }

  factory Time.nextTime({
    int hour = 0,
    int minute = 0,
    int second = 0,
  }) {
    return Time(
      hour: _current.hour + hour,
      minute: _current.minute + minute,
      second: _current.second + second,
    );
  }

  factory Time.fromTimeOfDay(TimeOfDay timeOfDay) {
    return Time(hour: timeOfDay.hour, minute: timeOfDay.minute);
  }

  factory Time.fromDateTime(DateTime dateTime) {
    return Time(
      hour: dateTime.hour,
      minute: dateTime.minute,
      second: dateTime.second,
    );
  }

  factory Time.from(Object? source) {
    return Time(
      hour: source.entityValue("hour"),
      minute: source.entityValue("minute"),
      second: source.entityValue("second"),
    );
  }

  static DateTime get _current => DateTime.now();

  int get milliseconds {
    return DateTime.utc(0, 0, 0, hour, minute, second).millisecondsSinceEpoch;
  }

  Map<String, dynamic> get source {
    return {
      "hour": hour,
      "minute": minute,
      "second": second,
    };
  }

  Time operator +(Time other) {
    return Time(
      hour: hour + other.hour,
      minute: minute + other.minute,
      second: second + other.second,
    );
  }

  Time operator -(Time other) {
    return Time(
      hour: hour - other.hour,
      minute: minute - other.minute,
      second: second - other.second,
    );
  }

  TimeOfDay get asTimeOfDay => TimeOfDay(hour: hour, minute: minute);

  DateTime get asDateTime {
    return DateTime.utc(
      _current.year,
      _current.month,
      _current.day,
      hour,
      minute,
      second,
    );
  }

  String get asString => toString();

  @override
  String toString() => toStringHMa();

  String toStringHM([String separator = ":"]) {
    return "${asTimeOfDay.hourOfPeriod.x2D}$separator${minute.x2D}";
  }

  String toStringHMa([String separator = ":"]) {
    return "${toStringHM(separator)} ${asTimeOfDay.period.value}";
  }

  DateTime toDateTime(Date date) {
    return DateTime(date.year, date.month, date.day, hour, minute, second);
  }

  int toMilliseconds(Date date) => toDateTime(date).millisecondsSinceEpoch;
}

extension TimePeriodExtension on DayPeriod? {
  DayPeriod get use => this ?? DayPeriod.am;

  bool get isAM => this == DayPeriod.am;

  bool get isPM => this == DayPeriod.pm;

  String get value => isPM ? "PM" : "AM";
}

extension _TimeFormatExtension on int {
  String get x2D => this >= 10 ? "$this" : "0$this";
}

class TimeSchedule extends Scheduler<Time> {
  const TimeSchedule({
    required super.start,
    super.end,
  });

  factory TimeSchedule.from(Map<String, dynamic> source) {
    var start = source.entityObject("start", (value) => Time.from(value));
    var end = source.entityObject("end", (value) => Time.from(value));
    return TimeSchedule(
      start: start ?? const Time.none(),
      end: end ?? const Time.none(),
    );
  }

  @override
  Map<String, dynamic> get source {
    return {
      "start": start.source,
      "end": end.source,
    };
  }

  @override
  Time get difference => end - start;
}
