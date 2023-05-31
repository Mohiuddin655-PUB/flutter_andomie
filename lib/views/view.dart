part of '../widgets.dart';

typedef OnViewToggle = Function(bool);
typedef OnViewBuilder<T> = Widget Function(BuildContext, T?);
typedef OnViewChangeListener = Function(dynamic value);
typedef OnViewClickListener = Function(BuildContext context);
typedef OnViewAttachBuilder<T extends ViewController> = Widget? Function(
  BuildContext context,
  T controller,
);
typedef OnViewModifyBuilder<T extends ViewController> = Widget Function(
  BuildContext context,
  T controller,
  Widget parent,
);
typedef OnViewNotifier = void Function(VoidCallback fn);
typedef OnViewNotifyListener<T extends ViewController> = Function(T controller);

class ViewController {
  /// Ripple properties
  double elevation = 0;
  Color? hoverColor;
  Color? pressedColor;
  Color rippleColor = Colors.transparent;

  /// Background

  Color? _background;
  ValueState<Color>? backgroundState;
  BlendMode? backgroundBlendMode;
  Gradient? _backgroundGradient;
  ValueState<Gradient>? backgroundGradientState;
  DecorationImage? _backgroundImage;
  ValueState<DecorationImage>? backgroundImageState;

  set background(Color? value) => _background = value;

  set backgroundGradient(Gradient? value) => _backgroundGradient = value;

  set backgroundImage(DecorationImage? value) => _backgroundImage = value;

  Color? get background => backgroundState?.selected(activated) ?? _background;

  Gradient? get backgroundGradient =>
      backgroundGradientState?.selected(activated) ?? _backgroundGradient;

  DecorationImage? get backgroundImage =>
      backgroundImageState?.selected(activated) ?? _backgroundImage;

  bool absorbMode = false;

  bool activated = false;

  Alignment? gravity;

  int animation = 0;

  bool get animationEnabled => animation > 0;

  Duration get animationDuration => Duration(microseconds: animation);

  Curve animationType = Curves.linear;

  Clip clipBehavior = Clip.antiAlias;

  double? _dimensionRatio;

  double get dimensionRatio => _dimensionRatio ?? 0;

  bool get isDimensional => root.ratio && dimensionRatio > 0;

  Color? foreground;

  Gradient? foregroundGradient;

  BlendMode? foregroundBlendMode;

  DecorationImage? foregroundImage;

  double border = 0;

  Color? borderColor;

  Gradient? borderGradient;

  double? borderHorizontal, borderVertical;

  double? _borderTop;

  double get borderTop => _borderTop ?? borderVertical ?? border;

  double? _borderBottom;

  double get borderBottom => _borderBottom ?? borderVertical ?? border;

  double? _borderStart;

  double get borderStart => _borderStart ?? borderHorizontal ?? border;

  double? _borderEnd;

  double get borderEnd => _borderEnd ?? borderHorizontal ?? border;

  double borderRadius = 0;

  double? _borderRadiusBL;

  double get borderRadiusBL => _borderRadiusBL ?? borderRadius;

  double get borderRadiusBLF {
    final a = borderRadiusBL;
    final b = a > 0 ? min(borderStart, borderBottom) : 0;
    return a + b;
  }

  double? _borderRadiusBR;

  double get borderRadiusBR => _borderRadiusBR ?? borderRadius;

  double get borderRadiusBRF {
    final a = borderRadiusBR;
    final b = a > 0 ? min(borderEnd, borderBottom) : 0;
    return a + b;
  }

  double? _borderRadiusTL;

  double get borderRadiusTL => _borderRadiusTL ?? borderRadius;

  double get borderRadiusTLF {
    final a = borderRadiusTL;
    final b = a > 0 ? min(borderStart, borderTop) : 0;
    return a + b;
  }

  double? _borderRadiusTR;

  double get borderRadiusTR => _borderRadiusTR ?? borderRadius;

  double get borderRadiusTRF {
    final a = borderRadiusTR;
    final b = a > 0 ? min(borderEnd, borderTop) : 0;
    return a + b;
  }

  Widget? child;

  bool enabled = true;

  int flex = 0;

  double? _width;

  double? get width => isSquire || isCircular ? squireSize : _width;

  double? _widthMax;

  double get widthMax => _widthMax ?? double.infinity;

  double? _widthMin;

  double get widthMin => _widthMin ?? 0.0;

  double? _height;

  double? get height => isSquire || isCircular ? squireSize : _height;

  double? _heightMax;

  double get heightMax => _heightMax ?? double.infinity;

  double? _heightMin;

  double get heightMin => _heightMin ?? 0.0;

  double margin = 0;

  double? _marginStart;

  double get marginStart => _marginStart ?? marginHorizontal ?? margin;

  double? _marginEnd;

  double get marginEnd => _marginEnd ?? marginHorizontal ?? margin;

  double? _marginTop;

  double get marginTop => _marginTop ?? marginVertical ?? margin;

  double? _marginBottom;

  double get marginBottom => _marginBottom ?? marginVertical ?? margin;

  double? marginHorizontal;

  double? marginVertical;

  double padding = 0;

  double? _paddingStart;

  double get paddingStart => _paddingStart ?? paddingHorizontal ?? padding;

  double? _paddingEnd;

  double get paddingEnd => _paddingEnd ?? paddingHorizontal ?? padding;

  double? _paddingTop;

  double get paddingTop => _paddingTop ?? paddingVertical ?? padding;

  double? _paddingBottom;

  double get paddingBottom => _paddingBottom ?? paddingVertical ?? padding;

  double? paddingHorizontal;

  double? paddingVertical;

  ViewPosition? _position;

  ViewPosition get position => _position ?? positionType.position;

  ViewPositionType positionType = ViewPositionType.none;

  Matrix4? transform;

  Alignment? transformGravity;

  double shadow = 0;

  Color? shadowColor;

  double shadowBlurRadius = 5;

  BlurStyle shadowBlurStyle = BlurStyle.normal;

  double shadowSpreadRadius = 0;

  ViewShadowType shadowType = ViewShadowType.none;

  double? shadowHorizontal;

  double? shadowVertical;

  double? _shadowStart;

  double get shadowStart => _shadowStart ?? shadowHorizontal ?? shadow;

  double? _shadowEnd;

  double get shadowEnd => _shadowEnd ?? shadowHorizontal ?? shadow;

  double? _shadowTop;

  double get shadowTop => _shadowTop ?? shadowVertical ?? shadow;

  double? _shadowBottom;

  double get shadowBottom => _shadowBottom ?? shadowVertical ?? shadow;

  ViewProperties root = const ViewProperties();

  ViewShape shape = ViewShape.rectangular;

  ViewVisibility visibility = ViewVisibility.visible;

  OnViewClickListener? _onClick;

  OnViewClickListener? get onClick => enabled ? _onClick : null;

  set onClick(OnViewClickListener? listener) => _onClick ??= listener;

  OnViewClickListener? _onDoubleClick;

  OnViewClickListener? get onDoubleClick => enabled ? _onDoubleClick : null;

  set onDoubleClick(OnViewClickListener? listener) =>
      _onDoubleClick ??= listener;

  OnViewClickListener? _onLongClick;

