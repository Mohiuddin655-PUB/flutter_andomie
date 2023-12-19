part of 'extensions.dart';

extension ListExtension<E> on List<E>? {
  bool get isValid => use.isNotEmpty;

  bool get isNotValid => !isValid;

  List<E> get use => this ?? [];

  List<E> get unify => use.toSet().toList();

  E? get at => isValid ? use.first : null;

  E? get end => isValid ? use.last : null;

  int get size => use.length;

  List<E> get removeFirst => removeItemAt(0);

  List<E> get removeEnd => removeItemAt(size - 1);

  bool isFound(E value) => use.where((_) => value == _).isNotEmpty;

  bool isNotFound(E value) => !use.isFound(value);

  E? getItem(int index, [E? defaultValue]) =>
      size > 0 && size > index ? use[index] : defaultValue;

  List<E> attachItem(E item, [int? index]) {
    var list = List<E>.from(use);
    if (index != null && size >= index) {
      list.insert(index, item);
    } else {
      list.add(item);
    }
    return list;
  }

  List<E> attachItemAtFirst(E item) => attachItem(item, 0);

  List<E> attachItemAtMiddle(E item) => attachItem(item, size ~/ 2);

  List<E> attachItemAtLast(E item) => attachItem(item, size);

  List<E> attachItems(List<E> items, [bool insertable = true]) {
    if (insertable) {
      var list = List<E>.from(use);
      list.addAll(items);
      return list;
    } else {
      return items;
    }
  }

  List<E> attachItemsAt(List<E> items, int index) {
    var list = List<E>.from(use);
    if (size >= index) {
      list.insertAll(index, items);
    } else {
      list.addAll(items);
    }
    return list;
  }

  List<E> attachItemsAtFirst(List<E> items) => attachItemsAt(items, 0);

  List<E> attachItemsAtMiddle(List<E> items) => attachItemsAt(items, size ~/ 2);

  List<E> attachItemsAtLast(List<E> items) => attachItemsAt(items, size);

  List<E> change(bool status, E value) {
    final a = unify;
    if (status) {
      a.insert(0, value);
    } else {
      a.remove(value);
    }
    return a;
  }

  List<E> changeOnce(E value) {
    final a = unify;
    if (a.contains(value)) {
      a.remove(value);
    } else {
      a.insert(0, value);
    }
    return a;
  }

  List<R> convert<R>(R Function(E value) callback) {
    return use.map(callback).toList();
  }

  List<E> removeItem(E item) {
    var list = List<E>.from(use);
    list.remove(item);
    return list;
  }

  List<E> removeItemAt(int index) {
    if (index >= 0 && index < size) {
      var list = List<E>.from(use);
      list.removeAt(index);
      return list;
    } else {
      return use;
    }
  }

  List<E> removeItems(List<E> items) {
    var list = List<E>.from(use);
    for (var i in items) {
      list.remove(i);
    }
    return list;
  }

  List<E> removeItemsAt(List<int> indexes) {
    var list = List<E>.from(use);
    for (var i in indexes) {
      list.removeAt(i);
    }
    return list;
  }

  List<E> removeItemsByRange(int start, [int? end]) {
    var ending = end ?? size - 1;
    if (start >= 0 && size > ending) {
      var list = List<E>.from(use);
      list.removeRange(start, ending);
      return list;
    } else {
      return use;
    }
  }

  List<E> removeItemsByQuery(bool Function(E item) query) {
    var list = List<E>.from(use);
    list.removeWhere((_) {
      return query(_);
    });
    return list;
  }
}
