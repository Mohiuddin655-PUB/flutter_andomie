import 'dart:math';

import 'package:flutter/material.dart';

/// A utility class for generating random values.
class RandomProvider {
  const RandomProvider._();

  /// Generates a random integer within the specified range.
  ///
  /// Parameters:
  /// - [max]: The maximum value (exclusive).
  /// - [min]: The minimum value (inclusive). Default is 0.
  /// - [seed]: Seed for the random number generator. Default is null.
  ///
  /// Example:
  /// ```dart
  /// int randomInt = RandomProvider.integer(max: 10, min: 5, seed: 42);
  /// // Result: Random integer between 5 (inclusive) and 10 (exclusive).
  /// ```
  static int integer({int max = 100, int min = 0, int? seed}) {
    return Random(seed).nextInt(max - min) + min;
  }

  /// Generates a random string of specified length from the given character set.
  ///
  /// Parameters:
  /// - [data]: The character set to use for generating the string.
  /// - [max]: The length of the generated string.
  /// - [seed]: Seed for the random number generator. Default is null.
  ///
  /// Example:
  /// ```dart
  /// String randomString = RandomProvider.string('abc123', max: 8, seed: 42);
  /// // Result: Random string of length 8 using characters 'a', 'b', 'c', '1', '2', '3'.
  /// ```
  static String string(String data, {int? max, int? seed}) {
    max ??= data.length;
    final Random random = Random(seed);
    var characters = data.characters;
    var value = '';
    for (int i = 0; i < max; ++i) {
      final a = characters.elementAt(random.nextInt(characters.length));
      value = "$value$a";
    }
    return value;
  }

  /// Retrieves a random value from the provided list.
  ///
  /// Parameters:
  /// - [data]: The list of values.
  /// - [max]: The maximum index to use for selecting a value.
  /// - [min]: The minimum index to use for selecting a value. Default is 0.
  /// - [seed]: Seed for the random number generator. Default is null.
  ///
  /// Example:
  /// ```dart
  /// List<String> options = ['A', 'B', 'C', 'D'];
  /// String? randomValue = RandomProvider.value(options, max: 4, min: 1, seed: 42);
  /// // Result: Random value from the list 'B'.
  /// ```
  static T? value<T>(Iterable<T> data, {int? max, int min = 0, int? seed}) {
    max ??= data.length;
    if (data.isNotEmpty) {
      return data.elementAtOrNull(integer(max: max, min: min, seed: seed));
    } else {
      return null;
    }
  }

  /// Generates a list of random values from the provided list.
  ///
  /// Parameters:
  /// - [data]: The list of values.
  /// - [length]: The length of the generated list.
  /// - [min]: The minimum index to use for selecting a value. Default is 0.
  /// - [seed]: Seed for the random number generator. Default is null.
  ///
  /// Example:
  /// ```dart
  /// List<String> options = ['A', 'B', 'C', 'D'];
  /// List<String> randomList = RandomProvider.list(options, length: 3, min: 1, seed: 42);
  /// // Result: List of 3 random values from the list ['B', 'C', 'D'].
  /// ```
  static List<T> list<T>(
    Iterable<T> data, {
    int? length,
    int min = 0,
    int? seed,
  }) {
    length ??= data.length;
    final List<T> list = [];
    for (int i = 0; i < length; ++i) {
      list.add(value(data, max: length, min: min, seed: seed) as T);
    }
    return list;
  }

