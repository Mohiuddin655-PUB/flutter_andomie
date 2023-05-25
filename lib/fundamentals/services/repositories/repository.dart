part of 'repositories.dart';

class Repository {
  final ConnectivityProvider connectivity;

  const Repository({
    required this.connectivity,
  });

  Future<bool> get isConnected async => await connectivity.isConnected;

  Future<bool> get isDisconnected async => !(await isConnected);
}
