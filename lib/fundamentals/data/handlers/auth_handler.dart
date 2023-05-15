part of 'handlers.dart';

class AuthHandlerImpl extends AuthHandler {
  const AuthHandlerImpl({
    required super.repository,
  });

  @override
  Future<bool> isSignIn() {
    try {
      return repository.isSignIn();
    } catch (_) {
      return Future.error("$_");
    }
  }

  @override
  Future<Response<bool>> signInWithBiometric() {
    try {
      return repository.signInWithBiometric();
    } catch (_) {
      return Future.error("$_");
    }
  }

  @override
  Future<Response<UserCredential>> signInWithEmailNPassword({
    required String email,
    required String password,
  }) {
    try {
      return repository.signInWithEmailNPassword(
        email: email,
        password: password,
      );
    } catch (_) {
      return Future.error("$_");
    }
  }

  @override
  Future<Response<Credential>> signInWithFacebook() {
    try {
      return repository.signInWithFacebook();
    } catch (_) {
      return Future.error("$_");
    }
  }

  @override
  Future<Response<Credential>> signInWithGoogle() {
    try {
      return repository.signInWithGoogle();
    } catch (_) {
      return Future.error("$_");
    }
  }

  @override
  Future<Response<void>> signOut() {
    try {
      return repository.signOut();
    } catch (_) {
      return Future.error("$_");
    }
  }

  @override
  Future<Response<UserCredential>> signUpWithCredential({
    required AuthCredential credential,
  }) async {
    try {
      return repository.signUpWithCredential(
        credential: credential,
      );
    } catch (_) {
      return Future.error("$_");
    }
  }

  @override
  Future<Response<UserCredential>> signUpWithEmailNPassword({
    required String email,
    required String password,
  }) {
    try {
      return repository.signUpWithEmailNPassword(
        email: email,
        password: password,
      );
    } catch (_) {
      return Future.error("$_");
    }
  }

  @override
  String? get uid => repository.uid;

  @override
  User? get user => repository.user;
}
