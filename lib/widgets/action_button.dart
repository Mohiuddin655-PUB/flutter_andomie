import 'package:flutter/material.dart';

import 'material_icon.dart';

class ActionButton extends StatefulWidget {
  final ActionButtonController? controller;
  final EdgeInsetsGeometry? margin;
  final double? padding, borderRadius;
  final bool enabled;
  final dynamic icon;
  final double? size;
  final Color? background, rippleColor, pressedColor, tint;
  final BoxFit? fit;

  final Function()? onClick;

  const ActionButton({
    super.key,
    this.controller,
    this.fit,
    this.margin,
    this.padding,
    this.borderRadius = 25,
    this.enabled = true,
    this.onClick,
    this.icon,
    this.size,
    this.tint,
    this.background,
    this.rippleColor,
    this.pressedColor = const Color(0xFFF2F2F2),
  });

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  late ActionButtonController controller;

  @override
  void initState() {
    controller = widget.controller ?? ActionButtonController();
    controller.background = widget.background;
    controller.borderRadius = widget.borderRadius??25;
    controller.icon = widget.icon;
    controller.tint = widget.tint;
    controller.size = widget.size;
    controller.fit = widget.fit;
    controller.setNotifier(setState);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: widget.margin ?? const EdgeInsets.all(8),
          child: Material(
            color: controller.background,
            clipBehavior: Clip.antiAlias,
            borderRadius: BorderRadius.circular(controller.borderRadius),
            child: InkWell(
              onTap: () => controller.onClick?.call(context),
              onDoubleTap: () => controller.onDoubleClick?.call(context),
              onLongPress: () => controller.onLongClick?.call(context),
              splashColor: widget.rippleColor,
              highlightColor: widget.pressedColor,
              hoverColor: widget.pressedColor,
              child: AbsorbPointer(
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(widget.padding ?? 8),
                  child: MaterialIcon(controller: controller),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ActionButtonController extends MaterialIconController {

}
