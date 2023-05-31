import 'package:flutter/material.dart';

class FutureButton extends StatefulWidget {
  final double? width, height;
  final EdgeInsetsGeometry? margin, padding;
  final String? text;
  final double? textSize;
  final FontWeight? textStyle;
  final EdgeInsetsGeometry? textPadding;
  final double borderRadius;
  final bool enabled;
  final Function()? onClick;
  final Future<dynamic> Function()? onExecute;
  final IconData? icon;
  final double iconSize;
  final bool expended;
  final EdgeInsetsGeometry? iconPadding;
  final EdgeInsetsGeometry? indicatorPadding;
  final IconAlignment iconAlignment;
  final bool visibleIndicator;

  final bool? Function(ButtonState state)? expendedState;
  final String? Function(ButtonState state)? textState;
  final IconData? Function(ButtonState state)? iconState;
  final Color? Function(ButtonState state)? colorState;
  final Color? Function(ButtonState state)? backgroundState;

  const FutureButton({
    super.key,
    this.text,
    this.textSize = 16,
    this.textStyle,
    this.textPadding,
    this.width,
    this.height,
    this.margin,
    this.padding,
    this.borderRadius = 0,
    this.enabled = true,
    this.onClick,
    this.onExecute,
    this.icon,
    this.expended = false,
    this.iconSize = 18,
    this.iconPadding,
    this.indicatorPadding,
    this.iconAlignment = IconAlignment.end,
    this.visibleIndicator = true,
    this.expendedState,
    this.textState,
    this.iconState,
    this.colorState,
    this.backgroundState,
  });

  @override
  State<FutureButton> createState() => _FutureButtonState();
}

class _FutureButtonState extends State<FutureButton> {
  late bool isLoaded = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = widget.textState?.call(state) ?? widget.text ?? "";
    final color = isEnabled ? Colors.white : Colors.grey.shade400;
    final background = isEnabled ? theme.primaryColor : Colors.grey.shade200;

    return Container(
      margin: widget.margin,
      child: Material(
        color: widget.backgroundState?.call(state) ?? background,
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: InkWell(
          onTap: isEnabled && isLoaded ? _onClick : null,
          child: AbsorbPointer(
            child: Container(
              width: isExpended ? widget.width : null,
              height: widget.padding == null ? widget.height : null,
              padding: widget.padding ??
                  (title.isNotEmpty
                      ? const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        )
                      : widget.indicatorPadding ?? const EdgeInsets.all(12)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FBIcon(
                    visible: isIconAvailable &&
                        widget.iconAlignment == IconAlignment.start,
                    state: state,
                    icon: widget.icon,
                    iconState: widget.iconState,
                    color: color,
                    colorState: widget.colorState,
                    size: widget.iconSize,
                    padding:
                        title.isNotEmpty ? widget.iconPadding : EdgeInsets.zero,
                    visibleIndicator: widget.visibleIndicator,
                  ),
                  if (isExpended && widget.iconAlignment == IconAlignment.start)
                    const Spacer(),
                  FBText(
                    state: state,
                    primary: color,
                    padding: widget.textPadding,
                    text: widget.text,
                    textSize: widget.textSize,
                    textStyle: widget.textStyle,
                    textState: widget.textState,
                    colorState: widget.colorState,
                  ),
                  if (isExpended && widget.iconAlignment == IconAlignment.end)
                    const Spacer(),
                  FBIcon(
                    visible: isIconAvailable &&
                        widget.iconAlignment == IconAlignment.end,
                    state: state,
                    icon: widget.icon,
                    iconState: widget.iconState,
                    color: color,
                    colorState: widget.colorState,
                    size: widget.iconSize,
                    padding:
                        title.isNotEmpty ? widget.iconPadding : EdgeInsets.zero,
                    visibleIndicator: widget.visibleIndicator,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool get isIconAvailable => (widget.iconState ?? widget.icon) != null;

  bool get isEnabled =>
      (widget.onClick != null || widget.onExecute != null) && widget.enabled;

  bool get isExpended =>
      (widget.iconState ?? widget.icon) != null &&
      (widget.expendedState?.call(state) ?? widget.expended);

  void _onClick() async {
    loading;
    if (widget.onExecute != null) {
      await widget.onExecute?.call();
    } else {
      widget.onClick?.call();
    }
    loaded;
  }

  get loading => setState(() => isLoaded = false);

  get loaded => setState(() => isLoaded = true);

  ButtonState get state {
    if (isEnabled) {
      if (isLoaded) {
        return ButtonState.initial;
      } else {
        return ButtonState.loading;
      }
    } else {
      return ButtonState.disabled;
    }
  }
}

class FBIcon extends StatelessWidget {
  final ButtonState state;
  final IconData? icon;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final double? size;
  final IconData? Function(ButtonState state)? iconState;
  final Color? Function(ButtonState state)? colorState;
  final bool visible;
  final bool visibleIndicator;

  const FBIcon({
    Key? key,
    required this.state,
    this.icon,
    this.padding,
    this.color,
    this.size,
    this.iconState,
    this.colorState,
    this.visible = true,
    this.visibleIndicator = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final c = colorState?.call(state) ?? color;
    return Visibility(
      visible: visible,
      child: Container(
        padding: padding,
        child: visibleIndicator && state == ButtonState.loading
            ? SizedBox(
                width: size,
                height: size,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.transparent,
                  strokeWidth: (size ?? 0) * 0.12,
                  color: c,
                ),
              )
            : Icon(
                iconState?.call(state) ?? icon,
                color: c,
                size: size,
              ),
      ),
    );
  }
}

class FBText extends StatelessWidget {
  final Color? primary;
  final EdgeInsetsGeometry? padding;
  final String? text;
  final double? textSize;
  final FontWeight? textStyle;
  final String? Function(ButtonState state)? textState;
  final Color? Function(ButtonState state)? colorState;
  final ButtonState state;
  final bool visible;

  const FBText({
    Key? key,
    required this.state,
    this.primary,
    this.padding,
    this.text,
    this.textSize = 14,
    this.textStyle,
    this.textState,
    this.colorState,
    this.visible = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final value = textState?.call(state) ?? text ?? "";
    return Visibility(
      visible: visible && value.isNotEmpty,
      child: Container(
        padding: padding,
        child: Text(
          value,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: colorState?.call(state) ?? primary,
            fontSize: textSize,
            fontWeight: textStyle,
          ),
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
  initial,
  loading,
  disabled,
}
