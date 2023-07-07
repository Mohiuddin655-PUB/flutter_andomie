part of '../services.dart';

typedef LocalDataBuilder<T extends Entity> = T Function(dynamic);

typedef ClearByFinder<T extends Entity> = (
  bool isValid,
  List<T>? backups,
  List<T>? result,
  String? message,
  Status? status,
);
typedef DeleteByIdFinder<T extends Entity> = (
  bool isValid,
  T? find,
  List<T>? result,
  String? message,
  Status? status,
);
typedef FindByFinder<T extends Entity> = (
  bool isValid,
  List<T>? result,
  String? message,
  Status? status,
);
typedef FindByIdFinder<T extends Entity> = (
  bool isValid,
  T? find,
  List<T>? result,
  String? message,
  Status? status,
);
typedef UpdateByDataFinder<T extends Entity> = (
  bool isValid,
  T? data,
  List<T>? result,
  String? message,
  Status? status,
);
typedef SetByDataFinder<T extends Entity> = (
  bool isValid,
  List<T>? result,
  String? message,
  Status? status,
);
typedef SetByListFinder<T extends Entity> = (
  bool isValid,
  List<T>? current,
  List<T>? ignores,
  List<T>? result,
  String? message,
  Status? status,
);

class LocalDatabaseImpl extends LocalDatabase {
  const LocalDatabaseImpl(super.preferences);

  static SharedPreferences? _proxy;

  static Future<LocalDatabaseImpl> get instance async {
    return LocalDatabaseImpl(
      _proxy ??= await SharedPreferences.getInstance(),
    );
  }

  static Future<LocalDatabase> get I => instance;

  static Future<LocalDatabase> getInstance() => instance;

  @override
  Future<bool> input<T extends Entity>(
    String key,
    List<T>? data,
  ) async {
    try {
      final db = this;
      if (data.isValid) {
        return db.setItems(key, data._);
      } else {
        return db.setItems(key, null);
      }
    } catch (_) {
      return Future.error(_);
    }
  }

  @override
  Future<List<T>> output<T extends Entity>(
    String key,
    LocalDataBuilder<T> builder,
  ) async {
    try {
      final db = this;
      return db.getItems(key)._.map((E) => builder(E)).toList();
    } catch (_) {
      return Future.error(_);
    }
  }

  @override
  Future<ClearByFinder<T>> clearBy<T extends Entity>({
    required String path,
    required LocalDataBuilder<T> builder,
  }) {
    return I.clearBy(path: path, builder: builder);
  }

  @override
  Future<DeleteByIdFinder<T>> deleteById<T extends Entity>({
    required String path,
    required String id,
    required LocalDataBuilder<T> builder,
  }) {
    return I.deleteById(path: path, id: id, builder: builder);
  }

  @override
  Future<FindByFinder<T>> findBy<T extends Entity>({
    required String path,
    required LocalDataBuilder<T> builder,
  }) {
    return I.findBy(path: path, builder: builder);
  }

  @override
  Future<FindByIdFinder<T>> findById<T extends Entity>({
    required String path,
    required String id,
    required LocalDataBuilder<T> builder,
  }) {
    return I.findById(path: path, id: id, builder: builder);
  }

  @override
  Future<UpdateByDataFinder<T>> updateByData<T extends Entity>({
    required String path,
    required String id,
    required Map<String, dynamic> data,
    required LocalDataBuilder<T> builder,
  }) {
    return I.updateByData(path: path, id: id, data: data, builder: builder);
  }

  @override
  Future<SetByDataFinder<T>> setByData<T extends Entity>({
    required String path,
    required T data,
    required LocalDataBuilder<T> builder,
  }) {
    return I.setByData(path: path, data: data, builder: builder);
  }

  @override
  Future<SetByListFinder<T>> setByList<T extends Entity>({
    required String path,
    required List<T> data,
    required LocalDataBuilder<T> builder,
  }) {
    return I.setByList(path: path, data: data, builder: builder);
  }
}

extension LocalDataFinder on Future<LocalDatabase> {
  Future<ClearByFinder<T>> clearBy<T extends Entity>({
    required String path,
    required LocalDataBuilder<T> builder,
  }) async {
    try {
      return output<T>(path, builder).then((value) {
        if (value.isNotEmpty) {
          return input(path, null).then((successful) {
            if (successful) {
              return (true, value, null, null, Status.ok);
            } else {
              return (false, null, value, "Database error!", Status.error);
            }
          }).onError((e, s) {
            return (false, null, value, "$e", Status.failure);
          });
        } else {
          return (false, null, value, null, Status.notFound);
        }
      });
    } catch (_) {
      return (false, null, null, "$_", Status.failure);
    }
  }

  Future<DeleteByIdFinder<T>> deleteById<T extends Entity>({
    required String path,
    required String id,
    required LocalDataBuilder<T> builder,
  }) async {
    if (id.isValid) {
      try {
        return output<T>(path, builder).then((value) {
          final result = value.where((E) => E.id == id).toList();
          if (result.isNotEmpty) {
            value.removeWhere((E) => E.id == id);
            return input(path, value).then((successful) {
              if (successful) {
                return (true, result.first, value, null, Status.ok);
              } else {
                return (false, null, value, "Database error!", Status.error);
              }
            }).onError((e, s) {
              return (false, null, value, "$e", Status.failure);
            });
          } else {
            return (false, null, value, null, Status.notFound);
          }
        });
      } catch (_) {
        return (false, null, null, "$_", Status.failure);
      }
    } else {
      return (false, null, null, null, Status.invalidId);
    }
  }