  OnViewClickListener? get onLongClick => enabled ? _onLongClick : null;

  set onLongClick(OnViewClickListener? listener) => _onLongClick ??= listener;

  OnViewToggle? _onToggleClick;

  OnViewToggle? get onToggleClick => enabled ? _onToggleClick : null;

  set onToggleClick(OnViewToggle? listener) => _onToggleClick ??= listener;

  OnViewNotifyListener? onClickHandle, onDoubleClickHandle, onLongClickHandle;

  OnViewNotifier? _onNotifier;

  bool get isObservable {
    return root.observer &&
        (isClickable || isDoubleClickable || isLongClickable);
  }

  bool get isClickable => onClick != null || onClickHandle != null;

  bool get isDoubleClickable =>
      onDoubleClick != null || onDoubleClickHandle != null;

  bool get isLongClickable => onLongClick != null || onLongClickHandle != null;

  bool get isRippled =>
      root.ripple &&
      (isObservable ||
          rippleColor != Colors.transparent ||
          pressedColor != null ||
          hoverColor != null);

  bool get isToggleClickable => onToggleClick != null;

  bool get isPositional {
    return root.position &&
        (_position != null || positionType != ViewPositionType.none);
  }

  bool get isExpendable {
    return root.flex && flex > 0;
  }

  bool get isBorder {
    final x = borderStart + borderEnd + borderTop + borderBottom;
    return root.border && x > 0;
  }

  bool get isBorderRadius {
    final x =
        borderRadiusBLF + borderRadiusBRF + borderRadiusTLF + borderRadiusTRF;
    return root.radius && x > 0;
  }

  bool get isMargin {
    final x = marginStart + marginEnd + marginTop + marginBottom;
    return root.margin && x > 0;
  }

  bool get isPadding {
    final x = paddingStart + paddingEnd + paddingTop + paddingBottom;
    return root.padding && x > 0;
  }

  bool get isConstraints =>
      root.constraints &&
      (_widthMax != null ||
          _widthMin != null ||
          _heightMax != null ||
          _heightMin != null);

  bool get isShadow {
    final x = shadowStart + shadowEnd + shadowTop + shadowBottom;
    return root.shadow && (x > 0 || shadowType == ViewShadowType.overlay);
  }

  bool get isOverlayShadow =>
      root.shadow && shadowType == ViewShadowType.overlay;

  bool get isCircular =>
      !isRippled && root.shape && shape == ViewShape.circular;

  bool get isRadius {
    var a = root.radius;
    var b = !isCircular;
    var c = isBorderRadius;
    return a && b && c;
  }

  bool get isSquire {
    return shape == ViewShape.squire;
  }

  double get squireSize {
    return max(_width ?? 0, _height ?? 0);
  }

  OnViewNotifier? get notifier {
    return _onNotifier;
  }

  void get notify {
    if (_onNotifier != null) {
      _onNotifier?.call(() {});
    }
  }

  ViewController({
    this.hoverColor,
    this.pressedColor,
    this.rippleColor = Colors.transparent,
    Color? background,
    this.backgroundState,
    this.backgroundBlendMode,
    Gradient? backgroundGradient,
    this.backgroundGradientState,
    DecorationImage? backgroundImage,
    this.backgroundImageState,
    this.root = const ViewProperties(),
    this.absorbMode = false,
    this.activated = false,
    this.enabled = true,
    this.visibility = ViewVisibility.visible,
    this.flex = 0,
    double? dimensionRatio,
    this.elevation = 0,
    double? width,
    double? widthMax,
    double? widthMin,
    double? height,
    double? heightMax,
    double? heightMin,
    this.animation = 0,
    this.animationType = Curves.linear,
    this.margin = 0,
    this.marginHorizontal,
    this.marginVertical,
    double? marginTop,
    double? marginBottom,
    double? marginStart,
    double? marginEnd,
    this.padding = 0,
    this.paddingHorizontal,
    this.paddingVertical,
    double? paddingTop,
    double? paddingBottom,
    double? paddingStart,
    double? paddingEnd,
    this.border = 0,
    this.borderHorizontal,
    this.borderVertical,
    double? borderTop,
    double? borderBottom,
    double? borderStart,
    double? borderEnd,
    this.borderRadius = 0,
    double? borderRadiusBL,
    double? borderRadiusBR,
    double? borderRadiusTL,
    double? borderRadiusTR,
    this.shadow = 0,
    this.shadowBlurRadius = 0,
    this.shadowSpreadRadius = 0,
    this.shadowHorizontal,
    this.shadowVertical,
    double? shadowStart,
    double? shadowEnd,
    double? shadowTop,
    double? shadowBottom,
    this.foreground,
    this.borderColor,
    this.shadowColor,
    this.gravity,
    this.transformGravity,
    this.foregroundBlendMode,
    this.foregroundImage,
    this.foregroundGradient,
    this.borderGradient,
    this.transform,
    this.shadowBlurStyle = BlurStyle.normal,
    this.clipBehavior = Clip.antiAlias,
    this.shadowType = ViewShadowType.none,
    ViewPosition? position,
    this.positionType = ViewPositionType.none,
    this.shape = ViewShape.rectangular,
    this.child,
    this.onClickHandle,
    this.onDoubleClickHandle,
    this.onLongClickHandle,
    OnViewClickListener? onClick,
    OnViewClickListener? onDoubleClick,
    OnViewClickListener? onLongClick,
    OnViewToggle? onViewNotify,
  })  : _background = background,
        _backgroundGradient = backgroundGradient,
        _backgroundImage = backgroundImage,
        _marginStart = marginStart,
        _marginEnd = marginEnd,
        _marginTop = marginTop,
        _marginBottom = marginBottom,
        _paddingStart = paddingStart,
        _paddingEnd = paddingEnd,
        _paddingTop = paddingTop,
        _paddingBottom = paddingBottom,
        _position = position,
        _shadowBottom = shadowBottom,
        _shadowTop = shadowTop,
        _shadowEnd = shadowEnd,
        _shadowStart = shadowStart,
        _heightMin = heightMin,
        _heightMax = heightMax,
        _widthMin = widthMin,
        _widthMax = widthMax,
        _width = width,
        _height = height,
        _borderRadiusTR = borderRadiusTR,
        _borderRadiusTL = borderRadiusTL,
        _borderRadiusBR = borderRadiusBR,
        _borderRadiusBL = borderRadiusBL,
        _borderEnd = borderEnd,
        _borderStart = borderStart,
        _borderBottom = borderBottom,
        _borderTop = borderTop,
        _dimensionRatio = dimensionRatio,
        _onClick = onClick,
        _onDoubleClick = onDoubleClick,
        _onLongClick = onLongClick;

