part of '../utils.dart';

enum TimeFormats {
  hour("hh"),
  minute("mm"),
  second("ss"),
  zone("TZD"),
  timeMS("mm:ss"),
  timeHM("hh:mm"),
  timeHMa("hh:mm a"),
  timeHMSa("hh:mm:ss a"),
  timeHMSZone("hh:mm:ss TZD"),
  none("");

  final String value;

  const TimeFormats(this.value);
}

enum DateFormats {
  day("dd"),
  dayFullName("EEEE"),
  dayShortName("EE"),
  month("MM"),
  monthFullName("MMMM"),
  monthShortName("MMM"),
  yearFull("yyyy"),
  yearShort("yy"),
  dateDMY("dd-MM-yyyy"),
  dateDMCY("dd MMMM, yyyy"),
  dateMDCY("MMMM dd, yyyy"),
  dateYMD("yyyy-MM-dd"),
  dateECDMCY("EEEE, dd MMMM, yyyy"),
  dateECMDCY("EEEE, dd MMMM, yyyy"),
  none("");

  final String value;

  const DateFormats(this.value);
}

class Realtime {
  final bool today;
  final bool tomorrow;
  final bool yesterday;
  final int days;
  final int hours;
  final int minutes;
  final int seconds;
  final int milliseconds;
  final int microseconds;

  int get afterHours => hours * -1;

  int get afterMinutes => minutes * -1;

  int get afterSeconds => seconds * -1;

  int get afterMilliseconds => milliseconds * -1;

  int get afterMicroseconds => microseconds * -1;

  const Realtime({
    this.today = false,
    this.tomorrow = false,
    this.yesterday = false,
    this.days = 0,
    this.hours = 0,
    this.minutes = 0,
    this.seconds = 0,
    this.milliseconds = 0,
    this.microseconds = 0,
  });

  factory Realtime.fromDuration(Duration duration) {
    var a = duration.inCurrentDays;
    var isToday = a == 0;
    var isTomorrow = a == 1;
    var isYesterday = a == -1;

    return Realtime(
      today: isToday,
      tomorrow: isTomorrow,
      yesterday: isYesterday,
      days: duration.inCurrentDays,
      hours: duration.inCurrentHours,
      minutes: duration.inCurrentMinutes,
      seconds: duration.inCurrentSeconds,
      milliseconds: duration.inCurrentMilliseconds,
      microseconds: duration.inCurrentMicroseconds,
    );
  }

  factory Realtime.fromDateTime(DateTime dateTime) {
    return Realtime.fromDuration(
      DateTime.now().difference(dateTime),
    );
  }

  bool get isHourMode => hours > 0;

  bool get isMinuteMode => minutes > 0;

  bool get isSecondMode => seconds > 0;

  bool get isAfterHourMode => afterHours > 0;

  bool get isAfterMinuteMode => afterMinutes > 0;

  bool get isAfterSecondMode => afterSeconds > 0;
}

class RealtimeTextFormat {
  final String after;
  final String ago;
  final String now;
  final String today;
  final String tomorrow;
  final String yesterday;
  final TextFormat second;
  final TextFormat minute;
  final TextFormat hour;

  const RealtimeTextFormat({
    this.after = "After",
    this.ago = "ago",
    this.now = "Now",
    this.today = "Today",
    this.tomorrow = "Tomorrow",
    this.yesterday = "Yesterday",
    this.second = const TextFormat(
      singular: "second",
      plural: "seconds",
    ),
    this.minute = const TextFormat(
      singular: "minute",
      plural: "minutes",
    ),
    this.hour = const TextFormat(
      singular: "hour",
      plural: "hours",
    ),
  });
}

class DateProvider {
  const DateProvider._();

  static int get currentMS {
    return DateTime.now().millisecondsSinceEpoch;
  }

  static int get currentDay {
    return DateTime.now().day;
  }

  static int get currentMonth {
    return DateTime.now().month;
  }

  static int get currentYear {
    return DateTime.now().year;
  }

  static int toDay(int timeMills) {
    return DateTime.fromMillisecondsSinceEpoch(timeMills).day;
  }

  static int toMonth(int timeMills) {
    return DateTime.fromMillisecondsSinceEpoch(timeMills).month;
  }

