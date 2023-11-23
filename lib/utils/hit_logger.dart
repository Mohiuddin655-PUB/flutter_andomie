part of '../utils.dart';

typedef OnHitLoggerListen = void Function(HitLogs value);

extension HitLoggerFutureExtension<T> on Future<T> {
  Future<T> hitCounter(String key) async {
    HitLogger.hit("$key-init");
    final data = await this;
    HitLogger.hit("$key-complete");
    return data;
  }
}

extension HitLoggerStreamExtension<T> on Stream<T> {
  Stream<T> hitCounter(String key) {
    final controller = StreamController<T>();
    HitLogger.hit("$key-init");
    listen((event) {
      HitLogger.hit("$key-listen");
      controller.add(event);
    });
    return controller.stream;
  }
}

class HitLogs {
  final Map<String, int> logs;

  const HitLogs(this.logs);

  int getHits(String name) {
    return logs["$name-init"] ?? 0;
  }

  int getCompletingHits(String name) {
    return logs["$name-complete"] ?? 0;
  }

  int getListeningHits(String name) {
    return logs["$name-listen"] ?? 0;
  }

  int getTotalHits(String name) {
    final init = getHits(name);
    final complete = getCompletingHits(name);
    final listen = getListeningHits(name);
    return init + complete + listen;
  }

  @override
  String toString() => "HitLogs $logs";
}

class HitLogger {
  final bool loggable;
  final bool printable;
  final String name;
  final OnHitLoggerListen? listenLogs;

  Map<String, int> _hits = {};

  HitLogger._(this.name, this.loggable, this.printable, this.listenLogs);

  static HitLogger? _proxy;

  static HitLogger init(
    String name, {
    bool loggable = false,
    bool printable = false,
    OnHitLoggerListen? onListen,
  }) {
    return _proxy ??= HitLogger._(name, loggable, printable, onListen);
  }

  static HitLogger get _i => init("HIT_LOGS");

  static String get logs => _i._logs;

  static void hit(String key) => _i._hit(key);

  static void clear([String? key]) => _i._clear(key);

  String get _logs {
    final log = _hits.toString().replaceAll("{", "").replaceAll("}", "");
    return "$name ($log)";
  }

  void _hit(String key) {
    final value = _hits[key] ?? 0;
    _hits[key] = value + 1;
    final log = "$name ($key : ${_hits[key]})";
    if (listenLogs != null) listenLogs!(HitLogs(_hits));
    if (loggable) developer.log(log);
    if (printable) {
      if (kDebugMode) print(log);
    }
  }

  void _clear([String? key]) {
    if (key != null) {
      _hits[key] = 0;
    } else {
      _hits = {};
    }
    final log = "$name ($key : ${_hits[key]})";
    if (listenLogs != null) listenLogs!(HitLogs(_hits));
    if (loggable) developer.log(log);
    if (printable) {
      if (kDebugMode) print(log);
    }
  }
}