  ViewController properties({
    required bool? absorbMode,
    required bool? activated,
    required bool? enabled,
    required int? animation,
    required Curve? animationType,
    required int? flex,
    required double? dimensionRatio,
    required double? elevation,
    required double? width,
    required double? widthMax,
    required double? widthMin,
    required double? height,
    required double? heightMax,
    required double? heightMin,
    required double? margin,
    required double? marginHorizontal,
    required double? marginVertical,
    required double? marginTop,
    required double? marginBottom,
    required double? marginStart,
    required double? marginEnd,
    required double? padding,
    required double? paddingHorizontal,
    required double? paddingVertical,
    required double? paddingTop,
    required double? paddingBottom,
    required double? paddingStart,
    required double? paddingEnd,
    required double? border,
    required double? borderHorizontal,
    required double? borderVertical,
    required double? borderTop,
    required double? borderBottom,
    required double? borderStart,
    required double? borderEnd,
    required double? borderRadius,
    required double? borderRadiusBL,
    required double? borderRadiusBR,
    required double? borderRadiusTL,
    required double? borderRadiusTR,
    required double? shadow,
    required double? shadowBlurRadius,
    required double? shadowSpreadRadius,
    required double? shadowHorizontal,
    required double? shadowVertical,
    required double? shadowStart,
    required double? shadowEnd,
    required double? shadowTop,
    required double? shadowBottom,
    required Color? background,
    required Color? borderColor,
    required Color? foreground,
    required Color? hoverColor,
    required Color? pressedColor,
    required Color? rippleColor,
    required Color? shadowColor,
    required Alignment? gravity,
    required Alignment? transformGravity,
    required BlendMode? backgroundBlendMode,
    required BlendMode? foregroundBlendMode,
    required DecorationImage? backgroundImage,
    required DecorationImage? foregroundImage,
    required Gradient? backgroundGradient,
    required Gradient? foregroundGradient,
    required Gradient? borderGradient,
    required Matrix4? transform,
    required BlurStyle? shadowBlurStyle,
    required Clip? clipBehavior,
    required ViewShadowType? shadowType,
    required ViewPosition? position,
    required ViewPositionType? positionType,
    required ViewProperties? root,
    required ViewShape? shape,
    required ViewVisibility? visibility,
    required Widget? child,
    required ValueState<Color>? backgroundState,
    required ValueState<Gradient>? backgroundGradientState,
    required ValueState<DecorationImage>? backgroundImageState,
    required OnViewClickListener? onClick,
    required OnViewClickListener? onDoubleClick,
    required OnViewClickListener? onLongClick,
    required OnViewNotifyListener? onClickHandle,
    required OnViewNotifyListener? onDoubleClickHandle,
    required OnViewNotifyListener? onLongClickHandle,
    required OnViewToggle? onToggleClick,
  }) {
    // Ripple properties
    this.hoverColor = hoverColor;
    this.pressedColor = pressedColor;
    this.rippleColor = rippleColor ?? Colors.transparent;

    // VIEW CONDITIONAL PROPERTIES
    this.absorbMode = absorbMode ?? false;
    this.activated = activated ?? false;
    this.enabled = enabled ?? true;

    // ANIMATION PROPERTIES
    this.animation = animation ?? 0;
    this.animationType = animationType ?? Curves.linear;

    // VIEW SIZE PROPERTIES
    this.flex = flex ?? 0;
    _dimensionRatio = dimensionRatio;
    this.elevation = elevation ?? 0;
    _width = width;
    _widthMax = widthMax;
    _widthMin = widthMin;
    _height = height;
    _heightMax = heightMax;
    _heightMin = heightMin;

    // VIEW MARGIN PROPERTIES
    this.margin = margin ?? 0;
    this.marginVertical = marginVertical;
    _marginStart = marginStart;
    _marginEnd = marginEnd;
    _marginTop = marginTop;
    _marginBottom = marginBottom;
    this.marginHorizontal = marginHorizontal;

    // VIEW PADDING PROPERTIES
    this.padding = padding ?? 0;
    _paddingStart = paddingStart;
    _paddingEnd = paddingEnd;
    _paddingTop = paddingTop;
    _paddingBottom = paddingBottom;
    this.paddingHorizontal = paddingHorizontal;
    this.paddingVertical = paddingVertical;

    // VIEW BORDER PROPERTIES
    this.borderColor = borderColor;
    this.borderGradient = borderGradient;
    this.border = border ?? 0;
    _borderStart = borderStart;
    _borderEnd = borderEnd;
    _borderTop = borderTop;
    _borderBottom = borderBottom;
    this.borderHorizontal = borderHorizontal;
    this.borderVertical = borderVertical;

    // VIEW BORDER RADIUS PROPERTIES
    this.borderRadius = borderRadius ?? 0;
    _borderRadiusBL = borderRadiusBL;
    _borderRadiusBR = borderRadiusBR;
    _borderRadiusTL = borderRadiusTL;
    _borderRadiusTL = borderRadiusTL;

    // VIEW SHADOW PROPERTIES
    this.shadowColor = shadowColor;
    this.shadow = shadow ?? 0;
    _shadowStart = shadowStart;
    _shadowEnd = shadowEnd;
    _shadowTop = shadowTop;
    _shadowBottom = shadowBottom;
    this.shadowHorizontal = shadowHorizontal;
    this.shadowVertical = shadowVertical;
    this.shadowBlurRadius = shadowBlurRadius ?? 5;
    this.shadowBlurStyle = shadowBlurStyle ?? BlurStyle.normal;
    this.shadowSpreadRadius = shadowSpreadRadius ?? 0;
    this.shadowType = shadowType ?? ViewShadowType.none;

    // VIEW DECORATION PROPERTIES
    _background = background;
    this.foreground = foreground;
    this.backgroundBlendMode = backgroundBlendMode;
    this.foregroundBlendMode = foregroundBlendMode;
    _backgroundGradient = backgroundGradient;
    this.foregroundGradient = foregroundGradient;
    _backgroundImage = backgroundImage;
    this.foregroundImage = foregroundImage;
    this.clipBehavior = clipBehavior ?? Clip.antiAlias;
    this.gravity = gravity;
    this.transform = transform;
    this.transformGravity = transformGravity;
    this.transform = transform;
    _position = position;
    this.positionType = positionType ?? ViewPositionType.none;
    this.shape = shape ?? ViewShape.rectangular;
    this.root = root ?? const ViewProperties();
    this.visibility = visibility ?? ViewVisibility.visible;
    this.child = child;

    // Value States
    this.backgroundState = backgroundState;
    this.backgroundImageState = backgroundImageState;
    this.backgroundGradientState = backgroundGradientState;

    // VIEW LISTENER PROPERTIES
    this.onClick = onClick;
    this.onDoubleClick = onDoubleClick;
    this.onLongClick = onLongClick;
    this.onClickHandle = onClickHandle;
    this.onDoubleClickHandle = onDoubleClickHandle;
    this.onLongClickHandle = onLongClickHandle;
    this.onToggleClick = onToggleClick;

    return this;
  }

