part of '../utils.dart';

/// A class representing configuration for different devices.
class DeviceConfig {
  final Device mobile, tab, laptop, desktop, tv;

  /// Constructs a new instance of [DeviceConfig].
  ///
  /// The parameters [mobile], [tab], [laptop], [desktop], and [tv] represent
  /// configurations for different types of devices.
  const DeviceConfig({
    this.mobile = const Device(
      x: DeviceInfo.mobileX,
      y: DeviceInfo.mobileY,
      fontVariant: DeviceInfo.mobileVariant,
      name: 'Mobile',
    ),
    this.tab = const Device(
      x: DeviceInfo.tabX,
      y: DeviceInfo.tabY,
      fontVariant: DeviceInfo.tabVariant,
      name: 'Tab',
    ),
    this.laptop = const Device(
      x: DeviceInfo.laptopX,
      y: DeviceInfo.laptopY,
      fontVariant: DeviceInfo.laptopVariant,
      name: 'Laptop',
    ),
    this.desktop = const Device(
      x: DeviceInfo.desktopX,
      y: DeviceInfo.desktopY,
      fontVariant: DeviceInfo.desktopVariant,
      name: 'Desktop',
    ),
    this.tv = const Device(
      x: DeviceInfo.tvX,
      y: DeviceInfo.tvY,
      fontVariant: DeviceInfo.tvVariant,
      name: 'TV',
    ),
  });

  /// Checks if the platform is Android.
  bool get isAndroid => Platform.isAndroid;

  /// Checks if the platform is Fuchsia.
  bool get isFuchsia => Platform.isFuchsia;

  /// Checks if the platform is iOS.
  bool get isIOS => Platform.isIOS;

  /// Checks if the platform is Linux.
  bool get isLinux => Platform.isLinux;

  /// Checks if the platform is macOS.
  bool get isMacOS => Platform.isMacOS;

  /// Checks if the platform is Windows.
  bool get isWindows => Platform.isWindows;

  /// Checks if the given coordinates represent a mobile device.
  bool isMobile(double cx, double cy) => isDevice(mobile, cx, cy);

  /// Checks if the given coordinates represent a tab device.
  bool isTab(double cx, double cy) => isDevice(tab, cx, cy);

  /// Checks if the given coordinates represent a laptop device.
  bool isLaptop(double cx, double cy) => isDevice(laptop, cx, cy);

  /// Checks if the given coordinates represent a desktop device.
  bool isDesktop(double cx, double cy) => isDevice(desktop, cx, cy);

  /// Checks if the given coordinates represent any configured device.
  bool isDevice(Device device, double cx, double cy) {
    final x = device.aspectRatio;
    final y = device.ratio(cx, cy);
    return x > y;
  }

  /// Determines the type of the device based on the given coordinates.
  DeviceType deviceType(double cx, double cy) {
    if (isMobile(cx, cy)) {
      return DeviceType.mobile;
    } else if (isTab(cx, cy)) {
      return DeviceType.tab;
    } else if (isLaptop(cx, cy)) {
      return DeviceType.laptop;
    } else if (isDesktop(cx, cy)) {
      return DeviceType.desktop;
    } else {
      return DeviceType.other;
    }
  }
}

/// A class representing device information such as screen dimensions and font variants.
class Device extends Size {
  final String name;
  final double fontVariant;

  /// Constructs a new instance of [Device] with specified dimensions and optional parameters.
  const Device({
    required double x,
    required double y,
    this.name = 'Unknown',
    this.fontVariant = 0,
  }) : super(x, y);

  @override
  double get width => super.width > 100 ? super.width : super.width * 100;

  @override
  double get height => super.height > 100 ? super.height : super.height * 100;

  double rationalWidth(double cx) => cx * aspectRatio;

  double rationalHeight(double cy) => cy * aspectRatio;

  double ratioX(double cx) => rationalWidth(cx) / 100;

  double ratioY(double cy) => rationalHeight(cy) / 100;

  double ratio(double cx, double cy) => Size(cx, cy).aspectRatio;
}

/// A class containing static constants representing default dimensions and font variants for different devices.
class DeviceInfo {
  static const double mobileX = 10, mobileY = 16, mobileVariant = 3.6;
  static const double tabX = 1, tabY = 1, tabVariant = 5;
  static const double laptopX = 16, laptopY = 10, laptopVariant = 6;
  static const double desktopX = 16, desktopY = 8, desktopVariant = 7;
  static const double tvX = 0, tvY = 0, tvVariant = 8;
}

/// An enumeration representing different types of devices.
enum DeviceType {
  mobile,
  tab,
  laptop,
  desktop,
  other;
}
