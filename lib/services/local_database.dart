part of '../services.dart';

abstract class LocalDatabase extends PreferenceHelper {
  const LocalDatabase(super.preferences);

  Future<bool> input<T extends Entity>(
    String key,
    List<T>? data,
  );

  Future<List<T>> output<T extends Entity>(
    String key,
    LocalDataBuilder<T> builder,
  );

  Future<ClearByFinder<T>> clearBy<T extends Entity>({
    required String path,
    required LocalDataBuilder<T> builder,
  });

  Future<DeleteByIdFinder<T>> deleteById<T extends Entity>({
    required String path,
    required String id,
    required LocalDataBuilder<T> builder,
  });

  Future<FindByFinder<T>> findBy<T extends Entity>({
    required String path,
    required LocalDataBuilder<T> builder,
  });

  Future<FindByIdFinder<T>> findById<T extends Entity>({
    required String path,
    required String id,
    required LocalDataBuilder<T> builder,
  });

  Future<UpdateByDataFinder<T>> updateByData<T extends Entity>({
    required String path,
    required String id,
    required Map<String, dynamic> data,
    required LocalDataBuilder<T> builder,
  });

  Future<SetByDataFinder<T>> setByData<T extends Entity>({
    required String path,
    required T data,
    required LocalDataBuilder<T> builder,
  });

  Future<SetByListFinder<T>> setByList<T extends Entity>({
    required String path,
    required List<T> data,
    required LocalDataBuilder<T> builder,
  });
}