  static int toYear(int timeMills) {
    return DateTime.fromMillisecondsSinceEpoch(timeMills).year;
  }

  static String toDate(
    int ms, {
    String? format,
    String? local,
    TimeFormats? timeFormat,
    DateFormats dateFormat = DateFormats.dateDMCY,
    String? separator,
  }) {
    return ms.toDate(
      format: format,
      local: local,
      timeFormat: timeFormat,
      dateFormat: dateFormat,
      separator: separator,
    );
  }

  static String toDateFromUTC(
    int year,
    int month,
    int day, [
    TimeFormats timeFormat = TimeFormats.none,
    DateFormats dateFormat = DateFormats.none,
    String? pattern,
    String separator = "",
    String? local,
  ]) {
    if ((year + month + day) > 0) {
      return DateTime.utc(year, month, day).toDate(
        timeFormat: timeFormat,
        dateFormat: dateFormat,
        format: pattern,
        separator: separator,
        local: local,
      );
    } else {
      return '';
    }
  }

  static int toMSFromUTC(
    int year, [
    int month = 1,
    int day = 1,
    int hour = 0,
    int minute = 0,
    int second = 0,
  ]) {
    return DateTime.utc(
      year,
      month - 1,
      day,
      hour,
      minute,
      second,
    ).millisecond;
  }

  static int toMSFromSource(String? source) {
    return DateTime.tryParse(source ?? "")?.millisecond ?? 0;
  }

  static bool isToday(int? ms) => ms.isToday;

  static bool isTomorrow(int? ms) => ms.isTomorrow;

  static bool isYesterday(int? ms) => ms.isYesterday;

  static String realtime(int? ms) => toRealtime(ms);

  static String toRealtime(
    int? ms, {
    bool showRealtime = true,
    int whenShowNow = 10,
    String? format,
    String? local,
    TimeFormats timeFormat = TimeFormats.timeHMa,
    DateFormats dateFormat = DateFormats.dateDMCY,
    String separator = " at ",
    RealtimeTextFormat textFormat = const RealtimeTextFormat(),
    String Function(Realtime value)? onRealtime,
    String Function(Realtime value)? onRealtimeByHours,
    String Function(Realtime value)? onRealtimeByMinutes,
    String Function(Realtime value)? onRealtimeBySeconds,
    String Function(Realtime value)? onRealtimeByAfterHours,
    String Function(Realtime value)? onRealtimeByAfterMinutes,
    String Function(Realtime value)? onRealtimeByAfterSeconds,
    String Function(Realtime value, String time)? onRealtimeByTomorrow,
    String Function(Realtime value, String time)? onRealtimeByToday,
    String Function(Realtime value, String time)? onRealtimeByYesterday,
  }) {
    var time = DateTime.fromMillisecondsSinceEpoch(ms ?? 0);
    var realtime = Realtime.fromDateTime(time);

    /// for yesterday time
    if (time.isYesterday) {
      var yesterdayTime = time.toDate(
        timeFormat: timeFormat,
        dateFormat: DateFormats.none,
        local: local,
      );
      if (onRealtimeByYesterday != null) {
        return onRealtimeByYesterday(realtime, yesterdayTime);
      } else {
        return "${textFormat.yesterday}$separator$yesterdayTime";
      }
    }

    /// for today time
    else if (time.isToday) {
      ///
      /// for realtime
      if (showRealtime) {
        ///
        /// for hours
        if (realtime.isHourMode) {
          if (onRealtimeByHours != null) {
            return onRealtimeByHours(realtime);
          } else {
            int _ = realtime.hours;
            return "$_ ${textFormat.hour.getText(_)} ${textFormat.ago}";
          }
        }

        /// for minutes
        else if (realtime.isMinuteMode) {
          if (onRealtimeByMinutes != null) {
            return onRealtimeByMinutes(realtime);
          } else {
            int _ = realtime.minutes;
            return "$_ ${textFormat.minute.getText(_)} ${textFormat.ago}";
          }
        }

        /// for after hours
        else if (realtime.isAfterHourMode) {
          if (onRealtimeByAfterHours != null) {
            return onRealtimeByAfterHours(realtime);
          } else {
            int _ = realtime.afterHours;
            return "${textFormat.after} $_ ${textFormat.hour.getText(_)}";
          }
        }

        /// for after minutes
        else if (realtime.isAfterMinuteMode) {
          if (onRealtimeByAfterMinutes != null) {
            return onRealtimeByAfterMinutes(realtime);
          } else {
            int _ = realtime.afterMinutes;
            return "${textFormat.after} $_ ${textFormat.minute.getText(_)}";
          }
        }

        /// for after seconds
        else if (realtime.isAfterSecondMode) {
          if (onRealtimeByAfterSeconds != null) {
            return onRealtimeByAfterSeconds(realtime);
          } else {
            int _ = realtime.afterSeconds;
            return "${textFormat.after} $_ ${textFormat.second.getText(_)}";
          }
        }

        /// for seconds
        else {
          if (onRealtimeBySeconds != null) {
            return onRealtimeBySeconds(realtime);
          } else {
            int _ = realtime.seconds;
            if (whenShowNow < _) {
              return "$_ ${textFormat.second.getText(_)} ${textFormat.ago}";
            } else {
              return textFormat.now;
            }
          }
        }
      }

      /// for today default time
      else {
        var todayTime = time.toDate(
          timeFormat: timeFormat,
          dateFormat: DateFormats.none,
          local: local,
        );
        if (onRealtimeByToday != null) {
          return onRealtimeByToday(realtime, todayTime);
        } else {
          return "${textFormat.today}$separator$todayTime";
        }
      }
    }

    /// for tomorrow time
    else if (time.isTomorrow) {
      var tomorrowTime = time.toDate(
        timeFormat: timeFormat,
        dateFormat: DateFormats.none,
        local: local,
      );
      if (onRealtimeByTomorrow != null) {
        return onRealtimeByTomorrow(realtime, tomorrowTime);
      } else {
        return "${textFormat.tomorrow}$separator$tomorrowTime";
      }
    }

    /// for default time
    else {
      return time.toDate(
        timeFormat: timeFormat,
        dateFormat: dateFormat,
        format: format,
        separator: separator,
        local: local,
      );
    }
  }
}

