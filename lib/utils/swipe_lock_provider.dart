import 'dart:async';

import 'package:flutter/material.dart';

// Constants for keys used in storing swipe limitation data.
const _kSwipeLimitationTime = "__swipe_limitation_time__207448";
const _kSwipeLimitationTimes = "__swipe_limitation_times__207448";

// Function types for reading and writing stored data.
typedef OnSwipeLockProviderReader = int? Function(String key);
typedef OnSwipeLockProviderWriter = void Function(String key, int value);

/// SwipeLockProvider class to manage swipe lock mechanism.
class SwipeLockProvider with ChangeNotifier {
  final int times;
  final Duration lockoutDuration;
  final OnSwipeLockProviderReader reader;
  final OnSwipeLockProviderWriter writer;

  SwipeLockProvider._({
    this.times = 5,
    this.lockoutDuration = const Duration(hours: 8),
    required this.reader,
    required this.writer,
  });

  static SwipeLockProvider? _instance;

  /// Returns the singleton instance of SwipeLockProvider.
  /// Throws an error if the instance is not initialized.
  static SwipeLockProvider get instance {
    if (_instance != null) {
      return _instance!;
    } else {
      throw UnimplementedError("SwipeLockProvider is not initialized yet");
    }
  }

  /// Returns the singleton instance of SwipeLockProvider.
  static SwipeLockProvider get i => instance;

  /// Returns the singleton instance of SwipeLockProvider.
  static SwipeLockProvider get I => instance;

  /// Initializes the SwipeLockProvider singleton instance.
  static SwipeLockProvider init({
    int times = 5,
    Duration lockoutDuration = const Duration(hours: 8),
    DateTime? now,
    required OnSwipeLockProviderReader reader,
    required OnSwipeLockProviderWriter writer,
  }) {
    _instance ??= SwipeLockProvider._(
      times: times,
      lockoutDuration: lockoutDuration,
      reader: reader,
      writer: writer,
    );
    instance._swipe = reader(_kSwipeLimitationTimes) ?? 0;
    final lt = reader(_kSwipeLimitationTime) ?? 0;
    now ??= DateTime.now();
    if (instance._isLocked(now: now, lockoutTime: lt)) {
      final x = DateTime.fromMillisecondsSinceEpoch(lt).difference(now);
      final y = x > lockoutDuration ? lockoutDuration : x;
      instance._startTimer(now: now, lockoutTime: lt, remainingDuration: y);
    }
    return instance;
  }

  int _swipe = 0;

  /// Reads the lockout time from storage.
  int get _lockoutTime => reader(_kSwipeLimitationTime) ?? 0;

  /// Returns true if the swipe action is currently locked.
  bool get isLocked => _isLocked();

  /// Checks if the swipe action is locked.
  bool isLockedNow([DateTime? now]) => _isLocked(now: now);

  bool _isLocked({
    DateTime? now,
    int? lockoutTime,
  }) {
    now ??= DateTime.now();
    lockoutTime ??= _lockoutTime;
    if (lockoutTime > 0) {
      return now.isBefore(DateTime.fromMillisecondsSinceEpoch(lockoutTime));
    } else {
      return false;
    }
  }

  /// Resets the swipe count and lockout time.
  void reset() {
    _swipe = 0;
    writer(_kSwipeLimitationTime, 0);
    writer(_kSwipeLimitationTimes, 0);
    notifyListeners();
  }

  /// Increments the swipe count and checks if the limit is reached.
  /// Applies lockout if necessary.
  void swipe([DateTime? now]) {
    _swipe++;
    if (_swipe >= times) {
      _swipe = 0;
      now ??= DateTime.now();
      final lockoutMillis = now.add(lockoutDuration).millisecondsSinceEpoch;
      writer(_kSwipeLimitationTime, lockoutMillis);
      writer(_kSwipeLimitationTimes, 0);
      notifyListeners();
      _startTimer();
    } else {
      writer(_kSwipeLimitationTimes, _swipe);
    }
  }

  Timer? _timer;
  Duration remaining = Duration.zero;

  void _startTimer({
    DateTime? now,
    int? lockoutTime,
    Duration? remainingDuration,
  }) {
    remaining = remainingDuration ?? lockoutDuration;
    if (remaining != Duration.zero) {
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_isLocked(now: now, lockoutTime: lockoutTime)) {
          remaining -= const Duration(seconds: 1);
        } else {
          timer.cancel();
        }
        notifyListeners();
      });
    } else {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }
}
