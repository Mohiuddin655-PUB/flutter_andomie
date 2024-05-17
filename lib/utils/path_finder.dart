/// Utility class for working with paths.
class PathFinder {
  static const String _pathRegs = r"^[a-zA-Z_]\w*(/[a-zA-Z_]\w*)*$";

  /// Splits a path into segments.
  static List<String> segments(String path) {
    return RegExp(_pathRegs).hasMatch(path) ? path.split("/") : [];
  }

  /// Retrieves path information, including pairs of segments and an ending.
  static PathInfo info(String path) {
    final isValid = path.isNotEmpty && RegExp(_pathRegs).hasMatch(path);
    if (isValid) {
      var segments = path.split("/");
      int length = segments.length;
      String end = length.isOdd ? segments.last : "";
      List<String> x = [];
      List<String> y = [];
      List.generate(length.isOdd ? length - 1 : length, (i) {
        i.isEven ? x.add(segments[i]) : y.add(segments[i]);
      });
      return PathInfo(
        ending: end,
        pairs: List.generate(x.length, (index) {
          return PathTween(x[index], y[index]);
        }),
      );
    }
    return PathInfo(invalid: true);
  }
}

/// Information about a path, including ending and pairs of segments.
class PathInfo {
  final bool invalid;
  final String ending;
  final List<PathTween> pairs;

  PathInfo({
    this.invalid = false,
    this.ending = "",
    this.pairs = const [],
  });

  @override
  String toString() {
    return "Invalid: $invalid, Ending: $ending, Pairs: $pairs";
  }
}

/// Represents a pair of path segments.
class PathTween {
  final String x1;
  final String x2;

  PathTween(this.x1, this.x2);

  @override
  String toString() {
    return "Pair($x1 : $x2)";
  }
}