  ViewController init({
    bool? absorbMode,
    bool? activated,
    bool? enabled,
    int? animation,
    Curve? animationType,
    int? flex,
    double? dimensionRatio,
    double? elevation,
    double? width,
    double? widthMax,
    double? widthMin,
    double? height,
    double? heightMax,
    double? heightMin,
    double? margin,
    double? marginHorizontal,
    double? marginVertical,
    double? marginTop,
    double? marginBottom,
    double? marginStart,
    double? marginEnd,
    double? padding,
    double? paddingHorizontal,
    double? paddingVertical,
    double? paddingTop,
    double? paddingBottom,
    double? paddingStart,
    double? paddingEnd,
    double? border,
    double? borderHorizontal,
    double? borderVertical,
    double? borderTop,
    double? borderBottom,
    double? borderStart,
    double? borderEnd,
    double? borderRadius,
    double? borderRadiusBL,
    double? borderRadiusBR,
    double? borderRadiusTL,
    double? borderRadiusTR,
    double? shadow,
    double? shadowBlurRadius,
    double? shadowSpreadRadius,
    double? shadowHorizontal,
    double? shadowVertical,
    double? shadowStart,
    double? shadowEnd,
    double? shadowTop,
    double? shadowBottom,
    Color? background,
    Color? borderColor,
    Color? foreground,
    Color? hoverColor,
    Color? pressedColor,
    Color? rippleColor,
    Color? shadowColor,
    Alignment? gravity,
    Alignment? transformGravity,
    BlendMode? backgroundBlendMode,
    BlendMode? foregroundBlendMode,
    DecorationImage? backgroundImage,
    DecorationImage? foregroundImage,
    Gradient? backgroundGradient,
    Gradient? foregroundGradient,
    Gradient? borderGradient,
    Matrix4? transform,
    BlurStyle? shadowBlurStyle,
    Clip? clipBehavior,
    ViewShadowType? shadowType,
    ViewPosition? position,
    ViewPositionType? positionType,
    ViewShape? shape,
    ViewVisibility? visibility,
    ViewProperties? root,
    Widget? child,
    ValueState<Color>? backgroundState,
    ValueState<Gradient>? backgroundGradientState,
    ValueState<DecorationImage>? backgroundImageState,
    OnViewClickListener? onClick,
    OnViewClickListener? onDoubleClick,
    OnViewClickListener? onLongClick,
    OnViewNotifyListener? onClickNotify,
    OnViewNotifyListener? onDoubleClickNotify,
    OnViewNotifyListener? onLongClickNotify,
    OnViewToggle? onToggleClick,
  }) {
    return properties(
      absorbMode: absorbMode,
      activated: activated,
      enabled: enabled,
      animation: animation,
      animationType: animationType,
      flex: flex,
      dimensionRatio: dimensionRatio,
      elevation: elevation,
      width: width,
      widthMax: widthMax,
      widthMin: widthMin,
      height: height,
      heightMax: heightMax,
      heightMin: heightMin,
      margin: margin,
      marginHorizontal: marginHorizontal,
      marginVertical: marginVertical,
      marginTop: marginTop,
      marginBottom: marginBottom,
      marginStart: marginStart,
      marginEnd: marginEnd,
      padding: padding,
      paddingHorizontal: paddingHorizontal,
      paddingVertical: paddingVertical,
      paddingTop: paddingTop,
      paddingBottom: paddingBottom,
      paddingStart: paddingStart,
      paddingEnd: paddingEnd,
      border: border,
      borderHorizontal: borderHorizontal,
      borderVertical: borderVertical,
      borderTop: borderTop,
      borderBottom: borderBottom,
      borderStart: borderStart,
      borderEnd: borderEnd,
      borderRadius: borderRadius,
      borderRadiusBL: borderRadiusBL,
      borderRadiusBR: borderRadiusBR,
      borderRadiusTL: borderRadiusTL,
      borderRadiusTR: borderRadiusTR,
      shadow: shadow,
      shadowBlurRadius: shadowBlurRadius,
      shadowSpreadRadius: shadowSpreadRadius,
      shadowHorizontal: shadowHorizontal,
      shadowVertical: shadowVertical,
      shadowStart: shadowStart,
      shadowEnd: shadowEnd,
      shadowTop: shadowTop,
      shadowBottom: shadowBottom,
      background: background,
      backgroundState: backgroundState,
      borderColor: borderColor,
      foreground: foreground,
      hoverColor: hoverColor,
      pressedColor: pressedColor,
      rippleColor: rippleColor,
      shadowColor: shadowColor,
      gravity: gravity,
      transformGravity: transformGravity,
      backgroundBlendMode: backgroundBlendMode,
      foregroundBlendMode: foregroundBlendMode,
      backgroundImage: backgroundImage,
      backgroundImageState: backgroundImageState,
      foregroundImage: foregroundImage,
      backgroundGradient: backgroundGradient,
      backgroundGradientState: backgroundGradientState,
      foregroundGradient: foregroundGradient,
      borderGradient: borderGradient,
      transform: transform,
      shadowBlurStyle: shadowBlurStyle,
      clipBehavior: clipBehavior,
      shadowType: shadowType,
      position: position,
      positionType: positionType,
      shape: shape,
      visibility: visibility,
      root: root,
      child: child,
      onClick: onClick,
      onDoubleClick: onDoubleClick,
      onLongClick: onLongClick,
      onClickHandle: onClickNotify,
      onDoubleClickHandle: onDoubleClickNotify,
      onLongClickHandle: onLongClickNotify,
      onToggleClick: onToggleClick,
    );
  }

  @mustCallSuper
  ViewController attach(YMRView view) => properties(
        absorbMode: view.absorbMode,
        activated: view.activated,
        enabled: view.enabled,
        animation: view.animation,
        animationType: view.animationType,
        flex: view.flex,
        dimensionRatio: view.dimensionRatio,
        elevation: view.elevation,
        width: view.width,
        widthMax: view.widthMax,
        widthMin: view.widthMin,
        height: view.height,
        heightMax: view.heightMax,
        heightMin: view.heightMin,
        margin: view.margin,
        marginHorizontal: view.marginHorizontal,
        marginVertical: view.marginVertical,
        marginTop: view.marginTop,
        marginBottom: view.marginBottom,
        marginStart: view.marginStart,
        marginEnd: view.marginEnd,
        padding: view.padding,
        paddingHorizontal: view.paddingHorizontal,
        paddingVertical: view.paddingVertical,
        paddingTop: view.paddingTop,
        paddingBottom: view.paddingBottom,
        paddingStart: view.paddingStart,
        paddingEnd: view.paddingEnd,
        border: view.borderSize,
        borderHorizontal: view.borderHorizontal,
        borderVertical: view.borderVertical,
        borderTop: view.borderTop,
        borderBottom: view.borderBottom,
        borderStart: view.borderStart,
        borderEnd: view.borderEnd,
        borderRadius: view.borderRadius,
        borderRadiusBL: view.borderRadiusBL,
        borderRadiusBR: view.borderRadiusBR,
        borderRadiusTL: view.borderRadiusTL,
        borderRadiusTR: view.borderRadiusTR,
        shadow: view.shadow,
        shadowBlurRadius: view.shadowBlurRadius,
        shadowSpreadRadius: view.shadowSpreadRadius,
        shadowHorizontal: view.shadowHorizontal,
        shadowVertical: view.shadowVertical,
        shadowStart: view.shadowStart,
        shadowEnd: view.shadowEnd,
        shadowTop: view.shadowTop,
        shadowBottom: view.shadowBottom,
        background: view.background,
        backgroundState: view.backgroundState,
        borderColor: view.borderColor,
        foreground: view.foreground,
        hoverColor: view.hoverColor,
        pressedColor: view.pressedColor,
        rippleColor: view.rippleColor,
        shadowColor: view.shadowColor,
        gravity: view.gravity,
        transformGravity: view.transformGravity,
        backgroundBlendMode: view.backgroundBlendMode,
        foregroundBlendMode: view.foregroundBlendMode,
        backgroundImage: view.backgroundImage,
        backgroundImageState: view.backgroundImageState,
        foregroundImage: view.foregroundImage,
        backgroundGradient: view.backgroundGradient,
        backgroundGradientState: view.backgroundGradientState,
        foregroundGradient: view.foregroundGradient,
        borderGradient: view.borderGradient,
        transform: view.transform,
        shadowBlurStyle: view.shadowBlurStyle,
        clipBehavior: view.clipBehavior,
        shadowType: view.shadowType,
        position: view.position,
        positionType: view.positionType,
        shape: view.shape,
        visibility: view.visibility,
        root: view.properties,
        child: view.child,
        onClick: view.onClick,
        onDoubleClick: view.onDoubleClick,
        onLongClick: view.onLongClick,
        onClickHandle: view.onClickHandle,
        onDoubleClickHandle: view.onDoubleClickHandle,
        onLongClickHandle: view.onLongClickHandle,
        onToggleClick: view.onToggleClick,
      );

