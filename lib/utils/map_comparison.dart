class MapChanges {
  final List<String> added;
  final List<String> removed;
  final List<String> modified;
  final List<String> unchanged;

  bool isAdded(String path) => added.contains(path);

  bool isRemoved(String path) => removed.contains(path);

  bool isChanged(String path) => modified.any((e) => e.startsWith(path));

  bool isNotChanged(String path) => unchanged.any((e) => e.startsWith(path));

  const MapChanges({
    this.added = const [],
    this.removed = const [],
    this.modified = const [],
    this.unchanged = const [],
  });

  factory MapChanges.changes(Map oldMap, Map newMap) {
    return MapComparison.changes(oldMap, newMap);
  }

  factory MapChanges.compare(Map oldMap, Map newMap) {
    return MapComparison.compare(oldMap, newMap);
  }

  @override
  String toString() {
    return "$MapChanges(added: $added, removed: $removed, modified: $modified, unchanged: $unchanged)";
  }
}

class MapComparison {
  const MapComparison._();

  /// Checks if two values are different, handling nested maps and lists
  static bool isDifferent(dynamic oldValue, dynamic newValue) {
    // Different types
    if (oldValue.runtimeType != newValue.runtimeType) {
      return true;
    }

    // Handle nested maps
    if (oldValue is Map && newValue is Map) {
      // Different lengths
      if (oldValue.length != newValue.length) {
        return true;
      }

      // Check each key-value pair
      for (final key in oldValue.keys) {
        if (!newValue.containsKey(key) ||
            isDifferent(oldValue[key], newValue[key])) {
          return true;
        }
      }

      // Check if newMap has keys not in oldMap
      for (final key in newValue.keys) {
        if (!oldValue.containsKey(key)) {
          return true;
        }
      }

      return false;
    }

    // Handle lists
    if (oldValue is List && newValue is List) {
      if (oldValue.length != newValue.length) {
        return true;
      }

      for (var i = 0; i < oldValue.length; i++) {
        if (isDifferent(oldValue[i], newValue[i])) {
          return true;
        }
      }

      return false;
    }

    // Simple value comparison
    return oldValue != newValue;
  }

  /// Compares two maps and returns different types of changes between them
  static MapChanges compare(Map oldMap, Map newMap) {
    final result = {
      // Keys present in newMap but not in oldMap
      'added': <String>{},
      // Keys present in oldMap but not in newMap
      'removed': <String>{},
      // Keys present in both maps but with different values
      'modified': <String>{},
      // Keys present in both maps with identical values
      'unchanged': <String>{},
    };

    // Find added and modified keys
    newMap.forEach((key, newValue) {
      if (!oldMap.containsKey(key)) {
        result['added']?.add(key);
      } else {
        final oldValue = oldMap[key];
        if (isDifferent(oldValue, newValue)) {
          result['modified']?.add(key);
        } else {
          result['unchanged']?.add(key);
        }
      }
    });

    // Find removed keys
    for (var key in oldMap.keys) {
      if (!newMap.containsKey(key)) {
        result['removed']?.add(key);
      }
    }

    final added = result["added"]!.toList();
    final removed = result["removed"]!.toList();
    final modified = result["modified"]!.toList();
    final unchanged = result["unchanged"]!.toList();

    return MapChanges(
      added: added,
      removed: removed,
      modified: modified,
      unchanged: unchanged,
    );
  }

  /// Helper function to find all changed paths in nested maps
  static MapChanges changes(Map oldMap, Map newMap) {
    final result = {
      'added': <String>[],
      'removed': <String>[],
      'modified': <String>[],
      'unchanged': <String>[],
    };

    _compareNestedMaps(oldMap, newMap, '', result);

    final added = result["added"]!;
    final removed = result["removed"]!;
    final modified = result["modified"]!;
    final unchanged = result["unchanged"]!;

    return MapChanges(
      added: added,
      removed: removed,
      modified: modified,
      unchanged: unchanged,
    );
  }

  /// Helper function to recursively compare nested maps
  static void _compareNestedMaps(
    Map oldMap,
    Map newMap,
    String currentPath,
    Map<String, List<String>> result,
  ) {
    // Check for removed keys
    for (final key in oldMap.keys) {
      final path = currentPath.isEmpty ? key : '$currentPath/$key';

      if (!newMap.containsKey(key)) {
        result['removed']!.add(path);
        continue;
      }

      final oldValue = oldMap[key];
      final newValue = newMap[key];

      // Recursively check nested maps
      if (oldValue is Map && newValue is Map) {
        _compareNestedMaps(oldValue, newValue, path, result);
      }
      // Handle different values
      else if (isDifferent(oldValue, newValue)) {
        result['modified']!.add(path);
      }
    }

    // Check for added keys
    for (final key in newMap.keys) {
      if (!oldMap.containsKey(key)) {
        final path = currentPath.isEmpty ? key : '$currentPath/$key';
        result['added']!.add(path);
      }
    }
  }
}
