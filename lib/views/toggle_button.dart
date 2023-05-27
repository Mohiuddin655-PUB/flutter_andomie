import 'package:flutter/material.dart';
import 'package:flutter_andomie/widgets.dart';

class ToggleButton extends StatefulWidget {
  final double? width, height;
  final EdgeInsetsGeometry? margin, padding;
  final String? text;
  final double? textSize;
  final FontWeight? textStyle;
  final double borderRadius;
  final bool selected;
  final bool enabled;
  final Function(bool)? onClick;
  final dynamic icon;
  final double iconSize;
  final Color? pressedColor;
  final bool expended;
  final EdgeInsetsGeometry? iconPadding;
  final ToggleIconAlignment iconAlignment;

  final ToggleState<String>? textState;
  final ToggleState<dynamic>? iconState;
  final ToggleState<Color>? colorState;
  final ToggleState<Color>? backgroundState;

  const ToggleButton({
    super.key,
    this.text,
    this.textSize = 16,
    this.textStyle,
    this.width,
    this.height,
    this.margin,
    this.padding,
    this.borderRadius = 0,
    this.selected = false,
    this.enabled = true,
    this.pressedColor = Colors.transparent,
    this.onClick,
    this.icon,
    this.expended = false,
    this.iconSize = 18,
    this.iconPadding,
    this.iconAlignment = ToggleIconAlignment.end,
    this.textState,
    this.iconState,
    this.colorState,
    this.backgroundState,
  });

  @override
  State<ToggleButton> createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {
  late bool isSelected = widget.selected;

  @override
  void didUpdateWidget(covariant ToggleButton oldWidget) {
    isSelected = widget.selected;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = widget.enabled && widget.onClick != null
        ? isSelected
            ? theme.primaryColor
            : Colors.white
        : Colors.grey.shade400;
    final background = widget.enabled && widget.onClick != null
        ? isSelected
            ? theme.primaryColor.withOpacity(0.1)
            : theme.primaryColor
        : Colors.grey.shade200;

    return Container(
      margin: widget.margin,
      child: Material(
        color: widget.backgroundState?.call(state) ?? background,
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: InkWell(
          onTap: widget.enabled && widget.onClick != null
              ? () => setState(() {
                    widget.onClick?.call(isSelected);
                    isSelected = !isSelected;
                  })
              : null,
          splashColor: widget.pressedColor,
          highlightColor: widget.pressedColor,
          hoverColor: widget.pressedColor,
          child: AbsorbPointer(
            child: Container(
              width: widget.width,
              height: widget.padding == null ? widget.height : null,
              padding: widget.padding ??
                  const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _Icon(
                    visible: (widget.iconState ?? widget.icon) != null &&
                        widget.iconAlignment == ToggleIconAlignment.start,
                    state: state,
                    icon: widget.icon,
                    iconState: widget.iconState,
                    color: color,
                    colorState: widget.colorState,
                    size: widget.iconSize,
                    padding: widget.iconPadding,
                  ),
                  if ((widget.iconState ?? widget.icon) != null &&
                      widget.iconAlignment == ToggleIconAlignment.start &&
                      widget.expended)
                    const Spacer(),
                  _Text(
                    state: state,
                    primary: color,
                    text: widget.text,
                    textSize: widget.textSize,
                    textStyle: widget.textStyle,
                    textState: widget.textState,
                    colorState: widget.colorState,
                  ),
                  if ((widget.iconState ?? widget.icon) != null &&
                      widget.iconAlignment == ToggleIconAlignment.end &&
                      widget.expended)
                    const Spacer(),
                  _Icon(
                    visible: (widget.iconState ?? widget.icon) != null &&
                        widget.iconAlignment == ToggleIconAlignment.end,
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

  ToggleType get state {
    if (widget.enabled && widget.onClick != null) {
      if (isSelected) {
        return ToggleType.selected;
      } else {
        return ToggleType.none;
      }
    } else {
      return ToggleType.disable;
    }
  }
}

class _Text extends StatelessWidget {
  final Color? primary;
  final String? text;
  final double? textSize;
  final FontWeight? textStyle;
  final ToggleState<String>? textState;
  final ToggleState<Color>? colorState;
  final ToggleType state;

  const _Text({
    Key? key,
    required this.state,
    this.primary,
    this.text,
    this.textSize = 14,
    this.textStyle,
    this.textState,
    this.colorState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      textState?.call(state) ?? text ?? "",
      textAlign: TextAlign.center,
      style: TextStyle(
        color: colorState?.call(state) ?? primary,
        fontSize: textSize,
        fontWeight: textStyle,
      ),
    );
  }
}

class _Icon extends StatelessWidget {
  final ToggleType state;
  final dynamic icon;
  final bool visible;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final double? size;
  final ToggleState<dynamic>? iconState;
  final ToggleState<Color>? colorState;

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
        child: RawIconView(
          icon: iconState?.call(state) ?? icon,
          tint: colorState?.call(state) ?? color,
          size: size,
        ),
      ),
    );
  }
}

enum ToggleIconAlignment {
  start,
  end,
}

class ToggleState<T> {
  final T regular;
  final T? _selected;
  final T? _disabled;

  const ToggleState({
    required this.regular,
    T? selected,
    T? disabled,
  })  : _selected = selected ?? regular,
        _disabled = disabled ?? regular;

  factory ToggleState.activator({
    required T enabled,
    required T disabled,
  }) {
    return ToggleState(
      regular: enabled,
      selected: disabled,
    );
  }

  factory ToggleState.selectable({
    required T selected,
    required T unselected,
  }) {
    return ToggleState(
      regular: unselected,
      selected: selected,
    );
  }

  T get selected => _selected ?? regular;

  T get disabled => _disabled ?? regular;

  T call(ToggleType type) {
    switch (type) {
      case ToggleType.selected:
        return selected;
      case ToggleType.disable:
        return disabled;
      case ToggleType.none:
        return regular;
    }
  }
}

enum ToggleType {
  selected,
  disable,
  none,
}
