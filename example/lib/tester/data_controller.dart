import 'package:flutter_andomie/core.dart';

class DataController extends DefaultDataController<AuthInfo> {
  DataController({
    required super.handler,
  });

  @override
  void insert<R>(
    AuthInfo data, {
    bool cacheMode = true,
    bool localMode = false,
    OnDataSourceBuilder<R>? source,
  }) {
    super.insert(
      data,
      cacheMode: cacheMode,
      localMode: localMode,
      source: source,
    );
  }

  @override
  void inserts<R>(
    List<AuthInfo> data, {
    bool cacheMode = true,
    bool localMode = false,
    OnDataSourceBuilder<R>? source,
  }) {
    super.inserts(
      data,
      cacheMode: cacheMode,
      localMode: localMode,
      source: source,
    );
  }

  @override
  void update<R>(
    AuthInfo data, {
    bool cacheMode = true,
    bool localMode = false,
    OnDataSourceBuilder<R>? source,
  }) {
    super.update(
      data,
      cacheMode: cacheMode,
      localMode: localMode,
      source: source,
    );
  }

  @override
  void delete<R>(
    String id, {
    bool cacheMode = true,
    bool localMode = false,
    OnDataSourceBuilder<R>? source,
  }) {
    super.delete(
      id,
      cacheMode: cacheMode,
      localMode: localMode,
      source: source,
    );
  }

  @override
  void get<R>(
    String id, {
    bool cacheMode = true,
    bool localMode = false,
    OnDataSourceBuilder<R>? source,
  }) {
    super.get(
      id,
      cacheMode: cacheMode,
      localMode: localMode,
      source: source,
    );
  }

  @override
  void gets<R>({
    bool cacheMode = true,
    bool localMode = false,
    OnDataSourceBuilder<R>? source,
  }) {
    super.gets(
      cacheMode: cacheMode,
      localMode: localMode,
      source: source,
    );
  }

  @override
  void getUpdates<R>({
    bool cacheMode = true,
    bool localMode = false,
    OnDataSourceBuilder<R>? source,
  }) {
    super.getUpdates(
      cacheMode: cacheMode,
      localMode: localMode,
      source: source,
    );
  }

  @override
  Stream<Response<AuthInfo>> live<R>(
    String id, {
    bool cacheMode = true,
    bool localMode = false,
    OnDataSourceBuilder<R>? source,
  }) {
    return super.live(
      id,
      cacheMode: cacheMode,
      localMode: localMode,
      source: source,
    );
  }

  @override
  Stream<Response<AuthInfo>> lives<R>({
    bool cacheMode = true,
    bool localMode = false,
    OnDataSourceBuilder<R>? source,
  }) {
    return super.lives(
      cacheMode: cacheMode,
      localMode: localMode,
      source: source,
    );
  }
}
