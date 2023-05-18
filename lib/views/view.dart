part of '../widgets.dart';

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
typedef OnViewNotifyBuilder = void Function(VoidCallback fn);
typedef OnViewNotifyListener<T extends ViewController> = Function(T controller);

class YMRView<T extends ViewController> extends StatefulWidget {
  final T? controller;

  final int? flex;
  final bool? activated, enabled, visibility;

  final int? animation;
  final Curve? animationType;

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

  final Color? background, foreground, borderColor, shadowColor;

  final DecorationImage? backgroundImage, foregroundImage;
  final Gradient? backgroundGradient, foregroundGradient, borderGradient;
  final Matrix4? transform;

  final Alignment? gravity, transformGravity;
  final BlendMode? backgroundBlendMode, foregroundBlendMode;
  final BlurStyle? shadowBlurStyle;
  final Clip? clipBehavior;
  final ViewShadowType? shadowType;
  final ViewPosition? position;
  final ViewPositionType? positionType;
  final ViewShape? shape;

  final Widget? child;

  final OnViewClickListener? onClick, onDoubleClick, onLongClick;
  final OnViewNotifyListener<T>? onClickHandle;
  final OnViewNotifyListener<T>? onDoubleClickHandle;
  final OnViewNotifyListener<T>? onLongClickHandle;

  const YMRView({
    Key? key,
    this.controller,
    this.flex,
    this.activated,
    this.enabled,
    this.visibility,
    this.animation,
    this.animationType,
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
    this.foreground,
    this.borderColor,
    this.shadowColor,
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
    this.onClick,
    this.onDoubleClick,
    this.onLongClick,
    this.onClickHandle,
    this.onDoubleClickHandle,
    this.onLongClickHandle,
  }) : super(key: key);

  void initialization(T controller) {}

  T attachController() => ViewController() as T;

