import 'package:flutter/material.dart';
import 'package:flutter_andomie/widgets.dart';

class Button extends YMRView<ButtonController> {
  final String? text;
  final double? textSize;
  final FontWeight? textWeight;
  final TextStyle? textStyle;
  final dynamic icon;
  final double? iconSize;
  final bool? expended;
  final EdgeInsetsGeometry? iconPadding;
  final IconAlignment? iconAlignment;
  final bool? textAllCaps;
  final Color? textColor;

  final ValueState<String>? textState;
  final ValueState<dynamic>? iconState;
  final ValueState<Color>? colorState;

  const Button({
    super.key,
    super.controller,
    super.absorbMode,
    super.animation,
    super.animationType,
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
    super.shape,
    super.child,
    super.onClick,
    super.onClickHandle,
    super.onDoubleClick,
    super.onDoubleClickHandle,
    super.onLongClick,
    super.onLongClickHandle,
    this.text,
    this.textSize,
    this.textWeight,
    this.textStyle,
    this.icon,
    this.iconSize,
    this.expended,
    this.iconPadding,
    this.iconAlignment,
    this.textAllCaps,
    this.textColor,
    this.textState,
    this.iconState,
    this.colorState,
  });

  @override
  ButtonController attachController() {
    return ButtonController();
  }

  @override
  ButtonController initController(ButtonController controller) {
    return controller.attach(
      this,
      text: text,
      textSize: textSize,
      textWeight: textWeight,
      textState: textState,
      icon: icon,
      iconSize: iconSize,
      expended: expended,
      iconPadding: iconPadding,
      iconAlignment: iconAlignment,
      textAllCaps: textAllCaps,
      textColor: textColor,
      textStyle: textStyle,
      iconState: iconState,
      colorState: colorState,
    );
  }

  @override
  Widget? attach(BuildContext context, ButtonController controller) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _Icon(
          controller: controller,
          visible: controller.icon != null &&
              controller.iconAlignment == IconAlignment.start,
          padding: controller.iconPadding,
        ),
        if (controller.icon != null &&
            controller.iconAlignment == IconAlignment.start &&
            controller.expended)
          const Spacer(),
        _Text(controller: controller),
        if (controller.icon != null &&
            controller.iconAlignment == IconAlignment.end &&
            controller.expended)
          const Spacer(),
        _Icon(
          controller: controller,
          visible: controller.icon != null &&
              controller.iconAlignment == IconAlignment.end,
          padding: controller.iconPadding,
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
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawTextView(
      text: controller.text,
      textAlign: TextAlign.center,
      textColor: controller.color,
      textSize: controller.textSize,
      fontWeight: controller.textWeight,
      textStyle: controller.textStyle,
    );
  }
}

class _Icon extends StatelessWidget {
  final ButtonController controller;
  final bool visible;
  final EdgeInsetsGeometry? padding;

  const _Icon({
    Key? key,
    required this.controller,
    this.visible = true,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: Container(
        padding: padding,
        child: RawIconView(
          icon: controller.icon,
          tint: controller.color,
          size: controller.iconSize,
        ),
      ),
    );
  }
}

enum IconAlignment {
  start,
  end,
}

enum ButtonState {
  disabled,
  enabled,
}

class ButtonController extends ViewController {
  String? _text;
  double textSize = 14;
  FontWeight? textWeight;
  TextStyle textStyle = const TextStyle();
  dynamic _icon;
  double? iconSize;
  bool expended = false;
  EdgeInsetsGeometry? iconPadding;
  IconAlignment? iconAlignment;
  bool textAllCaps = false;
  Color? textColor;

  ValueState<String>? textState;
  ValueState<dynamic>? iconState;
  ValueState<Color>? colorState;

  @override
  ButtonController attach(
    YMRView<ViewController> view, {
    String? text,
    double? textSize,
    FontWeight? textWeight,
    TextStyle? textStyle,
    dynamic icon,
    double? iconSize,
    bool? expended,
    EdgeInsetsGeometry? iconPadding,
    IconAlignment? iconAlignment,
    bool? textAllCaps,
    Color? textColor,
    ValueState<String>? textState,
    ValueState<dynamic>? iconState,
    ValueState<Color>? colorState,
  }) {
    super.attach(view);
    _text = text;
    this.textSize = textSize ?? 14;
    this.textWeight = textWeight;
    this.textStyle = textStyle = const TextStyle();
    _icon = icon;
    this.iconSize = iconSize;
    this.expended = expended ?? false;
    this.iconPadding = iconPadding;
    this.iconAlignment = iconAlignment;
    this.textAllCaps = textAllCaps ?? false;
    this.textColor = textColor;
    this.textState = textState;
    this.iconState = iconState;
    this.colorState = colorState;
    return this;
  }

  String get text {
    var value = textState?.activated(activated, enabled) ?? _text ?? "";
    return textAllCaps ? value.toUpperCase() : value;
  }

  dynamic get icon => iconState?.activated(activated, enabled) ?? _icon;

  Color? get color => colorState?.activated(activated, enabled) ?? textColor;
}
