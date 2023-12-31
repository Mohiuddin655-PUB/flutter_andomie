import 'dart:async';

typedef OnSleepCompleteListener = void Function();
typedef OnSleepRemainingListener = void Function(Duration value);

class Sleeper {
  final Duration duration;
  final Duration periodicTime;

  bool isRunning = false;

  Duration _target = Duration.zero;
  OnSleepCompleteListener _complete = () {};
  OnSleepRemainingListener _remaining = (value) {};

  Timer? _timer;
  Timer? _prediction;

  Sleeper(
    this.duration, {
    this.periodicTime = const Duration(seconds: 1),
  });

  void _counter(Timer timer) {
    isRunning = true;
    _target = _target - periodicTime;
    _remaining(_target);
    if (_target == Duration.zero || _target.inSeconds < 0) {
      isRunning = false;
      timer.cancel();
      _prediction?.cancel();
    }
  }

  void start() {
    if (duration != Duration.zero && !isRunning) {
      if (_target == Duration.zero) _target = duration;
      _prediction?.cancel();
      _timer?.cancel();
      _prediction = Timer.periodic(periodicTime, _counter);
      _timer = Timer(_target, _complete);
    }
  }

  void reset([Duration? duration]) {
    _target = duration ?? this.duration;
    _prediction?.cancel();
    _timer?.cancel();
    if (isRunning) {
      _prediction = Timer.periodic(periodicTime, _counter);
      _timer = Timer(_target, _complete);
    } else {
      _remaining(_target);
    }
  }

  void stop() {
    isRunning = false;
    _prediction?.cancel();
    _timer?.cancel();
  }

  void setOnCompleteListener(OnSleepCompleteListener listener) {
    _complete = listener;
  }

  void setOnRemainingListener(OnSleepRemainingListener listener) {
    _remaining = listener;
  }
}
