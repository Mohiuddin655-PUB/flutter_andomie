import '../instance.dart';
import '../models/remaining_duration.dart';
import 'text_format.dart';

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
  dateECMDCY("EEEE, MMMM dd, yyyy"),
  none("");

  final String value;

  const DateFormats(this.value);
}

/// Represents a time duration in a human-readable format.
class Realtime {
  /// Indicates if the time is today.
  final bool today;

  /// Indicates if the time is tomorrow.
  final bool tomorrow;

  /// Indicates if the time is yesterday.
  final bool yesterday;

  /// Number of days in the duration.
  final int days;

  /// Number of hours in the duration.
  final int hours;

  /// Number of minutes in the duration.
  final int minutes;

  /// Number of seconds in the duration.
  final int seconds;

  /// Number of milliseconds in the duration.
  final int milliseconds;

  /// Number of microseconds in the duration.
  final int microseconds;

  /// Gets the duration in hours after the specified time.
  int get afterHours => hours * -1;

  /// Gets the duration in minutes after the specified time.
  int get afterMinutes => minutes * -1;

  /// Gets the duration in seconds after the specified time.
  int get afterSeconds => seconds * -1;

  /// Gets the duration in milliseconds after the specified time.
  int get afterMilliseconds => milliseconds * -1;

  /// Gets the duration in microseconds after the specified time.
  int get afterMicroseconds => microseconds * -1;

  /// Constructs a [Realtime] instance with the specified parameters.
  ///
  /// Example:
  ///
  /// ```dart
  /// Realtime myTime = Realtime(
  ///   today: true,
  ///   hours: 2,
  ///   minutes: 30,
  /// );
  /// print(myTime.isHourMode);  // Output: true
  /// ```
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

  /// Constructs a [Realtime] instance from the specified [Duration].
  ///
  /// Example:
  ///
  /// ```dart
  /// Duration myDuration = Duration(hours: 2, minutes: 30);
  /// Realtime myTime = Realtime.fromDuration(myDuration);
  /// print(myTime.isHourMode);  // Output: true
  /// ```
  factory Realtime.fromDuration(Duration duration) {
    var a = duration.days;
    var isToday = a == 0;
    var isTomorrow = a == 1;
    var isYesterday = a == -1;

    return Realtime(
      today: isToday,
      tomorrow: isTomorrow,
      yesterday: isYesterday,
      days: duration.days,
      hours: duration.hours,
      minutes: duration.minutes,
      seconds: duration.seconds,
      milliseconds: duration.milliseconds,
      microseconds: duration.microseconds,
    );
  }

  /// Constructs a [Realtime] instance from the specified [DateTime].
  ///
  /// Example:
  ///
  /// ```dart
  /// DateTime myDateTime = DateTime.now().subtract(Duration(hours: 2, minutes: 30));
  /// Realtime myTime = Realtime.fromDateTime(myDateTime);
  /// print(myTime.isHourMode);  // Output: true
  /// ```
  factory Realtime.fromDateTime(DateTime dateTime) {
    return Realtime.fromDuration(
      DateTime.now().difference(dateTime),
    );
  }

  /// Indicates if the duration represents hours.
  bool get isHourMode => hours > 0;

  /// Indicates if the duration represents minutes.
  bool get isMinuteMode => minutes > 0;

  /// Indicates if the duration represents seconds.
  bool get isSecondMode => seconds > 0;

  /// Indicates if the duration is after the specified number of hours.
  bool get isAfterHourMode => afterHours > 0;

  /// Indicates if the duration is after the specified number of minutes.
  bool get isAfterMinuteMode => afterMinutes > 0;

  /// Indicates if the duration is after the specified number of seconds.
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

/// Provides utility methods related to date and time.
class DateHelper {
  const DateHelper._();

  /// Gets the current time in milliseconds since epoch.
  static int get currentMS {
    return DateTime.now().millisecondsSinceEpoch;
  }

  /// Gets the current day of the month.
  static int get currentDay {
    return DateTime.now().day;
  }

  /// Gets the current month.
  static int get currentMonth {
    return DateTime.now().month;
  }

  /// Gets the current year.
  static int get currentYear {
    return DateTime.now().year;
  }

  static int get weekday => DateTime.now().weekday;

  static bool isWeekday(int day) => weekday == day;

  static DateTime toRecentWeekday(int weekday, [DateTime? initial]) {
    // Get the initial date
    final today = initial ?? DateTime.now();

    // Calculate how many days to subtract to get the recent weekday
    int difference = today.weekday - weekday;

    // If the difference is negative, go back to the previous week
    if (difference < 0) difference += 7;

    // Subtract the difference to get the recent weekday
    return today.subtract(Duration(days: difference));
  }

