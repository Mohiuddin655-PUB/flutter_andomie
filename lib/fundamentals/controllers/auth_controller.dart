part of 'controllers.dart';

class AuthController extends Cubit<AuthResponse> {
  final AuthHandler handler;
  final UserHandler userHandler;

  AuthController({
    required this.handler,
    required this.userHandler,
  }) : super(const AuthResponse());

  String get uid => user?.uid ?? "uid";

  User? get user => FirebaseAuth.instance.currentUser;

  Future<bool> get isLoggedIn async {
    try {
      emit(state.copy(isLoading: true));
      final signedIn = await handler.isSignIn();
      if (signedIn) {
        emit(state.copy(isSuccessful: true));
      } else {
        emit(state.copy(error: "User logged out!"));
      }
      return signedIn;
    } catch (e) {
      emit(state.copy(error: e.toString()));
      return Future.error(e);
    }
  }

  Future<Response> signUpByEmail(UserEntity entity) async {
    const cubitResponse = Response();
    final email = entity.email;
    final password = entity.password;
    if (!Validator.isValidEmail(email)) {
      emit(state.copy(error: "Email isn't valid!"));
      return cubitResponse.copy(message: "Email isn't valid!");
    } else if (!Validator.isValidPassword(password)) {
      emit(state.copy(error: "Password isn't valid!"));
      return cubitResponse.copy(message: "Password isn't valid!");
    } else {
      try {
        emit(state.copy(isLoading: true));
        final response = await handler.signUpWithEmailNPassword(
          email: email,
          password: password,
        );
        final result = response.data?.user;
        if (result != null) {
          final user = entity.copy(
            id: result.uid,
            email: result.email,
            phone: result.phoneNumber,
            name: result.displayName,
            photo: result.photoURL,
          );
          final userResponse = await userHandler.create(user);
          if (userResponse.isSuccessful || userResponse.snapshot != null) {
            emit(state.copy(user: user, firebaseUser: response.data?.user));
          } else {
            emit(state.copy(error: userResponse.message));
          }
          return userResponse.copy(data: user);
        } else {
          emit(state.copy(error: response.message));
          return response;
        }
      } catch (e) {
        emit(state.copy(error: e.toString()));
        return cubitResponse.copy(message: e.toString());
      }
    }
  }

  Future<Response> signInByEmail(UserEntity entity) async {
    const cubitResponse = Response();
    final email = entity.email;
    final password = entity.password;
    if (!Validator.isValidEmail(email)) {
      emit(state.copy(error: "Email isn't valid!"));
      return cubitResponse.copy(message: "Email isn't valid!");
    } else if (!Validator.isValidPassword(password)) {
      emit(state.copy(error: "Password isn't valid!"));
      return cubitResponse.copy(message: "Password isn't valid!");
    } else {
      try {
        emit(state.copy(isLoading: true));
        final response = await handler.signInWithEmailNPassword(
          email: email,
          password: password,
        );
        final result = response.data?.user;
        if (result != null) {
          final user = entity.copy(
            id: result.uid,
            email: result.email,
            name: result.displayName,
            phone: result.phoneNumber,
            photo: result.photoURL,
            provider: AuthProvider.email.name,
          );
          final userResponse = await userHandler.create(user);
          if (userResponse.isSuccessful || userResponse.snapshot != null) {
            emit(state.copy(user: user, firebaseUser: result));
          } else {
            emit(state.copy(error: userResponse.message));
          }
          return userResponse.copy(data: user);
        } else {
          emit(state.copy(error: response.message));
          return response;
        }
      } catch (e) {
        emit(state.copy(error: e.toString()));
        return cubitResponse.copy(message: e.toString());
      }
    }
  }

  Future<Response> signInByFacebook(UserEntity entity) async {
    emit(state.copy(isLoading: true));
    final response = await handler.signInWithFacebook();
    final result = response.data;
    if (result != null && result.credential != null) {
      final finalResponse = await handler.signUpWithCredential(
        credential: result.credential!,
      );
      if (finalResponse.isSuccessful) {
        final currentData = finalResponse.data?.user;
        final user = entity.copy(
          id: currentData?.uid ?? result.id,
          email: result.email,
          name: result.name,
          photo: result.photo,
          provider: AuthProvider.facebook.name,
        );
        final userResponse = await userHandler.create(user);
        if (userResponse.isSuccessful || userResponse.snapshot != null) {
          emit(state.copy(user: user, firebaseUser: currentData));
        } else {
          emit(state.copy(error: userResponse.message));
        }
        return userResponse.copy(data: user);
      } else {
        emit(state.copy(error: finalResponse.message));
        return finalResponse;
      }
    } else {
      emit(state.copy(error: response.message));
      return response;
    }
  }

  Future<Response> signInByGoogle(UserEntity entity) async {
    emit(state.copy(isLoading: true));
    final response = await handler.signInWithGoogle();
    final result = response.data;
    if (result != null && result.credential != null) {
      final finalResponse = await handler.signUpWithCredential(
        credential: result.credential!,
      );
      if (finalResponse.isSuccessful) {
        final currentData = finalResponse.data?.user;
        final user = entity.copy(
          id: currentData?.uid ?? result.id,
          name: result.name,
          photo: result.photo,
          email: result.email,
          provider: AuthProvider.google.name,
        );
        final userResponse = await userHandler.create(user);
        if (userResponse.isSuccessful || userResponse.snapshot != null) {
          emit(state.copy(user: user, firebaseUser: currentData));
        } else {
          emit(state.copy(error: userResponse.message));
        }
        return userResponse.copy(data: user);
      } else {
        emit(state.copy(error: finalResponse.message));
        return finalResponse;
      }
    } else {
      emit(state.copy(error: response.message));
      return response;
    }
  }

  Future<Response> signInByBiometric() async {
    emit(state.copy(isLoading: true));
    final response = await handler.signInWithBiometric();
    if (response.isSuccessful) {
      final userResponse = await userHandler.get(uid, fromCache: true);
      final user = userResponse.data;
      if (userResponse.isSuccessful && user is UserEntity) {
        final email = user.email;
        final password = user.password;
        final loginResponse = await handler.signInWithEmailNPassword(
          email: email,
          password: password,
        );
        if (loginResponse.isSuccessful) {
          emit(state.copy(firebaseUser: loginResponse.data?.user, user: user));
        } else {
          emit(state.copy(error: loginResponse.message));
        }
        return loginResponse;
      } else {
        emit(state.copy(error: userResponse.message));
      }
      return userResponse;
    } else {
      emit(state.copy(error: response.message));
    }
    return response;
  }

  Future<Response> signOut() async {
    emit(state.copy(isLoading: true));
    final response = await handler.signOut();
    if (response.isSuccessful) {
      final userResponse = await userHandler.delete(uid);
      if (userResponse.isSuccessful || userResponse.snapshot != null) {
        emit(state.copy(firebaseUser: null));
      } else {
        emit(state.copy(error: userResponse.message));
      }
      return userResponse.copy(data: null);
    } else {
      emit(state.copy(error: response.message));
      return response;
    }
  }
}