  void setAbsorbMode(bool value) {
    absorbMode = value;
    notify;
  }

  void setActivated(bool value) {
    activated = value;
    notify;
  }

  void setAlignment(Alignment? value) {
    gravity = value;
    notify;
  }

  void setAnimation(int value) {
    animation = value;
    notify;
  }

  void setAnimationType(Curve value) {
    animationType = value;
    notify;
  }

  void setBackground(Color? value) {
    _background = value;
    notify;
  }

  void setBackgroundState(ValueState<Color>? value) {
    backgroundState = value;
    notify;
  }

  void setBackgroundGradient(Gradient? value) {
    _backgroundGradient = value;
    notify;
  }

  void setBackgroundGradientState(ValueState<Gradient>? value) {
    backgroundGradientState = value;
    notify;
  }

  void setBackgroundBlendMode(BlendMode? value) {
    backgroundBlendMode = value;
    notify;
  }

  void setBackgroundImage(DecorationImage? value) {
    _backgroundImage = value;
    notify;
  }

  void setBackgroundImageState(ValueState<DecorationImage>? value) {
    backgroundImageState = value;
    notify;
  }

  void setClipBehavior(Clip value) {
    clipBehavior = value;
    notify;
  }

  void setDimensionRatio(double? value) {
    _dimensionRatio = value;
    notify;
  }

  void setElevation(double value) {
    elevation = value;
    notify;
  }

  void setForeground(Color? value) {
    foreground = value;
    notify;
  }

  void setForegroundGradient(Gradient? value) {
    foregroundGradient = value;
    notify;
  }

  void setForegroundBlendMode(BlendMode? value) {
    foregroundBlendMode = value;
    notify;
  }

  void setForegroundImage(DecorationImage? value) {
    foregroundImage = value;
    notify;
  }

  void setBorderColor(Color? value) {
    borderColor = value;
    notify;
  }

  void setBorderGradient(Gradient? value) {
    borderGradient = value;
    notify;
  }

  void setBorder(double value) {
    border = value;
    notify;
  }

  void setBorderHorizontal(double? value) {
    borderHorizontal = value;
    notify;
  }

  void setBorderVertical(double? value) {
    borderVertical = value;
    notify;
  }

  void setBorderTop(double? value) {
    _borderTop = value;
    notify;
  }

  void setBorderBottom(double? value) {
    _borderBottom = value;
    notify;
  }

  void setBorderStart(double? value) {
    _borderStart = value;
    notify;
  }

  void setBorderEnd(double? value) {
    _borderEnd = value;
    notify;
  }

  void setBorderRadius(double value) {
    borderRadius = value;
    notify;
  }

  void setBorderRadiusBL(double? value) {
    _borderRadiusBL = value;
    notify;
  }

  void setBorderRadiusBR(double? value) {
    _borderRadiusBR = value;
    notify;
  }

  void setBorderRadiusTL(double? value) {
    _borderRadiusTL = value;
    notify;
  }

  void setBorderRadiusTR(double? value) {
    _borderRadiusTR = value;
    notify;
  }

  void setChild(Widget? value) {
    child = value;
    notify;
  }

  void setEnabled(bool value) {
    enabled = value;
    notify;
  }

  void setFlex(int value) {
    flex = value;
    notify;
  }

  void setWidth(double? value) {
    _width = value;
    notify;
  }

  void setMaxWidth(double? value) {
    _widthMax = value;
    notify;
  }

  void setMinWidth(double? value) {
    _widthMin = value;
    notify;
  }

  void setHeight(double? value) {
    _height = value;
    notify;
  }

  void setMaxHeight(double? value) {
    _heightMax = value;
    notify;
  }

  void setMinHeight(double? value) {
    _heightMin = value;
    notify;
  }

  void setMargin(double value) {
    margin = value;
    notify;
  }

  void setMarginStart(double? value) {
    _marginStart = value;
    notify;
  }

  void setMarginEnd(double? value) {
    _marginEnd = value;
    notify;
  }

  void setMarginTop(double? value) {
    _marginTop = value;
    notify;
  }

  void setMarginBottom(double? value) {
    _marginBottom = value;
    notify;
  }

  void setMarginHorizontal(double? value) {
    marginHorizontal = value;
    notify;
  }

  void setMarginVertical(double? value) {
    marginVertical = value;
    notify;
  }

  void setPadding(double value) {
    padding = value;
    notify;
  }

  void setPaddingStart(double? value) {
    _paddingStart = value;
    notify;
  }

  void setPaddingEnd(double? value) {
    _paddingEnd = value;
    notify;
  }

  void setPaddingTop(double? value) {
    _paddingTop = value;
    notify;
  }

  void setPaddingBottom(double? value) {
    _paddingBottom = value;
    notify;
  }

  void setPaddingHorizontal(double? value) {
    paddingHorizontal = value;
    notify;
  }

  void setPaddingVertical(double? value) {
    paddingVertical = value;
    notify;
  }

  void setPosition(ViewPosition? value) {
    _position = value;
    notify;
  }

  void setPositionType(ViewPositionType value) {
    positionType = value;
    notify;
  }

  void setTransform(Matrix4 value) {
    transform = value;
    notify;
  }

  void setTransformAlignment(Alignment value) {
    transformGravity = value;
    notify;
  }

  void setShadow(double value) {
    shadow = value;
    notify;
  }

  void setShadowColor(Color value) {
    shadowColor = value;
    notify;
  }

  void setShadowBlurRadius(double value) {
    shadowBlurRadius = value;
    notify;
  }

  void setShadowBlurStyle(BlurStyle value) {
    shadowBlurStyle = value;
    notify;
  }

  void setShadowSpreadRadius(double value) {
    shadowSpreadRadius = value;
    notify;
  }

  void setShadowType(ViewShadowType value) {
    shadowType = value;
    notify;
  }

  void setShadowHorizontal(double? value) {
    shadowHorizontal = value;
    notify;
  }

  void setShadowVertical(double? value) {
    shadowVertical = value;
    notify;
  }

  void setShadowStart(double? value) {
    _shadowStart = value;
    notify;
  }