  /// Converts milliseconds since epoch to the day of the month.
  static int toDay(int timeMills) {
    return DateTime.fromMillisecondsSinceEpoch(timeMills).day;
  }

  /// Converts milliseconds since epoch to the month.
  static int toMonth(int timeMills) {
    return DateTime.fromMillisecondsSinceEpoch(timeMills).month;
  }

  /// Converts milliseconds since epoch to the year.
  static int toYear(int timeMills) {
    return DateTime.fromMillisecondsSinceEpoch(timeMills).year;
  }

  /// Converts milliseconds since epoch to a formatted date string.
  ///
  /// Example:
  ///
  /// ```dart
  /// int myTime = DateProvider.currentMS;
  /// String formattedDate = DateProvider.toDate(myTime, dateFormat: DateFormats.dateDMCY);
  /// print(formattedDate);  // Output: "06-02-2024"
  /// ```
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

  /// Converts UTC components to a formatted date string.
  ///
  /// Example:
  ///
  /// ```dart
  /// String utcDate = DateProvider.toDateFromUTC(2024, 2, 6);
  /// print(utcDate);  // Output: "06-02-2024"
  /// ```
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

  /// Converts UTC components to milliseconds since epoch.
  ///
  /// Example:
  ///
  /// ```dart
  /// int utcMS = DateProvider.toMSFromUTC(2024, 2, 6);
  /// print(utcMS);  // Output: milliseconds since epoch for 06-02-2024
  /// ```
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
    ).millisecondsSinceEpoch;
  }

  /// Converts a date string to milliseconds since epoch.
  ///
  /// Example:
  ///
  /// ```dart
  /// String dateString = "2024-02-06";
  /// int dateMS = DateProvider.toMSFromSource(dateString);
  /// print(dateMS);  // Output: milliseconds since epoch for 06-02-2024
  /// ```
  static int toMSFromSource(String? source) {
    return DateTime.tryParse(source ?? "")?.millisecondsSinceEpoch ?? 0;
  }

  /// Checks if the given milliseconds since epoch represents today.
  static bool isToday(int? ms) => ms.isToday;

  /// Checks if the given milliseconds since epoch represents tomorrow.
  static bool isTomorrow(int? ms) => ms.isTomorrow;

  /// Checks if the given milliseconds since epoch represents yesterday.
  static bool isYesterday(int? ms) => ms.isYesterday;

  /// Converts milliseconds since epoch to a human-readable relative time string.
  ///
  /// Example:
  ///
  /// ```dart
  /// int myTime = DateProvider.currentMS;
  /// String relativeTime = DateProvider.realtime(myTime);
  /// print(relativeTime);  // Output: "Now" or "2 hours ago" or "Yesterday at 10:30 AM"
  /// ```
  static String realtime(int? ms) => toRealtime(ms);

  /// Converts milliseconds since epoch to a customizable relative time string.
  ///
  /// Example:
  ///
  /// ```dart
  /// int myTime = DateProvider.currentMS;
  /// String customRelativeTime = DateProvider.toRealtime(
  ///   myTime,
  ///   onRealtimeByHours: (value) => "Custom hours: ${value.hours}",
  ///   onRealtimeByMinutes: (value) => "Custom minutes: ${value.minutes}",
  /// );
  /// print(customRelativeTime);  // Output: Custom hours: 2
  /// ```
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
            return "$_ ${textFormat.hour.apply(_)} ${textFormat.ago}";
          }
        }

        /// for minutes
        else if (realtime.isMinuteMode) {
          if (onRealtimeByMinutes != null) {
            return onRealtimeByMinutes(realtime);
          } else {
            int _ = realtime.minutes;
            return "$_ ${textFormat.minute.apply(_)} ${textFormat.ago}";
          }
        }

        /// for after hours
        else if (realtime.isAfterHourMode) {
          if (onRealtimeByAfterHours != null) {
            return onRealtimeByAfterHours(realtime);
          } else {
            int _ = realtime.afterHours;
            return "${textFormat.after} $_ ${textFormat.hour.apply(_)}";
          }
        }

        /// for after minutes
        else if (realtime.isAfterMinuteMode) {
          if (onRealtimeByAfterMinutes != null) {
            return onRealtimeByAfterMinutes(realtime);
          } else {
            int _ = realtime.afterMinutes;
            return "${textFormat.after} $_ ${textFormat.minute.apply(_)}";
          }
        }

        /// for after seconds
        else if (realtime.isAfterSecondMode) {
          if (onRealtimeByAfterSeconds != null) {
            return onRealtimeByAfterSeconds(realtime);
          } else {
            int _ = realtime.afterSeconds;
            return "${textFormat.after} $_ ${textFormat.second.apply(_)}";
          }
        }

        /// for seconds
        else {
          if (onRealtimeBySeconds != null) {
            return onRealtimeBySeconds(realtime);
          } else {
            int _ = realtime.seconds;
            if (whenShowNow < _) {
              return "$_ ${textFormat.second.apply(_)} ${textFormat.ago}";
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

  static List<DateTime> range({
    required DateTime start,
    required DateTime end,
    Duration difference = const Duration(days: 1),
  }) {
    if (start.isAfter(end)) {
      throw ArgumentError(
        'Initial date must be before or equal to the end date',
      );
    }

    List<DateTime> dates = [];
    DateTime currentDate = start;

    while (!currentDate.isAfter(end)) {
      dates.add(currentDate);
      currentDate = currentDate.add(difference);
    }

    return dates;
  }
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

  /// Converts milliseconds since epoch to a human-readable relative time string.
  ///
  /// Example:
  ///
  /// ```dart
  /// int myTime = DateProvider.currentMS;
  /// String relativeTime = DateProvider.realtime(myTime);
  /// print(relativeTime);  // Output: "Now" or "2 hours ago" or "Yesterday at 10:30 AM"
  /// ```
  String get realtime => toRealtime();

  /// Converts the custom date to a formatted string.
  ///
  /// The method provides flexibility for custom formatting options.
  ///
  /// Parameters:
  /// - [format]: Custom date and time format string.
  /// - [local]: Optional parameter to specify the locale for formatting.
  /// - [timeFormat]: Enum specifying the time format (e.g., hour, minute, second).
  /// - [dateFormat]: Enum specifying the date format (e.g., day, month, year).
  /// - [separator]: Separator string between date and time components.
  ///
  /// Example:
  ///
  /// ```dart
  /// int myDate = DateTime.now().millisecondsSinceEpoch;
  /// String formattedDate = myDate.toDate(
  ///   dateFormat: DateFormats.dateDMCY,
  ///   timeFormat: TimeFormats.timeHMa,
  ///   separator: " at ",
  /// );
  /// print(formattedDate);  // Output: "06-02-2024 at 03:45 PM"
  /// ```
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

  /// Converts milliseconds since epoch to a customizable relative time string.
  ///
  /// Example:
  ///
  /// ```dart
  /// int myTime = DateProvider.currentMS;
  /// String customRelativeTime = DateProvider.toRealtime(
  ///   myTime,
  ///   onRealtimeByHours: (value) => "Custom hours: ${value.hours}",
  ///   onRealtimeByMinutes: (value) => "Custom minutes: ${value.minutes}",
  /// );
  /// print(customRelativeTime);  // Output: Custom hours: 2
  /// ```
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
    return DateHelper.toRealtime(
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

  String get dateOnly {
    final now = _v;
    return "${now.year}-${now.month}-${now.day}";
  }

  String get timeOnly {
    final now = _v;
    return "${now.hour}:${now.minute}:${now.second}";
  }

  String get realtime => toRealtime();

  bool isDay(DateTime now) {
    return now.day == _v.day && now.month == _v.month && now.year == _v.year;
  }

  /// Converts the custom date to a formatted string.
  ///
  /// The method provides flexibility for custom formatting options.
  ///
  /// Parameters:
  /// - [format]: Custom date and time format string.
  /// - [local]: Optional parameter to specify the locale for formatting.
  /// - [timeFormat]: Enum specifying the time format (e.g., hour, minute, second).
  /// - [dateFormat]: Enum specifying the date format (e.g., day, month, year).
  /// - [separator]: Separator string between date and time components.
  ///
  /// Example:
  ///
  /// ```dart
  /// DateTime myDate = DateTime.now();
  /// String formattedDate = myDate.toDate(
  ///   dateFormat: DateFormats.dateDMCY,
  ///   timeFormat: TimeFormats.timeHMa,
  ///   separator: " at ",
  /// );
  /// print(formattedDate);  // Output: "06-02-2024 at 03:45 PM"
  /// ```
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
    return Andomie.dateFormatter(format ?? "", local, _v);
  }

  /// Converts milliseconds since epoch to a customizable relative time string.
  ///
  /// Example:
  ///
  /// ```dart
  /// int myTime = DateProvider.currentMS;
  /// String customRelativeTime = DateProvider.toRealtime(
  ///   myTime,
  ///   onRealtimeByHours: (value) => "Custom hours: ${value.hours}",
  ///   onRealtimeByMinutes: (value) => "Custom minutes: ${value.minutes}",
  /// );
  /// print(customRelativeTime);  // Output: Custom hours: 2
  /// ```
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
    return DateHelper.toRealtime(
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
