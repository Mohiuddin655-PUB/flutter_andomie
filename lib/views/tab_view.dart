part of '../widgets.dart';

class TabView extends YMRView<TabViewController> {
  final Color? contentColor;
  final ValueState<Color>? contentColorState;
  final dynamic icon;
  final ValueState? iconState;
  final Color? iconTint;
  final ValueState<Color>? iconTintState;
  final double? iconSize;
  final ValueState<double>? iconSizeState;
  final double? iconSpace;
  final bool? inline;
  final String? title;
  final ValueState<String>? titleState;
  final double? titleSize;
  final ValueState<double>? titleSizeState;
  final FontWeight? titleWeight;
  final ValueState<FontWeight>? titleWeightState;

  final bool Function(bool selected)? onVisibleIconWhenTabSelected;
  final bool Function(bool selected)? onVisibleTitleWhenTabSelected;

  const TabView({
    super.key,
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
    super.position,
    super.positionType,
    super.shadowType,
    super.shape,
    super.onClick,
    super.onClickHandler,
    super.onDoubleClick,
    super.onDoubleClickHandler,
    super.onLongClick,
    super.onLongClickHandler,
    this.contentColor,
    this.contentColorState,
    this.icon,
    this.iconState,
    this.iconTint,
    this.iconTintState,
    this.iconSize,
    this.iconSizeState,
    this.iconSpace,
    this.inline,
    this.title,
    this.titleState,
    this.titleSize,
    this.titleSizeState,
    this.titleWeight,
    this.titleWeightState,
    this.onVisibleIconWhenTabSelected,
    this.onVisibleTitleWhenTabSelected,
  });

  @override
  TabViewController initController() {
    return TabViewController();
  }

  @override
  TabViewController attachController(TabViewController controller) {
    return controller.fromView(
      this,
      contentColor: contentColor,
      contentColorState: contentColorState,
      icon: icon,
      iconState: iconState,
      size: iconSize,
      iconSizeState: iconSizeState,
      iconSpace: iconSpace,
      iconTint: iconTint,
      iconTintState: iconTintState,
      inline: inline,
      title: title,
      titleState: titleState,
      titleSize: titleSize,
      titleSizeState: titleSizeState,
      titleWeight: titleWeight,
      titleWeightState: titleWeightState,
      onVisibleIconWhenTabSelected: onVisibleIconWhenTabSelected,
      onVisibleTitleWhenTabSelected: onVisibleTitleWhenTabSelected,
    );
  }

  @override
  Widget? attach(BuildContext context, TabViewController controller) {
    return controller.inline
        ? _TabViewX(controller: controller)
        : _TabViewY(controller: controller);
  }
}

class _TabViewX extends StatelessWidget {
  final TabViewController controller;

  const _TabViewX({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (controller.iconVisible) _TabViewIcon(controller: controller),
        if (controller.titleVisible) _TabViewText(controller: controller),
      ],
    );
  }
}

class _TabViewY extends StatelessWidget {
  final TabViewController controller;

  const _TabViewY({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (controller.iconVisible) _TabViewIcon(controller: controller),
        if (controller.titleVisible) _TabViewText(controller: controller),
      ],
    );
  }
}

class _TabViewIcon extends StatelessWidget {
  final TabViewController controller;

  const _TabViewIcon({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        right: controller._iconSpacingX,
        bottom: controller._iconSpacingY,
      ),
      child: RawIconView(
        icon: controller.icon,
        size: controller.iconSize,
        tint: controller.iconTint,
      ),
    );
  }
}

class _TabViewText extends StatelessWidget {
  final TabViewController controller;

  const _TabViewText({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Text(
      controller.title,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: controller.contentColor,
        fontWeight: controller.titleWeight,
        fontSize: controller.titleSize,
      ),
    );
  }
}

class TabViewController extends ViewController {
  Color _contentColor = const Color(0xFF808080);
  ValueState<Color>? contentColorState;
  dynamic _icon;
  ValueState? iconState;
  Color? _iconTint;
  ValueState<Color>? iconTintState;
  double _iconSize = 24;
  ValueState<double>? iconSizeState;
  double iconSpace = 6;
  bool inline = false;
  String? _title;
  ValueState<String>? titleState;
  double _titleSize = 12;
  ValueState<double>? titleSizeState;
  FontWeight? _titleWeight;
  ValueState<FontWeight>? titleWeightState;

  bool Function(bool selected)? onVisibleIconWhenTabSelected;
  bool Function(bool selected)? onVisibleTitleWhenTabSelected;

  @override
  TabViewController fromView(
    YMRView<ViewController> view, {
    Color? contentColor,
    ValueState<Color>? contentColorState,
    dynamic icon,
    ValueState? iconState,
    Color? iconTint,
    ValueState<Color>? iconTintState,
    double? size,
    ValueState<double>? iconSizeState,
    double? iconSpace,
    bool? inline,
    String? title,
    ValueState<String>? titleState,
    double? titleSize,
    ValueState<double>? titleSizeState,
    FontWeight? titleWeight,
    ValueState<FontWeight>? titleWeightState,
    bool Function(bool selected)? onVisibleIconWhenTabSelected,
    bool Function(bool selected)? onVisibleTitleWhenTabSelected,
  }) {
    super.fromView(view);
    _contentColor = contentColor ?? const Color(0xFF808080);
    this.contentColorState = contentColorState;
    _icon = icon;
    this.iconState = iconState;
    _iconTint = iconTint;
    this.iconTintState = iconTintState;
    _iconSize = size ?? 24;
    this.iconSizeState = iconSizeState;
    this.iconSpace = iconSpace ?? 6;
    this.inline = inline ?? false;
    _title = title;
    this.titleState = titleState;
    _titleSize = titleSize ?? 12;
    this.titleSizeState = titleSizeState;
    _titleWeight = titleWeight;
    this.titleWeightState = titleWeightState;
    this.onVisibleIconWhenTabSelected = onVisibleIconWhenTabSelected;
    this.onVisibleTitleWhenTabSelected = onVisibleTitleWhenTabSelected;
    return this;
  }

  Color? get contentColor =>
      contentColorState?.selected(activated) ?? _contentColor;

  String get title => titleState?.selected(activated) ?? _title ?? "";

  double get titleSize => titleSizeState?.selected(activated) ?? _titleSize;

  FontWeight? get titleWeight =>
      titleWeightState?.selected(activated) ?? _titleWeight;

  dynamic get icon => iconState?.selected(activated) ?? _icon;

  Color? get iconTint =>
      iconTintState?.selected(activated) ?? _iconTint ?? contentColor;

  double get iconSize => iconSizeState?.selected(activated) ?? _iconSize;

  double get _iconSpacingX => inline && titleVisible ? iconSpace : 0;

  double get _iconSpacingY => inline && titleVisible ? 0 : iconSpace;

  bool get iconVisible => icon != null && _isVisibleIconWhenSelected;

  bool get titleVisible => title.isNotEmpty && _isVisibleTitleWhenSelected;

  bool get _isVisibleIconWhenSelected {
    return onVisibleIconWhenTabSelected?.call(activated) ?? true;
  }

  bool get _isVisibleTitleWhenSelected {
    return onVisibleTitleWhenTabSelected?.call(activated) ?? true;
  }
}
