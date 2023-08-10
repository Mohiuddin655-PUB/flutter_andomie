part of 'models.dart';

class Schedule {
  final int start;
  final int end;

  static DateTime toDateTime(DateTime date, TimeOfDay time) {
    return DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
  }

  static int toMilliseconds(DateTime date, TimeOfDay time) {
    return toDateTime(date, time).millisecondsSinceEpoch;
  }

  const Schedule({
    this.start = 0,
    int? end,
  }) : end = end ?? start;

  factory Schedule.fromDateTime(DateTime starting, [DateTime? ending]) {
    var start = starting.millisecondsSinceEpoch;
    var end = ending?.millisecondsSinceEpoch ?? start;
    return Schedule(
      start: start,
      end: end,
    );
  }

  factory Schedule.from(Object? source) {
    return Schedule(
      start: source.entityValue("start") ?? 0,
      end: source.entityValue("end") ?? 0,
    );
  }

  Map<String, dynamic> get source {
    return {
      "start": start,
      "end": end,
    };
  }
}
