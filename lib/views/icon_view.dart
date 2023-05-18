part of '../widgets.dart';

class IconView extends YMRView<IconViewController> {
  final BoxFit? fit;
  final dynamic icon;
  final ValueState<dynamic>? iconState;
  final double? size;
  final ValueState<double>? sizeState;
  final Color? tint;
  final ValueState<Color>? tintState;
  final BlendMode? tintMode;

  final Color? splashColor;
  final Color? pressedColor;

  const IconView({
    super.key,
    super.controller,
    super.flex,
    super.activated,
    super.enabled,
    super.visibility,
    super.dimensionRatio,
    super.margin,
    super.marginHorizontal,
    super.marginVertical,
    super.marginTop,
    super.marginBottom,
    super.marginStart,
    super.marginEnd,
    super.padding = 8,
    super.borderSize,
    super.borderHorizontal,
    super.borderVertical,
    super.borderTop,
    super.borderBottom,
    super.borderStart,
    super.borderEnd,
    super.borderRadius,
    super.borderRadiusBL,
    super.borderRadiusBR,
    super.borderRadiusTL,
    super.borderRadiusTR,
    super.shadow,
    super.shadowBlurRadius,
    super.shadowSpreadRadius,
    super.shadowHorizontal,
    super.shadowVertical,
    super.shadowStart,
    super.shadowEnd,
    super.shadowTop,
    super.shadowBottom,
    super.background,
    super.foreground,
    super.borderColor,
    super.shadowColor,
    super.gravity,
    super.transformGravity,
    super.backgroundBlendMode,
    super.foregroundBlendMode,
    super.backgroundImage,
    super.foregroundImage,
    super.backgroundGradient,
    super.foregroundGradient,
    super.borderGradient,
    super.transform,
    super.shadowBlurStyle,
    super.clipBehavior,
    super.position,
    super.positionType,
    super.shadowType,
    super.shape,
    super.onClick,
    super.onClickHandle,
    super.onDoubleClick,
    super.onDoubleClickHandle,
    super.onLongClick,
    super.onLongClickHandle,
    this.icon,
    this.fit,
    this.iconState,
    this.size,
    this.sizeState,
    this.tint,
    this.tintState,
    this.tintMode,
    this.splashColor,
    this.pressedColor,
  });

  @override
  IconViewController attachController() {
    return IconViewController();
  }

  @override
  IconViewController initController(IconViewController controller) {
    return controller.attach(
      this,
      fit: fit,
      icon: icon,
      iconState: iconState,
      size: size,
      iconSizeState: sizeState,
      iconTint: tint,
      iconTintState: tintState,
      tintMode: tintMode,
      pressedColor: pressedColor,
      splashColor: splashColor,
    );
  }

  @override
  ViewProperties get properties => super.properties.modify(observer: false, background: false);

  @override
  Widget build(
    BuildContext context,
    IconViewController controller,
    Widget parent,
  ) {
    return Column(
      children: [
        Material(
          borderRadius: BorderRadius.circular(controller.borderRadius),
          color: controller.background,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            splashColor: controller.splashColor,
            hoverColor: controller.pressedColor,
            highlightColor: controller.pressedColor,
            onTap: () => controller.onClick?.call(context),
            child: AbsorbPointer(child: parent),
          ),
        ),
      ],
    );
  }

  @override
  Widget? attach(BuildContext context, IconViewController controller) {
    return RawIcon(
      fit: controller.fit,
      icon: controller.icon,
      size: controller.iconSize,
      tint: controller.iconTint,
      tintMode: controller.tintMode,
    );
  }
}

class RawIcon extends StatelessWidget {
  final BoxFit? fit;
  final dynamic icon;
  final double? size;
  final Color? tint;
  final BlendMode tintMode;

  const RawIcon({
    super.key,
    required this.icon,
    this.fit,
    this.size,
    this.tint,
    this.tintMode = BlendMode.srcIn,
  });

  @override
  Widget build(BuildContext context) {
    final type = getType(icon);
    switch (type) {
      case IconType.icon:
        return Icon(
          icon,
          color: tint,
          size: size,
        );
      case IconType.svg:
        return SvgPicture.asset(
          icon,
          width: size,
          height: size,
          fit: fit ?? BoxFit.contain,
          colorFilter: ColorFilter.mode(
            tint ?? const Color(0xFF808080),
            tintMode,
          ),
          theme: SvgTheme(
            currentColor: tint ?? const Color(0xFF808080),
          ),
        );
      case IconType.png:
        return Image.asset(
          icon,
          color: tint,
          width: size,
          height: size,
          fit: fit,
          colorBlendMode: tintMode,
        );
      default:
        return SizedBox(
          width: size,
          height: size,
        );
    }
  }

  IconType getType(dynamic source) {
    if (source is IconData) {
      return IconType.icon;
    } else if (source is String) {
      if (source.endsWith('.svg')) {
        return IconType.svg;
      } else if (source.endsWith('.png')) {
        return IconType.png;
      } else {
        return IconType.none;
      }
    } else {
      return IconType.none;
    }
  }
}

enum IconType {
  none,
  icon,
  svg,
  png,
}

class IconViewController extends ViewController {
  BoxFit fit = BoxFit.contain;
  dynamic _icon;
  ValueState<dynamic>? iconState;
  double _iconSize = 40;
  ValueState<double>? iconSizeState;
  Color _iconTint = const Color(0xFF808080);
  ValueState<Color>? tintState;
  BlendMode tintMode = BlendMode.srcIn;
  Color? splashColor = Colors.transparent;
  Color? pressedColor;

  @override
  IconViewController attach(
    YMRView<ViewController> view, {
    BoxFit? fit,
    dynamic icon,
    ValueState<dynamic>? iconState,
    double? size,
    ValueState<double>? iconSizeState,
    Color? iconTint,
    ValueState<Color>? iconTintState,
    BlendMode? tintMode,
    Color? splashColor,
    Color? pressedColor,
  }) {
    super.attach(view);
    this.fit = fit ?? this.fit;
    _icon = icon ?? _icon;
    this.iconState = iconState ?? this.iconState;
    _iconSize = size ?? _iconSize;
    _iconTint = iconTint ?? _iconTint;
    tintState = iconTintState ?? tintState;
    this.tintMode = tintMode ?? this.tintMode;
    this.splashColor = splashColor ?? this.splashColor;
    this.pressedColor = pressedColor ?? this.pressedColor;
    return this;
  }

  @override
  double? get width => iconSize;

  @override
  double? get height => iconSize;

  @override
  double get borderRadius {
    return super.borderRadius > 0 ? super.borderRadius : iconSize;
  }

  dynamic get icon => iconState?.selected(activated) ?? _icon;

  double get iconSize => iconSizeState?.selected(activated) ?? _iconSize;

  Color get iconTint => tintState?.selected(activated) ?? _iconTint;

  void setIcon(dynamic value) {
    _icon = value;
    notify;
  }

  void setIconSize(double value) {
    _iconSize = value;
    notify;
  }

  void setIconTint(Color value) {
    _iconTint = value;
    notify;
  }

  void setIconTintState(ValueState<Color>? value) {
    tintState = value;
    notify;
  }
}
