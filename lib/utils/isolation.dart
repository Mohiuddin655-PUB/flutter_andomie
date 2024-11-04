import 'dart:async';
import 'dart:isolate';

typedef IsolationCallback<T> = Future<T> Function(dynamic params);

class Isolation {
  Isolate? _isolate;
  late SendPort _sendPort;
  final ReceivePort _receivePort = ReceivePort();

  static Future<void> _isolation(SendPort mainSendPort) async {
    final receivePort = ReceivePort();
    mainSendPort.send(receivePort.sendPort);
    receivePort.listen((message) async {
      if (message is List) {
        final task = message[0] as List;
        final callback = task.first as IsolationCallback;
        final params = task.last;
        print(params);
        final responsePort = message[1] as SendPort;
        final result = await callback(params);
        responsePort.send(result);
      } else if (message == 'stop') {
        receivePort.close();
      }
    });
  }

  Future<void> initialize() async {
    _isolate = await Isolate.spawn(_isolation, _receivePort.sendPort);
    _sendPort = await _receivePort.first as SendPort;
  }

  Future<T?> isolate<T>(IsolationCallback<T> task, params) async {
    final responsePort = ReceivePort();
    _sendPort.send([
      [task, params],
      responsePort.sendPort
    ]);
    return responsePort.first.then((value) {
      return value is T ? value : null;
    });
  }

  void dispose() {
    _sendPort.send('stop');
    _receivePort.close();
    _isolate?.kill(priority: Isolate.immediate);
    _isolate = null;
  }
}