extension DurationExtension on Duration {
  int get inCurrentDays => inDays;

  int get inCurrentHours => inHours - (inDays * 24);

  int get inCurrentMinutes => inMinutes - (inHours * 60);

  int get inCurrentSeconds => inSeconds - (inMinutes * 60);

  int get inCurrentMilliseconds => inMilliseconds - (inSeconds * 1000);

  int get inCurrentMicroseconds => inMicroseconds - (inMilliseconds * 1000);
}

extension TimeFormatExtension on TimeFormats? {
  String get use => this?.value ?? "";

  bool get isUsable => use.isNotEmpty;
}

extension DateFormatExtension on DateFormats? {
  String get use => this?.value ?? "";

  bool get isUsable => use.isNotEmpty;
}

extension TimeExtension on int? {
  int get _v => this ?? 0;

  bool get isToday => DateTime.fromMillisecondsSinceEpoch(_v).isToday;

  bool get isTomorrow => DateTime.fromMillisecondsSinceEpoch(_v).isTomorrow;

  bool get isYesterday => DateTime.fromMillisecondsSinceEpoch(_v).isYesterday;

  String get realtime => toRealtime();

  String toDate({
    String? format,
    String? local,
    TimeFormats? timeFormat,
    DateFormats dateFormat = DateFormats.dateDMCY,
    String? separator,
  }) {
    return DateTime.fromMillisecondsSinceEpoch(_v).toDate(
      timeFormat: timeFormat,
      dateFormat: dateFormat,
      format: format,
      separator: separator,
      local: local,
    );
  }

