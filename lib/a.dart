class TextFormat {
  /// The singular form of the text.
  final String singular;

  /// The plural form of the text. If not provided, it defaults to the singular form.
  final String plural;

  /// Creates a [TextFormat] instance with the specified [singular] form and optional [plural] form.
  const TextFormat({
    required this.singular,
    String? plural,
  }) : plural = plural ?? singular;

  /// Gets the appropriate text form based on the provided [counter].
  /// If the counter is greater than 1, returns the plural form; otherwise, returns the singular form.
  String apply(int counter) => counter > 1 ? plural : singular;
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
  final TextFormat day;
  final TextFormat week;
  final TextFormat month;
  final TextFormat year;

  const RealtimeTextFormat({
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
}

class Realtime {
  final bool after;
  final int second;
  final int minute;
  final int hour;
  final int day;
  final int week;
  final int month;
  final int year;

  const Realtime({
    this.after = false,
    this.second = 0,
    this.minute = 0,
    this.hour = 0,
    this.day = 0,
    this.week = 0,
    this.month = 0,
    this.year = 0,
  });

  const Realtime.seconds(bool after, int value)
      : this(after: after, second: value);

  const Realtime.minutes(bool after, int m, int s)
      : this(after: after, minute: m, second: s);

  const Realtime.hours(bool after, int h, int m, int s)
      : this(after: after, hour: h, minute: m, second: s);

  const Realtime.days(bool after, int d, int h, int m, int s)
      : this(after: after, day: d, hour: h, minute: m, second: s);

  const Realtime.weeks(bool after, int w, int d, int h, int m, int s)
      : this(after: after, week: w, day: d, hour: h, minute: m, second: s);

  const Realtime.months(bool after, int mo, int w, int d, int h, int m, int s)
      : this(
          after: after,
          month: mo,
          week: w,
          day: d,
          hour: h,
          minute: m,
          second: s,
        );

  const Realtime.years(
      bool after, int y, int mo, int w, int d, int h, int m, int s)
      : this(
          after: after,
          year: y,
          month: mo,
          week: w,
          day: d,
          hour: h,
          minute: m,
          second: s,
        );
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
    this.nowShowingBeforeSeconds = 5,
    this.today = true,
    this.tomorrow = true,
    this.yesterday = true,
    this.second = true,
    this.minute = true,
    this.hour = true,
    this.day = true,
    this.week = true,
    this.month = true,
    this.year = true,
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
    String separator = " at ",
    RealtimeTextFormat textFormat = const RealtimeTextFormat(),
  });
}

