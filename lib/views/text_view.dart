part of '../widgets.dart';

class TextView<T extends TextViewController> extends YMRView<T> {
  final int? maxCharacters;
  final int? maxLines;

  final double? letterSpacing;
  final double? lineSpacingExtra;
  final double? wordSpacing;

  final String? ellipsizeText;
  final bool? ellipsizeVisibility;
  final double? ellipsizeLetterSpace;
  final Color? ellipsizeTextColor;
  final double? ellipsizeTextSize;
  final FontStyle? ellipsizeTextStyle;
  final FontWeight? ellipsizeTextWeight;

  final String? fontFamily;
  final FontStyle? fontStyle;
  final FontWeight? fontWeight;

  final String? text;
  final ValueState<String>? textState;
  final TextAlign? textAlign;
  final bool? textAllCaps;
  final Color? textColor;
  final ValueState<Color>? textColorState;
  final TextDecoration? textDecoration;
  final Color? textDecorationColor;
  final TextDecorationStyle? textDecorationStyle;
  final double? textDecorationThickness;
  final TextDirection? textDirection;
  final TextLeadingDistribution? textLeadingDistribution;
  final TextOverflow? textOverflow;
  final double? textSize;
  final List<TextSpan>? textSpans;
  final TextStyle? textStyle;

  const TextView({
    Key? key,
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
    super.position,
    super.positionType,
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
    super.backgroundState,
    super.backgroundBlendMode,
    super.backgroundGradient,
    super.backgroundGradientState,
    super.backgroundImage,
    super.backgroundImageState,
    super.foreground,
    super.borderColor,
    super.rippleColor,
    super.pressedColor,
    super.hoverColor,
    super.elevation,
    super.ripple,
    super.shadowColor,
    super.gravity,
    super.transformGravity,
    super.foregroundBlendMode,
    super.foregroundImage,
    super.foregroundGradient,
    super.borderGradient,
    super.transform,
    super.shadowBlurStyle,
    super.clipBehavior,
    super.shadowType,
    super.shape,
    super.onClick,
    super.onClickHandler,
    super.onDoubleClick,
    super.onDoubleClickHandler,
    super.onLongClick,
    super.onLongClickHandler,
    super.onToggle,
    this.maxCharacters,
    this.maxLines,
    this.letterSpacing,
    this.lineSpacingExtra,
    this.wordSpacing,
    this.ellipsizeText,
    this.ellipsizeVisibility,
    this.ellipsizeLetterSpace,
    this.ellipsizeTextColor,
    this.ellipsizeTextSize,
    this.ellipsizeTextStyle,
    this.ellipsizeTextWeight,
    this.fontFamily,
    this.fontStyle,
    this.fontWeight,
    this.text,
    this.textState,
    this.textAlign,
    this.textAllCaps,
    this.textColor,
    this.textColorState,
    this.textDecoration,
    this.textDecorationColor,
    this.textDecorationStyle,
    this.textDecorationThickness,
    this.textDirection,
    this.textLeadingDistribution,
    this.textOverflow,
    this.textSize,
    this.textSpans,
    this.textStyle,
  }) : super(key: key);

  @override
  T initController() {
    return TextViewController() as T;
  }

  @override
  T attachController(T controller) {
    return controller.fromTextView(this) as T;
  }

  @override
  Widget? attach(BuildContext context, T controller) {
    return RawTextView(
      text: controller.text,
      textSpans: controller.isSpannable
          ? [
              TextSpan(
                text: controller.isAutoEllipsize
                    ? controller.ellipsizeText ?? " ... "
                    : null,
                style: TextStyle(
                  color: controller.ellipsizeTextColor,
                  fontSize: controller.ellipsizeTextSize,
                  fontStyle: controller.ellipsizeTextStyle,
                  letterSpacing: controller.ellipsizeLetterSpace,
                  fontWeight: controller.ellipsizeTextWeight,
                ),
              ),
            ]
          : [],
      maxLines: controller.maxLines,
      textOverflow: controller.textOverflow,
      textStyle: controller.textStyle,
      textColor: controller.textColor,
      textSize: controller.textSize,
      fontWeight: controller.fontWeight,
      textDecoration: controller.textDecoration,
      textDecorationColor: controller.textDecorationColor,
      textDecorationStyle: controller.textDecorationStyle,
      textDecorationThickness: controller.textDecorationThickness,
      fontFamily: controller.fontFamily,
      fontStyle: controller.fontStyle,
      textLeadingDistribution: controller.textLeadingDistribution,
      lineHeight: controller.spacingFactor,
      letterSpacing: controller.letterSpacing,
      wordSpacing: controller.wordSpacing,
      textAlign: controller.textAlign,
      textDirection: controller.textDirection,
    );
  }
}

