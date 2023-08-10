part of 'models.dart';

class Time {
  final int hour;
  final int minute;
  final TimePeriod period;

  const Time({
    required int hour,
    required this.minute,
    TimePeriod? period,
  })  : hour = hour > 12 ? hour - 12 : hour,
        period = period ?? (hour > 12 ? TimePeriod.pm : TimePeriod.am);

  const Time.none()
      : hour = 0,
        minute = 0,
        period = TimePeriod.am;

  factory Time.custom({
    int? hour,
    int? minute,
    TimePeriod? period,
  }) {
    return Time(
      hour: hour ?? 0,
      minute: minute ?? 0,
      period: period,
    );
  }

  factory Time.from(Object? source) {
    return Time(
      hour: source.entityValue("hour") ?? 0,
      minute: source.entityValue("hour") ?? 0,
    );
  }

  int get hourAs24 => period.isPM ? hour + 12 : hour;

  Map<String, dynamic> get source {
    return {
      "hour": hourAs24,
      "minute": minute,
    };
  }

  @override
  String toString() => toStringHMa();

  String toStringHM([String separator = ":"]) {
    return "${hour.x2D}$separator${minute.x2D}";
  }

  String toStringHMa([String separator = ":"]) {
    return "${toStringHM(separator)} ${period.value}";
  }
}

extension TimeExtension on Time? {
  Time get use => this ?? const Time.none();

  String get asStringHM => "${use.hour.x2D}:${use.minute.x2D}";

  String get asStringHMa => "$asStringHM ${use.period.value}";
}

enum TimePeriod {
  am("AM"),
  pm("PM");

  final String value;

  const TimePeriod(this.value);

  factory TimePeriod.from(String? source) {
    if (source == am.name || source == am.value) {
      return am;
    } else {
      return pm;
    }
  }
}

extension TimePeriodExtension on TimePeriod? {
  TimePeriod get use => this ?? TimePeriod.am;

  bool get isAM => this == TimePeriod.am;

  bool get isPM => this == TimePeriod.pm;
}

extension _TimeFormatExtension on int {
  String get x2D => this >= 10 ? "$this" : "0$this";
}

class TimeSchedule {
  final Time start;
  final Time end;

  const TimeSchedule({
    this.start = const Time.none(),
    this.end = const Time.none(),
  });

  factory TimeSchedule.from(Map<String, dynamic> source) {
    var start = source.entityObject("start", (value) => Time.from(value));
    var end = source.entityObject("end", (value) => Time.from(value));
    return TimeSchedule(
      start: start ?? const Time.none(),
      end: end ?? const Time.none(),
    );
  }

  Map<String, dynamic> get source {
    return {
      "start": start,
      "end": end,
    };
  }
}