  void setShadowEnd(double? value) {
    _shadowEnd = value;
    notify;
  }

  void setShadowTop(double? value) {
    _shadowTop = value;
    notify;
  }

  void setShadowBottom(double? value) {
    _shadowBottom = value;
    notify;
  }

  void setViewShape(ViewShape value) {
    shape = value;
    notify;
  }

  void setVisibility(ViewVisibility value) {
    visibility = value;
    notify;
  }

  void setOnClickListener(OnViewClickListener listener) {
    _onClick = listener;
  }

  void setOnDoubleClickListener(OnViewClickListener listener) {
    _onDoubleClick = listener;
  }

  void setOnLongClickListener(OnViewClickListener listener) {
    _onLongClick = listener;
  }

  void setOnToggleClickListener(OnViewToggle listener) {
    _onToggleClick = listener;
  }

  void setNotifier(OnViewNotifier? notifier) {
    _onNotifier = notifier;
  }

  void onToggleNotify() {
    activated = !activated;
    onToggleClick?.call(activated);
    notify;
  }

  void onNotify() => notify;
}

enum ViewPositionType {
  bottomEnd(ViewPosition(bottom: 0, right: 0)),
  bottomStart(ViewPosition(bottom: 0, left: 0)),
  center,
  centerBottom(ViewPosition(bottom: 0)),
  centerEnd(ViewPosition(right: 0)),
  centerStart(ViewPosition(left: 0)),
  centerTop(ViewPosition(top: 0)),
  flexStart(ViewPosition(left: 0, top: 0, bottom: 0)),
  flexEnd(ViewPosition(right: 0, top: 0, bottom: 0)),
  flexTop(ViewPosition(top: 0, left: 0, right: 0)),
  flexBottom(ViewPosition(bottom: 0, left: 0, right: 0)),
  flexHorizontal(ViewPosition(left: 0, right: 0)),
  flexVertical(ViewPosition(top: 0, bottom: 0)),
  topEnd(ViewPosition(top: 0, right: 0)),
  topStart(ViewPosition(top: 0, left: 0)),
  none;

  final ViewPosition position;

  const ViewPositionType([
    this.position = const ViewPosition(),
  ]);
}

enum ViewShadowType {
  overlay,
  none,
}

enum ViewShape {
  circular,
  rectangular,
  squire,
}

class ValueState<T> {
  final T _primary;
  final T _activated;
  final T _disabled;
  final T _focused;
  final T _selected;

  const ValueState._({
    required T primary,
    T? activated,
    T? disabled,
    T? focused,
    T? selected,
  })  : _primary = primary,
        _activated = activated ?? primary,
        _disabled = disabled ?? primary,
        _focused = focused ?? primary,
        _selected = selected ?? primary;

  factory ValueState.active({
    required T activated,
    required T inactivated,
    T? disabled,
  }) {
    return ValueState._(
      primary: inactivated,
      activated: activated,
      disabled: disabled,
    );
  }

  factory ValueState.focus({
    required T focused,
    required T unfocused,
    T? disabled,
  }) {
    return ValueState._(
      primary: unfocused,
      focused: focused,
      disabled: disabled,
    );
  }

  factory ValueState.select({
    required T selected,
    required T unselected,
    T? disabled,
  }) {
    return ValueState._(
      primary: unselected,
      selected: selected,
      disabled: disabled,
    );
  }

  T activated(bool activated, [bool enabled = true]) {
    if (enabled) {
      return activated ? _activated : _primary;
    } else {
      return _disabled;
    }
  }

  T focused(bool focused, [bool enabled = true]) {
    if (enabled) {
      return focused ? _focused : _primary;
    } else {
      return _disabled;
    }
  }

  T selected(bool selected, [bool enabled = true]) {
    if (enabled) {
      return selected ? _selected : _primary;
    } else {
      return _disabled;
    }
  }
}

enum StateType {
  none,
  error,
  selected,
  unselected,
  focused,
  unfocused,
  enabled,
  disabled,
}

enum ViewVisibility {
  gone,
  visible,
  invisible;
}

extension VisibilityExtension on ViewVisibility {
  bool get isGone => this == ViewVisibility.gone;

  bool get isVisible => this == ViewVisibility.visible;

  bool get isInvisible => this == ViewVisibility.invisible;

  bool get isVisibleOrInvisible => isVisible || isInvisible;
}

class ViewPosition {
  final double? top, bottom, left, right;

  const ViewPosition({
    this.top,
    this.bottom,
    this.left,
    this.right,
  });
}

class ViewProperties {
  final bool ripple;
  final bool position, flex, ratio, observer;
  final bool view, constraints, margin, padding;
  final bool decoration, shadow, shape, radius, border, background;

  const ViewProperties({
    this.ripple = true,
    this.position = true,
    this.flex = true,
    this.ratio = true,
    this.observer = true,
    this.view = true,
    this.constraints = true,
    this.margin = true,
    this.padding = true,
    this.decoration = true,
    this.shadow = true,
    this.shape = true,
    this.radius = true,
    this.border = true,
    this.background = true,
  });

  ViewProperties modify({
    bool? ripple,
    bool? position,
    bool? flex,
    bool? ratio,
    bool? observer,
    bool? view,
    bool? constraints,
    bool? margin,
    bool? padding,
    bool? decoration,
    bool? shadow,
    bool? shape,
    bool? radius,
    bool? border,
    bool? background,
  }) {
    return ViewProperties(
      ripple: ripple ?? this.ripple,
      position: position ?? this.position,
      flex: flex ?? this.flex,
      ratio: ratio ?? this.ratio,
      observer: observer ?? this.observer,
      view: view ?? this.view,
      constraints: constraints ?? this.constraints,
      margin: margin ?? this.margin,
      padding: padding ?? this.padding,
      decoration: decoration ?? this.decoration,
      shadow: shadow ?? this.shadow,
      shape: shape ?? this.shape,
      radius: radius ?? this.radius,
      border: border ?? this.border,
      background: background ?? this.background,
    );
  }
}

class YMRView<T extends ViewController> extends StatefulWidget {
  final T? controller;

  final int? flex;
  final bool? absorbMode, activated, enabled;

  final int? animation;
  final Curve? animationType;

  final double? elevation;
  final double? dimensionRatio;
  final double? width, widthMax, widthMin;
  final double? height, heightMax, heightMin;

  final double? margin;
  final double? marginHorizontal, marginVertical;
  final double? marginTop, marginBottom, marginStart, marginEnd;

  final double? padding;
  final double? paddingHorizontal, paddingVertical;
  final double? paddingTop, paddingBottom, paddingStart, paddingEnd;

  final double? borderSize;
  final double? borderHorizontal, borderVertical;
  final double? borderTop, borderBottom, borderStart, borderEnd;

  final double? borderRadius;
  final double? borderRadiusBL, borderRadiusBR, borderRadiusTL, borderRadiusTR;

  final double? shadow;
  final double? shadowBlurRadius, shadowSpreadRadius;
  final double? shadowHorizontal, shadowVertical;
  final double? shadowStart, shadowEnd, shadowTop, shadowBottom;

  final Color? background, borderColor, foreground, shadowColor;
  final Color? hoverColor, pressedColor, rippleColor;

