part of '../utils.dart';

class ListCreator<T> {
  final int _capacity;
  List<List<T>> _collections = [];
  int _index = 0;

  ListCreator(this._capacity);

  static List<List<T>> chopped<T>(List<T> list, int limit) {
    final parts = <List<T>>[];
    final int N = list.length;
    for (int i = 0; i < N; i += limit) {
      List<T> li = list.sublist(i, min(N, i + limit));
      parts.add(li);
    }
    return parts;
  }

  int get index => _index;

  ListCreator<T> load(List<T> list) {
    _collections = chopped(list, max(_capacity, 1));
    _index = 0;
    return this;
  }

  List<T> collection([int? position]) {
    final i = position ?? index;
    final data = collections.length > i ? collections[i] : <T>[];
    _index++;
    return data;
  }

  List<List<T>> get collections => _collections;
}
