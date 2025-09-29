import 'text_format.dart';

class RealtimeTextFormats {
  final String after;
  final String ago;
  final String now;
  final String today;
  final String tomorrow;
  final String yesterday;
  final TextFormat second;
  final TextFormat minute;
  final TextFormat hour;
  final TextFormat day;
  final TextFormat week;
  final TextFormat month;
  final TextFormat year;

  const RealtimeTextFormats({
    this.after = "after",
    this.ago = "ago",
    this.now = "now",
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
    this.day = const TextFormat(
      singular: "day",
      plural: "days",
    ),
    this.week = const TextFormat(
      singular: "week",
      plural: "weeks",
    ),
    this.month = const TextFormat(
      singular: "month",
      plural: "months",
    ),
    this.year = const TextFormat(
      singular: "year",
      plural: "years",
    ),
  });

  RealtimeTextFormats merge(RealtimeTextFormats? other) {
    return RealtimeTextFormats(
      after: other?.after ?? after,
      ago: other?.ago ?? ago,
      day: other?.day ?? day,
      hour: other?.hour ?? hour,
      minute: other?.minute ?? minute,
      month: other?.month ?? month,
      now: other?.now ?? now,
      second: other?.second ?? second,
      today: other?.today ?? today,
      tomorrow: other?.tomorrow ?? tomorrow,
      week: other?.week ?? week,
      year: other?.year ?? year,
      yesterday: other?.yesterday ?? yesterday,
    );
  }
}

class RealtimeOptions {
  final bool after;
  final bool ago;
  final bool now;
  final bool today;
  final bool tomorrow;
  final bool yesterday;
  final bool second;
  final bool minute;
  final bool hour;
  final bool day;
  final bool week;
  final bool month;
  final bool year;
  final int nowShowingBeforeSeconds;
  final String Function(Realtime time)? onYears;
  final String Function(Realtime time)? onMonths;
  final String Function(Realtime time)? onWeeks;
  final String Function(Realtime time)? onDays;
  final String Function(Realtime time)? onHours;
  final String Function(Realtime time)? onMinutes;
  final String Function(Realtime time)? onSeconds;
  final String Function(Realtime time)? onTomorrow;
  final String Function(Realtime time)? onToday;
  final String Function(Realtime time)? onYesterday;

  const RealtimeOptions({
    this.after = true,
    this.ago = true,
    this.now = true,
    this.nowShowingBeforeSeconds = 10,
    this.today = false,
    this.tomorrow = true,
    this.yesterday = true,
    this.second = true,
    this.minute = true,
    this.hour = true,
    this.day = true,
    this.week = false,
    this.month = false,
    this.year = false,
    this.onYears,
    this.onMonths,
    this.onWeeks,
    this.onDays,
    this.onHours,
    this.onMinutes,
    this.onSeconds,
    this.onTomorrow,
    this.onToday,
    this.onYesterday,
  });

  RealtimeOptions merge(RealtimeOptions? other) {
    return RealtimeOptions(
      after: other?.after ?? after,
      ago: other?.ago ?? ago,
      day: other?.day ?? day,
      hour: other?.hour ?? hour,
      minute: other?.minute ?? minute,
      month: other?.month ?? month,
      now: other?.now ?? now,
      nowShowingBeforeSeconds:
          other?.nowShowingBeforeSeconds ?? nowShowingBeforeSeconds,
      second: other?.second ?? second,
      today: other?.today ?? today,
      tomorrow: other?.tomorrow ?? tomorrow,
      week: other?.week ?? week,
      year: other?.year ?? year,
      yesterday: other?.yesterday ?? yesterday,
      onDays: other?.onDays ?? onDays,
      onHours: other?.onHours ?? onHours,
      onMinutes: other?.onMinutes ?? onMinutes,
      onMonths: other?.onMonths ?? onMonths,
      onSeconds: other?.onSeconds ?? onSeconds,
      onToday: other?.onToday ?? onToday,
      onTomorrow: other?.onTomorrow ?? onTomorrow,
      onWeeks: other?.onWeeks ?? onWeeks,
      onYears: other?.onYears ?? onYears,
      onYesterday: other?.onYesterday ?? onYesterday,
    );
  }
}

class Realtime {
  final bool future;
  final int second;
  final int minute;
  final int hour;
  final int day;
  final int week;
  final int month;
  final int year;
  final Duration diff;
  final DateTime? _dateTime;

  DateTime get dateTime => _dateTime ?? DateTime(0);

  static RealtimeTextFormats formats = RealtimeTextFormats();
  static RealtimeOptions options = RealtimeOptions();
  static String Function(DateTime date)? time;
  static String Function(DateTime date)? date;

  const Realtime({
    this.future = false,
    this.second = 0,
    this.minute = 0,
    this.hour = 0,
    this.day = 0,
    this.week = 0,
    this.month = 0,
    this.year = 0,
    this.diff = Duration.zero,
    DateTime? dateTime,
  }) : _dateTime = dateTime;

  factory Realtime.parse(DateTime dateTime) {
    final now = DateTime.now();
    final future = dateTime.isAfter(now);
    final diff = future ? dateTime.difference(now) : now.difference(dateTime);

    int days = diff.inDays;

    final years = days ~/ 365;
    days -= years * 365;

    final months = days ~/ 30;
    days -= months * 30;

    final weeks = days ~/ 7;
    days -= weeks * 7;

    final hours = diff.inHours % 24;
    final minutes = diff.inMinutes % 60;
    final seconds = diff.inSeconds % 60;

    return Realtime(
      future: future,
      dateTime: dateTime,
      diff: diff,
      year: years,
      month: months,
      week: weeks,
      day: days,
      hour: hours,
      minute: minutes,
      second: seconds,
    );
  }

