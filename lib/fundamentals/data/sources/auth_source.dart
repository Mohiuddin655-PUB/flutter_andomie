part of 'sources.dart';

class AuthDataSourceImpl extends AuthDataSource {
  final FacebookAuth facebookAuth;
  final FirebaseAuth firebaseAuth;
  final LocalAuthentication localAuth;

  AuthDataSourceImpl({
    required this.facebookAuth,
    required this.firebaseAuth,
    required this.localAuth,
  });

  @override
  Future<bool> isSignIn() async => firebaseAuth.currentUser?.uid != null;

  @override
  Future<Response> signOut() async {
    final response = Response();
    await firebaseAuth.signOut();
    return response.attach(data: true);
  }

  @override
  String? get uid => user?.uid;

  @override
  User? get user => firebaseAuth.currentUser;

  @override
  Future<Response<UserCredential>> signUpWithEmailNPassword({
    required String email,
    required String password,
  }) async {
    final response = Response<UserCredential>();
    try {
      final result = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return response.attach(data: result, message: "Sign up successful!");
    } on FirebaseAuthException catch (e) {
      return response.attach(exception: e.message);
    }
  }

  @override
  Future<Response<UserCredential>> signUpWithCredential({
    required AuthCredential credential,
  }) async {
    final response = Response<UserCredential>();
    try {
      final result = await firebaseAuth.signInWithCredential(credential);
      return response.attach(data: result, message: "Sign up successful!");
    } on FirebaseAuthException catch (e) {
      return response.attach(exception: e.message);
    }
  }

  @override
  Future<Response<UserCredential>> signInWithEmailNPassword({
    required String email,
    required String password,
  }) async {
    final response = Response<UserCredential>();
    try {
      final result = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return response.attach(
        status: ResponseStatus.ok,
        data: result,
        message: "Sign in successful!",
      );
    } on FirebaseAuthException catch (e) {
      return response.attach(
        status: ResponseStatus.networkError,
        exception: e.message,
      );
    }
  }

  @override
  Future<Response<Credential>> signInWithFacebook() async {
    final response = Response<Credential>();
    try {
      final token = await facebookAuth.accessToken;
      LoginResult? result;

      result = token == null
          ? await facebookAuth.login(permissions: ['public_profile', 'email'])
          : null;

      final status = result?.status ?? LoginStatus.failed;

      if (token != null || status == LoginStatus.success) {
        final accessToken = result?.accessToken ?? token;
        if (accessToken != null) {
          final credential = FacebookAuthProvider.credential(accessToken.token);
          final fbData = await facebookAuth.getUserData();
          final data = Credential.fromMap(fbData);
          return response.attach(
            data: data.copyWith(
              accessToken: accessToken.token,
              credential: credential,
            ),
          );
        } else {
          return response.attach(exception: 'Token not valid!');
        }
      } else {
        return response.attach(exception: 'Token not valid!');
      }
    } on FirebaseAuthException catch (e) {
      return response.attach(exception: e.message);
    }
  }

  @override
  Future<Response<Credential>> signInWithGoogle() async {
    final response = Response<Credential>();
    try {
      GoogleSignInAccount? result;
      final auth = GoogleSignIn(scopes: ['email']);
      final isSignedIn = await auth.isSignedIn();
      if (isSignedIn) {
        result = await auth.signInSilently();
      } else {
        result = await auth.signIn();
      }
      if (result != null) {
        final authentication = await result.authentication;
        final idToken = authentication.idToken;
        final accessToken = authentication.accessToken;
        if (accessToken != null && idToken != null) {
          final credential = GoogleAuthProvider.credential(
              idToken: idToken, accessToken: accessToken);
          final receivedData = auth.currentUser;
          final data = Credential(
            id: receivedData?.id,
            email: receivedData?.email,
            name: receivedData?.displayName,
            photo: receivedData?.photoUrl,
          );
          return response.attach(
            data: data.copyWith(
              accessToken: accessToken,
              idToken: idToken,
              credential: credential,
            ),
          );
        } else {
          return response.attach(exception: 'Token not valid!');
        }
      } else {
        return response.attach(exception: 'Sign in failed!');
      }
    } on FirebaseAuthException catch (e) {
      return response.attach(exception: e.message);
    }
  }

  @override
  Future<Response<bool>> signInWithBiometric() async {
    final response = Response<bool>();
    try {
      if (!await localAuth.isDeviceSupported()) {
        return response.attach(exception: "Device isn't supported!");
      } else {
        if (await localAuth.canCheckBiometrics) {
          final authenticated = await localAuth.authenticate(
            localizedReason:
                'Scan your fingerprint (or face or whatever) to authenticate',
            options: const AuthenticationOptions(
              stickyAuth: true,
              biometricOnly: true,
            ),
          );
          if (authenticated) {
            return response.attach(
              message: "Biometric matched!",
              data: true,
            );
          } else {
            return response.attach(exception: "Biometric matching failed!");
          }
        } else {
          return response.attach(exception: "Can not check bio metrics!");
        }
      }
    } catch (e) {
      return response.attach(exception: e.toString());
    }
  }
}
