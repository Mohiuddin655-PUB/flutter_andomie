part of '../utils.dart';

typedef OnRankGenerateListener = void Function();

class RankGenerator {
  final int percentage;

  RankGenerator({
    this.percentage = 100,
  });

  final _increment = 1;

  bool _granted = false;
  int _current = 0;
  int _temp = 0;
  int _total = 0;
  OnRankGenerateListener? _generate;

  bool get _grantMode {
    if (_total > 0) {
      final target = _total * (percentage / 100);
      return _current >= target && _generate != null && !_granted;
    } else {
      throw UnimplementedError(
        "init(value) function didn't call anywhere or value is not getter than 0!",
      );
    }
  }

  void init(int value) {
    _current = 0;
    _granted = false;
    _total = value;
  }

  void update(int value) {
    if (value != _temp && !_granted) {
      _temp = value;
      _current = _current + _increment;
      if (_grantMode) {
        _granted = true;
        _generate?.call();
      }
    }
  }

  void addListener(OnRankGenerateListener listener) => _generate = listener;
}
