part of 'repositories.dart';

abstract class AuthRepository {
  String? get uid;

  User? get user;

  Future<bool> isSignIn();

  Future<Response<void>> signOut();

  Future<Response<bool>> signInWithBiometric();

  Future<Response<Credential>> signInWithFacebook();

  Future<Response<Credential>> signInWithGoogle();

  Future<Response<UserCredential>> signInWithEmailNPassword({
    required String email,
    required String password,
  });

  Future<Response<UserCredential>> signUpWithCredential({
    required AuthCredential credential,
  });

  Future<Response<UserCredential>> signUpWithEmailNPassword({
    required String email,
    required String password,
  });
}