part of '../widgets.dart';

class ExpendableTextView extends TextView {
  final String? expendedText;
  final double? expendedCharacterSpace;
  final Color? expendedTextColor;
  final double? expendedTextSize;
  final FontStyle? expendedTextStyle;
  final bool expendedTextVisible;
  final FontWeight? expendedTextWeight;

  const ExpendableTextView({
    Key? key,
    super.controller,
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
    super.shadowType,
    super.shape,
    super.onClick,
    super.onClickHandle,
    super.onDoubleClick,
    super.onDoubleClickHandle,
    super.onLongClick,
    super.onLongClickHandle,
    super.maxCharacters,
    super.maxLines,
    super.letterSpacing,
    super.lineSpacingExtra,
    super.wordSpacing,
    super.ellipsizeText = " ...more ",
    super.ellipsizeVisibility,
    super.ellipsizeLetterSpace,
    super.ellipsizeTextColor,
    super.ellipsizeTextSize,
    super.ellipsizeTextStyle,
    super.ellipsizeTextWeight = FontWeight.bold,
    super.fontFamily,
    super.fontStyle,
    super.fontWeight,
    super.text,
    super.textAlign,
    super.textColor,
    super.textDecoration,
    super.textDecorationColor,
    super.textDecorationStyle,
    super.textDecorationThickness,
    super.textDirection,
    super.textLeadingDistribution,
    super.textOverflow,
    super.textSize,
    super.textSpans,
    super.textStyle,
    this.expendedCharacterSpace,
    this.expendedText = " ...less ",
    this.expendedTextColor,
    this.expendedTextSize,
    this.expendedTextStyle,
    this.expendedTextWeight,
    this.expendedTextVisible = true,
  }) : super(key: key);

  @override
  State<ExpendableTextView> createState() => _ExpendableTextViewState();
}

class _ExpendableTextViewState extends State<ExpendableTextView> {
  bool expended = false;

  @override
  Widget build(BuildContext context) {
    return TextView(
      controller: widget.controller,
      gravity: widget.gravity,
      background: widget.background,
      backgroundGradient: widget.backgroundGradient,
      borderColor: widget.borderColor,
      borderRadius: widget.borderRadius,
      borderRadiusTL: widget.borderRadiusTL,
      borderRadiusTR: widget.borderRadiusTR,
      borderRadiusBL: widget.borderRadiusBL,
      borderRadiusBR: widget.borderRadiusBR,
      borderSize: widget.borderSize,
      textDecoration: widget.textDecoration,
      textDecorationColor: widget.textDecorationColor,
      textDecorationStyle: widget.textDecorationStyle,
      textDecorationThickness: widget.textDecorationThickness,
      ellipsizeVisibility:
          widget.expendedText != null && widget.expendedTextVisible,
      ellipsizeLetterSpace: expended
          ? widget.expendedCharacterSpace ?? widget.ellipsizeLetterSpace
          : widget.ellipsizeLetterSpace,
      ellipsizeText: expended ? widget.expendedText : widget.ellipsizeText,
      ellipsizeTextColor: (expended
              ? widget.expendedTextColor ?? widget.ellipsizeTextColor
              : widget.ellipsizeTextColor) ??
          widget.textColor?.withOpacity(1 / 3),
      ellipsizeTextSize: expended
          ? widget.expendedTextSize ?? widget.ellipsizeTextSize
          : widget.ellipsizeTextSize,
      ellipsizeTextStyle: expended
          ? widget.expendedTextStyle ?? widget.ellipsizeTextStyle
          : widget.ellipsizeTextStyle,
      ellipsizeTextWeight: expended
          ? widget.expendedTextWeight ?? widget.ellipsizeTextWeight
          : widget.ellipsizeTextWeight,
      enabled: widget.enabled,
      flex: widget.flex,
      fontFamily: widget.fontFamily,
      fontStyle: widget.fontStyle,
      fontWeight: widget.fontWeight,
      height: widget.height,
      textLeadingDistribution: widget.textLeadingDistribution,
      letterSpacing: widget.letterSpacing,
      lineSpacingExtra: widget.lineSpacingExtra,
      maxCharacters: expended ? 0 : widget.maxCharacters,
      maxLines: null,
      margin: widget.margin,
      marginStart: widget.marginStart,
      marginEnd: widget.marginEnd,
      marginTop: widget.marginTop,
      marginBottom: widget.marginBottom,
      marginHorizontal: widget.marginHorizontal,
      marginVertical: widget.marginVertical,
      padding: widget.padding,
      paddingStart: widget.paddingStart,
      paddingEnd: widget.paddingEnd,
      paddingTop: widget.paddingTop,
      paddingBottom: widget.paddingBottom,
      paddingHorizontal: widget.paddingHorizontal,
      paddingVertical: widget.paddingVertical,
      text: widget.text,
      textAlign: widget.textAlign,
      textColor: widget.textColor,
      textDirection: widget.textDirection,
      textSize: widget.textSize,
      textSpans: widget.textSpans,
      textStyle: widget.textStyle,
      textOverflow: null,
      visibility: widget.visibility,
      width: widget.width,
      wordSpacing: widget.wordSpacing,
      onClick: (c) {
        setState(() {
          expended = !expended;
        });
      },
    );
  }
}

class ExpendableTextViewController extends TextViewController {}
