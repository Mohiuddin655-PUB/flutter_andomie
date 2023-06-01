part of '../widgets.dart';

class Button extends TextView<ButtonController> {
  final bool? centerText;
  final dynamic icon;
  final ValueState<dynamic>? iconState;
  final double? iconSize;
  final ValueState<double>? iconSizeState;
  final bool? iconFlexible;
  final double? iconSpace;
  final IconAlignment? iconAlignment;

  const Button({
    super.key,
    super.controller,
    super.absorbMode,
    super.flex,
    super.activated,
    super.enabled,
    super.visibility,
    super.dimensionRatio,
    super.width,
    super.widthMax,
    super.widthMin,
    super.height,
    super.heightMax,
    super.heightMin,
    super.margin,
    super.marginHorizontal,
    super.marginVertical,
    super.marginTop,
    super.marginBottom,
    super.marginStart,
    super.marginEnd,
    super.padding,
    super.paddingHorizontal,
    super.paddingVertical,
    super.paddingTop,
    super.paddingBottom,
    super.paddingStart,
    super.paddingEnd,
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
    super.hoverColor,
    super.pressedColor,
    super.shadowColor,
    super.rippleColor,
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
    super.onClick,
    super.onClickHandler,
    super.onDoubleClick,
    super.onDoubleClickHandler,
    super.onLongClick,
    super.onLongClickHandler,
    super.text,
    super.textSize,
    super.fontWeight,
    super.textStyle,
    super.textAllCaps,
    super.textColor,
    super.textState,
    this.centerText,
    this.iconFlexible,
    this.icon,
    this.iconState,
    this.iconSize,
    this.iconSizeState,
    this.iconSpace,
    this.iconAlignment,
  });

  @override
  ButtonController initController() {
    return ButtonController();
  }

  @override
  ButtonController attachController(ButtonController controller) {
    return controller.fromButton(this);
  }

  @override
  Widget? attach(BuildContext context, ButtonController controller) {
    return controller.isCenterText
        ? Stack(
            alignment: Alignment.center,
            children: [
              _Text(controller: controller),
              _Icon(
                controller: controller,
                visible: controller.icon != null,
              ),
            ],
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _Icon(
                controller: controller,
                visible: controller.isStartIconVisible,
              ),
              if (controller.isStartIconFlex) const Spacer(),
              _Text(controller: controller),
              if (controller.isEndIconFlex) const Spacer(),
              _Icon(
                controller: controller,
                visible: controller.isEndIconVisible,
              ),
            ],
          );
  }
}

class _Text extends StatelessWidget {
  final ButtonController controller;

  const _Text({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextView(
      text: controller.text,
      textAlign: TextAlign.center,
      textColor: controller.color,
      textSize: controller.textSize,
      fontWeight: controller.fontWeight,
      textStyle: controller.textStyle,
    );
  }
}

class _Icon extends StatelessWidget {
  final ButtonController controller;
  final bool visible;

  const _Icon({
    Key? key,
    required this.controller,
    this.visible = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconView(
      visibility: visible ? ViewVisibility.visible : ViewVisibility.gone,
      marginStart: !controller.isCenterText && controller.isEndIconVisible
          ? controller.iconSpace
          : null,
      marginEnd: !controller.isCenterText && controller.isStartIconVisible
          ? controller.iconSpace
          : null,
      position: controller.isCenterText
          ? ViewPosition(
              left: controller.isStartIconVisible ? 0 : null,
              right: controller.isEndIconVisible ? 0 : null,
            )
          : null,
      icon: controller.icon,
      tint: controller.color,
      size: controller.iconSize,
    );
  }
}

class ButtonController extends TextViewController {
  bool centerText = false;
  dynamic _icon;
  ValueState<dynamic>? iconState;
  double? _iconSize;
  ValueState<double>? iconSizeState;
  bool expended = false;
  double iconSpace = 16;
  IconAlignment iconAlignment = IconAlignment.end;

  ButtonController fromButton(Button view) {
    super.fromTextView(view);
    centerText = view.centerText ?? false;
    _icon = view.icon;
    iconState = view.iconState;
    _iconSize = view.iconSize;
    iconSizeState = view.iconSizeState;
    expended = view.iconFlexible ?? false;
    iconSpace = view.iconSpace ?? 16;
    iconAlignment = view.iconAlignment ?? IconAlignment.end;
    return this;
  }

  dynamic get icon => iconState?.activated(activated, enabled) ?? _icon;

  double get iconSize =>
      iconSizeState?.activated(activated, enabled) ?? _iconSize ?? textSize;

  bool get isCenterText => centerText;

  get isStartIconVisible => iconAlignment.isStart && icon != null;

  bool get isEndIconVisible => iconAlignment.isEnd && icon != null;

  bool get isStartIconFlex => isStartIconVisible && expended;

  bool get isEndIconFlex => isEndIconVisible && expended;

  Color? get color {
    var I = textColorState?.activated(activated, enabled) ?? textColor;
    if (I == null) {
      return enabled ? Colors.white : Colors.grey.shade400;
    }
    return I;
  }

  @override
  Color? get background {
    if (super.background == null) {
      return enabled ? theme.primaryColor : Colors.grey.shade200;
    }
    return super.background;
  }

  @override
  double? get paddingHorizontal => super.paddingHorizontal ?? 24;

  @override
  double? get paddingVertical => super.paddingVertical ?? 12;

  @override
  double? get height => super.isPadding ? null : super.height;
}

enum IconAlignment { start, end }

extension IconAlignException on IconAlignment {
  bool get isStart => this == IconAlignment.start;

  bool get isEnd => this == IconAlignment.end;
}
