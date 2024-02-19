part of '../utils.dart';

/// Callback signature for the rank generation listener.
typedef OnRankGenerateListener = void Function(int value);

/// A class for generating ranks based on a percentage of completion.
class RankGenerator {
  final int percentage;

  /// Creates a [RankGenerator] with the specified percentage.
  ///
  /// The [percentage] determines the threshold for rank generation.
  /// By default, it is set to 100%.
  RankGenerator({
    this.percentage = 100,
  });

  final _increment = 1;
  bool _granted = false;
  int _current = 0;
  int _temp = 0;
  int _total = 0;
  OnRankGenerateListener? _generate;

  /// Checks if the current rank generation threshold is met.
  bool get _grantMode {
    if (_total > 0) {
      final target = _total * (percentage / 100);
      return _current >= target && _generate != null && !_granted;
    } else {
      throw UnimplementedError(
        "init(value) function didn't call anywhere or value is not greater than 0!",
      );
    }
  }

  /// Initializes the [RankGenerator] with the total value.
  ///
  /// This function should be called before any rank updates.
  void init(int value) {
    _current = 0;
    _granted = false;
    _total = value;
  }

  /// Updates the [RankGenerator] with the current progress value.
  ///
  /// If the progress value changes and the rank hasn't been granted,
  /// it increments the current rank, checks the threshold, and triggers the listener if necessary.
  void update(int value) {
    if (value != _temp && !_granted) {
      _temp = value;
      _current = _current + _increment;
      if (_grantMode) {
        _granted = true;
        _generate?.call(_current);
      }
    }
  }

  /// Adds a listener to be notified when a rank is generated.
  void addListener(OnRankGenerateListener listener) => _generate = listener;
}
