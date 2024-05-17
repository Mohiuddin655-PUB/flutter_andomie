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
  /// int randomInt = RandomProvider.getInt(max: 10, min: 5, seed: 42);
  /// // Result: Random integer between 5 (inclusive) and 10 (exclusive).
  /// ```
  static int getInt({
    required int max,
    int min = 0,
    int? seed,
  }) {
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
  /// String randomString = RandomProvider.getString(data: 'abc123', max: 8, seed: 42);
  /// // Result: Random string of length 8 using characters 'a', 'b', 'c', '1', '2', '3'.
  /// ```
  static String getString({
    required String data,
    required int max,
    int? seed,
  }) {
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
  /// String? randomValue = RandomProvider.getValue(data: options, max: 4, min: 1, seed: 42);
  /// // Result: Random value from the list ['B', 'C', 'D'].
  /// ```
  static T? getValue<T>({
    required List<T> data,
    required int max,
    int min = 0,
    int? seed,
  }) {
    if (data.isNotEmpty) {
      return data[getInt(max: data.length, min: min, seed: seed)];
    } else {
      return null;
    }
  }

  /// Generates a list of random values from the provided list.
  ///
  /// Parameters:
  /// - [data]: The list of values.
  /// - [size]: The size of the generated list.
  /// - [min]: The minimum index to use for selecting a value. Default is 0.
  /// - [seed]: Seed for the random number generator. Default is null.
  ///
  /// Example:
  /// ```dart
  /// List<String> options = ['A', 'B', 'C', 'D'];
  /// List<String> randomList = RandomProvider.getList(data: options, size: 3, min: 1, seed: 42);
  /// // Result: List of 3 random values from the list ['B', 'C', 'D'].
  /// ```
  static List<T> getList<T>({
    required List<T> data,
    required int size,
    int min = 0,
    int? seed,
  }) {
    final List<T> list = [];
    for (int i = 0; i < size; ++i) {
      list.add(getValue(data: data, max: size, min: min, seed: seed) as T);
    }
    return list;
  }
}