class RawTextView extends StatelessWidget {
  final int? maxCharacters;
  final int? maxLines;

  final double? letterSpacing;
  final double? lineHeight;
  final double? wordSpacing;

  final String? fontFamily;
  final FontStyle? fontStyle;
  final FontWeight? fontWeight;

  final String? text;
  final TextAlign? textAlign;
  final Color? textColor;
  final TextDecoration? textDecoration;
  final Color? textDecorationColor;
  final TextDecorationStyle? textDecorationStyle;
  final double? textDecorationThickness;
  final TextDirection? textDirection;
  final TextLeadingDistribution? textLeadingDistribution;
  final TextOverflow? textOverflow;
  final double textSize;
  final List<TextSpan> textSpans;
  final TextStyle textStyle;

  const RawTextView({
    super.key,
    this.maxCharacters,
    this.maxLines,
    this.letterSpacing,
    this.lineHeight,
    this.wordSpacing,
    this.fontFamily,
    this.fontStyle,
    this.fontWeight,
    required this.text,
    this.textAlign,
    this.textColor,
    this.textDecoration,
    this.textDecorationColor,
    this.textDecorationStyle,
    this.textDecorationThickness,
    this.textDirection,
    this.textLeadingDistribution,
    this.textOverflow,
    this.textSize = 14,
    this.textSpans = const [],
    this.textStyle = const TextStyle(),
  });

  @override
  Widget build(BuildContext context) {
    return textSpans.isNotEmpty
        ? Text.rich(
            TextSpan(
              text: text,
              children: textSpans,
            ),
            maxLines: maxLines,
            overflow: maxCharacters == 0 ? textOverflow : null,
            style: textStyle.copyWith(
              color: textColor,
              fontSize: textSize,
              fontWeight: fontWeight,
              decoration: textDecoration,
              decorationColor: textDecorationColor,
              decorationStyle: textDecorationStyle,
              decorationThickness: textDecorationThickness,
              fontFamily: fontFamily,
              fontStyle: fontStyle,
              height: lineHeight,
              leadingDistribution: textLeadingDistribution,
              letterSpacing: letterSpacing,
              wordSpacing: wordSpacing,
            ),
            textAlign: textAlign,
            textDirection: textDirection,
          )
        : Text(
            text ?? "",
            maxLines: maxLines,
            overflow: maxCharacters == 0 ? textOverflow : null,
            style: textStyle.copyWith(
              color: textColor,
              fontSize: textSize,
              fontWeight: fontWeight,
              decoration: textDecoration,
              decorationColor: textDecorationColor,
              decorationStyle: textDecorationStyle,
              decorationThickness: textDecorationThickness,
              fontFamily: fontFamily,
              fontStyle: fontStyle,
              height: lineHeight,
              leadingDistribution: textLeadingDistribution,
              letterSpacing: letterSpacing,
              wordSpacing: wordSpacing,
            ),
            textAlign: textAlign,
            textDirection: textDirection,
          );
  }
}

class TextViewController extends ViewController {
  int maxCharacters = 0;
  int? maxLines;

  double? letterSpacing;
  double lineSpacingExtra = 0;
  double? wordSpacing;

  String? ellipsizeText;
  bool ellipsizeVisibility = false;
  double? ellipsizeLetterSpace;
  Color? ellipsizeTextColor;
  double? ellipsizeTextSize;
  FontStyle? ellipsizeTextStyle;
  FontWeight? ellipsizeTextWeight;

  String? fontFamily;
  FontStyle? fontStyle;
  FontWeight? fontWeight;

  String? _text;
  ValueState<String>? textState;
  TextAlign? textAlign;
  bool textAllCaps = false;
  Color? _textColor;
  ValueState<Color>? textColorState;
  TextDecoration? textDecoration;
  Color? textDecorationColor;
  TextDecorationStyle? textDecorationStyle;
  double? textDecorationThickness;
  TextDirection? textDirection;
  TextLeadingDistribution? textLeadingDistribution;
  TextOverflow? textOverflow;
  double textSize = 14;
  List<TextSpan>? textSpans;
  TextStyle textStyle = const TextStyle();