  Future<FindByFinder<T>> findBy<T extends Entity>({
    required String path,
    required LocalDataBuilder<T> builder,
  }) async {
    try {
      return output<T>(path, builder).then((value) {
        if (value.isNotEmpty) {
          return (true, value, null, Status.alreadyFound);
        } else {
          return (false, null, null, Status.notFound);
        }
      });
    } catch (_) {
      return (false, null, "$_", Status.failure);
    }
  }

  Future<FindByIdFinder<T>> findById<T extends Entity>({
    required String path,
    required String id,
    required LocalDataBuilder<T> builder,
  }) async {
    if (id.isValid) {
      try {
        return output<T>(path, builder).then((value) {
          final result = value.where((E) => E.id == id).toList();
          if (result.isNotEmpty) {
            return (true, result.first, value, null, Status.alreadyFound);
          } else {
            return (false, null, value, null, Status.notFound);
          }
        });
      } catch (_) {
        return (false, null, null, "$_", Status.failure);
      }
    } else {
      return (false, null, null, null, Status.invalidId);
    }
  }

  Future<UpdateByDataFinder<T>> updateByData<T extends Entity>({
    required String path,
    required String id,
    required Map<String, dynamic> data,
    required LocalDataBuilder<T> builder,
  }) async {
    if (id.isValid) {
      try {
        return output<T>(path, builder).then((value) {
          T? B;
          var i = value.indexWhere((E) {
            if (id == E.id) {
              B = E;
              return true;
            } else {
              return false;
            }
          });
          if (i > -1) {
            value.removeAt(i);
            value.insert(i, builder(data));
            return input(path, value).then((task) {
              if (task) {
                return (true, B, value, null, Status.ok);
              } else {
                return (false, null, value, "Database error!", Status.error);
              }
            }).onError((e, s) {
              return (false, null, value, "$e", Status.failure);
            });
          } else {
            return (false, null, value, null, Status.notFound);
          }
        });
      } catch (_) {
        return (false, null, null, "$_", Status.failure);
      }
    } else {
      return (false, null, null, null, Status.invalidId);
    }
  }

  Future<SetByDataFinder<T>> setByData<T extends Entity>({
    required String path,
    required T data,
    required LocalDataBuilder<T> builder,
  }) async {
    if (data.id.isValid) {
      try {
        return output<T>(path, builder).then((value) {
          final insertable = value.where((E) => E.id == data.id).isEmpty;
          if (insertable) {
            value.add(data);
            return input(path, value).then((task) {
              if (task) {
                return (true, value, null, Status.ok);
              } else {
                return (false, value, "Database error!", Status.error);
              }
            }).onError((e, s) {
              return (false, value, "$e", Status.error);
            });
          } else {
            return (false, value, null, Status.alreadyFound);
          }
        });
      } catch (_) {
        return (false, null, "$_", Status.failure);
      }
    } else {
      return (false, null, null, Status.invalidId);
    }
  }

  Future<SetByListFinder<T>> setByList<T extends Entity>({
    required String path,
    required List<T> data,
    required LocalDataBuilder<T> builder,
  }) async {
    if (data.isValid) {
      try {
        return output<T>(path, builder).then((value) {
          List<T> current = [];
          List<T> ignores = [];
          for (var i in data) {
            final insertable = value.where((E) => E.id == i.id).isEmpty;
            if (insertable) {
              current.add(i);
              value.add(i);
            } else {
              ignores.add(i);
            }
          }
          if (data.length != ignores.length) {
            return input(path, value).then((task) {
              if (task) {
                return (true, current, ignores, value, null, Status.ok);
              } else {
                return (
                  false,
                  current,
                  ignores,
                  value,
                  "Database error!",
                  Status.error,
                );
              }
            }).onError((e, s) {
              return (false, current, ignores, value, "$e", Status.failure);
            });
          } else {
            return (false, null, null, null, null, Status.alreadyFound);
          }
        });
      } catch (_) {
        return (false, null, null, null, "$_", Status.failure);
      }
    } else {
      return (false, null, null, null, null, Status.invalidId);
    }
  }
}

extension _LocalExtension on Future<LocalDatabase> {
  Future<bool> input<T extends Entity>(
    String key,
    List<T>? data,
  ) async {
    var db = await this;
    return db.input(key, data);
  }

  Future<List<T>> output<T extends Entity>(
    String key,
    LocalDataBuilder<T> builder,
  ) async {
    var db = await this;
    return db.output(key, builder);
  }
}

extension _LocalListExtension<T extends Entity> on List<T>? {
  List<T> get use => this ?? [];

  List<Map<String, dynamic>> get _ => use.map((_) => _.source).toList();
}

extension _LocalRawItemsExtension on List? {
  List get _ => this ?? [];
}