  final DecorationImage? backgroundImage, foregroundImage;
  final Gradient? backgroundGradient, foregroundGradient, borderGradient;
  final Matrix4? transform;

  final Alignment? gravity, transformGravity;
  final BlendMode? backgroundBlendMode, foregroundBlendMode;
  final BlurStyle? shadowBlurStyle;
  final Clip? clipBehavior;

  final ValueState<Color>? backgroundState;
  final ValueState<Gradient>? backgroundGradientState;
  final ValueState<DecorationImage>? backgroundImageState;

  final ViewShadowType? shadowType;
  final ViewPosition? position;
  final ViewPositionType? positionType;
  final ViewShape? shape;
  final ViewVisibility? visibility;

  final Widget? child;

  final OnViewClickListener? onClick, onDoubleClick, onLongClick;
  final OnViewNotifyListener<T>? onClickHandle;
  final OnViewNotifyListener<T>? onDoubleClickHandle;
  final OnViewNotifyListener<T>? onLongClickHandle;
  final OnViewToggle? onToggleClick;

  const YMRView({
    Key? key,
    this.controller,
    this.flex,
    this.absorbMode,
    this.activated,
    this.enabled,
    this.visibility,
    this.animation,
    this.animationType,
    this.elevation,
    this.dimensionRatio,
    this.width,
    this.widthMax,
    this.widthMin,
    this.height,
    this.heightMax,
    this.heightMin,
    this.margin,
    this.marginHorizontal,
    this.marginVertical,
    this.marginTop,
    this.marginBottom,
    this.marginStart,
    this.marginEnd,
    this.padding,
    this.paddingHorizontal,
    this.paddingVertical,
    this.paddingTop,
    this.paddingBottom,
    this.paddingStart,
    this.paddingEnd,
    this.borderSize,
    this.borderHorizontal,
    this.borderVertical,
    this.borderTop,
    this.borderBottom,
    this.borderStart,
    this.borderEnd,
    this.borderRadius,
    this.borderRadiusBL,
    this.borderRadiusBR,
    this.borderRadiusTL,
    this.borderRadiusTR,
    this.shadow,
    this.shadowBlurRadius,
    this.shadowSpreadRadius,
    this.shadowHorizontal,
    this.shadowVertical,
    this.shadowStart,
    this.shadowEnd,
    this.shadowTop,
    this.shadowBottom,
    this.background,
    this.borderColor,
    this.foreground,
    this.hoverColor,
    this.pressedColor,
    this.shadowColor,
    this.rippleColor,
    this.gravity,
    this.transformGravity,
    this.backgroundBlendMode,
    this.foregroundBlendMode,
    this.backgroundImage,
    this.foregroundImage,
    this.backgroundGradient,
    this.foregroundGradient,
    this.borderGradient,
    this.transform,
    this.shadowBlurStyle,
    this.clipBehavior,
    this.shadowType,
    this.position,
    this.positionType,
    this.shape,
    this.child,
    this.backgroundState,
    this.backgroundGradientState,
    this.backgroundImageState,
    this.onClick,
    this.onDoubleClick,
    this.onLongClick,
    this.onClickHandle,
    this.onDoubleClickHandle,
    this.onLongClickHandle,
    this.onToggleClick,
  }) : super(key: key);

  void init(T controller) {}

  T attachController() => ViewController() as T;

  T initController(T controller) => controller.attach(this) as T;

  void onViewCreated(BuildContext context, T controller) {}

  Widget root(BuildContext context, T controller, Widget parent) => parent;

  Widget build(BuildContext context, T controller, Widget parent) => parent;

  Widget? attach(BuildContext context, T controller) => controller.child;

  ViewProperties get properties => const ViewProperties();

  void onDispose() {}

  @override
  State<YMRView<T>> createState() => _YMRViewState<T>();
}

class _YMRViewState<T extends ViewController> extends State<YMRView<T>> {
  late T controller;

