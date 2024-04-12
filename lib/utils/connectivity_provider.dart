/// A utility class for checking and monitoring device connectivity status.
part of '../utils.dart';

/// A provider class for checking device connectivity.
class ConnectivityProvider {
  const ConnectivityProvider._();

  static ConnectivityProvider? _instance;

  /// Singleton instance of [ConnectivityProvider].
  static ConnectivityProvider get I =>
      _instance ??= const ConnectivityProvider._();

  /// Checks if the device is connected to a mobile network.
  Future<bool> get isMobile =>
      ConnectivityService.I.isAvailable(ConnectivityResult.mobile);

  /// Checks if the device is connected to a Wi-Fi network.
  Future<bool> get isWifi =>
      ConnectivityService.I.isAvailable(ConnectivityResult.wifi);

  /// Checks if the device is connected to an Ethernet network.
  Future<bool> get isEthernet =>
      ConnectivityService.I.isAvailable(ConnectivityResult.ethernet);

  /// Checks if the device is connected to a Bluetooth network.
  Future<bool> get isBluetooth =>
      ConnectivityService.I.isAvailable(ConnectivityResult.bluetooth);

  /// Checks if the device is connected to a VPN.
  Future<bool> get isVPN =>
      ConnectivityService.I.isAvailable(ConnectivityResult.vpn);

  /// Checks if the device has no network connectivity.
  Future<bool> get isNone =>
      ConnectivityService.I.isAvailable(ConnectivityResult.none);

  /// Checks if the device is connected to any network.
  Future<bool> get isConnected async {
    final statuses = await ConnectivityService.I.checkStatus;
    final status = statuses.firstOrNull;
    final mobile = status == ConnectivityResult.mobile;
    final wifi = status == ConnectivityResult.wifi;
    final ethernet = status == ConnectivityResult.ethernet;
    return mobile || wifi || ethernet;
  }
}

/// A service class for monitoring and checking device connectivity.
class ConnectivityService {
  const ConnectivityService._();

  static ConnectivityService? _instance;
  static Connectivity? _connectivity;

  /// Singleton instance of [ConnectivityService].
  static ConnectivityService get I =>
      _instance ??= const ConnectivityService._();

  /// Singleton instance of the [Connectivity] package.
  static Connectivity get connectivity => _connectivity ??= Connectivity();

  /// Checks the current connectivity status of the device.
  Future<List<ConnectivityResult>> get checkStatus async =>
      await connectivity.checkConnectivity();

  /// Stream of connectivity changes.
  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      connectivity.onConnectivityChanged;

  /// Checks if the specified connectivity result is currently available.
  Future<bool> isAvailable(ConnectivityResult? result) async {
    final status = await checkStatus;
    return status.firstOrNull == result;
  }

  /// Checks if the connectivity status changes based on the specified [ConnectivityType].
  ///
  /// Parameters:
  /// - [type]: The type of connectivity change to monitor.
  ///
  /// Example:
  /// ```dart
  /// bool isConnected = await ConnectivityService.I.onChangedStatus();
  /// ```
  Future<bool> onChangedStatus([
    ConnectivityType type = ConnectivityType.single,
  ]) async {
    final result = await getDynamicResult(type);
    return isAvailable(result.firstOrNull);
  }

  /// Gets the dynamic connectivity result based on the specified [ConnectivityType].
  ///
  /// Parameters:
  /// - [type]: The type of connectivity change to monitor.
  ///
  /// Example:
  /// ```dart
  /// ConnectivityResult result = await ConnectivityService.I.getDynamicResult(ConnectivityType.single);
  /// ```
  Future<List<ConnectivityResult>> getDynamicResult(
      ConnectivityType type) async {
    switch (type) {
      case ConnectivityType.first:
        return await onConnectivityChanged.first;
      case ConnectivityType.last:
        return await onConnectivityChanged.last;
      default:
        return await onConnectivityChanged.single;
    }
  }
}

/// Enumeration of possible connectivity change types.
enum ConnectivityType {
  single,
  first,
  last,
}
