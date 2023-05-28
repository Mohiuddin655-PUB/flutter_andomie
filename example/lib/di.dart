import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:example/user_local_data_source.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_andomie/core.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'tester/data_controller.dart';
import 'user_data_source.dart';

GetIt locator = GetIt.instance;

Future<void> diInit() async {
  final local = await SharedPreferences.getInstance();
  final database = FirebaseFirestore.instance;
  final realtime = FirebaseDatabase.instance;
  locator.registerLazySingleton<SharedPreferences>(() => local);
  locator.registerLazySingleton<FirebaseFirestore>(() => database);
  locator.registerLazySingleton<FirebaseDatabase>(() => realtime);
  _helpers();
  _dataSources();
  _repositories();
  _handlers();
  _controllers();
  await locator.allReady();
}

void _helpers() {}

void _dataSources() {
  locator.registerLazySingleton<AuthDataSource>(() {
    return AuthDataSourceImpl();
  });
  locator.registerLazySingleton<LocalDataSource<AuthInfo>>(() {
    return LocalUserDataSource(db: locator());
  });
  locator.registerLazySingleton<RemoteDataSource<AuthInfo>>(() {
    return RemoteUserDataSource();
  });
}

void _repositories() {
  locator.registerLazySingleton<AuthRepository>(() {
    return AuthRepositoryImpl(
      authDataSource: locator.call(),
    );
  });
  locator.registerLazySingleton<DataRepository<AuthInfo>>(() {
    return DataRepositoryImpl<AuthInfo>(
      local: locator(),
      remote: locator(),
    );
  });
}

void _handlers() {
  locator.registerLazySingleton<AuthHandler>(() {
    return AuthHandlerImpl(repository: locator());
  });
  locator.registerLazySingleton<DataHandler<AuthInfo>>(() {
    return DataHandlerImpl<AuthInfo>(
      repository: locator(),
    );
  });
}

void _controllers() {
  locator.registerFactory<DefaultAuthController>(() {
    return DefaultAuthController(
      handler: locator(),
      userHandler: locator(),
    );
  });
  locator.registerFactory<DataController>(() {
    return DataController(
      handler: locator(),
    );
  });
}