  T initController(T controller) => controller.attach(this) as T;

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
    widget.initialization(controller);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant YMRView<T> oldWidget) {
    controller = widget.initController(controller);
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.onDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.root(
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
    );
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
        ? GestureDetector(
            onTap: () => controller.onClickHandle != null
                ? controller.onClickHandle?.call(controller)
                : controller.onClick?.call(context),
            onDoubleTap: () => controller.onDoubleClickHandle != null
                ? controller.onDoubleClickHandle?.call(controller)
                : controller.onDoubleClick?.call(context),
            onLongPress: () => controller.onLongClickHandle != null
                ? controller.onLongClickHandle?.call(controller)
                : controller.onLongClick?.call(context),
            child: attachView,
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
    final isOverlayShadow =
        root.shadow && controller.shadowType == ViewShadowType.overlay;
    final isCircular = root.shape && controller.isCircular;
    final isRadius = root.radius && !isCircular && controller.isBorderRadius;
    final isMargin = root.margin && controller.isMargin;
    final isPadding = root.padding && controller.isPadding;
    final isBorder = root.border && controller.isBorder;
    final isShadow = root.shadow && controller.isShadow;
    final isConstraints = root.constraints && controller.isConstraints;

    final borderRadius = isRadius
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

    return controller.visibility
        ? builder(
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
                            backgroundBlendMode: controller.backgroundBlendMode,
                            borderRadius: borderRadius,
                            color: root.background
                                ? isBorder
                                    ? controller.borderColor
                                    : controller.background
                                : null,
                            gradient: isBorder
                                ? controller.borderGradient
                                : controller.backgroundGradient,
                            image: controller.backgroundImage,
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
          )
        : const SizedBox();
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

class ViewController {
  ViewController({
    this.activated = false,
    this.enabled = true,
    this.root = const ViewProperties(),
    this.visibility = true,
    this.flex = 0,
    double? dimensionRatio,
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
    this.background,
    this.foreground,
    this.borderColor,
    this.shadowColor,
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
  })  : _marginStart = marginStart,
        _marginEnd = marginEnd,
        _marginTop = marginTop,
        _marginBottom = marginBottom,
        _paddingStart = paddingStart,
        _paddingEnd = paddingEnd,
        _paddingTop = paddingTop,
        _paddingBottom = paddingBottom,
        _position = position,
        _shadowBottom = shadowBottom,
        __shadowTop = shadowTop,
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
    required bool? activated,
    required bool? enabled,
    required bool? visibility,
    required int? animation,
    required Curve? animationType,
    required int? flex,
    required double? dimensionRatio,
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
    required Color? foreground,
    required Color? borderColor,
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
    required Widget? child,
    required OnViewClickListener? onClick,
    required OnViewClickListener? onDoubleClick,
    required OnViewClickListener? onLongClick,
    required OnViewNotifyListener? onClickHandle,
    required OnViewNotifyListener? onDoubleClickHandle,
    required OnViewNotifyListener? onLongClickHandle,
  }) {
    // VIEW CONDITIONAL PROPERTIES
    this.activated = activated ?? this.activated;
    this.enabled = enabled ?? this.enabled;
    this.visibility = visibility ?? this.visibility;

    // ANIMATION PROPERTIES
    this.animation = animation ?? this.animation;
    this.animationType = animationType ?? this.animationType;

    // VIEW SIZE PROPERTIES
    this.flex = flex ?? this.flex;
    _dimensionRatio = dimensionRatio ?? _dimensionRatio;
    _width = width ?? _width;
    _widthMax = widthMax ?? _widthMax;
    _widthMin = widthMin ?? _widthMin;
    _height = height ?? _height;
    _heightMax = heightMax ?? _heightMax;
    _heightMin = heightMin ?? _heightMin;

    // VIEW MARGIN PROPERTIES
    this.margin = margin ?? this.margin;
    this.marginVertical = marginVertical ?? this.marginVertical;
    _marginStart = marginStart ?? _marginStart;
    _marginEnd = marginEnd ?? _marginEnd;
    _marginTop = marginTop ?? _marginTop;
    _marginBottom = marginBottom ?? _marginBottom;
    this.marginHorizontal = marginHorizontal ?? this.marginHorizontal;

    // VIEW PADDING PROPERTIES
    this.padding = padding ?? this.padding;
    _paddingStart = paddingStart ?? _paddingStart;
    _paddingEnd = paddingEnd ?? _paddingEnd;
    _paddingTop = paddingTop ?? _paddingTop;
    _paddingBottom = paddingBottom ?? _paddingBottom;
    this.paddingHorizontal = paddingHorizontal ?? this.paddingHorizontal;
    this.paddingVertical = paddingVertical ?? this.paddingVertical;

    // VIEW BORDER PROPERTIES
    this.borderColor = borderColor ?? this.borderColor;
    this.borderGradient = borderGradient ?? this.borderGradient;
    this.border = border ?? this.border;
    _borderStart = borderStart ?? _borderStart;
    _borderEnd = borderEnd ?? _borderEnd;
    _borderTop = borderTop ?? _borderTop;
    _borderBottom = borderBottom ?? _borderBottom;
    this.borderHorizontal = borderHorizontal ?? this.borderHorizontal;
    this.borderVertical = borderVertical ?? this.borderVertical;

    // VIEW BORDER RADIUS PROPERTIES
    this.borderRadius = borderRadius ?? this.borderRadius;
    _borderRadiusBL = borderRadiusBL ?? _borderRadiusBL;
    _borderRadiusBR = borderRadiusBR ?? _borderRadiusBR;
    _borderRadiusTL = borderRadiusTL ?? _borderRadiusTL;
    _borderRadiusTL = borderRadiusTL ?? _borderRadiusTL;

    // VIEW SHADOW PROPERTIES
    this.shadowColor = shadowColor ?? this.shadowColor;
    this.shadow = shadow ?? this.shadow;
    _shadowStart = shadowStart ?? _shadowStart;
    _shadowEnd = shadowEnd ?? _shadowEnd;
    __shadowTop = shadowTop ?? __shadowTop;
    _shadowBottom = shadowBottom ?? _shadowBottom;
    this.shadowHorizontal = shadowHorizontal ?? this.shadowHorizontal;
    this.shadowVertical = shadowVertical ?? this.shadowVertical;
    this.shadowBlurRadius = shadowBlurRadius ?? this.shadowBlurRadius;
    this.shadowBlurStyle = shadowBlurStyle ?? this.shadowBlurStyle;
    this.shadowSpreadRadius = shadowSpreadRadius ?? this.shadowSpreadRadius;
    this.shadowType = shadowType ?? this.shadowType;

    // VIEW DECORATION PROPERTIES
    this.background = background ?? this.background;
    this.foreground = foreground ?? this.foreground;
    this.backgroundBlendMode = backgroundBlendMode ?? this.backgroundBlendMode;
    this.foregroundBlendMode = foregroundBlendMode ?? this.foregroundBlendMode;
    this.backgroundGradient = backgroundGradient ?? this.backgroundGradient;
    this.foregroundGradient = foregroundGradient ?? this.foregroundGradient;
    this.backgroundImage = backgroundImage ?? this.backgroundImage;
    this.foregroundImage = foregroundImage ?? this.foregroundImage;
    this.clipBehavior = clipBehavior ?? this.clipBehavior;
    this.gravity = gravity ?? this.gravity;
    this.transform = transform ?? this.transform;
    this.transformGravity = transformGravity ?? this.transformGravity;
    this.transform = transform ?? this.transform;
    _position = position ?? _position;
    this.positionType = positionType ?? this.positionType;
    this.shape = shape ?? this.shape;
    this.root = root ?? this.root;
    this.child = child ?? this.child;

    // VIEW LISTENER PROPERTIES
    this.onClick = onClick ?? this.onClick;
    this.onDoubleClick = onDoubleClick ?? this.onDoubleClick;
    this.onLongClick = onLongClick ?? this.onLongClick;
    this.onClickHandle = onClickHandle ?? this.onClickHandle;
    this.onDoubleClickHandle = onDoubleClickHandle ?? this.onDoubleClickHandle;
    this.onLongClickHandle = onLongClickHandle ?? this.onLongClickHandle;

    return this;
  }

  ViewController init({
    bool? activated,
    bool? enabled,
    bool? visibility,
    int? animation,
    Curve? animationType,
    int? flex,
    double? dimensionRatio,
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
    Color? foreground,
    Color? borderColor,
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
    ViewProperties? root,
    Widget? child,
    OnViewClickListener? onClick,
    OnViewClickListener? onDoubleClick,
    OnViewClickListener? onLongClick,
    OnViewNotifyListener? onClickNotify,
    OnViewNotifyListener? onDoubleClickNotify,
    OnViewNotifyListener? onLongClickNotify,
  }) {
    return properties(
      activated: activated,
      enabled: enabled,
      visibility: visibility,
      animation: animation,
      animationType: animationType,
      flex: flex,
      dimensionRatio: dimensionRatio,
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
      foreground: foreground,
      borderColor: borderColor,
      shadowColor: shadowColor,
      gravity: gravity,
      transformGravity: transformGravity,
      backgroundBlendMode: backgroundBlendMode,
      foregroundBlendMode: foregroundBlendMode,
      backgroundImage: backgroundImage,
      foregroundImage: foregroundImage,
      backgroundGradient: backgroundGradient,
      foregroundGradient: foregroundGradient,
      borderGradient: borderGradient,
      transform: transform,
      shadowBlurStyle: shadowBlurStyle,
      clipBehavior: clipBehavior,
      shadowType: shadowType,
      position: position,
      positionType: positionType,
      shape: shape,
      root: root,
      child: child,
      onClick: onClick,
      onDoubleClick: onDoubleClick,
      onLongClick: onLongClick,
      onClickHandle: onClickNotify,
      onDoubleClickHandle: onDoubleClickNotify,
      onLongClickHandle: onLongClickNotify,
    );
  }

  @mustCallSuper
  ViewController attach(YMRView view) => properties(
        activated: view.activated,
        enabled: view.enabled,
        visibility: view.visibility,
        animation: view.animation,
        animationType: view.animationType,
        flex: view.flex,
        dimensionRatio: view.dimensionRatio,
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
        foreground: view.foreground,
        borderColor: view.borderColor,
        shadowColor: view.shadowColor,
        gravity: view.gravity,
        transformGravity: view.transformGravity,
        backgroundBlendMode: view.backgroundBlendMode,
        foregroundBlendMode: view.foregroundBlendMode,
        backgroundImage: view.backgroundImage,
        foregroundImage: view.foregroundImage,
        backgroundGradient: view.backgroundGradient,
        foregroundGradient: view.foregroundGradient,
        borderGradient: view.borderGradient,
        transform: view.transform,
        shadowBlurStyle: view.shadowBlurStyle,
        clipBehavior: view.clipBehavior,
        shadowType: view.shadowType,
        position: view.position,
        positionType: view.positionType,
        shape: view.shape,
        root: view.properties,
        child: view.child,
        onClick: view.onClick,
        onDoubleClick: view.onDoubleClick,
        onLongClick: view.onLongClick,
        onClickHandle: view.onClickHandle,
        onDoubleClickHandle: view.onDoubleClickHandle,
        onLongClickHandle: view.onLongClickHandle,
      );

  bool activated = false;

  void setActivated(bool value) {
    activated = value;
    notify;
  }

  Alignment? gravity;

  void setAlignment(Alignment? value) {
    gravity = value;
    notify;
  }

  int animation = 0;

  bool get animationEnabled => animation > 0;

  void setAnimation(int value) {
    animation = value;
    notify;
  }

  Duration get animationDuration => Duration(microseconds: animation);

  Curve animationType;

  void setAnimationType(Curve value) {
    animationType = value;
    notify;
  }

  Color? background;

  void setBackground(Color? value) {
    background = value;
    notify;
  }

  Gradient? backgroundGradient;

  void setBackgroundGradient(Gradient? value) {
    backgroundGradient = value;
    notify;
  }

  BlendMode? backgroundBlendMode;

  void setBackgroundBlendMode(BlendMode? value) {
    backgroundBlendMode = value;
    notify;
  }

  DecorationImage? backgroundImage;

  void setBackgroundImage(DecorationImage? value) {
    backgroundImage = value;
    notify;
  }

  Clip clipBehavior = Clip.antiAlias;

  void setClipBehavior(Clip value) {
    clipBehavior = value;
    notify;
  }

  double? _dimensionRatio;

  double get dimensionRatio => _dimensionRatio ?? 0;

  bool get isDimensional => root.ratio && dimensionRatio > 0;

  void setDimensionRatio(double? value) {
    _dimensionRatio = value;
    notify;
  }

  Color? foreground;

  void setForeground(Color? value) {
    foreground = value;
    notify;
  }

  Gradient? foregroundGradient;

  void setForegroundGradient(Gradient? value) {
    foregroundGradient = value;
    notify;
  }

  BlendMode? foregroundBlendMode;

  void setForegroundBlendMode(BlendMode? value) {
    foregroundBlendMode = value;
    notify;
  }

  DecorationImage? foregroundImage;

  void setForegroundImage(DecorationImage? value) {
    foregroundImage = value;
    notify;
  }

  Color? borderColor;

  void setBorderColor(Color? value) {
    borderColor = value;
    notify;
  }

  Gradient? borderGradient;

  void setBorderGradient(Gradient? value) {
    borderGradient = value;
    notify;
  }

  double border = 0;

  void setBorder(double value) {
    border = value;
    notify;
  }

  double? borderHorizontal, borderVertical;

  void setBorderHorizontal(double? value) {
    borderHorizontal = value;
    notify;
  }

  void setBorderVertical(double? value) {
    borderVertical = value;
    notify;
  }

  double? _borderTop;

  double get borderTop => _borderTop ?? borderVertical ?? border;

  void setBorderTop(double? value) {
    _borderTop = value;
    notify;
  }

  double? _borderBottom;

  double get borderBottom => _borderBottom ?? borderVertical ?? border;

  void setBorderBottom(double? value) {
    _borderBottom = value;
    notify;
  }

  double? _borderStart;

  double get borderStart => _borderStart ?? borderHorizontal ?? border;

  void setBorderStart(double? value) {
    _borderStart = value;
    notify;
  }

  double? _borderEnd;

  double get borderEnd => _borderEnd ?? borderHorizontal ?? border;

  void setBorderEnd(double? value) {
    _borderEnd = value;
    notify;
  }

  double borderRadius = 0;

  void setBorderRadius(double value) {
    borderRadius = value;
    notify;
  }

  double? _borderRadiusBL;

  double get borderRadiusBL => _borderRadiusBL ?? borderRadius;

  double get borderRadiusBLF {
    final a = borderRadiusBL;
    final b = a > 0 ? min(borderStart, borderBottom) : 0;
    return a + b;
  }

  void setBorderRadiusBL(double? value) {
    _borderRadiusBL = value;
    notify;
  }

  double? _borderRadiusBR;

  double get borderRadiusBR => _borderRadiusBR ?? borderRadius;

  double get borderRadiusBRF {
    final a = borderRadiusBR;
    final b = a > 0 ? min(borderEnd, borderBottom) : 0;
    return a + b;
  }

  void setBorderRadiusBR(double? value) {
    _borderRadiusBR = value;
    notify;
  }

  double? _borderRadiusTL;

  double get borderRadiusTL => _borderRadiusTL ?? borderRadius;

  double get borderRadiusTLF {
    final a = borderRadiusTL;
    final b = a > 0 ? min(borderStart, borderTop) : 0;
    return a + b;
  }

  void setBorderRadiusTL(double? value) {
    _borderRadiusTL = value;
    notify;
  }

  double? _borderRadiusTR;

  double get borderRadiusTR => _borderRadiusTR ?? borderRadius;

  double get borderRadiusTRF {
    final a = borderRadiusTR;
    final b = a > 0 ? min(borderEnd, borderTop) : 0;
    return a + b;
  }

  void setBorderRadiusTR(double? value) {
    _borderRadiusTR = value;
    notify;
  }

  Widget? child;

  void setChild(Widget? value) {
    child = value;
    notify;
  }

  bool enabled = true;

  void setEnabled(bool value) {
    enabled = value;
    notify;
  }

  int flex = 0;

  void setFlex(int value) {
    flex = value;
    notify;
  }

  double? _width;

  double? get width => isSquire || isCircular ? squireSize : _width;

  void setWidth(double? value) {
    _width = value;
    notify;
  }

  double? _widthMax;

  double get widthMax => _widthMax ?? double.infinity;

  void setMaxWidth(double? value) {
    _widthMax = value;
    notify;
  }

  double? _widthMin;

  double get widthMin => _widthMin ?? 0.0;

  void setMinWidth(double? value) {
    _widthMin = value;
    notify;
  }

  double? _height;

  double? get height => isSquire || isCircular ? squireSize : _height;

  void setHeight(double? value) {
    _height = value;
    notify;
  }

  double? _heightMax;

  double get heightMax => _heightMax ?? double.infinity;

  void setMaxHeight(double? value) {
    _heightMax = value;
    notify;
  }

  double? _heightMin;

  double get heightMin => _heightMin ?? 0.0;

  void setMinHeight(double? value) {
    _heightMin = value;
    notify;
  }

  double margin = 0;

  void setMargin(double value) {
    margin = value;
    notify;
  }

  double? _marginStart;

  double get marginStart => _marginStart ?? marginHorizontal ?? margin;

  void setMarginStart(double? value) {
    _marginStart = value;
    notify;
  }

  double? _marginEnd;

  double get marginEnd => _marginEnd ?? marginHorizontal ?? margin;

  void setMarginEnd(double? value) {
    _marginEnd = value;
    notify;
  }

  double? _marginTop;

  double get marginTop => _marginTop ?? marginVertical ?? margin;

  void setMarginTop(double? value) {
    _marginTop = value;
    notify;
  }

  double? _marginBottom;

  double get marginBottom => _marginBottom ?? marginVertical ?? margin;

  void setMarginBottom(double? value) {
    _marginBottom = value;
    notify;
  }

  double? marginHorizontal;

  void setMarginHorizontal(double? value) {
    marginHorizontal = value;
    notify;
  }

  double? marginVertical;

  void setMarginVertical(double? value) {
    marginVertical = value;
    notify;
  }

  double padding = 0;

  void setPadding(double value) {
    padding = value;
    notify;
  }

  double? _paddingStart;

  double get paddingStart => _paddingStart ?? paddingHorizontal ?? padding;

  void setPaddingStart(double? value) {
    _paddingStart = value;
    notify;
  }

  double? _paddingEnd;

  double get paddingEnd => _paddingEnd ?? paddingHorizontal ?? padding;

  void setPaddingEnd(double? value) {
    _paddingEnd = value;
    notify;
  }

  double? _paddingTop;

  double get paddingTop => _paddingTop ?? paddingVertical ?? padding;

  void setPaddingTop(double? value) {
    _paddingTop = value;
    notify;
  }

  double? _paddingBottom;

  double get paddingBottom => _paddingBottom ?? paddingVertical ?? padding;

  void setPaddingBottom(double? value) {
    _paddingBottom = value;
    notify;
  }

  double? paddingHorizontal;

  void setPaddingHorizontal(double? value) {
    paddingHorizontal = value;
    notify;
  }

  double? paddingVertical;

  void setPaddingVertical(double? value) {
    paddingVertical = value;
    notify;
  }

  ViewPosition? _position;

  ViewPosition get position => _position ?? positionType.position;

  void setPosition(ViewPosition? value) {
    _position = value;
    notify;
  }

  ViewPositionType positionType = ViewPositionType.none;

  void setPositionType(ViewPositionType value) {
    positionType = value;
    notify;
  }

  Matrix4? transform;

  void setTransform(Matrix4 value) {
    transform = value;
    notify;
  }

  Alignment? transformGravity;

  void setTransformAlignment(Alignment value) {
    transformGravity = value;
    notify;
  }

  double shadow = 0;

  void setShadow(double value) {
    shadow = value;
    notify;
  }

  Color? shadowColor;

  void setShadowColor(Color value) {
    shadowColor = value;
    notify;
  }

  double shadowBlurRadius = 5;

  void setShadowBlurRadius(double value) {
    shadowBlurRadius = value;
    notify;
  }

  BlurStyle shadowBlurStyle = BlurStyle.normal;

  void setShadowBlurStyle(BlurStyle value) {
    shadowBlurStyle = value;
    notify;
  }

  double shadowSpreadRadius = 0;

  void setShadowSpreadRadius(double value) {
    shadowSpreadRadius = value;
    notify;
  }

  ViewShadowType shadowType = ViewShadowType.none;

  void setShadowType(ViewShadowType value) {
    shadowType = value;
    notify;
  }

  double? shadowHorizontal;

  void setShadowHorizontal(double? value) {
    shadowHorizontal = value;
    notify;
  }

  double? shadowVertical;

  void setShadowVertical(double? value) {
    shadowVertical = value;
    notify;
  }

  double? _shadowStart;

  double get shadowStart => _shadowStart ?? shadowHorizontal ?? shadow;

  void setShadowStart(double? value) {
    _shadowStart = value;
    notify;
  }

  double? _shadowEnd;

  double get shadowEnd => _shadowEnd ?? shadowHorizontal ?? shadow;

  void setShadowEnd(double? value) {
    _shadowEnd = value;
    notify;
  }

  double? __shadowTop;

  double get shadowTop => __shadowTop ?? shadowVertical ?? shadow;

  void setShadowTop(double? value) {
    __shadowTop = value;
    notify;
  }

  double? _shadowBottom;

  double get shadowBottom => _shadowBottom ?? shadowVertical ?? shadow;

  void setShadowBottom(double? value) {
    _shadowBottom = value;
    notify;
  }

  ViewProperties root = const ViewProperties();

  ViewShape shape = ViewShape.rectangular;

  void setViewType(ViewShape value) {
    shape = value;
    notify;
  }

  bool visibility = true;

  void setVisibility(bool value) {
    visibility = value;
    notify;
  }

  OnViewClickListener? _onClick;

  OnViewClickListener? get onClick => enabled ? _onClick : null;

  set onClick(OnViewClickListener? listener) => _onClick ??= listener;

  void setOnClickListener(OnViewClickListener listener) {
    _onClick = listener;
  }

  OnViewClickListener? _onDoubleClick;

  OnViewClickListener? get onDoubleClick => enabled ? _onDoubleClick : null;

  set onDoubleClick(OnViewClickListener? listener) =>
      _onDoubleClick ??= listener;

  void setOnDoubleClickListener(OnViewClickListener listener) {
    _onDoubleClick = listener;
  }

  OnViewClickListener? _onLongClick;

  OnViewClickListener? get onLongClick => enabled ? _onLongClick : null;

  set onLongClick(OnViewClickListener? listener) => _onLongClick ??= listener;

  void setOnLongClickListener(OnViewClickListener listener) {
    _onLongClick = listener;
  }

  OnViewNotifyListener? onClickHandle, onDoubleClickHandle, onLongClickHandle;

  OnViewNotifyBuilder? _onNotifier;

  void setNotifier(OnViewNotifyBuilder? notifier) {
    _onNotifier = notifier;
  }

  bool get isObservable {
    return root.observer &&
        (onClick != null ||
            onDoubleClick != null ||
            onLongClick != null ||
            onClickHandle != null ||
            onDoubleClickHandle != null ||
            onLongClickHandle != null);
  }

  bool get isPositional {
    return root.position &&
        (_position != null || positionType != ViewPositionType.none);
  }

  bool get isExpendable {
    return root.flex && flex > 0;
  }

  bool get isBorder {
    final x = borderStart + borderEnd + borderTop + borderBottom;
    return x > 0;
  }

  bool get isBorderRadius {
    final x =
        borderRadiusBLF + borderRadiusBRF + borderRadiusTLF + borderRadiusTRF;
    return x > 0;
  }

  bool get isMargin {
    final x = marginStart + marginEnd + marginTop + marginBottom;
    return x > 0;
  }

  bool get isPadding {
    final x = paddingStart + paddingEnd + paddingTop + paddingBottom;
    return x > 0;
  }

  bool get isConstraints =>
      _widthMax != null ||
      _widthMin != null ||
      _heightMax != null ||
      _heightMin != null;

  bool get isShadow {
    final x = shadowStart + shadowEnd + shadowTop + shadowBottom;
    return (x > 0 || shadowType == ViewShadowType.overlay);
  }

  bool get isCircular {
    return shape == ViewShape.circular;
  }

  bool get isSquire {
    return shape == ViewShape.squire;
  }

  double get squireSize {
    return max(_width ?? 0, _height ?? 0);
  }

  OnViewNotifyBuilder? get notifier {
    return _onNotifier;
  }

  void get notify {
    if (_onNotifier != null) {
      _onNotifier?.call(() {});
    }
  }

  void onNotify() => notify;
}

