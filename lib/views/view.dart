part of '../widgets.dart';

typedef OnViewBuilder<T> = Widget Function(BuildContext context, T? controller);
typedef OnViewChangeListener = Function(dynamic value);
typedef OnViewClickListener = Function(BuildContext context);
typedef OnViewToggleListener = Function(bool value);
typedef OnViewToggleHandler<T extends ViewController> = Function(
  BuildContext context,
  T controller,
);
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

enum ViewPositionType {
  bottomEnd(ViewPosition(bottom: 0, right: 0)),
  bottomStart(ViewPosition(bottom: 0, left: 0)),
  center,
  centerBottom(ViewPosition(bottom: 0, left: 0, right: 0)),
  centerEnd(ViewPosition(right: 0, top: 0, bottom: 0)),
  centerStart(ViewPosition(left: 0, top: 0, bottom: 0)),
  centerTop(ViewPosition(top: 0, left: 0, right: 0)),
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

enum ViewShadowType { overlay, none }

enum ViewShape { circular, rectangular, squire }

enum ViewVisibility { gone, visible, invisible }

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

class ViewRoots {
  final bool ripple;
  final bool position, flex, ratio, observer;
  final bool view, constraints, margin, padding;
  final bool decoration, shadow, shape, radius, border, background;

  const ViewRoots({
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

  ViewRoots modify({
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
    return ViewRoots(
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

class ValueState<T> {
  final T _primary;
  final T? _activated;
  final T? _disabled;
  final T? _focused;
  final T? _selected;

  const ValueState._({
    required T primary,
    T? activated,
    T? disabled,
    T? focused,
    T? selected,
  })  : _primary = primary,
        _activated = activated,
        _disabled = disabled,
        _focused = focused,
        _selected = selected;

  T get primaryValue => _primary;

  T? get activatedValue => _activated;

  T? get disabledValue => _disabled;

  T? get focusedValue => _focused;

  T? get selectedValue => _selected;

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
      activated: selected,
      selected: selected,
      disabled: disabled,
    );
  }

  T? activated(bool activated, [bool enabled = true]) {
    if (enabled) {
      return activated ? _activated : _primary;
    } else {
      return _disabled;
    }
  }

  T? focused(bool focused, [bool enabled = true]) {
    if (enabled) {
      return focused ? _focused : _primary;
    } else {
      return _disabled;
    }
  }

  T? selected(bool selected, [bool enabled = true]) {
    if (enabled) {
      return selected ? _selected ?? _activated : _primary;
    } else {
      return _disabled;
    }
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
  final double? ripple;

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
  final OnViewNotifyListener<T>? onClickHandler;
  final OnViewNotifyListener<T>? onDoubleClickHandler;
  final OnViewNotifyListener<T>? onLongClickHandler;
  final OnViewToggleListener? onToggle;

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
    this.ripple,
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
    this.onClickHandler,
    this.onDoubleClickHandler,
    this.onLongClickHandler,
    this.onToggle,
  }) : super(key: key);

  void init(T controller) {}

  T initController() => ViewController() as T;

  T attachController(T controller) => controller.fromView(this) as T;

  void onViewCreated(BuildContext context, T controller) {}

  void onToggleHandler(BuildContext context, T controller) {}

  Widget root(BuildContext context, T controller, Widget parent) => parent;

  Widget build(BuildContext context, T controller, Widget parent) => parent;

  Widget? attach(BuildContext context, T controller) => controller.child;

  ViewRoots get roots => const ViewRoots();

  void onDispose() {}

  @override
  State<YMRView<T>> createState() => _YMRViewState<T>();
}

class _YMRViewState<T extends ViewController> extends State<YMRView<T>> {
  late T controller;

  @override
  void initState() {
    controller = widget.controller ?? widget.initController();
    controller._setNotifier(setState);
    controller = widget.attachController(controller);
    widget.init(controller);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant YMRView<T> oldWidget) {
    controller = widget.attachController(controller);
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
    controller.context = context;
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
                    onToggleHandler: widget.onToggleHandler,
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

class _ViewListener<T extends ViewController> extends StatelessWidget {
  final T controller;
  final Widget attachView;
  final OnViewToggleHandler<T> onToggleHandler;

  const _ViewListener({
    Key? key,
    required this.controller,
    required this.attachView,
    required this.onToggleHandler,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return controller.isObservable
        ? controller.isRippled
            ? Padding(
                padding: controller.isMargin
                    ? EdgeInsets.only(
                        left: controller.marginStart,
                        right: controller.marginEnd,
                        top: controller.marginTop,
                        bottom: controller.marginBottom,
                      )
                    : EdgeInsets.zero,
                child: Material(
                  elevation: controller.elevation,
                  borderRadius: controller.isRippled
                      ? controller.isCircular
                          ? BorderRadius.circular(controller.maxSize)
                          : BorderRadius.only(
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
                              controller._onToggleNotify();
                              onToggleHandler(context, controller);
                            } else {
                              controller.onClickHandler != null
                                  ? controller.onClickHandler?.call(controller)
                                  : controller.onClick?.call(context);
                            }
                          }
                        : null,
                    onDoubleTap: controller.isDoubleClickable
                        ? () {
                            controller.onDoubleClickHandler != null
                                ? controller.onDoubleClickHandler
                                    ?.call(controller)
                                : controller.onDoubleClick?.call(context);
                          }
                        : null,
                    onLongPress: controller.isLongClickable
                        ? () {
                            controller.onLongClickHandler != null
                                ? controller.onLongClickHandler
                                    ?.call(controller)
                                : controller.onLongClick?.call(context);
                          }
                        : null,
                    child: controller.absorbMode
                        ? AbsorbPointer(child: attachView)
                        : attachView,
                  ),
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
                          controller.onClickHandler != null
                              ? controller.onClickHandler?.call(controller)
                              : controller.onClick?.call(context);
                        }
                      }
                    : null,
                onDoubleTap: controller.isDoubleClickable
                    ? () {
                        controller.onDoubleClickHandler != null
                            ? controller.onDoubleClickHandler?.call(controller)
                            : controller.onDoubleClick?.call(context);
                      }
                    : null,
                onLongPress: controller.isLongClickable
                    ? () {
                        controller.onLongClickHandler != null
                            ? controller.onLongClickHandler?.call(controller)
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
    final root = controller.roots;
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
        : isRadius && !isCircular
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
            controller.roots.view
                ? Container(
                    alignment: controller.gravity,
                    clipBehavior: root.decoration && !isRippled
                        ? controller.clipBehavior
                        : Clip.none,
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
                    decoration: root.decoration && !isRippled
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
                    margin: isMargin && !isRippled
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
          controller.roots.decoration ? controller.clipBehavior : Clip.none,
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
  @mustCallSuper
  ViewController fromView(YMRView view) {
    hoverColor = view.hoverColor;
    pressedColor = view.pressedColor;
    _ripple = view.ripple ?? 0;
    rippleColor = view.rippleColor ?? Colors.white;

    // VIEW CONDITIONAL PROPERTIES
    absorbMode = view.absorbMode ?? false;
    activated = view.activated ?? false;
    enabled = view.enabled ?? true;

    // ANIMATION PROPERTIES
    animation = view.animation ?? 0;
    animationType = view.animationType ?? Curves.linear;

    // VIEW SIZE PROPERTIES
    flex = view.flex ?? 0;
    _dimensionRatio = view.dimensionRatio;
    elevation = view.elevation ?? 0;
    _width = view.width;
    _widthMax = view.widthMax;
    _widthMin = view.widthMin;
    _height = view.height;
    _heightMax = view.heightMax;
    _heightMin = view.heightMin;

    // VIEW MARGIN PROPERTIES
    margin = view.margin ?? 0;
    marginVertical = view.marginVertical;
    _marginStart = view.marginStart;
    _marginEnd = view.marginEnd;
    _marginTop = view.marginTop;
    _marginBottom = view.marginBottom;
    marginHorizontal = view.marginHorizontal;

    // VIEW PADDING PROPERTIES
    padding = view.padding ?? 0;
    _paddingStart = view.paddingStart;
    _paddingEnd = view.paddingEnd;
    _paddingTop = view.paddingTop;
    _paddingBottom = view.paddingBottom;
    paddingHorizontal = view.paddingHorizontal;
    paddingVertical = view.paddingVertical;

    // VIEW BORDER PROPERTIES
    borderColor = view.borderColor;
    borderGradient = view.borderGradient;
    border = view.borderSize ?? 0;
    _borderStart = view.borderStart;
    _borderEnd = view.borderEnd;
    _borderTop = view.borderTop;
    _borderBottom = view.borderBottom;
    borderHorizontal = view.borderHorizontal;
    borderVertical = view.borderVertical;

    // VIEW BORDER RADIUS PROPERTIES
    borderRadius = view.borderRadius ?? 0;
    _borderRadiusBL = view.borderRadiusBL;
    _borderRadiusBR = view.borderRadiusBR;
    _borderRadiusTL = view.borderRadiusTL;
    _borderRadiusTL = view.borderRadiusTL;

    // VIEW SHADOW PROPERTIES
    shadowColor = view.shadowColor;
    shadow = view.shadow ?? 0;
    _shadowStart = view.shadowStart;
    _shadowEnd = view.shadowEnd;
    _shadowTop = view.shadowTop;
    _shadowBottom = view.shadowBottom;
    shadowHorizontal = view.shadowHorizontal;
    shadowVertical = view.shadowVertical;
    shadowBlurRadius = view.shadowBlurRadius ?? 5;
    shadowBlurStyle = view.shadowBlurStyle ?? BlurStyle.normal;
    shadowSpreadRadius = view.shadowSpreadRadius ?? 0;
    shadowType = view.shadowType ?? ViewShadowType.none;

    // VIEW DECORATION PROPERTIES
    _background = view.background;
    foreground = view.foreground;
    backgroundBlendMode = view.backgroundBlendMode;
    foregroundBlendMode = view.foregroundBlendMode;
    _backgroundGradient = view.backgroundGradient;
    foregroundGradient = view.foregroundGradient;
    _backgroundImage = view.backgroundImage;
    foregroundImage = view.foregroundImage;
    clipBehavior = view.clipBehavior ?? Clip.antiAlias;
    gravity = view.gravity;
    transform = view.transform;
    transformGravity = view.transformGravity;
    transform = view.transform;
    _position = view.position;
    positionType = view.positionType ?? ViewPositionType.none;
    shape = view.shape ?? ViewShape.rectangular;
    visibility = view.visibility ?? ViewVisibility.visible;
    child = view.child;

    // Properties
    roots = view.roots;

    // Value States
    backgroundState = view.backgroundState;
    backgroundImageState = view.backgroundImageState;
    backgroundGradientState = view.backgroundGradientState;

    // VIEW LISTENER PROPERTIES
    onClick = view.onClick;
    onDoubleClick = view.onDoubleClick;
    onLongClick = view.onLongClick;
    onClickHandler = view.onClickHandler;
    onDoubleClickHandler = view.onDoubleClickHandler;
    onLongClickHandler = view.onLongClickHandler;
    onToggle = view.onToggle;

    return this;
  }

  late BuildContext context;

  ViewRoots roots = const ViewRoots();

  ThemeData get theme => Theme.of(context);

  double elevation = 0;
  double _ripple = 0;

  Color? _background;
  Color? hoverColor;
  Color? pressedColor;
  Color _rippleColor = Colors.white;

  BlendMode? backgroundBlendMode;
  Gradient? _backgroundGradient;
  DecorationImage? _backgroundImage;

  ValueState<Color>? backgroundState;
  ValueState<Gradient>? backgroundGradientState;
  ValueState<DecorationImage>? backgroundImageState;

  double get ripple {
    if (_ripple > 0) {
      if (_ripple > 100) {
        return 100;
      } else {
        return _ripple;
      }
    } else {
      return 0;
    }
  }

  Color get rippleColor {
    return _rippleColor.withOpacity(ripple / 100);
  }

  set rippleColor(Color value) => _rippleColor = value;

  set background(Color? value) => _background = value;

  set backgroundGradient(Gradient? value) => _backgroundGradient = value;

  set backgroundImage(DecorationImage? value) => _backgroundImage = value;

  Color? get background =>
      backgroundState?.activated(activated, enabled) ?? _background;

  Gradient? get backgroundGradient =>
      backgroundGradientState?.activated(activated, enabled) ??
      _backgroundGradient;

  DecorationImage? get backgroundImage =>
      backgroundImageState?.activated(activated, enabled) ?? _backgroundImage;

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

  bool get isDimensional => roots.ratio && dimensionRatio > 0;

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

  double? get width => isSquire || isCircular ? maxSize : _width;

  double? _widthMax;

  double get widthMax => _widthMax ?? double.infinity;

  double? _widthMin;

  double get widthMin => _widthMin ?? 0.0;

  double? _height;

  double? get height => isSquire || isCircular ? maxSize : _height;

  double? _heightMax;

  double get heightMax => _heightMax ?? double.infinity;

  double? _heightMin;

  double get heightMin => _heightMin ?? 0.0;

  double margin = 0;

  double get marginAll => marginStart + marginEnd + marginTop + marginBottom;

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

  double get paddingAll =>
      paddingStart + paddingEnd + paddingTop + paddingBottom;

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

  OnViewToggleListener? _onToggleClick;

  OnViewToggleListener? get onToggle => enabled ? _onToggleClick : null;

  set onToggle(OnViewToggleListener? listener) => _onToggleClick ??= listener;

  OnViewNotifyListener? onClickHandler,
      onDoubleClickHandler,
      onLongClickHandler;

  OnViewNotifier? _onNotifier;

  bool get isHeight => height != null;

  bool get isObservable {
    return roots.observer &&
        (isClickable || isDoubleClickable || isLongClickable);
  }

  bool get isClickable =>
      onClick != null || onClickHandler != null || isToggleClickable;

  bool get isDoubleClickable =>
      onDoubleClick != null || onDoubleClickHandler != null;

  bool get isLongClickable => onLongClick != null || onLongClickHandler != null;

  bool get isRippled => roots.ripple && _ripple > 0 && isObservable;

  bool get isToggleClickable => onToggle != null;

  bool get isPositional {
    return roots.position &&
        (_position != null || positionType != ViewPositionType.none);
  }

  bool get isExpendable {
    return roots.flex && flex > 0;
  }

  bool get isBorder {
    final x = borderStart + borderEnd + borderTop + borderBottom;
    return roots.border && x > 0;
  }

  bool get isBorderRadius {
    final x =
        borderRadiusBLF + borderRadiusBRF + borderRadiusTLF + borderRadiusTRF;
    return roots.radius && x > 0;
  }

  bool get isMargin {
    return roots.margin && marginAll > 0;
  }

  bool get isMarginX {
    return roots.margin && (marginStart + marginEnd) > 0;
  }

  bool get isMarginY {
    return roots.margin && (marginTop + marginBottom) > 0;
  }

  bool get isPadding {
    return roots.padding && paddingAll > 0;
  }

  bool get isPaddingX {
    return roots.padding && (paddingStart + paddingEnd) > 0;
  }

  bool get isPaddingY {
    return roots.padding && (paddingTop + paddingBottom) > 0;
  }

  bool get isConstraints =>
      roots.constraints &&
      (_widthMax != null ||
          _widthMin != null ||
          _heightMax != null ||
          _heightMin != null);

  bool get isShadow {
    final x = shadowStart + shadowEnd + shadowTop + shadowBottom;
    return roots.shadow && (x > 0 || shadowType == ViewShadowType.overlay);
  }

  bool get isOverlayShadow =>
      roots.shadow && shadowType == ViewShadowType.overlay;

  bool get isCircular => roots.shape && shape == ViewShape.circular;

  bool get isRadius {
    var a = roots.radius;
    var b = !isCircular;
    var c = isBorderRadius;
    return a && b && c;
  }

  bool get isSquire {
    return shape == ViewShape.squire;
  }

  double get maxSize {
    return max(_width ?? 0, _height ?? 0);
  }

  double get minSize {
    return min(_width ?? 0, _height ?? 0);
  }

  void get _notify {
    if (_onNotifier != null) {
      _onNotifier?.call(() {});
    }
  }

  void setAbsorbMode(bool value) {
    absorbMode = value;
    _notify;
  }

  void setActivated(bool value) {
    activated = value;
    _notify;
  }

  void setAlignment(Alignment? value) {
    gravity = value;
    _notify;
  }

  void setAnimation(int value) {
    animation = value;
    _notify;
  }

  void setAnimationType(Curve value) {
    animationType = value;
    _notify;
  }

  void setBackground(Color? value) {
    _background = value;
    _notify;
  }

  void setBackgroundState(ValueState<Color>? value) {
    backgroundState = value;
    _notify;
  }

  void setBackgroundGradient(Gradient? value) {
    _backgroundGradient = value;
    _notify;
  }

  void setBackgroundGradientState(ValueState<Gradient>? value) {
    backgroundGradientState = value;
    _notify;
  }

  void setBackgroundBlendMode(BlendMode? value) {
    backgroundBlendMode = value;
    _notify;
  }

  void setBackgroundImage(DecorationImage? value) {
    _backgroundImage = value;
    _notify;
  }

  void setBackgroundImageState(ValueState<DecorationImage>? value) {
    backgroundImageState = value;
    _notify;
  }

  void setClipBehavior(Clip value) {
    clipBehavior = value;
    _notify;
  }

  void setDimensionRatio(double? value) {
    _dimensionRatio = value;
    _notify;
  }

  void setElevation(double value) {
    elevation = value;
    _notify;
  }

  void setForeground(Color? value) {
    foreground = value;
    _notify;
  }

  void setForegroundGradient(Gradient? value) {
    foregroundGradient = value;
    _notify;
  }

  void setForegroundBlendMode(BlendMode? value) {
    foregroundBlendMode = value;
    _notify;
  }

  void setForegroundImage(DecorationImage? value) {
    foregroundImage = value;
    _notify;
  }

  void setBorderColor(Color? value) {
    borderColor = value;
    _notify;
  }

  void setBorderGradient(Gradient? value) {
    borderGradient = value;
    _notify;
  }

  void setBorder(double value) {
    border = value;
    _notify;
  }

  void setBorderHorizontal(double? value) {
    borderHorizontal = value;
    _notify;
  }

  void setBorderVertical(double? value) {
    borderVertical = value;
    _notify;
  }

  void setBorderTop(double? value) {
    _borderTop = value;
    _notify;
  }

  void setBorderBottom(double? value) {
    _borderBottom = value;
    _notify;
  }

  void setBorderStart(double? value) {
    _borderStart = value;
    _notify;
  }

  void setBorderEnd(double? value) {
    _borderEnd = value;
    _notify;
  }

  void setBorderRadius(double value) {
    borderRadius = value;
    _notify;
  }

  void setBorderRadiusBL(double? value) {
    _borderRadiusBL = value;
    _notify;
  }

  void setBorderRadiusBR(double? value) {
    _borderRadiusBR = value;
    _notify;
  }

  void setBorderRadiusTL(double? value) {
    _borderRadiusTL = value;
    _notify;
  }

  void setBorderRadiusTR(double? value) {
    _borderRadiusTR = value;
    _notify;
  }

  void setChild(Widget? value) {
    child = value;
    _notify;
  }

  void setEnabled(bool value) {
    enabled = value;
    _notify;
  }

  void setFlex(int value) {
    flex = value;
    _notify;
  }

  void setWidth(double? value) {
    _width = value;
    _notify;
  }

  void setMaxWidth(double? value) {
    _widthMax = value;
    _notify;
  }

  void setMinWidth(double? value) {
    _widthMin = value;
    _notify;
  }

  void setHeight(double? value) {
    _height = value;
    _notify;
  }

  void setMaxHeight(double? value) {
    _heightMax = value;
    _notify;
  }

  void setMinHeight(double? value) {
    _heightMin = value;
    _notify;
  }

  void setMargin(double value) {
    margin = value;
    _notify;
  }

  void setMarginStart(double? value) {
    _marginStart = value;
    _notify;
  }

  void setMarginEnd(double? value) {
    _marginEnd = value;
    _notify;
  }

  void setMarginTop(double? value) {
    _marginTop = value;
    _notify;
  }

  void setMarginBottom(double? value) {
    _marginBottom = value;
    _notify;
  }

  void setMarginHorizontal(double? value) {
    marginHorizontal = value;
    _notify;
  }

  void setMarginVertical(double? value) {
    marginVertical = value;
    _notify;
  }

  void setPadding(double value) {
    padding = value;
    _notify;
  }

  void setPaddingStart(double? value) {
    _paddingStart = value;
    _notify;
  }

  void setPaddingEnd(double? value) {
    _paddingEnd = value;
    _notify;
  }

  void setPaddingTop(double? value) {
    _paddingTop = value;
    _notify;
  }

  void setPaddingBottom(double? value) {
    _paddingBottom = value;
    _notify;
  }

  void setPaddingHorizontal(double? value) {
    paddingHorizontal = value;
    _notify;
  }

  void setPaddingVertical(double? value) {
    paddingVertical = value;
    _notify;
  }

  void setPosition(ViewPosition? value) {
    _position = value;
    _notify;
  }

  void setPositionType(ViewPositionType value) {
    positionType = value;
    _notify;
  }

  void setTransform(Matrix4 value) {
    transform = value;
    _notify;
  }

  void setTransformAlignment(Alignment value) {
    transformGravity = value;
    _notify;
  }

  void setShadow(double value) {
    shadow = value;
    _notify;
  }

  void setShadowColor(Color value) {
    shadowColor = value;
    _notify;
  }

  void setShadowBlurRadius(double value) {
    shadowBlurRadius = value;
    _notify;
  }

  void setShadowBlurStyle(BlurStyle value) {
    shadowBlurStyle = value;
    _notify;
  }

  void setShadowSpreadRadius(double value) {
    shadowSpreadRadius = value;
    _notify;
  }

  void setShadowType(ViewShadowType value) {
    shadowType = value;
    _notify;
  }

  void setShadowHorizontal(double? value) {
    shadowHorizontal = value;
    _notify;
  }

  void setShadowVertical(double? value) {
    shadowVertical = value;
    _notify;
  }

  void setShadowStart(double? value) {
    _shadowStart = value;
    _notify;
  }

  void setShadowEnd(double? value) {
    _shadowEnd = value;
    _notify;
  }

  void setShadowTop(double? value) {
    _shadowTop = value;
    _notify;
  }

  void setShadowBottom(double? value) {
    _shadowBottom = value;
    _notify;
  }

  void setViewShape(ViewShape value) {
    shape = value;
    _notify;
  }

  void setVisibility(ViewVisibility value) {
    visibility = value;
    _notify;
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

  void setOnToggleClickListener(OnViewToggleListener listener) {
    _onToggleClick = listener;
  }

  void _setNotifier(OnViewNotifier? notifier) {
    _onNotifier = notifier;
  }

  void _onToggleNotify() {
    activated = !activated;
    onToggle?.call(activated);
    _notify;
  }

  void onNotify() => _notify;
}
