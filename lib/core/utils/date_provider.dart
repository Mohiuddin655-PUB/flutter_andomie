part of '../../utils.dart';

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

  static String toDate(int? timeMills, DateFormats format) {
    return timeMills.toDate(format);
  }

  static DateTime toDateTime(int? timeMills) {
    return DateTime.fromMillisecondsSinceEpoch(timeMills ?? 0);
  }

  static String toDateFromUTC(
    int year,
    int month,
    int day, [
    DateFormats? format,
  ]) {
    if (year > 0 && month > 0 && day > 0) {
      return DateTime.utc(year, month, day).modify(format);
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

  static String activeTime(int? ms) => ms.activeTime;

  static String toLiveTime(
    int? ms, [
    DateFormats format = DateFormats.dateDMY,
  ]) {
    return ms.toLiveTime(format);
  }

  static String toNamingTime(int? ms, [DateFormats? format]) {
    return ms.toNamingTime(format);
  }

  static String toPublishTime(
    int ms, [
    DateFormats timeFormat = DateFormats.timeHMa,
    DateFormats dateFormat = DateFormats.dateDMY,
  ]) {
    return ms.toPublishTime(
      timeFormat: timeFormat,
      dateFormat: dateFormat,
    );
  }
}

extension TimeExtension on int? {
  int get _v => this ?? 0;

  bool get isToday => DateTime.fromMillisecondsSinceEpoch(_v).isToday;

  bool get isTomorrow => DateTime.fromMillisecondsSinceEpoch(_v).isTomorrow;

  bool get isYesterday => DateTime.fromMillisecondsSinceEpoch(_v).isYesterday;

  String get activeTime {
    final time = DateTime.fromMillisecondsSinceEpoch(_v);
    final int currentMS = DateTime.now().microsecondsSinceEpoch;
    final int tempMS = currentMS - _v;

    double initTime;
    int day = TimeConstrains.dayMS.value;
    int hour = TimeConstrains.hourMS.value;
    int minute = TimeConstrains.minuteMS.value;

    if (tempMS < minute) {
      return "Now";
    } else if (tempMS < hour) {
      initTime = tempMS / minute;
      return "${initTime.toInt()} minute ago";
    } else if (tempMS < day) {
      initTime = tempMS / hour;
      return "${initTime.toInt()} hour ago";
    } else {
      return time.toDate();
    }
  }

  String toLiveTime([DateFormats format = DateFormats.dateDMY]) {
    final time = DateTime.fromMillisecondsSinceEpoch(_v);
    final int currentMS = DateTime.now().microsecondsSinceEpoch;
    final int tempMS = currentMS - _v;

    final double secondCount = tempMS / TimeConstrains.secondMS.value;
    final double minuteCount = tempMS / TimeConstrains.minuteMS.value;
    final double hourCount = tempMS / TimeConstrains.hourMS.value;

    if (tempMS < TimeConstrains.secondMS.value) {
      return "Now";
    } else if (tempMS < TimeConstrains.minuteMS.value) {
      return "$secondCount second ago";
    } else if (tempMS < TimeConstrains.hourMS.value) {
      return "$minuteCount minute ago";
    } else if (tempMS < TimeConstrains.dayMS.value) {
      return "$hourCount hour ago";
    } else {
      return time.toDate(format);
    }
  }

  String toDate(DateFormats format) {
    return DateTime.fromMillisecondsSinceEpoch(_v).toDate(format);
  }

  String toNamingTime([DateFormats? format]) {
    return DateTime.fromMillisecondsSinceEpoch(_v).modify(format);
  }

  String toPublishTime({
    DateFormats timeFormat = DateFormats.timeHMa,
    DateFormats dateFormat = DateFormats.dateDMY,
  }) {
    final time = DateTime.fromMillisecondsSinceEpoch(_v);
    final int currentMS = DateTime.now().microsecondsSinceEpoch;
    final int tempMS = currentMS - _v;

    int dayMS = TimeConstrains.dayMS.value;
    int hourMS = TimeConstrains.hourMS.value;
    int minuteMS = TimeConstrains.minuteMS.value;

    final double minuteCount = tempMS / minuteMS;

    if (tempMS < minuteMS) {
      return "Now";
    } else if (tempMS < hourMS) {
      return "$minuteCount minute ago";
    } else if (tempMS < dayMS && time.isYesterday) {
      return 'Yesterday - ${time.modify(timeFormat)}';
    } else {
      return '${time.modify(dateFormat)} - ${time.modify(timeFormat)}';
    }
  }
}

extension DateExtension on DateTime? {
  DateTime get _v => this ?? DateTime.now();

  bool get isToday => isDay(DateTime.now());

  bool get isTomorrow {
    return isDay(DateTime.now().add(const Duration(days: 1)));
  }

  bool get isYesterday {
    return isDay(DateTime.now().subtract(const Duration(days: 1)));
  }

  bool isDay(DateTime now) {
    return now.day == _v.day && now.month == _v.month && now.year == _v.year;
  }

  String toDate([DateFormats format = DateFormats.dateDMY, String? local]) {
    if (isToday) {
      return 'Today';
    } else if (isYesterday) {
      return 'Yesterday';
    } else {
      return DateFormat(format.value, local).format(_v);
    }
  }

  String modify(DateFormats? format, [String? local]) {
    return DateFormat(format?.value, local).format(_v);
  }
}

enum DateFormats {
  hour("hh"),
  minute("mm"),
  second("ss"),
  timeZone("TZD"),
  timeMS("mm:ss"),
  timeHM("hh:mm"),
  timeHMa("hh:mm a"),
  timeHMSa("hh:mm:ss a"),
  timeHMSZone("hh:mm:ss TZD"),
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
  dateECMDCY("EEEE, MMMM dd, yyyy");

  final String value;

  const DateFormats(this.value);
}

enum TimeConstrains {
  dayMS(86400000),
  hourMS(3600000),
  minuteMS(60000),
  secondMS(1000);

  final int value;

  const TimeConstrains(this.value);
}
