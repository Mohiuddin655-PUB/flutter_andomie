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
  final TextAlign? textAlign;
  final Color? textColor;
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
    this.textAlign,
    this.textColor,
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
  T attachController() {
    return TextViewController() as T;
  }

  @override
  T initController(T controller) {
    return controller.attach(
      this,
      ellipsizeVisibility: ellipsizeVisibility,
      ellipsizeLetterSpace: ellipsizeLetterSpace,
      ellipsizeText: ellipsizeText,
      ellipsizeTextColor: ellipsizeTextColor,
      ellipsizeTextSize: ellipsizeTextSize,
      ellipsizeTextStyle: ellipsizeTextStyle,
      ellipsizeTextWeight: ellipsizeTextWeight,
      fontFamily: fontFamily,
      fontStyle: fontStyle,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      lineSpacingExtra: lineSpacingExtra,
      maxCharacters: maxCharacters,
      maxLines: maxLines,
      text: text,
      textAlign: textAlign,
      textColor: textColor,
      textDecoration: textDecoration,
      textDecorationColor: textDecorationColor,
      textDecorationStyle: textDecorationStyle,
      textDecorationThickness: textDecorationThickness,
      textDirection: textDirection,
      textLeadingDistribution: textLeadingDistribution,
      textOverflow: textOverflow,
      textSize: textSize,
      textSpans: textSpans,
      textStyle: textStyle,
      wordSpacing: wordSpacing,
    ) as T;
  }

  @override
  Widget? attach(BuildContext context, T controller) {
    return _TextView(
      controller: controller,
    );
  }
}

class _TextView<T extends TextViewController> extends StatelessWidget {
  final T controller;

  const _TextView({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => RawText(
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

class RawText extends StatelessWidget {
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

  const RawText({
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
  TextAlign? textAlign;
  Color? textColor;
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

  @override
  TextViewController attach(
    YMRView view, {
    int? maxCharacters,
    int? maxLines,
    double? letterSpacing,
    double? lineSpacingExtra,
    double? wordSpacing,
    String? ellipsizeText,
    bool? ellipsizeVisibility,
    double? ellipsizeLetterSpace,
    Color? ellipsizeTextColor,
    double? ellipsizeTextSize,
    FontStyle? ellipsizeTextStyle,
    FontWeight? ellipsizeTextWeight,
    String? fontFamily,
    FontStyle? fontStyle,
    FontWeight? fontWeight,
    String? text,
    TextAlign? textAlign,
    Color? textColor,
    TextDecoration? textDecoration,
    Color? textDecorationColor,
    TextDecorationStyle? textDecorationStyle,
    double? textDecorationThickness,
    TextDirection? textDirection,
    TextLeadingDistribution? textLeadingDistribution,
    TextOverflow? textOverflow,
    double? textSize,
    List<TextSpan>? textSpans,
    TextStyle? textStyle,
  }) {
    super.attach(view);

    this.maxCharacters = maxCharacters ?? this.maxCharacters;
    this.maxLines = maxLines ?? this.maxLines;

    this.letterSpacing = letterSpacing ?? this.letterSpacing;
    this.lineSpacingExtra = lineSpacingExtra ?? this.lineSpacingExtra;
    this.wordSpacing = wordSpacing ?? this.wordSpacing;

    this.ellipsizeVisibility = ellipsizeVisibility ?? this.ellipsizeVisibility;
    this.ellipsizeLetterSpace =
        ellipsizeLetterSpace ?? this.ellipsizeLetterSpace;
    this.ellipsizeText = ellipsizeText ?? this.ellipsizeText;
    this.ellipsizeTextColor = ellipsizeTextColor ?? this.ellipsizeTextColor;
    this.ellipsizeTextSize = ellipsizeTextSize ?? this.ellipsizeTextSize;
    this.ellipsizeTextStyle = ellipsizeTextStyle ?? this.ellipsizeTextStyle;
    this.ellipsizeTextWeight = ellipsizeTextWeight ?? this.ellipsizeTextWeight;

    this.fontFamily = fontFamily ?? this.fontFamily;
    this.fontStyle = fontStyle ?? this.fontStyle;
    this.fontWeight = fontWeight ?? this.fontWeight;

    this.text = text ?? this.text;
    this.textAlign = textAlign ?? this.textAlign;
    this.textColor = textColor ?? this.textColor;
    this.textDecoration = textDecoration ?? this.textDecoration;
    this.textDecorationColor = textDecorationColor ?? this.textDecorationColor;
    this.textDecorationStyle = textDecorationStyle ?? this.textDecorationStyle;
    this.textDecorationThickness =
        textDecorationThickness ?? this.textDecorationThickness;
    this.textDirection = textDirection ?? this.textDirection;
    this.textLeadingDistribution =
        textLeadingDistribution ?? this.textLeadingDistribution;
    this.textOverflow = textOverflow ?? this.textOverflow;
    this.textSize = textSize ?? this.textSize;
    this.textSpans = textSpans ?? this.textSpans;
    this.textStyle = textStyle ?? this.textStyle;
    return this;
  }

  set text(String? value) => _text = value;

  String get text {
    final value = _text ?? "";
    if (maxCharacters > 0) {
      return value.substring(
        0,
        value.length > maxCharacters ? maxCharacters : value.length,
      );
    }
    return value;
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
    notify;
  }

  void setEllipsizeText(String? value) {
    ellipsizeText = value;
    notify;
  }

  void setEllipsizeTextColor(Color? value) {
    ellipsizeTextColor = value;
    notify;
  }

  void setEllipsizeTextSize(double? value) {
    ellipsizeTextSize = value;
    notify;
  }

  void setEllipsizeTextStyle(FontStyle? value) {
    ellipsizeTextStyle = value;
    notify;
  }

  void setEllipsizeTextWeight(FontWeight value) {
    ellipsizeTextWeight = value;
    notify;
  }

  void setEllipsizeVisibility(bool value) {
    ellipsizeVisibility = value;
    notify;
  }

  void setFontWeight(FontWeight value) {
    fontWeight = value;
    notify;
  }

  void setLetterSpacing(double value) {
    letterSpacing = value;
    notify;
  }

  void setLineSpacingExtra(double value) {
    lineSpacingExtra = value;
    notify;
  }

  void setMaxLines(int? value) {
    maxLines = value;
    notify;
  }

  void setText(String value) {
    text = value;
    notify;
  }

  void setTextAlign(TextAlign value) {
    textAlign = value;
    notify;
  }

  void setTextColor(Color value) {
    textColor = value;
    notify;
  }

  void setTextDirection(TextDirection value) {
    textDirection = value;
    notify;
  }

  void setTextLength(int value) {
    maxCharacters = value;
    notify;
  }

  void setTextOverflow(TextOverflow value) {
    textOverflow = value;
    notify;
  }

  void setTextSize(double value) {
    textSize = value;
    notify;
  }

  void setTextSpans(List<TextSpan> value) {
    textSpans = value;
    notify;
  }

  void setTextWeight(FontWeight value) {
    fontWeight = value;
    notify;
  }

  void setWordSpacing(double value) {
    wordSpacing = value;
    notify;
  }
}
