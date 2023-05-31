part of '../widgets.dart';

class Button extends StatefulWidget {
  final ButtonController? controller;
  final double? width, height;
  final EdgeInsetsGeometry? margin, padding;
  final String? text;
  final double? textSize;
  final FontWeight? textWeight;
  final TextStyle textStyle;
  final Color? background;
  final double borderRadius;
  final bool enabled;
  final OnViewClickListener? onClick;
  final IconData? icon;
  final double iconSize;
  final bool expended;
  final EdgeInsetsGeometry? iconPadding;
  final IconAlignment iconAlignment;
  final bool textAllCaps;
  final Color? textColor, rippleColor, pressedColor;

  final String? Function(ButtonState state)? textState;
  final IconData? Function(ButtonState state)? iconState;
  final Color? Function(ButtonState state)? colorState;
  final Color? Function(ButtonState state)? backgroundState;

  const Button({
    this.controller,
    super.key,
    this.text,
    this.textColor,
    this.textSize = 16,
    this.textStyle = const TextStyle(),
    this.textWeight,
    this.width,
    this.height,
    this.margin,
    this.padding,
    this.borderRadius = 0,
    this.enabled = true,
    this.onClick,
    this.icon,
    this.expended = false,
    this.iconSize = 18,
    this.iconPadding,
    this.iconAlignment = IconAlignment.end,
    this.textState,
    this.iconState,
    this.colorState,
    this.background,
    this.backgroundState,
    this.textAllCaps = false,
    this.rippleColor,
    this.pressedColor,
  });

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  late ButtonController controller;

  @override
  void initState() {
    controller = widget.controller ?? ButtonController();
    controller.setCallback(setState);
    controller.text = widget.text ?? "";
    controller.textColor = widget.textColor;
    controller.textWeight = widget.textWeight;
    controller.background = widget.background;
    controller.enabled = widget.enabled;
    controller.textSize = widget.textSize;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant Button oldWidget) {
    controller.text = widget.text ?? "";
    controller.textColor = widget.textColor;
    controller.textWeight = widget.textWeight;
    controller.background = widget.background;
    controller.enabled = widget.enabled;
    controller.textSize = widget.textSize;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = controller.enabled && widget.onClick != null
        ? controller.textColor ?? Colors.white
        : Colors.grey.shade400;
    final background = controller.enabled && widget.onClick != null
        ? controller.background ?? theme.primaryColor
        : Colors.grey.shade200;

    return Container(
      margin: widget.margin,
      child: Material(
        color: widget.backgroundState?.call(state) ?? background,
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: InkWell(
          onTap:
              controller.enabled ? () => widget.onClick?.call(context) : null,
          splashColor: widget.rippleColor,
          hoverColor: widget.pressedColor,
          highlightColor: widget.pressedColor,
          child: AbsorbPointer(
            child: Container(
              width: widget.width,
              height: widget.padding == null ? widget.height : null,
              padding: widget.padding ??
                  EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: widget.height != null ? 0 : 12,
                  ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _Icon(
                    visible: (widget.iconState ?? widget.icon) != null &&
                        widget.iconAlignment == IconAlignment.start,
                    state: state,
                    icon: widget.icon,
                    iconState: widget.iconState,
                    color: color,
                    colorState: widget.colorState,
                    size: widget.iconSize,
                    padding: widget.iconPadding,
                  ),
                  if ((widget.iconState ?? widget.icon) != null &&
                      widget.iconAlignment == IconAlignment.start &&
                      widget.expended)
                    const Spacer(),
                  _Text(
                    state: state,
                    primary: color,
                    text: controller.text,
                    textSize: controller.textSize,
                    textStyle: widget.textStyle,
                    textWeight: controller.textWeight,
                    textState: widget.textState,
                    colorState: widget.colorState,
                    textAllCaps: widget.textAllCaps,
                  ),
                  if ((widget.iconState ?? widget.icon) != null &&
                      widget.iconAlignment == IconAlignment.end &&
                      widget.expended)
                    const Spacer(),
                  _Icon(
                    visible: (widget.iconState ?? widget.icon) != null &&
                        widget.iconAlignment == IconAlignment.end,
                    state: state,
                    icon: widget.icon,
                    iconState: widget.iconState,
                    color: color,
                    colorState: widget.colorState,
                    size: widget.iconSize,
                    padding: widget.iconPadding,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  ButtonState get state {
    if (controller.enabled && widget.onClick != null) {
      return ButtonState.enabled;
    } else {
      return ButtonState.disabled;
    }
  }
}

class _Text extends StatelessWidget {
  final Color? primary;
  final String? text;
  final double? textSize;
  final TextStyle textStyle;
  final FontWeight? textWeight;
  final bool textAllCaps;
  final String? Function(ButtonState state)? textState;
  final Color? Function(ButtonState state)? colorState;
  final ButtonState state;

  const _Text({
    Key? key,
    required this.state,
    this.primary,
    this.text,
    this.textSize = 14,
    this.textStyle = const TextStyle(),
    this.textWeight,
    this.textState,
    this.colorState,
    this.textAllCaps = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title = textState?.call(state) ?? text ?? "";
    return Text(
      textAllCaps ? title.toUpperCase() : title,
      textAlign: TextAlign.center,
      style: textStyle.copyWith(
        color: colorState?.call(state) ?? primary,
        fontSize: textSize,
        fontWeight: textWeight,
      ),
    );
  }
}

class _Icon extends StatelessWidget {
  final ButtonState state;
  final IconData? icon;
  final bool visible;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final double? size;
  final IconData? Function(ButtonState state)? iconState;
  final Color? Function(ButtonState state)? colorState;

  const _Icon({
    Key? key,
    required this.state,
    this.icon,
    this.visible = true,
    this.padding,
    this.color,
    this.size,
    this.iconState,
    this.colorState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: Container(
        padding: padding,
        child: Icon(
          iconState?.call(state) ?? icon,
          color: colorState?.call(state) ?? color,
          size: size,
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

class ButtonController {
  late Function(VoidCallback fn) callback;
  String? _text;
  double? textSize;
  FontWeight? textWeight;
  Color? background;
  bool enabled = true;
  Color? textColor;

  void setCallback(void Function(VoidCallback fn) callback) {
    this.callback = callback;
  }

  set text(String value) => _text = value;

  String get text => _text ?? "";

  void setText(String? value) {
    callback(() {
      text = value ?? "";
    });
  }

  void setTextColor(Color value) {
    callback(() {
      textColor = value;
    });
  }

  void setTextSize(double value) {
    callback(() {
      textSize = value;
    });
  }

  void setEnabled(bool value) {
    callback(() {
      enabled = value;
    });
  }
}