  /// Randomly selects elements from multiple lists while ensuring uniqueness.
  ///
  /// Parameters:
  /// - [root]: A list of lists containing possible values.
  /// - [length]: The desired number of elements in the result.
  /// - [initial]: An optional list of initial values (default is empty).
  /// - [converter]: A function to modify selected items before adding them.
  ///
  /// Example:
  /// ```dart
  /// List<List<String>> root = [
  ///   ['A', 'B', 'C'],
  ///   ['D', 'E'],
  ///   ['F', 'G', 'H']
  /// ];
  ///
  /// List<String> result = randomize(root, 5);
  /// // Possible output: ['B', 'D', 'F', 'C', 'E']
  /// ```
  static List<T> randomize<T>(
    Iterable<Iterable<T>> root, {
    int? length,
    List<T> initial = const [],
    T Function(int index, T old)? converter,
  }) {
    if (root.isEmpty) return [];
    final total = root.map((e) => e.length).reduce((a, b) => a + b);
    length ??= total;
    final random = Random();
    List<T> randoms = [...initial];
    for (int i = 0; i < root.length; i++) {
      final items = root.elementAtOrNull(i);
      if (items == null || items.isEmpty) continue;
      int index = random.nextInt(items.length);
      final item = items.elementAtOrNull(index);
      if (item == null) continue;
      if (length <= total && randoms.contains(item)) continue;
      randoms.add(
        converter != null ? converter(randoms.length + 1, item) : item,
      );
    }
    if (randoms.length == length) return randoms;
    if (randoms.length > length) return randoms.take(length).toList();
    return randomize(
      root,
      length: length,
      initial: randoms,
      converter: converter,
    );
  }
}

extension RandomStringHelper on String {
  /// Generates a random string of specified length from the given character set.
  ///
  /// Parameters:
  /// - [data]: The character set to use for generating the string.
  /// - [max]: The length of the generated string.
  /// - [seed]: Seed for the random number generator. Default is null.
  ///
  /// Example:
  /// ```dart
  /// String randomString = 'abc123'.randomString(max: 8, seed: 42);
  /// // Result: Random string of length 8 using characters 'a', 'b', 'c', '1', '2', '3'.
  /// ```
  String randomString({int? max, int? seed}) {
    return RandomProvider.string(this, max: max, seed: seed);
  }
}

extension RandomListHelper<T> on Iterable<T> {
  /// Retrieves a random value from the provided list.
  ///
  /// Parameters:
  /// - [data]: The list of values.
  /// - [max]: The maximum index to use for selecting a value.
  /// - [min]: The minimum index to use for selecting a value. Default is 0.
  /// - [seed]: Seed for the random number generator. Default is null.
  ///
  /// Example:
  /// ```dart
  /// List<String> options = ['A', 'B', 'C', 'D'];
  /// String? randomValue = options.randomValue(options, max: 4, min: 1, seed: 42);
  /// // Result: Random value from the list 'B'.
  /// ```
  T? randomValue({int? max, int min = 0, int? seed}) {
    return RandomProvider.value(this, max: max, min: min, seed: seed);
  }

  /// Generates a list of random values from the provided list.
  ///
  /// Parameters:
  /// - [data]: The list of values.
  /// - [length]: The length of the generated list.
  /// - [min]: The minimum index to use for selecting a value. Default is 0.
  /// - [seed]: Seed for the random number generator. Default is null.
  ///
  /// Example:
  /// ```dart
  /// List<String> options = ['A', 'B', 'C', 'D'];
  /// List<String> randomList = options.randomList(length: 3, min: 1, seed: 42);
  /// // Result: List of 3 random values from the list ['B', 'C', 'D'].
  /// ```
  List<T> randomList({int? length, int min = 0, int? seed}) {
    return RandomProvider.list(this, length: length, min: min, seed: seed);
  }
}

extension RanomizeHelper<T> on Iterable<Iterable<T>> {
  /// Randomly selects elements from multiple lists while ensuring uniqueness.
  ///
  /// Parameters:
  /// - [root]: A list of lists containing possible values.
  /// - [length]: The desired number of elements in the result.
  /// - [initial]: An optional list of initial values (default is empty).
  /// - [converter]: A function to modify selected items before adding them.
  ///
  /// Example:
  /// ```dart
  /// List<List<String>> root = [
  ///   ['A', 'B', 'C'],
  ///   ['D', 'E'],
  ///   ['F', 'G', 'H']
  /// ];
  ///
  /// List<String> result = root.randomize(length: 5);
  /// // Possible output: ['B', 'D', 'F', 'C', 'E']
  /// ```
  List<T> randomize({
    int? length,
    List<T> initial = const [],
    T Function(int index, T old)? converter,
  }) {
    return RandomProvider.randomize(
      this,
      length: length,
      initial: initial,
      converter: converter,
    );
  }
}
