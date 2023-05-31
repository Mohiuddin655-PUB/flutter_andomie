import 'package:flutter/material.dart';

class BorderButton extends StatefulWidget {
  final double? width, height;
  final EdgeInsetsGeometry? margin, padding;
  final String? text;
  final double? textSize;
  final TextStyle textStyle;
  final FontWeight? textWeight;
  final double borderRadius;
  final double borderSize;
  final bool enabled;
  final Function()? onClick;
  final IconData? icon;
  final double iconSize;
  final bool expended;
  final EdgeInsetsGeometry? iconPadding;
  final IconAlignment iconAlignment;
  final Color? splashColor;

  final String? Function(ButtonState state)? textState;
  final IconData? Function(ButtonState state)? iconState;
  final Color? Function(ButtonState state)? colorState;
  final Color? Function(ButtonState state)? borderState;

  const BorderButton({
    super.key,
    this.text,
    this.textSize = 16,
    this.textStyle = const TextStyle(),
    this.textWeight,
    this.width,
    this.height,
    this.margin,
    this.padding,
    this.borderRadius = 0,
    this.borderSize = 1,
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
    this.borderState,
    this.splashColor,
  });

  @override
  State<BorderButton> createState() => _BorderButtonState();
}

class _BorderButtonState extends State<BorderButton> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = widget.enabled && widget.onClick != null
        ? theme.primaryColor
        : Colors.grey.shade400;
    final color = widget.colorState?.call(state) ?? c;
    final border = widget.borderState?.call(state) ?? color;

    return Container(
      margin: widget.margin,
      child: Material(
        color: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: InkWell(
          highlightColor:
              widget.splashColor?.withOpacity(0.5) ?? Colors.transparent,
          onTap: widget.enabled ? widget.onClick : null,
          splashColor: widget.splashColor ?? Colors.transparent,
          child: AbsorbPointer(
            child: Container(
              width: widget.width,
              height: widget.padding == null ? widget.height : null,
              padding: widget.padding ??
                  (widget.height == null
                      ? EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: widget.height != null ? 0 : 12,
                        )
                      : null),
              decoration: BoxDecoration(
                border: Border.all(
                  color: border,
                  width: widget.borderSize,
                ),
                borderRadius: BorderRadius.circular(widget.borderRadius),
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
                    text: widget.text,
                    textSize: widget.textSize,
                    textStyle: widget.textStyle,
                    textWeight: widget.textWeight,
                    textState: widget.textState,
                    colorState: widget.colorState,
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
    if (widget.enabled && widget.onClick != null) {
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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      textState?.call(state) ?? text ?? "",
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