class ViewProperties {
  final bool position, flex, ratio, observer;
  final bool view, constraints, margin, padding;
  final bool decoration, shadow, shape, radius, border, background;

  const ViewProperties({
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

class ViewPosition {
  final double? top, bottom, left, right;

  const ViewPosition({
    this.top,
    this.bottom,
    this.left,
    this.right,
  });
}

enum ViewPositionType {
  bottomEnd(ViewPosition(bottom: 0, right: 0)),
  bottomStart(ViewPosition(bottom: 0, left: 0)),
  center,
  centerBottom(ViewPosition(bottom: 0)),
  centerEnd(ViewPosition(right: 0)),
  centerStart(ViewPosition(left: 0)),
  centerTop(ViewPosition(top: 0)),
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
  final T _error;
  final T _selected;
  final T _unselected;
  final T _focused;
  final T _unfocused;
  final T _enabled;
  final T _disabled;

  const ValueState({
    required T primary,
    T? error,
    T? selected,
    T? unselected,
    T? focused,
    T? unfocused,
    T? enabled,
    T? disabled,
  })  : _primary = primary,
        _error = error ?? primary,
        _selected = selected ?? primary,
        _unselected = unselected ?? primary,
        _focused = focused ?? primary,
        _unfocused = unfocused ?? primary,
        _enabled = enabled ?? primary,
        _disabled = disabled ?? primary;

  factory ValueState.selectable({
    required T selected,
    required T unselected,
  }) {
    return ValueState(
      primary: unselected,
      selected: selected,
    );
  }

  T detect(bool isEnabled) => isEnabled ? _primary : _disabled;

  T selected(bool isSelected) => isSelected ? _selected : _primary;

  T focused(bool isFocused) => isFocused ? _focused : _unfocused;

  T error(bool isError) => isError ? _error : _primary;

  T typed(StateType type) {
    switch (type) {
      case StateType.none:
        return _primary;
      case StateType.error:
        return _error;
      case StateType.selected:
        return _selected;
      case StateType.unselected:
        return _unselected;
      case StateType.focused:
        return _focused;
      case StateType.unfocused:
        return _unfocused;
      case StateType.enabled:
        return _enabled;
      case StateType.disabled:
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