  static String format(
    DateTime dateTime, {
    RealtimeTextFormats? formats,
    RealtimeOptions? options,
    String separator = " at ",
    String Function(DateTime date)? time,
    String Function(DateTime date)? date,
  }) {
    formats = Realtime.formats.merge(formats);
    options = Realtime.options.merge(options);
    time ??= Realtime.time;
    date ??= Realtime.date;

    final rt = Realtime.parse(dateTime);

    final diff = rt.diff;

    String suffix = rt.future
        ? options.after
            ? ' ${formats.after}'
            : ''
        : options.ago
            ? ' ${formats.ago}'
            : '';

    if (!options.today &&
        options.now &&
        options.onSeconds == null &&
        diff.inSeconds <= options.nowShowingBeforeSeconds) {
      return formats.now;
    }

    if (!options.today && options.second && diff.inSeconds < 60) {
      final seconds = diff.inSeconds;
      if (options.onSeconds != null) {
        return options.onSeconds!(rt);
      }
      return "$seconds ${formats.second.apply(seconds)}$suffix";
    }

    if (!options.today && options.minute && diff.inMinutes < 60) {
      final minutes = diff.inMinutes;
      if (options.onMinutes != null) {
        return options.onMinutes!(rt);
      }
      return "$minutes ${formats.minute.apply(minutes)}$suffix";
    }

    if (!options.today && options.hour && diff.inHours < 24) {
      final hours = diff.inHours;
      if (options.onHours != null) return options.onHours!(rt);
      return "$hours ${formats.hour.apply(hours)}$suffix";
    }

    if (options.today && diff.inDays == 0) {
      if (options.onToday != null) options.onToday!(rt);
      if (time == null) return formats.today;
      final t = time(dateTime);
      return "${formats.today}$separator$t";
    }

    if ((options.tomorrow || options.yesterday) && diff.inDays == 1) {
      if (rt.future) {
        if (options.tomorrow) {
          if (options.onTomorrow != null) return options.onTomorrow!(rt);
          if (time == null) return formats.tomorrow;
          final t = time(dateTime);
          return "${formats.tomorrow}$separator$t";
        }
      } else {
        if (options.yesterday) {
          if (options.onYesterday != null) return options.onYesterday!(rt);
          if (time == null) return formats.yesterday;
          final t = time(dateTime);
          return "${formats.yesterday}$separator$t";
        }
      }
    }

    if (options.day && diff.inDays < 7) {
      final days = diff.inDays;
      if (options.onDays != null) return options.onDays!(rt);
      return "$days ${formats.day.apply(days)}$suffix";
    }

    if (options.week && diff.inDays < 30) {
      final weeks = (diff.inDays / 7).floor();
      if (options.onWeeks != null) return options.onWeeks!(rt);
      return "$weeks ${formats.week.apply(weeks)}$suffix";
    }

    if (options.month && diff.inDays < 365) {
      final months = (diff.inDays / 30).floor();
      if (options.onMonths != null) return options.onMonths!(rt);
      return "$months ${formats.month.apply(months)}$suffix";
    }

    if (options.year || date == null) {
      final years = (diff.inDays / 365).floor();
      if (options.onYears != null) return options.onYears!(rt);
      return "$years ${formats.year.apply(years)}$suffix";
    }

    return date(dateTime);
  }
}

extension RealtimeExtension on DateTime {
  String get realtime => realtimeWithOptions();

  String realtimeWithOptions({
    RealtimeTextFormats? formats,
    RealtimeOptions? options,
    String separator = " at ",
    String Function(DateTime date)? time,
    String Function(DateTime date)? date,
  }) {
    return Realtime.format(
      this,
      formats: formats,
      options: options,
      separator: separator,
      time: time,
      date: date,
    );
  }
}

extension RealtimeNullableExtension on DateTime? {
  String? get realtime => realtimeWithOptions();

  String? realtimeWithOptions({
    RealtimeTextFormats? formats,
    RealtimeOptions? options,
    String separator = " at ",
    String Function(DateTime date)? time,
    String Function(DateTime date)? date,
  }) {
    if (this == null) return null;
    return this!.realtimeWithOptions(
      formats: formats,
      options: options,
      separator: separator,
      time: time,
      date: date,
    );
  }
}

extension RealtimeIntExtension on int {
  String get realtime => realtimeWithOptions();

  String realtimeWithOptions({
    RealtimeTextFormats? formats,
    RealtimeOptions? options,
    String separator = " at ",
    String Function(DateTime date)? time,
    String Function(DateTime date)? date,
  }) {
    return DateTime.fromMillisecondsSinceEpoch(this).realtimeWithOptions(
      formats: formats,
      options: options,
      separator: separator,
      time: time,
      date: date,
    );
  }
}

extension RealtimeIntNullableExtension on int? {
  String? get realtime => realtimeWithOptions();

  String? realtimeWithOptions({
    RealtimeTextFormats? formats,
    RealtimeOptions? options,
    String separator = " at ",
    String Function(DateTime date)? time,
    String Function(DateTime date)? date,
  }) {
    if (this == null) return null;
    return this!.realtimeWithOptions(
      formats: formats,
      options: options,
      separator: separator,
      time: time,
      date: date,
    );
  }
}

extension RealtimeStringExtension on String? {
  String? get realtime => realtimeWithOptions();

  String? realtimeWithOptions({
    RealtimeTextFormats? formats,
    RealtimeOptions? options,
    String separator = " at ",
    String Function(DateTime date)? time,
    String Function(DateTime date)? date,
  }) {
    if (this == null || this!.isEmpty) return null;
    return DateTime.tryParse(this!)?.realtimeWithOptions(
      formats: formats,
      options: options,
      separator: separator,
      time: time,
      date: date,
    );
  }
}
