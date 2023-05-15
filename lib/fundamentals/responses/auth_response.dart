part of 'responses.dart';

class AuthResponse {
  final bool isCancel;
  final bool isLoggedIn;
  final bool isSuccessful;
  final bool isLoading;
  final bool isFailed;
  final String message;
  final String error;
  final User? firebaseUser;
  final UserEntity? user;
  final AuthStatus status;
  final Credential credential;

  const AuthResponse({
    this.firebaseUser,
    this.user,
    this.message = '',
    this.error = '',
    this.isCancel = false,
    this.isLoading = false,
    this.isLoggedIn = false,
    this.isSuccessful = false,
    this.credential = const Credential(),
    this.isFailed = false,
    this.status = AuthStatus.noContent,
  });

  AuthResponse copy({
    bool? isCancel,
    bool? isSuccessful,
    bool? isLoading,
    bool? isLoggedIn,
    bool? isFailed,
    User? firebaseUser,
    UserEntity? user,
    String? message,
    String? error,
    AuthStatus? status,
  }) {
    return AuthResponse(
      isCancel: isCancel ?? this.isCancel,
      isLoading: isLoading ?? this.isLoading,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      isSuccessful:
          isSuccessful ?? (message != null ? true : this.isSuccessful),
      isFailed: isFailed ?? this.isFailed,
      firebaseUser: firebaseUser ?? this.firebaseUser,
      user: user ?? this.user,
      message:
          message ?? (isSuccessful ?? false ? "Successful!" : this.message),
      error: error ?? this.error,
      status: status ??
          (firebaseUser != null
              ? AuthStatus.ok
              : (message != null ? AuthStatus.notFound : this.status)),
    );
  }

  get statusCode => status.value;
}

enum AuthStatus {
  processing(200),
  ok(200),
  created(201),
  accepted(202),
  noContent(204),
  resetContent(205),
  partialContent(206),
  multipleChoices(300),
  movedPermanently(301),
  notFound(404),
  notAcceptable(406),
  requestTimeout(408);

  const AuthStatus(this.value);

  final int value;
}
