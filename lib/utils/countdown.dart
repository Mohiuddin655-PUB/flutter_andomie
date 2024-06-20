import 'dart:async';

import '../models/remaining_duration.dart';

/// Signature for the sleep complete callback.
typedef OnCountdownCompleteListener = void Function();

/// Signature for the sleep remaining duration callback.
typedef OnCountdownRemainingListener = void Function(RemainingDuration value);

/// A timer class that provides sleep functionality with optional periodic updates.
class Countdown {
  /// The total duration for which the sleep timer will run.
  final Duration duration;

  /// The time interval for periodic updates during sleep.
  final Duration periodicTime;

  /// Flag indicating whether the timer is currently running.
  bool isRunning = false;

  Duration _target = Duration.zero;
  OnCountdownCompleteListener _complete = () {};
  OnCountdownRemainingListener _remaining = (value) {};

  Timer? _timer;
  Timer? _prediction;

  /// Creates a [Countdown] with the specified [duration] and optional [periodicTime].
  Countdown(
    this.duration, {
    this.periodicTime = const Duration(seconds: 1),
  });

  /// The callback function called at regular intervals during the sleep.
  void _counter(Timer timer) {
    isRunning = true;
    _target = _target - periodicTime;
    _remaining(_target.use);

    // Check if the sleep duration has elapsed
    if (_target == Duration.zero || _target.inSeconds < 0) {
      isRunning = false;
      timer.cancel();
      _prediction?.cancel();
    }
  }

  /// Starts the sleep timer.
  void start() {
    if (duration != Duration.zero && !isRunning) {
      if (_target == Duration.zero) _target = duration;
      _prediction?.cancel();
      _timer?.cancel();
      _prediction = Timer.periodic(periodicTime, _counter);
      _timer = Timer(_target, _complete);
    }
  }

  /// Resets the sleep timer with an optional new [duration].
  void reset([Duration? duration]) {
    _target = duration ?? this.duration;
    _prediction?.cancel();
    _timer?.cancel();

    if (isRunning) {
      _prediction = Timer.periodic(periodicTime, _counter);
      _timer = Timer(_target, _complete);
    } else {
      _remaining(_target.use);
    }
  }

  /// Stops the sleep timer.
  void stop() {
    isRunning = false;
    _prediction?.cancel();
    _timer?.cancel();
  }

  /// Sets the callback function to be executed when the sleep is complete.
  void setOnCompleteListener(OnCountdownCompleteListener listener) {
    _complete = listener;
  }

  /// Sets the callback function to be executed at each periodic update during sleep.
  void setOnRemainingListener(OnCountdownRemainingListener listener) {
    _remaining = listener;
  }
}

class SleepingTimer extends Countdown {
  SleepingTimer(
    super.duration, {
    super.periodicTime,
  });
}
