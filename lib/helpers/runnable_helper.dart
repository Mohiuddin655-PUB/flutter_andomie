import 'dart:async';
import 'dart:math' as math;

class RunnableHelper {
  late final int duration;
  late final int max;
  late int index;

  RunnableHelper({
    this.duration = 3000,
    this.max = 1,
    bool beforeLoad = false,
  }) {
    beforeLoad ? _beforeRun : _run;
  }

  void _execute() {
    onLoad(index);
    index++;
    index < counter ? _run : onCompleted();
  }

  void get _run {
    Timer(
      Duration(milliseconds: duration),
      _execute,
    );
  }

  void get _beforeRun {
    onLoad(index);
    index++;
    if (index < max) {
      _run;
    } else {
      onCompleted();
    }
  }

  bool get isCompleted => max == index + 1;

  int get counter => max;

  int get indexingSize => index + 1;

  int get invertedIndex => math.max(counter - indexingSize, 0);

  void onLoad(int index) {}

  void onCompleted() {}
}
