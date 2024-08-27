/// Utility class for working with paths.
class PathParser {
  static const String _pathRegs = r"^[a-zA-Z_]\w*(/[a-zA-Z_]\w*)*$";

  /// Splits a path into segments.
  static List<String> segments(String path) {
    path = path.startsWith("/") ? path.substring(1) : path;
    return RegExp(_pathRegs).hasMatch(path) ? path.split("/") : [];
  }

  /// Retrieves path information, including pairs of segments and an ending.
  static PathInfo parse(String source) {
    final path = source.startsWith("/") ? source.substring(1) : source;
    final isValid = path.isNotEmpty && RegExp(_pathRegs).hasMatch(path);
    if (isValid) {
      var segments = path.split("/");
      int length = segments.length;
      String? end = length.isOdd ? segments.last : null;
      List<String> x = [];
      List<String> y = [];
      List.generate(length.isOdd ? length - 1 : length, (i) {
        i.isEven ? x.add(segments[i]) : y.add(segments[i]);
      });
      return PathInfo(
        source: source,
        ending: end,
        collections: x,
        documents: y,
        pairs: List.generate(x.length, (index) {
          return PathPair(x[index], y[index]);
        }),
      );
    }
    return PathInfo(source: source, invalid: true);
  }
}

/// Information about a path, including ending and pairs of segments.
class PathInfo {
  final String source;
  final bool invalid;
  final String? ending;
  final List<PathPair> pairs;
  final List<String> collections;
  final List<String> documents;

  PathInfo({
    required this.source,
    this.invalid = false,
    this.ending,
    this.pairs = const [],
    this.collections = const [],
    this.documents = const [],
  });

  @override
  String toString() {
    return "$PathInfo(source: $source, invalid: $invalid, ending: $ending, pairs: $pairs, collections: $collections, documents: $documents)";
  }
}

/// Represents a pair of path segments.
class PathPair {
  final String x1;
  final String x2;

  PathPair(this.x1, this.x2);

  @override
  String toString() {
    return "Pair($x1 : $x2)";
  }
}