  String toRealtime({
    bool showRealtime = true,
    int whenShowNow = 10,
    String? format,
    String? local,
    TimeFormats timeFormat = TimeFormats.timeHMa,
    DateFormats dateFormat = DateFormats.dateDMCY,
    String separator = " at ",
    RealtimeTextFormat textFormat = const RealtimeTextFormat(),
    String Function(Realtime value)? onRealtime,
    String Function(Realtime value)? onRealtimeByHours,
    String Function(Realtime value)? onRealtimeByMinutes,
    String Function(Realtime value)? onRealtimeBySeconds,
    String Function(Realtime value)? onRealtimeByAfterHours,
    String Function(Realtime value)? onRealtimeByAfterMinutes,
    String Function(Realtime value)? onRealtimeByAfterSeconds,
    String Function(Realtime value, String time)? onRealtimeByTomorrow,
    String Function(Realtime value, String time)? onRealtimeByToday,
    String Function(Realtime value, String time)? onRealtimeByYesterday,
  }) {
    return DateProvider.toRealtime(
      this,
      showRealtime: showRealtime,
      whenShowNow: whenShowNow,
      format: format,
      local: local,
      timeFormat: timeFormat,
      dateFormat: dateFormat,
      separator: separator,
      textFormat: textFormat,
      onRealtime: onRealtime,
      onRealtimeByHours: onRealtimeByHours,
      onRealtimeByMinutes: onRealtimeByMinutes,
      onRealtimeBySeconds: onRealtimeBySeconds,
      onRealtimeByAfterHours: onRealtimeByAfterHours,
      onRealtimeByAfterMinutes: onRealtimeByAfterMinutes,
      onRealtimeByAfterSeconds: onRealtimeByAfterSeconds,
      onRealtimeByTomorrow: onRealtimeByTomorrow,
      onRealtimeByToday: onRealtimeByToday,
      onRealtimeByYesterday: onRealtimeByYesterday,
    );
  }
}

extension DateExtension on DateTime? {
  DateTime get _v => this ?? DateTime.now();

  bool get isToday => isDay(DateTime.now());

  bool get isNow => isDay(DateTime.now());

  bool get isTomorrow {
    return isDay(DateTime.now().add(const Duration(days: 1)));
  }

  bool get isYesterday {
    return isDay(DateTime.now().subtract(const Duration(days: 1)));
  }

  String get realtime => toRealtime();

  bool isDay(DateTime now) {
    return now.day == _v.day && now.month == _v.month && now.year == _v.year;
  }

  String toDate({
    String? format,
    String? local,
    TimeFormats? timeFormat,
    DateFormats dateFormat = DateFormats.dateDMCY,
    String? separator,
  }) {
    if ((format ?? "").isEmpty) {
      if (timeFormat.isUsable && dateFormat.isUsable) {
        format = "${dateFormat.use}'${separator ?? ' '}'${timeFormat.use}";
      } else if (timeFormat.isUsable) {
        format = timeFormat.use;
      } else {
        format = dateFormat.use;
      }
    }
    return DateFormat(format, local).format(_v);
  }

  String toRealtime({
    bool showRealtime = true,
    int whenShowNow = 10,
    String? format,
    String? local,
    TimeFormats timeFormat = TimeFormats.timeHMa,
    DateFormats dateFormat = DateFormats.dateDMCY,
    String separator = " at ",
    RealtimeTextFormat textFormat = const RealtimeTextFormat(),
    String Function(Realtime value)? onRealtime,
    String Function(Realtime value)? onRealtimeByHours,
    String Function(Realtime value)? onRealtimeByMinutes,
    String Function(Realtime value)? onRealtimeBySeconds,
    String Function(Realtime value)? onRealtimeByAfterHours,
    String Function(Realtime value)? onRealtimeByAfterMinutes,
    String Function(Realtime value)? onRealtimeByAfterSeconds,
    String Function(Realtime value, String time)? onRealtimeByTomorrow,
    String Function(Realtime value, String time)? onRealtimeByToday,
    String Function(Realtime value, String time)? onRealtimeByYesterday,
  }) {
    return DateProvider.toRealtime(
      this?.millisecondsSinceEpoch,
      showRealtime: showRealtime,
      whenShowNow: whenShowNow,
      format: format,
      local: local,
      timeFormat: timeFormat,
      dateFormat: dateFormat,
      separator: separator,
      textFormat: textFormat,
      onRealtime: onRealtime,
      onRealtimeByHours: onRealtimeByHours,
      onRealtimeByMinutes: onRealtimeByMinutes,
      onRealtimeBySeconds: onRealtimeBySeconds,
      onRealtimeByAfterHours: onRealtimeByAfterHours,
      onRealtimeByAfterMinutes: onRealtimeByAfterMinutes,
      onRealtimeByAfterSeconds: onRealtimeByAfterSeconds,
      onRealtimeByTomorrow: onRealtimeByTomorrow,
      onRealtimeByToday: onRealtimeByToday,
      onRealtimeByYesterday: onRealtimeByYesterday,
    );
  }
}
