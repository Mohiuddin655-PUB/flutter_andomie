import 'package:firebase_auth/firebase_auth.dart';

import '../../index.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthDataSource authDataSource;

  AuthRepositoryImpl({
    required this.authDataSource,
  });

  @override
  Future<bool> isSignIn() => authDataSource.isSignIn();

  @override
  Future<Response> signOut() => authDataSource.signOut();

  @override
  String? get uid => authDataSource.uid;

  @override
  User? get user => authDataSource.user;

  @override
  Future<Response<UserCredential>> signUpWithCredential({
    required AuthCredential credential,
  }) {
    return authDataSource.signUpWithCredential(credential: credential);
  }

  @override
  Future<Response<UserCredential>> signUpWithEmailNPassword({
    required String email,
    required String password,
  }) {
    return authDataSource.signUpWithEmailNPassword(
        email: email, password: password);
  }

  @override
  Future<Response<UserCredential>> signInWithEmailNPassword({
    required String email,
    required String password,
  }) {
    return authDataSource.signInWithEmailNPassword(
        email: email, password: password);
  }

  @override
  Future<Response<Credential>> signInWithFacebook() {
    return authDataSource.signInWithFacebook();
  }

  @override
  Future<Response<Credential>> signInWithGoogle() {
    return authDataSource.signInWithGoogle();
  }

  @override
  Future<Response<bool>> signInWithBiometric() {
    return authDataSource.signInWithBiometric();
  }
}