  TextViewController fromTextView(TextView view) {
    super.fromView(view);

    maxCharacters = view.maxCharacters ?? 0;
    maxLines = view.maxLines;

    letterSpacing = view.letterSpacing;
    lineSpacingExtra = view.lineSpacingExtra ?? 0;
    wordSpacing = view.wordSpacing;

    ellipsizeVisibility = view.ellipsizeVisibility ?? false;
    ellipsizeLetterSpace = view.ellipsizeLetterSpace;
    ellipsizeText = view.ellipsizeText;
    ellipsizeTextColor = view.ellipsizeTextColor;
    ellipsizeTextSize = view.ellipsizeTextSize;
    ellipsizeTextStyle = view.ellipsizeTextStyle;
    ellipsizeTextWeight = view.ellipsizeTextWeight;

    fontFamily = view.fontFamily;
    fontStyle = view.fontStyle;
    fontWeight = view.fontWeight;

    text = view.text;
    textState = view.textState;
    textAlign = view.textAlign;
    textAllCaps = view.textAllCaps ?? false;
    textColor = view.textColor;
    textColorState = view.textColorState;
    textDecoration = view.textDecoration;
    textDecorationColor = view.textDecorationColor;
    textDecorationStyle = view.textDecorationStyle;
    textDecorationThickness = view.textDecorationThickness;
    textDirection = view.textDirection;
    textLeadingDistribution = view.textLeadingDistribution;
    textOverflow = view.textOverflow;
    textSize = view.textSize ?? 14;
    textSpans = view.textSpans;
    textStyle = view.textStyle ?? const TextStyle();

    return this;
  }

  set text(String? value) => _text = value;

  String get text {
    final value = textState?.activated(activated, enabled) ?? _text ?? "";
    if (maxCharacters > 0) {
      return value.substring(
        0,
        value.length > maxCharacters ? maxCharacters : value.length,
      );
    }
    return textAllCaps ? value.toUpperCase() : value;
  }

  set textColor(Color? value) => _textColor = value;

  Color? get textColor {
    return textColorState?.activated(activated, enabled) ?? _textColor;
  }

  double? get spacingFactor {
    final x = textSize + lineSpacingExtra;
    final y = x * 0.068;
    return lineSpacingExtra > 0 ? y : null;
  }

  bool get isAutoEllipsize {
    final a = maxCharacters > 0;
    final b = text.length > maxCharacters;
    return (a && b) || ellipsizeVisibility;
  }

  bool get isSpannable {
    return (ellipsizeText ?? "").isNotEmpty || (textSpans ?? []).isNotEmpty;
  }

  void setEllipsizeLetterSpace(double? value) {
    ellipsizeLetterSpace = value;
    _notify;
  }

  void setEllipsizeText(String? value) {
    ellipsizeText = value;
    _notify;
  }

  void setEllipsizeTextColor(Color? value) {
    ellipsizeTextColor = value;
    _notify;
  }

  void setEllipsizeTextSize(double? value) {
    ellipsizeTextSize = value;
    _notify;
  }

  void setEllipsizeTextStyle(FontStyle? value) {
    ellipsizeTextStyle = value;
    _notify;
  }

  void setEllipsizeTextWeight(FontWeight value) {
    ellipsizeTextWeight = value;
    _notify;
  }

  void setEllipsizeVisibility(bool value) {
    ellipsizeVisibility = value;
    _notify;
  }

  void setFontWeight(FontWeight value) {
    fontWeight = value;
    _notify;
  }

  void setLetterSpacing(double value) {
    letterSpacing = value;
    _notify;
  }

  void setLineSpacingExtra(double value) {
    lineSpacingExtra = value;
    _notify;
  }

  void setMaxLines(int? value) {
    maxLines = value;
    _notify;
  }

  void setText(String value) {
    text = value;
    _notify;
  }

  void setTextState(ValueState<String> value) {
    textState = value;
    _notify;
  }

  void setTextAlign(TextAlign value) {
    textAlign = value;
    _notify;
  }

  void setTextColor(Color value) {
    textColor = value;
    _notify;
  }

  void setTextColorState(ValueState<Color> value) {
    textColorState = value;
    _notify;
  }

  void setTextDirection(TextDirection value) {
    textDirection = value;
    _notify;
  }

  void setTextLength(int value) {
    maxCharacters = value;
    _notify;
  }

  void setTextOverflow(TextOverflow value) {
    textOverflow = value;
    _notify;
  }

  void setTextSize(double value) {
    textSize = value;
    _notify;
  }

  void setTextSpans(List<TextSpan> value) {
    textSpans = value;
    _notify;
  }

  void setTextWeight(FontWeight value) {
    fontWeight = value;
    _notify;
  }

  void setWordSpacing(double value) {
    wordSpacing = value;
    _notify;
  }
}
