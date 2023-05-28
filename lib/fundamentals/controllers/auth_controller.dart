part of 'controllers.dart';

class DefaultAuthController<T extends AuthResponse>
    extends Cubit<AuthResponse> {
  final AuthHandler handler;
  final DataHandler<AuthInfo> userHandler;
  final String Function(String uid)? createUid;

  DefaultAuthController({
    required this.handler,
    required this.userHandler,
    this.createUid,
  }) : super(AuthResponse.initial());

  String get uid => user?.uid ?? "uid";

  User? get user => FirebaseAuth.instance.currentUser;

  Future isLoggedIn([AuthProvider? provider]) async {
    try {
      emit(AuthResponse.loading(provider));
      final signedIn = await handler.isSignIn();
      if (signedIn) {
        emit(AuthResponse.authenticated(state.data));
      } else {
        emit(AuthResponse.unauthenticated("User logged out!"));
      }
    } catch (e) {
      emit(AuthResponse.failure(e.toString()));
    }
  }

  Future signInByEmail(AuthInfo entity) async {
    final email = entity.email;
    final password = entity.password;
    if (!Validator.isValidEmail(email)) {
      emit(AuthResponse.failure("Email isn't valid!"));
    } else if (!Validator.isValidPassword(password)) {
      emit(AuthResponse.failure("Password isn't valid!"));
    } else {
      emit(AuthResponse.loading(AuthProvider.email));
      try {
        final response = await handler.signInWithEmailNPassword(
          email: email,
          password: password,
        );
        if (response.isSuccessful) {
          final result = response.data?.user;
          if (result != null) {
            final user = entity.copy(
              id: createUid?.call(result.uid) ?? result.uid,
              email: result.email,
              name: result.displayName,
              phone: result.phoneNumber,
              photo: result.photoURL,
              provider: AuthProvider.email.name,
            );
            await userHandler.insert(
              user,
              localMode: true,
            );
            emit(AuthResponse.authenticated(user));
          } else {
            emit(AuthResponse.failure(response.exception));
          }
        } else {
          emit(AuthResponse.failure(response.exception));
        }
      } catch (e) {
        emit(AuthResponse.failure(e.toString()));
      }
    }
  }

  Future signUpByEmail(AuthInfo entity) async {
    final email = entity.email;
    final password = entity.password;
    if (!Validator.isValidEmail(email)) {
      emit(AuthResponse.failure("Email isn't valid!"));
    } else if (!Validator.isValidPassword(password)) {
      emit(AuthResponse.failure("Password isn't valid!"));
    } else {
      emit(AuthResponse.loading(AuthProvider.email));
      try {
        final response = await handler.signUpWithEmailNPassword(
          email: email,
          password: password,
        );
        if (response.isSuccessful) {
          final result = response.data?.user;
          if (result != null) {
            final user = entity.copy(
              id: createUid?.call(result.uid) ?? result.uid,
              email: result.email,
              name: result.displayName,
              phone: result.phoneNumber,
              photo: result.photoURL,
              provider: AuthProvider.email.name,
            );
            await userHandler.insert(
              user,
              cacheMode: true,
            );
            emit(AuthResponse.authenticated(user));
          } else {
            emit(AuthResponse.failure(response.exception));
          }
        } else {
          emit(AuthResponse.failure(response.exception));
        }
      } catch (e) {
        emit(AuthResponse.failure(e.toString()));
      }
    }
  }

  Future signInByFacebook(AuthInfo entity) async {
    emit(AuthResponse.loading(AuthProvider.facebook));
    try {
      final response = await handler.signInWithFacebook();
      final result = response.data;
      if (result != null && result.credential != null) {
        final finalResponse = await handler.signUpWithCredential(
          credential: result.credential!,
        );
        if (finalResponse.isSuccessful) {
          final currentData = finalResponse.data?.user;
          final user = entity.copy(
            id: createUid?.call(currentData?.uid ?? result.id ?? uid) ??
                currentData?.uid ??
                result.id,
            email: result.email,
            name: result.name,
            photo: result.photo,
            provider: AuthProvider.facebook.name,
          );
          await userHandler.insert(user, cacheMode: true);
          emit(AuthResponse.authenticated(user));
        } else {
          emit(AuthResponse.failure(finalResponse.message));
        }
      } else {
        emit(AuthResponse.failure(response.message));
      }
    } catch (_) {
      emit(AuthResponse.failure(_.toString()));
    }
  }

  Future signInByGoogle(AuthInfo entity) async {
    emit(AuthResponse.loading(AuthProvider.google));
    try {
      final response = await handler.signInWithGoogle();
      final result = response.data;
      if (result != null && result.credential != null) {
        final finalResponse = await handler.signUpWithCredential(
          credential: result.credential!,
        );
        if (finalResponse.isSuccessful) {
          final currentData = finalResponse.data?.user;
          final user = entity.copy(
            id: createUid?.call(currentData?.uid ?? result.id ?? uid) ??
                currentData?.uid ??
                result.id,
            name: result.name,
            photo: result.photo,
            email: result.email,
            provider: AuthProvider.google.name,
          );
          await userHandler.insert(user, cacheMode: true);
          emit(AuthResponse.authenticated(user));
        } else {
          emit(AuthResponse.failure(finalResponse.message));
        }
      } else {
        emit(AuthResponse.failure(response.message));
      }
    } catch (_) {
      emit(AuthResponse.failure(_.toString()));
    }
  }

  Future signInByBiometric() async {
    emit(AuthResponse.loading(AuthProvider.biometric));
    final response = await handler.signInWithBiometric();
    try {
      if (response.isSuccessful) {
        final userResponse = await userHandler.get(
          createUid?.call(uid) ?? uid,
          localMode: true,
        );
        final user = userResponse.data;
        if (userResponse.isSuccessful && user is AuthInfo) {
          final email = user.email;
          final password = user.password;
          final loginResponse = await handler.signInWithEmailNPassword(
            email: email,
            password: password,
          );
          if (loginResponse.isSuccessful) {
            emit(AuthResponse.authenticated(user));
          } else {
            emit(AuthResponse.failure(loginResponse.message));
          }
        } else {
          emit(AuthResponse.failure(userResponse.message));
        }
      } else {
        emit(AuthResponse.failure(response.message));
      }
    } catch (_) {
      emit(AuthResponse.failure(_.toString()));
    }
  }

  Future signOut([AuthProvider? provider]) async {
    emit(AuthResponse.loading(provider));
    try {
      final response = await handler.signOut();
      if (response.isSuccessful) {
        final userResponse = await userHandler.delete(
          createUid?.call(uid) ?? uid,
        );
        if (userResponse.isSuccessful || userResponse.snapshot != null) {
          emit(AuthResponse.unauthenticated());
        } else {
          emit(AuthResponse.failure(userResponse.message));
        }
      } else {
        emit(AuthResponse.failure(response.message));
      }
    } catch (_) {
      emit(AuthResponse.failure(_.toString()));
    }
  }
}
