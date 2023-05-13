import 'package:firebase_auth/firebase_auth.dart';

import '../../index.dart';

abstract class AuthRepository {
  Future<bool> isSignIn();

  Future<Response> signOut();

  String? get uid;

  User? get user;

  Future<Response<UserCredential>> signUpWithCredential({
    required AuthCredential credential,
  });

  Future<Response<UserCredential>> signUpWithEmailNPassword({
    required String email,
    required String password,
  });

  Future<Response<UserCredential>> signInWithEmailNPassword({
    required String email,
    required String password,
  });

  Future<Response<Credential>> signInWithFacebook();

  Future<Response<Credential>> signInWithGoogle();

  Future<Response<bool>> signInWithBiometric();
}
