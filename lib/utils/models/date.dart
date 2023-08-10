part of 'models.dart';

class Date {
  final int year;
  final int month;
  final int day;

  Date({
    int? year,
    int? month,
    int? day,
  })  : year = year ?? _current.year,
        month = month ?? _current.month,
        day = day ?? _current.day;

  const Date.none()
      : year = 0,
        month = 0,
        day = 0;

  factory Date.today() => Date();

  factory Date.yesterday() => Date(day: _current.day - 1);

  factory Date.tomorrow() => Date(day: _current.day + 1);

  factory Date.lastDay(int day) => Date(day: _current.day - day);

  factory Date.nextDay(int day) => Date(day: _current.day + day);

  factory Date.lastMonth([int day = 0]) {
    return Date(
      month: _current.month - 1,
      day: _current.day - day,
    );
  }

  factory Date.nextMonth([int day = 0]) {
    return Date(
      month: _current.month + 1,
      day: _current.day + day,
    );
  }

  factory Date.lastYear({
    int month = 0,
    int day = 0,
  }) {
    return Date(
      year: _current.year - 1,
      month: _current.month - month,
      day: _current.day - day,
    );
  }

  factory Date.nextYear({
    int month = 0,
    int day = 0,
  }) {
    return Date(
      year: _current.year + 1,
      month: _current.month + month,
      day: _current.day + day,
    );
  }

  factory Date.lastDate({
    int year = 0,
    int month = 0,
    int day = 0,
  }) {
    return Date(
      year: _current.year - year,
      month: _current.month - month,
      day: _current.day - day,
    );
  }

  factory Date.nextDate({
    int year = 0,
    int month = 0,
    int day = 0,
  }) {
    return Date(
      year: _current.year + year,
      month: _current.month + month,
      day: _current.day + day,
    );
  }

  factory Date.fromDateTime(DateTime dateTime) {
    return Date(year: dateTime.year, month: dateTime.month, day: dateTime.day);
  }

  factory Date.from(Object? source) {
    return Date(
      year: source.entityValue("year"),
      month: source.entityValue("month"),
      day: source.entityValue("day"),
    );
  }

  static DateTime get _current => DateTime.now();

  Map<String, dynamic> get source {
    return {
      "year": year,
      "month": month,
      "day": day,
    };
  }

  int get asMilliseconds => asDateTime.millisecondsSinceEpoch;

  DateTime get asDateTime {
    return DateTime.utc(year, month, day);
  }

  Date operator +(Date other) {
    return Date(
      year: year + other.year,
      month: month + other.month,
      day: day + other.day,
    );
  }

  Date operator -(Date other) {
    return Date(
      year: year - other.year,
      month: month - other.month,
      day: day - other.day,
    );
  }

  @override
  String toString() => source.toString();

  DateTime toDateTime(Time time) {
    return DateTime(
      year,
      month,
      day,
      time.hour,
      time.minute,
      time.second,
    );
  }

  int toMilliseconds(Time time) => toDateTime(time).millisecondsSinceEpoch;
}

final class DateSchedule extends Scheduler<Date> {
  const DateSchedule({
    required super.start,
    super.end,
  });

  factory DateSchedule.from(Map<String, dynamic> source) {
    var start = source.entityObject("start", (value) => Date.from(value));
    var end = source.entityObject("end", (value) => Date.from(value));
    return DateSchedule(
      start: start ?? const Date.none(),
      end: end ?? const Date.none(),
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
  Date get difference => end - start;
}
