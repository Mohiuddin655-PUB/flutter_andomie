import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../index.dart';

abstract class RealtimeDataSourceImpl<T extends Entity> extends DataSource<T> {
  final String path;

  RealtimeDataSourceImpl({required this.path});

  FirebaseDatabase? _db;

  FirebaseDatabase get database => _db ??= FirebaseDatabase.instance;

  DatabaseReference _source<R>(
    R? Function(R parent)? source,
  ) {
    final parent = database.ref(path);
    dynamic current = source?.call(parent as R);
    if (current is DatabaseReference) {
      return current;
    } else {
      return parent;
    }
  }

  String get uid => FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  Future<Response<T>> create<R>({
    required T data,
    String? id,
    R? Function(R parent)? source,
  }) async {
    final response = Response<T>();
    if ((id ?? "").isNotEmpty) {
      final ref = _source(source).child(id ?? "");
      return await ref.get().then((value) async {
        if (!value.exists) {
          await ref.set(data);
          return response.copy(data: data);
        } else {
          return response.copy(
            snapshot: value,
            message: 'Already inserted!',
          );
        }
      });
    } else {
      return response.copy(error: "ID isn't valid!");
    }
  }

  @override
  Future<Response<T>> update<R>(
    String id,
    Map<String, dynamic> data, {
    R? Function(R parent)? source,
  }) async {
    final response = Response<T>();
    try {
      await _source(source).child(id).update(data);
      return response.copy(isSuccessful: true);
    } catch (_) {
      return response.copy(error: _.toString());
    }
  }

  @override
  Future<Response<T>> delete<R>(
    String id, {
    Map<String, dynamic>? extra,
    R? Function(R parent)? source,
  }) async {
    final response = Response<T>();
    try {
      await _source(source).child(id).remove();
      return response.copy(isSuccessful: true);
    } catch (_) {
      return response.copy(error: _.toString());
    }
  }

  @override
  Future<Response<T>> get<R>(
    String id, {
    Map<String, dynamic>? extra,
    R? Function(R parent)? source,
  }) async {
    final response = Response<T>();
    try {
      final result = await _source(source).child(id).get();
      if (result.exists && result.value != null) {
        return response.copy(data: build(result.value));
      } else {
        return response.copy(error: "Data not found!");
      }
    } catch (_) {
      return response.copy(error: _.toString());
    }
  }

  @override
  Future<Response<T>> gets<R>({
    bool onlyUpdatedData = false,
    Map<String, dynamic>? extra,
    R? Function(R parent)? source,
  }) async {
    final response = Response<T>();
    try {
      final result = await _source(source).get();
      if (result.exists) {
        List<T> list = result.children.map((e) {
          return build(e.value);
        }).toList();
        return response.copy(result: list);
      } else {
        return response.copy(error: "Data not found!");
      }
    } catch (_) {
      return response.copy(error: _.toString());
    }
  }

  @override
  Future<Response<T>> getUpdates<R>({
    Map<String, dynamic>? extra,
    R? Function(R parent)? source,
  }) {
    return gets(
      onlyUpdatedData: true,
      source: source,
    );
  }

  @override
  Stream<Response<T>> live<R>(
    String id, {
    Map<String, dynamic>? extra,
    R? Function(R parent)? source,
  }) {
    final controller = StreamController<Response<T>>();
    final response = Response<T>();
    try {
      _source(source).child(id).onValue.listen((event) {
        if (event.snapshot.exists || event.snapshot.value != null) {
          controller.add(response.copy(data: build(event.snapshot.value)));
        } else {
          controller.addError("Data not found!");
        }
      });
    } catch (_) {
      controller.addError(_);
    }
    return controller.stream;
  }

  @override
  Stream<Response<T>> lives<R>({
    bool onlyUpdatedData = false,
    Map<String, dynamic>? extra,
    R? Function(R parent)? source,
  }) {
    final controller = StreamController<Response<T>>();
    final response = Response<T>();
    try {
      _source(source).onValue.listen((result) {
        if (result.snapshot.exists) {
          List<T> list = result.snapshot.children.map((e) {
            return build(e.value);
          }).toList();
          controller.add(response.copy(result: list));
        } else {
          controller.addError("Data not found!");
        }
      });
    } catch (_) {
      controller.addError(_);
    }

    return controller.stream;
  }
}
