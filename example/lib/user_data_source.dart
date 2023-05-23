import 'package:flutter_andomie/core.dart';

class UserDataSource extends FireStoreDataSourceImpl<AuthInfo> {
  UserDataSource({
    super.path = "users",
  });

  @override
  AuthInfo build(source) => AuthInfo.from(source);
}
