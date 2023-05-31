import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ImageButton extends StatelessWidget {
  final double margin;
  final double? marginHorizontal, marginVertical;
  final double? marginTop, marginBottom, marginStart, marginEnd;
  final double padding, borderRadius;
  final bool enabled;
  final dynamic src;
  final double size;
  final Color? background, rippleColor, pressedColor, tint;
  final BoxFit? fit;
  final ImageButtonIconType type;

  final IconData? Function(ImageButtonState state)? iconState;
  final Color? Function(ImageButtonState state)? tintState;
  final Color? Function(ImageButtonState state)? backgroundState;

  final Function(BuildContext context)? onClick;

  const ImageButton({
    super.key,
    this.fit,
    this.padding = 8,
    this.margin = 0,
    this.marginHorizontal,
    this.marginVertical,
    this.marginTop,
    this.marginBottom,
    this.marginStart,
    this.marginEnd,
    this.borderRadius = 25,
    this.enabled = true,
    this.onClick,
    this.src,
    this.size = 24,
    this.iconState,
    this.tint,
    this.tintState,
    this.background = Colors.transparent,
    this.backgroundState,
    this.rippleColor,
    this.pressedColor = const Color(0xFFF2F2F2),
    this.type = ImageButtonIconType.detect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: marginHorizontal ?? marginStart ?? margin,
        right: marginHorizontal ?? marginEnd ?? margin,
        top: marginVertical ?? marginTop ?? margin,
        bottom: marginVertical ?? marginBottom ?? margin,
      ),
      child: Material(
        color: backgroundState?.call(state) ?? background,
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          onTap: enabled ? () => onClick?.call(context) : null,
          splashColor: rippleColor,
          highlightColor: pressedColor,
          hoverColor: pressedColor,
          child: AbsorbPointer(
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(padding),
              child: _Icon(
                icon: src,
                size: size,
                tint: tint,
                fit: fit,
                type: type,
              ),
            ),
          ),
        ),
      ),
    );
  }

  ImageButtonState get state {
    if (enabled && onClick != null) {
      return ImageButtonState.enabled;
    } else {
      return ImageButtonState.disabled;
    }
  }
}

class _Icon extends StatelessWidget {
  final dynamic icon;
  final ImageButtonIconType type;
  final Color? tint;
  final double? size;
  final BoxFit? fit;

  const _Icon({
    Key? key,
    required this.icon,
    this.type = ImageButtonIconType.detect,
    this.tint,
    this.size,
    this.fit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (_type) {
      case ImageButtonIconType.icon:
        return Icon(
          icon,
          color: tint,
          size: size,
        );
      case ImageButtonIconType.svg:
        return SvgPicture.asset(
          icon,
          theme: SvgTheme(currentColor: tint ?? Colors.black),
          width: size,
          height: size,
          fit: fit ?? BoxFit.contain,
        );
      case ImageButtonIconType.image:
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

  ImageButtonIconType get _type {
    final data = icon;
    if (type == ImageButtonIconType.detect) {
      if (data is IconData) {
        return ImageButtonIconType.icon;
      } else if (data is String) {
        if (data.contains('.svg')) {
          return ImageButtonIconType.svg;
        } else if (data.contains('.png') ||
            data.contains('.jpg') ||
            data.contains('.jpeg') ||
            data.contains('.webp')) {
          return ImageButtonIconType.image;
        } else {
          return type;
        }
      } else {
        return type;
      }
    } else {
      return type;
    }
  }
}

enum ImageButtonIconType {
  detect,
  icon,
  svg,
  image,
}

enum ImageButtonState {
  disabled,
  enabled,
}
