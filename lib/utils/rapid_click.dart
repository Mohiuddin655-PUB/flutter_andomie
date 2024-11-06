import 'dart:async';

import 'package:flutter/foundation.dart';

class RapidClick {
  DateTime? _lastClick;
  int _threshold = 300;
  int _counter = 0;
  Timer? _timer;

  RapidClick._();

  void _click(ValueChanged<bool> callback) {
    DateTime now = DateTime.now();
    if (_lastClick != null) {
      int difference = now.difference(_lastClick!).inMilliseconds;
      if (difference <= _threshold) {
        _counter++;
        callback(true);
        _timer?.cancel();
        _timer = Timer(Duration(milliseconds: _threshold), () {
          _timer?.cancel();
          callback(false);
        });
      } else {
        _counter = 0;
        callback(false);
      }
    }
    _lastClick = now;
  }

  static RapidClick? _i;

  static RapidClick get _ii => _i ??= RapidClick._();

  static int get count => _ii._counter;

  static set threshold(int? threshold) => _ii._threshold = threshold ?? 300;

  static void click(ValueChanged<bool> callback) => _ii._click(callback);
}
