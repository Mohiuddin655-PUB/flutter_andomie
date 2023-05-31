import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../widgets.dart';

class MaterialIcon extends StatefulWidget {
  final MaterialIconController? controller;
  final dynamic icon;
  final Color? tint;
  final double? size;
  final BoxFit? fit;

  const MaterialIcon({
    Key? key,
    this.controller,
    this.icon,
    this.tint = Colors.grey,
    this.size = 24,
    this.fit,
  }) : super(key: key);

  @override
  State<MaterialIcon> createState() => _MaterialIconState();
}

class _MaterialIconState extends State<MaterialIcon> {
  late MaterialIconController controller;

  @override
  void initState() {
    controller = widget.controller ?? MaterialIconController();
    initController();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant MaterialIcon oldWidget) {
    initController();
    super.didUpdateWidget(oldWidget);
  }

  void initController() {
    controller.icon = widget.icon;
    controller.tint = widget.tint;
    controller.size = widget.size;
    controller.fit = widget.fit;
    controller._setCallback(setState);
  }

  @override
  Widget build(BuildContext context) {
    final icon = controller.icon;
    final tint = controller.tint;
    final size = controller.size;
    final fit = controller.fit;
    final type = getType(icon);
    switch (type) {
      case MaterialIconType.icon:
        return Icon(
          icon,
          color: tint,
          size: size,
        );
      case MaterialIconType.svg:
        return SvgPicture.asset(
          icon,
          theme: SvgTheme(
            currentColor: tint ?? const Color(0xFF000000),
          ),
          width: size,
          height: size,
          fit: fit ?? BoxFit.contain,
        );
      case MaterialIconType.image:
        return Image.asset(
          icon,
          color: tint,
          width: size,
          height: size,
          fit: fit,
        );
      default:
        return Container(
          color: tint,
          width: size,
          height: size,
        );
    }
  }

  MaterialIconType getType(dynamic icon) {
    final data = icon;
    if (data is IconData) {
      return MaterialIconType.icon;
    } else if (data is String) {
      if (data.contains('.svg')) {
        return MaterialIconType.svg;
      } else if (data.contains('.png') ||
          data.contains('.jpg') ||
          data.contains('.jpeg') ||
          data.contains('.webp')) {
        return MaterialIconType.image;
      } else {
        return MaterialIconType.none;
      }
    } else {
      return MaterialIconType.none;
    }
  }
}

enum MaterialIconType {
  none,
  icon,
  svg,
  image,
}

class MaterialIconData<T> {
  final T active;
  final T inactive;

  const MaterialIconData({
    required this.active,
    dynamic inactive,
  }) : inactive = inactive ?? active;

  T drawable(bool isActivated) => isActivated ? active : inactive;
}

class MaterialIconController extends ViewController {
  late Function(VoidCallback fn) _callback;

  dynamic icon;
  Color? tint;
  double? size;
  BoxFit? fit;

  void setIcon(dynamic value) {
    _callback(() {
      icon = value;
    });
  }

  void setTint(Color value) {
    _callback(() {
      tint = value;
    });
  }

  void setSize(double value) {
    _callback(() {
      size = value;
    });
  }

  void setFit(BoxFit value) {
    _callback(() {
      fit = value;
    });
  }

  void _setCallback(void Function(VoidCallback fn) callback) =>
      _callback = callback;
}
