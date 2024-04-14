part of 'models.dart';

abstract class Scheduler<T> {
  final T start;
  final T end;

  const Scheduler({
    required this.start,
    T? end,
  }) : end = end ?? start;

  Map<String, dynamic> get source {
    return {
      "start": start,
      "end": end,
    };
  }

  T get difference;
}

final class Schedule extends Scheduler<int> {
  const Schedule({
    required super.start,
    super.end,
  });

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
      start: source.findByKey("start", 0),
      end: source.findByKey("end", 0),
    );
  }

  @override
  int get difference => end - start;
}
