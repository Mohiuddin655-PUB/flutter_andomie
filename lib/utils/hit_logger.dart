import 'dart:async';

typedef OnHitLoggerCheck = void Function(String tag, dynamic data);
typedef OnHitLoggerListen = void Function(String client);
typedef OnHitLoggerClientCheck = bool Function(String client);
typedef OnHitLoggerClientListen = void Function(ClientLogs value);

enum HitType {
  none(""),
  init("init"),
  listen("listen"),
  request("request"),
  response("response");

  final String name;

  const HitType(this.name);
}

extension HitLoggerFutureExtension<T> on Future<T> {
  Future<T> hitLogger(String tag, [String? client]) async {
    HitLogger.log(tag, type: HitType.request, client: client);
    final data = await this;
    HitLogger.log(tag, type: HitType.response, client: client, data: data);
    return data;
  }
}

extension HitLoggerStreamExtension<T> on Stream<T> {
  Stream<T> hitLogger(String key, [String? client]) {
    final controller = StreamController<T>();
    HitLogger.log(key, type: HitType.init, client: client);
    listen((event) {
      HitLogger.log(key, type: HitType.listen, client: client, data: event);
      controller.add(event);
    });
    return controller.stream;
  }
}

class ClientLogs {
  final String name;
  final String client;
  final Map<String, int> logs;

  const ClientLogs._(this.name, this.client, this.logs);

  int getHits([String? key]) {
    if (key == null || key.isEmpty) {
      var counter = 0;
      for (var i in logs.entries) {
        if (i.key.contains(HitType.none.name)) {
          counter = counter + i.value;
        }
      }
      return counter;
    } else {
      return logs["$key-${HitType.none.name}"] ?? 0;
    }
  }

  int getInitialHits([String? key]) {
    if (key == null || key.isEmpty) {
      var counter = 0;
      for (var i in logs.entries) {
        if (i.key.contains(HitType.init.name)) {
          counter = counter + i.value;
        }
      }
      return counter;
    } else {
      return logs["$key-${HitType.init.name}"] ?? 0;
    }
  }

  int getListeningHits([String? key]) {
    if (key == null || key.isEmpty) {
      var counter = 0;
      for (var i in logs.entries) {
        if (i.key.contains(HitType.listen.name)) {
          counter = counter + i.value;
        }
      }
      return counter;
    } else {
      return logs["$key-${HitType.listen.name}"] ?? 0;
    }
  }

  int getRequestedHits([String? key]) {
    if (key == null || key.isEmpty) {
      var counter = 0;
      for (var i in logs.entries) {
        if (i.key.contains(HitType.request.name)) {
          counter = counter + i.value;
        }
      }
      return counter;
    } else {
      return logs["$key-${HitType.request.name}"] ?? 0;
    }
  }

  int getResponseHits([String? key]) {
    if (key == null || key.isEmpty) {
      var counter = 0;
      for (var i in logs.entries) {
        if (i.key.contains(HitType.response.name)) {
          counter = counter + i.value;
        }
      }
      return counter;
    } else {
      return logs["$key-${HitType.response.name}"] ?? 0;
    }
  }

  String getTotalHits([String? key]) {
    var request = 0;
    var response = 0;
    var init = 0;
    var listen = 0;
    if (key != null && key.isNotEmpty) {
      request = getRequestedHits(key);
      response = getResponseHits(key);
      init = getInitialHits(key);
      listen = getListeningHits(key);
    } else {
      for (var i in logs.entries) {
        if (i.key.contains(HitType.request.name)) {
          request = request + i.value;
        } else if (i.key.contains(HitType.response.name)) {
          response = response + i.value;
        } else if (i.key.contains(HitType.init.name)) {
          init = init + i.value;
        } else if (i.key.contains(HitType.listen.name)) {
          listen = listen + i.value;
        }
      }
    }
    return "$name {\n"
        "-> ${HitType.init.name}     : $init\n"
        "-> ${HitType.listen.name}   : $listen\n"
        "-> ${HitType.request.name}  : $request\n"
        "-> ${HitType.response.name} : $response\n"
        "}";
  }

  @override
  String toString() {
    return "$name ($client) ${logs.toString().replaceAll("{", "{\n-> ").replaceAll(", ", "\n-> ").replaceAll("}", "\n}")}";
  }
}

class HitLogger {
  final String name;
  final OnHitLoggerCheck? onCheck;
  final OnHitLoggerListen? onListen;
  final OnHitLoggerClientListen? onClientListen;
  final OnHitLoggerClientCheck? onClientCheck;

  Map<String, Map<String, int>> _hits = {};

  HitLogger._({
    this.name = "HIT LOGGER",
    this.onCheck,
    this.onListen,
    this.onClientListen,
    this.onClientCheck,
  });

  static const String _client = "LOGS";

  static HitLogger? _proxy;

  static HitLogger init({
    String? name,
    OnHitLoggerCheck? onCheck,
    OnHitLoggerListen? onListen,
    OnHitLoggerClientCheck? onClientCheck,
    OnHitLoggerClientListen? onClientListen,
  }) {
    return _proxy ??= HitLogger._(
      name: name ?? "HIT LOGGER",
      onCheck: onCheck,
      onListen: onListen,
      onClientCheck: onClientCheck,
      onClientListen: onClientListen,
    );
  }

  static HitLogger get _i => init();

  static void log(
    String tag, {
    HitType type = HitType.none,
    String? client,
    dynamic data,
  }) {
    if (_i.onCheck != null &&
        (type == HitType.response || type == HitType.listen)) {
      _i.onCheck!(tag, data);
    }
    _i._count("$tag-${type.name}", client);
  }

  static void clear({
    String? tag,
    String? client,
  }) {
    _i._clear(tag, client);
  }

  bool _isClient(String client) {
    return onClientCheck?.call(client) ?? true;
  }

  void _count(String tag, [String? client]) {
    final mClient = client ?? _client;
    _hits.putIfAbsent(mClient, () => {});
    final value = _hits[mClient]?[tag] ?? 0;
    _hits[mClient]?[tag] = value + 1;
    if (onListen != null) {
      onListen!(_totalHits);
    }
    if (onClientListen != null && _isClient(mClient)) {
      onClientListen!(ClientLogs._(name, mClient, _hits[mClient] ?? {}));
    }
  }

  void _clear([String? tag, String? client]) {
    final mClient = client ?? _client;
    if (tag != null) {
      _hits[mClient]?[tag] = 0;
    } else {
      if (client != null) {
        _hits[client] = {};
      } else {
        _hits = {};
      }
    }
  }

  String get _totalHits {
    var request = 0;
    var response = 0;
    var init = 0;
    var listen = 0;
    for (var client in _hits.values) {
      for (var i in client.entries) {
        if (i.key.contains(HitType.request.name)) {
          request = request + i.value;
        } else if (i.key.contains(HitType.response.name)) {
          response = response + i.value;
        } else if (i.key.contains(HitType.init.name)) {
          init = init + i.value;
        } else if (i.key.contains(HitType.listen.name)) {
          listen = listen + i.value;
        }
      }
    }
    return "$name {\n"
        "-> ${HitType.init.name}     : $init\n"
        "-> ${HitType.listen.name}   : $listen\n"
        "-> ${HitType.request.name}  : $request\n"
        "-> ${HitType.response.name} : $response\n"
        "}";
  }
}
