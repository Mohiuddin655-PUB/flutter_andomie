import 'package:flutter_andomie/core.dart';

class RemoteUserDataSource extends FireStoreDataSourceImpl<AuthInfo> {
  RemoteUserDataSource({
    super.path = "users",
  });

  @override
  AuthInfo build(source) => AuthInfo.from(source);
}