String timeAgo(
  DateTime dateTime, {
  RealtimeTextFormat format = const RealtimeTextFormat(),
  RealtimeOptions options = const RealtimeOptions(),
  String Function(DateTime date)? parse,
}) {
  final now = DateTime.now();
  final isFuture = dateTime.isAfter(now);
  final diff = isFuture ? dateTime.difference(now) : now.difference(dateTime);

  String suffix = isFuture
      ? options.after
          ? ' ${format.after}'
          : ''
      : options.ago
          ? ' ${format.ago}'
          : '';

  if (options.now && diff.inSeconds <= options.nowShowingBeforeSeconds) {
    return format.now;
  }

  if (options.second && diff.inSeconds < 60) {
    final seconds = diff.inSeconds;
    if (options.onSeconds != null) {
      return options.onSeconds!(Realtime.seconds(isFuture, seconds));
    }
    return "$seconds ${format.second.apply(seconds)}$suffix";
  }

  if (options.minute && diff.inMinutes < 60) {
    final minutes = diff.inMinutes;
    if (options.onMinutes != null) {
      return options.onMinutes!(Realtime.minutes(
        isFuture,
        minutes,
        diff.inSeconds,
      ));
    }
    return "$minutes ${format.minute.apply(minutes)}$suffix";
  }

  if (options.hour && diff.inHours < 24) {
    final hours = diff.inHours;
    if (options.onHours != null) {
      return options.onHours!(Realtime.hours(
        isFuture,
        hours,
        diff.inMinutes,
        diff.inSeconds,
      ));
    }
    return "$hours ${format.hour.apply(hours)}$suffix";
  }

  if ((options.tomorrow || options.yesterday) && diff.inDays == 1) {
    if (isFuture) {
      if (options.tomorrow) {
        if (options.onTomorrow != null) {
          return options.onTomorrow!(Realtime.hours(
            true,
            diff.inHours,
            diff.inMinutes,
            diff.inSeconds,
          ));
        }
        return format.tomorrow;
      }
    } else {
      if (options.yesterday) {
        if (options.onYesterday != null) {
          return options.onYesterday!(Realtime.hours(
            false,
            diff.inHours,
            diff.inMinutes,
            diff.inSeconds,
          ));
        }
        return format.yesterday;
      }
    }
  }
  if (options.today && diff.inDays == 0) {
    if (options.onToday != null) {
      return options.onToday!(Realtime.hours(
        isFuture,
        diff.inHours,
        diff.inMinutes,
        diff.inSeconds,
      ));
    }
    return format.today;
  }

  if (options.day && diff.inDays < 7) {
    final days = diff.inDays;
    if (options.onDays != null) {
      return options.onDays!(Realtime.days(
        isFuture,
        days,
        diff.inHours,
        diff.inMinutes,
        diff.inSeconds,
      ));
    }
    return "$days ${format.day.apply(days)}$suffix";
  }

  if (options.week && diff.inDays < 30) {
    final weeks = (diff.inDays / 7).floor();
    if (options.onWeeks != null) {
      return options.onWeeks!(Realtime.weeks(
        isFuture,
        weeks,
        diff.inDays,
        diff.inHours,
        diff.inMinutes,
        diff.inSeconds,
      ));
    }
    return "$weeks ${format.week.apply(weeks)}$suffix";
  }

  if (options.month && diff.inDays < 365) {
    final months = (diff.inDays / 30).floor();
    if (options.onMonths != null) {
      return options.onMonths!(Realtime.months(
        isFuture,
        months,
        (diff.inDays / 7).floor(),
        diff.inDays,
        diff.inHours,
        diff.inMinutes,
        diff.inSeconds,
      ));
    }
    return "$months ${format.month.apply(months)}$suffix";
  }

  if (options.year || parse == null) {
    final years = (diff.inDays / 365).floor();
    if (options.onYears != null) {
      return options.onYears!(Realtime.years(
        isFuture,
        years,
        (diff.inDays / 30).floor(),
        (diff.inDays / 7).floor(),
        diff.inDays,
        diff.inHours,
        diff.inMinutes,
        diff.inSeconds,
      ));
    }
    return "$years ${format.year.apply(years)}$suffix";
  }

  return parse(dateTime);
}

void main() {
  final now = DateTime.now();

  final examples = <String, DateTime>{
    "now": now.subtract(Duration(seconds: 1)),
    "secondsAgo": now.subtract(Duration(seconds: 59)),
    "secondsAfter": now.add(Duration(seconds: 10)),
    "minutesAgo": now.subtract(Duration(minutes: 1)),
    "minutesAfter": now.add(Duration(minutes: 5)),
    "hoursAgo": now.subtract(Duration(hours: 3)),
    "hoursAfter": now.add(Duration(hours: 3)),
    "yesterday": now.subtract(Duration(days: 1)),
    "tomorrow": now.add(Duration(days: 1, hours: 1)),
    "daysAgo": now.subtract(Duration(days: 6)),
    "daysAfter": now.add(Duration(days: 7)),
    "weeksAgo": now.subtract(Duration(days: 18)),
    "weeksAfter": now.add(Duration(days: 14)),
    "monthsAgo": now.subtract(Duration(days: 90)),
    "monthsAfter": now.add(Duration(days: 90)),
    "yearsAgo": now.subtract(Duration(days: 730)),
    "yearsAfter": now.add(Duration(days: 730)),
  };

  examples.forEach((label, date) {
    print("$label: ${timeAgo(date, parse: (a) => a.toIso8601String())}");
  });
}
