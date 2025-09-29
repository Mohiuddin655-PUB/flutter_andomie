import '../instance.dart';
import 'realtime.dart';

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
    String? format,
    String? local,
    TimeFormats timeFormat = TimeFormats.timeHMa,
    DateFormats dateFormat = DateFormats.dateDMCY,
    String separator = " at ",
    RealtimeTextFormats? formats,
    RealtimeOptions? options,
  }) {
    if (ms == null) return '';
    return ms.realtimeWithOptions(
      separator: separator,
      formats: formats,
      options: options,
      time: (date) => date.toDate(
        timeFormat: timeFormat,
        dateFormat: DateFormats.none,
        local: local,
      ),
      date: (date) => date.toDate(
        timeFormat: timeFormat,
        dateFormat: dateFormat,
        format: format,
        separator: separator,
        local: local,
      ),
    );
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
  /// );
  /// ```
  String toRealtime({
    String? format,
    String? local,
    TimeFormats timeFormat = TimeFormats.timeHMa,
    DateFormats dateFormat = DateFormats.dateDMCY,
    String separator = " at ",
    RealtimeTextFormats? formats,
    RealtimeOptions? options,
  }) {
    return DateHelper.toRealtime(
      this,
      format: format,
      local: local,
      timeFormat: timeFormat,
      dateFormat: dateFormat,
      separator: separator,
      formats: formats,
      options: options,
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

  String get date => _v.toString().split(" ").first;

  String get time => _v.toString().split(" ").last.split(".").first;

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
  /// );
  /// ```
  String toRealtime({
    String? format,
    String? local,
    TimeFormats timeFormat = TimeFormats.timeHMa,
    DateFormats dateFormat = DateFormats.dateDMCY,
    String separator = " at ",
    RealtimeTextFormats? formats,
    RealtimeOptions? options,
  }) {
    return DateHelper.toRealtime(
      this?.millisecondsSinceEpoch,
      format: format,
      local: local,
      timeFormat: timeFormat,
      dateFormat: dateFormat,
      separator: separator,
      formats: formats,
      options: options,
    );
  }
}
