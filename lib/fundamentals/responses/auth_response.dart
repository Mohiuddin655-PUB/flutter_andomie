part of 'responses.dart';

class AuthResponse<T extends AuthInfo> {
  final bool? _initial;
  final bool? _loading;
  final bool? _authenticated;
  final bool? _unauthenticated;
  final bool? _failure;
  final String? _error;
  final T? data;
  final ResponseType? _type;

  factory AuthResponse.initial() => const AuthResponse._(initial: true);

  factory AuthResponse.loading() {
    return const AuthResponse._(
      loading: true,
    );
  }

  factory AuthResponse.authenticated(T? data) {
    return AuthResponse._(
      authenticated: true,
      data: data,
    );
  }

  factory AuthResponse.unauthenticated() {
    return const AuthResponse._(
      unauthenticated: true,
    );
  }

  factory AuthResponse.failure(String message) {
    return AuthResponse._(
      failure: true,
      error: message,
    );
  }

  const AuthResponse._({
    this.data,
    bool? initial,
    bool? loading,
    bool? authenticated,
    bool? unauthenticated,
    bool? failure,
    String? error,
    ResponseType? type,
  })  : _initial = initial,
        _loading = loading,
        _authenticated = authenticated,
        _unauthenticated = unauthenticated,
        _failure = failure,
        _error = error,
        _type = type;

  bool get isInitial => _initial ?? false;

  bool get isLoading => _loading ?? false;

  bool get isAuthenticated => _authenticated ?? false;

  bool get isUnauthenticated => _unauthenticated ?? false;

  bool get isFailure => _failure ?? false;

  bool get isError => error.isNotEmpty;

  String get error => _error ?? "";

  ResponseType get type => _type ?? ResponseType.initial;

  Map<String, dynamic> get source {
    return {
      "isInitial": isInitial,
      "isLoading": isLoading,
      "isAuthenticated": isAuthenticated,
      "isUnauthenticated": isUnauthenticated,
      "isFailure": isFailure,
      "isError": isError,
      "error": _error,
      "data": data,
    };
  }

  String get beautify =>
      toString().replaceAll(",", "\n").replaceAll("{", "").replaceAll("}", "");

  @override
  String toString() {
    return source.toString();
  }
}

enum ResponseType {
  initial,
  authenticated,
  unauthenticated,
}