  @override
  void initState() {
    controller = widget.controller ?? widget.attachController();
    controller.setNotifier(setState);
    controller = widget.initController(controller);
    widget.init(controller);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant YMRView<T> oldWidget) {
    widget.init(controller);
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.onDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.onViewCreated(context, controller);
    return controller.visibility.isVisibleOrInvisible
        ? widget.root(
            context,
            controller,
            _ViewPosition(
              controller: controller,
              attachView: _ViewFlex(
                controller: controller,
                attachView: _ViewDimension(
                  controller: controller,
                  attachView: _ViewListener(
                    controller: controller,
                    attachView: _ViewChild(
                      controller: controller,
                      attach: widget.attach(context, controller),
                      builder: (context, view) {
                        return widget.build(
                          context,
                          controller,
                          view,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          )
        : const SizedBox();
  }
}

class _ViewPosition extends StatelessWidget {
  final ViewController controller;
  final Widget attachView;

  const _ViewPosition({
    Key? key,
    required this.controller,
    required this.attachView,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return controller.isPositional
        ? Positioned(
            top: controller.position.top,
            bottom: controller.position.bottom,
            left: controller.position.left,
            right: controller.position.right,
            child: attachView,
          )
        : attachView;
  }
}

class _ViewFlex extends StatelessWidget {
  final ViewController controller;
  final Widget attachView;

  const _ViewFlex({
    Key? key,
    required this.controller,
    required this.attachView,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return controller.isExpendable
        ? Expanded(
            flex: controller.flex,
            child: attachView,
          )
        : attachView;
  }
}

class _ViewDimension extends StatelessWidget {
  final ViewController controller;
  final Widget attachView;

  const _ViewDimension({
    Key? key,
    required this.controller,
    required this.attachView,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return controller.isDimensional
        ? AspectRatio(
            aspectRatio: controller.dimensionRatio,
            child: attachView,
          )
        : attachView;
  }
}

class _ViewListener extends StatelessWidget {
  final ViewController controller;
  final Widget attachView;

  const _ViewListener({
    Key? key,
    required this.controller,
    required this.attachView,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return controller.isObservable
        ? controller.isRippled
            ? Material(
                elevation: controller.elevation,
                borderRadius: controller.isRadius
                    ? BorderRadius.only(
                        topLeft: Radius.circular(
                          controller.borderRadiusTLF,
                        ),
                        topRight: Radius.circular(
                          controller.borderRadiusTRF,
                        ),
                        bottomLeft: Radius.circular(
                          controller.borderRadiusBLF,
                        ),
                        bottomRight: Radius.circular(
                          controller.borderRadiusBRF,
                        ),
                      )
                    : null,
                color: controller.background,
                clipBehavior: controller.clipBehavior,
                child: InkWell(
                  splashColor: controller.rippleColor,
                  hoverColor: controller.hoverColor,
                  highlightColor: controller.pressedColor,
                  onTap: controller.isClickable
                      ? () {
                          if (controller.isToggleClickable) {
                            controller.onToggleNotify();
                          } else {
                            controller.onClickHandle != null
                                ? controller.onClickHandle?.call(controller)
                                : controller.onClick?.call(context);
                          }
                        }
                      : null,
                  onDoubleTap: controller.isDoubleClickable
                      ? () {
                          controller.onDoubleClickHandle != null
                              ? controller.onDoubleClickHandle?.call(controller)
                              : controller.onDoubleClick?.call(context);
                        }
                      : null,
                  onLongPress: controller.isLongClickable
                      ? () {
                          controller.onLongClickHandle != null
                              ? controller.onLongClickHandle?.call(controller)
                              : controller.onLongClick?.call(context);
                        }
                      : null,
                  child: controller.absorbMode
                      ? AbsorbPointer(child: attachView)
                      : attachView,
                ),
              )
            : GestureDetector(
                onTap: controller.isClickable
                    ? () {
                        if (controller.isToggleClickable) {
                          controller.setActivated(
                            !controller.activated,
                          );
                        } else {
                          controller.onClickHandle != null
                              ? controller.onClickHandle?.call(controller)
                              : controller.onClick?.call(context);
                        }
                      }
                    : null,
                onDoubleTap: controller.isDoubleClickable
                    ? () {
                        controller.onDoubleClickHandle != null
                            ? controller.onDoubleClickHandle?.call(controller)
                            : controller.onDoubleClick?.call(context);
                      }
                    : null,
                onLongPress: controller.isLongClickable
                    ? () {
                        controller.onLongClickHandle != null
                            ? controller.onLongClickHandle?.call(controller)
                            : controller.onLongClick?.call(context);
                      }
                    : null,
                child: controller.absorbMode
                    ? AbsorbPointer(child: attachView)
                    : attachView,
              )
        : attachView;
  }
}

class _ViewChild extends StatelessWidget {
  final ViewController controller;
  final Widget? attach;
  final Function(BuildContext context, Widget child) builder;

  const _ViewChild({
    Key? key,
    required this.controller,
    required this.attach,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final root = controller.root;
    final isOverlayShadow = controller.isOverlayShadow;
    final isCircular = controller.isCircular;
    final isRadius = controller.isBorderRadius;
    final isRippled = controller.isRippled;
    final isMargin = controller.isMargin;
    final isPadding = controller.isPadding;
    final isBorder = controller.isBorder;
    final isShadow = controller.isShadow;
    final isConstraints = controller.isConstraints;

    final borderRadius = isRippled
        ? null
        : isRadius
            ? BorderRadius.only(
                topLeft: Radius.circular(
                  controller.borderRadiusTLF,
                ),
                topRight: Radius.circular(
                  controller.borderRadiusTRF,
                ),
                bottomLeft: Radius.circular(
                  controller.borderRadiusBLF,
                ),
                bottomRight: Radius.circular(
                  controller.borderRadiusBRF,
                ),
              )
            : null;

    return controller.visibility.isInvisible
        ? null
        : builder(
            context,
            controller.root.view
                ? Container(
                    alignment: controller.gravity,
                    clipBehavior:
                        root.decoration ? controller.clipBehavior : Clip.none,
                    width: controller.width,
                    height: controller.height,
                    transform: controller.transform,
                    transformAlignment: controller.transformGravity,
                    constraints: isConstraints
                        ? BoxConstraints(
                            maxWidth: controller.widthMax,
                            minWidth: controller.widthMin,
                            maxHeight: controller.heightMax,
                            minHeight: controller.heightMin,
                          )
                        : null,
                    decoration: root.decoration
                        ? BoxDecoration(
                            backgroundBlendMode: isRippled
                                ? null
                                : controller.backgroundBlendMode,
                            borderRadius: borderRadius,
                            color: isRippled
                                ? null
                                : root.background
                                    ? isBorder
                                        ? controller.borderColor
                                        : controller.background
                                    : null,
                            gradient: isRippled
                                ? null
                                : isBorder
                                    ? controller.borderGradient
                                    : controller.backgroundGradient,
                            image:
                                isRippled ? null : controller.backgroundImage,
                            boxShadow: isShadow
                                ? [
                                    BoxShadow(
                                      color: controller.shadowColor ??
                                          Colors.black45,
                                      blurRadius: controller.shadowBlurRadius,
                                      offset: isOverlayShadow
                                          ? Offset.zero
                                          : Offset(
                                              -controller.shadowStart,
                                              -controller.shadowTop,
                                            ),
                                      blurStyle: controller.shadowBlurStyle,
                                      spreadRadius:
                                          controller.shadowSpreadRadius,
                                    ),
                                    if (!isOverlayShadow)
                                      BoxShadow(
                                        color: controller.shadowColor ??
                                            Colors.black45,
                                        blurRadius: controller.shadowBlurRadius,
                                        offset: Offset(
                                          controller.shadowEnd,
                                          controller.shadowBottom,
                                        ),
                                        blurStyle: controller.shadowBlurStyle,
                                        spreadRadius:
                                            controller.shadowSpreadRadius,
                                      ),
                                  ]
                                : null,
                            shape: isCircular
                                ? BoxShape.circle
                                : BoxShape.rectangle,
                          )
                        : null,
                    foregroundDecoration: root.decoration
                        ? BoxDecoration(
                            backgroundBlendMode: controller.foregroundBlendMode,
                            borderRadius: borderRadius,
                            color: controller.foreground,
                            gradient: controller.foregroundGradient,
                            image: controller.foregroundImage,
                            shape: isCircular
                                ? BoxShape.circle
                                : BoxShape.rectangle,
                          )
                        : null,
                    margin: isMargin
                        ? EdgeInsets.only(
                            left: controller.marginStart,
                            right: controller.marginEnd,
                            top: controller.marginTop,
                            bottom: controller.marginBottom,
                          )
                        : null,
                    padding: isBorder
                        ? EdgeInsets.only(
                            left: controller.borderStart,
                            right: controller.borderEnd,
                            top: controller.borderTop,
                            bottom: controller.borderBottom,
                          )
                        : isPadding
                            ? EdgeInsets.only(
                                left: controller.paddingStart,
                                right: controller.paddingEnd,
                                top: controller.paddingTop,
                                bottom: controller.paddingBottom,
                              )
                            : null,
                    child: isBorder
                        ? _ViewBorder(
                            controller: controller,
                            isCircular: isCircular,
                            isPadding: isPadding,
                            isRadius: isRadius,
                            child: attach,
                          )
                        : attach,
                  )
                : const SizedBox(),
          );
  }
}

class _ViewBorder extends StatelessWidget {
  final ViewController controller;
  final bool isCircular, isPadding, isRadius;
  final Widget? child;

  const _ViewBorder({
    Key? key,
    required this.controller,
    required this.isCircular,
    required this.isPadding,
    required this.isRadius,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior:
          controller.root.decoration ? controller.clipBehavior : Clip.none,
      padding: isPadding
          ? EdgeInsets.only(
              left: controller.paddingStart,
              right: controller.paddingEnd,
              top: controller.paddingTop,
              bottom: controller.paddingBottom,
            )
          : null,
      decoration: BoxDecoration(
        color: controller.background,
        shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: isRadius
            ? BorderRadius.only(
                topLeft: Radius.circular(
                  controller.borderRadiusTL,
                ),
                topRight: Radius.circular(
                  controller.borderRadiusTR,
                ),
                bottomLeft: Radius.circular(
                  controller.borderRadiusBL,
                ),
                bottomRight: Radius.circular(
                  controller.borderRadiusBR,
                ),
              )
            : null,
      ),
      child: child,
    );
  }
}
