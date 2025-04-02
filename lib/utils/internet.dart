import 'dart:async';

import 'package:flutter/foundation.dart';

class Internet extends ValueNotifier<bool> {
  Future<bool>? _connected;
  Stream<bool>? _connection;

  Internet._() : super(false);

  StreamSubscription? _connectivity;
  ValueChanged<bool>? _callback;

  static Internet? _i;

  static Internet get i => _i ??= Internet._();

  static Internet get instance => i;

  static bool get isConnected => i.value;

  /// ```dart
  /// Internet.connected = ConnectivityProvider.I.isConnected;
  /// ```
  static set connected(Future<bool> value) {
    i._connected = value;
  }

  static Future<bool> get connected {
    if (i._connected != null) return i._connected!;
    throw UnimplementedError(
      "connected has not been initialized yet. First, initialize it using:\n\n"
      "$Internet.init(\n"
      "  connected: ConnectivityProvider.I.isConnected,\n"
      ");\n\n"
      "Or,\n\n"
      "$Internet.connected = ConnectivityProvider.I.isConnected,\n\n"
      "Then, you can use it.\n",
    );
  }

  /// ```dart
  /// Internet.connection = ConnectivityProvider.I.connection;
  /// ```
  static set connection(Stream<bool> value) {
    i._connection = value;
  }

  static Stream<bool> get connection {
    if (i._connection != null) return i._connection!;
    throw UnimplementedError(
      "connected has not been initialized yet. First, initialize it using:\n\n"
      "$Internet.init(\n"
      "  connection: ConnectivityProvider.I.connection,\n"
      ");\n\n"
      "Or,\n\n"
      "$Internet.connection = ConnectivityProvider.I.connection,\n\n"
      "Then, you can use it.\n",
    );
  }

  ///   // CONNECTIVITY
  ///   ```
  ///   connected: ConnectivityProvider.I.isConnected,
  ///   connection: ConnectivityProvider.I.connection,
  static Future<void> init({
    Future<bool>? connected,
    Stream<bool>? connection,
  }) async {
    if (connected != null) {
      i._connected = connected;
      await i._load();
    }
    if (connection != null) {
      i._connection = connection;
      i._listen();
    }
  }

  static void setOnChangedListener(ValueChanged<bool> value) {
    i._callback = value;
  }

  Future<void> _load() async {
    try {
      await connected.then(notify);
    } catch (_) {}
  }

  void _listen() async {
    try {
      _connectivity?.cancel();
      _connectivity = connection.listen(notify);
    } catch (_) {}
  }

  void notify(bool value) {
    i.value = value;
    if (_callback != null) {
      _callback!(i.value);
    }
  }

  @override
  void dispose() {
    try {
      _connectivity?.cancel();
      super.dispose();
    } catch (_) {}
  }
}
