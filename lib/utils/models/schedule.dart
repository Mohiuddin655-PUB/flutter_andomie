part of 'models.dart';

class Schedule {
  final int start;
  final int end;

  const Schedule({
    this.start = 0,
    this.end = 0,
  });

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
