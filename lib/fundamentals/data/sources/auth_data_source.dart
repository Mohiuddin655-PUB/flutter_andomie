part of 'sources.dart';

class AuthDataSourceImpl extends AuthDataSource {
  final FacebookAuth facebookAuth;
  final FirebaseAuth firebaseAuth;
  final LocalAuthentication localAuth;
  final GoogleSignIn googleAuth;

  AuthDataSourceImpl({
    FacebookAuth? facebookAuth,
    FirebaseAuth? firebaseAuth,
    LocalAuthentication? localAuth,
    GoogleSignIn? googleAuth,
  })  : facebookAuth = facebookAuth ?? FacebookAuth.i,
        firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        localAuth = localAuth ?? LocalAuthentication(),
        googleAuth = googleAuth ?? GoogleSignIn(scopes: ['email']);

  @override
  Future<bool> isSignIn() async => firebaseAuth.currentUser?.uid != null;

  @override
  Future<Response> signOut() async {
    final response = Response();
    try {
      await firebaseAuth.signOut();
      if (await googleAuth.isSignedIn()) {
        googleAuth.disconnect();
        googleAuth.signOut();
      }
      ///await facebookAuth.logOut();
    } catch (_){
      return response.withException(_, status: Status.failure);
    }
    return response.modify(data: true);
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
      return response.modify(data: result, message: "Sign up successful!");
    } on FirebaseAuthException catch (e) {
      return response.modify(exception: e.message);
    }
  }

  @override
  Future<Response<UserCredential>> signUpWithCredential({
    required AuthCredential credential,
  }) async {
    final response = Response<UserCredential>();
    try {
      final result = await firebaseAuth.signInWithCredential(credential);
      return response.modify(data: result, message: "Sign up successful!");
    } on FirebaseAuthException catch (e) {
      return response.modify(exception: e.message);
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
      return response.modify(
        status: Status.ok,
        data: result,
        message: "Sign in successful!",
      );
    } on FirebaseAuthException catch (e) {
      return response.modify(
        status: Status.networkError,
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
          return response.modify(
            data: data.copyWith(
              accessToken: accessToken.token,
              credential: credential,
            ),
          );
        } else {
          return response.modify(exception: 'Token not valid!');
        }
      } else {
        return response.modify(exception: 'Token not valid!');
      }
    } on FirebaseAuthException catch (e) {
      return response.modify(exception: e.message);
    }
  }

  @override
  Future<Response<Credential>> signInWithGoogle() async {
    final response = Response<Credential>();
    try {
      GoogleSignInAccount? result;
      final auth = googleAuth;
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
        if (accessToken != null || idToken != null) {
          final credential = GoogleAuthProvider.credential(
              idToken: idToken, accessToken: accessToken);
          final receivedData = auth.currentUser;
          final data = Credential(
            id: receivedData?.id,
            email: receivedData?.email,
            name: receivedData?.displayName,
            photo: receivedData?.photoUrl,
          );
          return response.modify(
            data: data.copyWith(
              accessToken: accessToken,
              idToken: idToken,
              credential: credential,
            ),
          );
        } else {
          return response.modify(exception: 'Token not valid!');
        }
      } else {
        return response.modify(exception: 'Sign in failed!');
      }
    } on FirebaseAuthException catch (e) {
      return response.modify(exception: e.message);
    }
  }

  @override
  Future<Response<bool>> signInWithBiometric() async {
    final response = Response<bool>();
    try {
      if (!await localAuth.isDeviceSupported()) {
        return response.modify(exception: "Device isn't supported!");
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
            return response.modify(
              message: "Biometric matched!",
              data: true,
            );
          } else {
            return response.modify(exception: "Biometric matching failed!");
          }
        } else {
          return response.modify(exception: "Can not check bio metrics!");
        }
      }
    } catch (e) {
      return response.modify(exception: e.toString());
    }
  }
}
