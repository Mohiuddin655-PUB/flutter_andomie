part of '../widgets.dart';

class LinearLayout extends YMRView<LinearLayoutController> {
  final Axis? orientation;
  final bool? scrollable;
  final LayoutGravity? layoutGravity;
  final MainAxisAlignment? mainGravity;
  final CrossAxisAlignment? crossGravity;
  final LayoutScrollingType? scrollingType;
  final ScrollController? scrollController;
  final OnViewChangeListener? onPagingListener;

  final List<Widget>? children;

  const LinearLayout({
    super.key,
    super.controller,
    super.animation,
    super.animationType,
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
    super.child,
    super.onClick,
    super.onClickHandle,
    super.onDoubleClick,
    super.onDoubleClickHandle,
    super.onLongClick,
    super.onLongClickHandle,
    this.onPagingListener,
    this.layoutGravity,
    this.orientation,
    this.mainGravity,
    this.crossGravity,
    this.scrollable,
    this.scrollingType,
    this.scrollController,
    this.children,
  });

  @override
  LinearLayoutController attachController() {
    return LinearLayoutController();
  }

  @override
  LinearLayoutController initController(LinearLayoutController controller) {
    return controller.attach(
      this,
      crossGravity: crossGravity,
      mainGravity: mainGravity,
      layoutGravity: layoutGravity,
      orientation: orientation,
      scrollable: scrollable,
      scrollingType: scrollingType,
      scrollController: scrollController,
      onPagingListener: onPagingListener,
      children: children,
    );
  }

  @override
  Widget build(
    BuildContext context,
    LinearLayoutController controller,
    Widget parent,
  ) {
    return controller.scrollable
        ? SingleChildScrollView(
            controller: controller.scrollController,
            physics: controller.scrollingType.physics,
            scrollDirection: controller.orientation,
            child: parent,
          )
        : parent;
  }

  @override
  Widget? attach(BuildContext context, LinearLayoutController controller) {
    return controller.orientation == Axis.vertical
        ? Column(
            mainAxisAlignment: controller.mainGravity,
            crossAxisAlignment: controller.crossGravity,
            children: controller.children,
          )
        : Row(
            mainAxisAlignment: controller.mainGravity,
            crossAxisAlignment: controller.crossGravity,
            children: controller.children,
          );
  }
}

class LinearLayoutController extends ViewController {
  Axis orientation = Axis.vertical;
  LayoutGravity layoutGravity = LayoutGravity.start;
  MainAxisAlignment? _mainGravity;
  CrossAxisAlignment? _crossGravity;
  bool scrollable = false;
  LayoutScrollingType scrollingType = LayoutScrollingType.none;
  ScrollController _scrollController = ScrollController();
  List<Widget> children = [];

  OnViewChangeListener? onPagingListener;

  @override
  LinearLayoutController attach(
    YMRView<ViewController> view, {
    Axis? orientation,
    LayoutGravity? layoutGravity,
    MainAxisAlignment? mainGravity,
    CrossAxisAlignment? crossGravity,
    bool? scrollable,
    LayoutScrollingType? scrollingType,
    ScrollController? scrollController,
    List<Widget>? children,
    OnViewChangeListener? onPagingListener,
  }) {
    super.attach(view);
    this.orientation = orientation ?? Axis.vertical;
    this.layoutGravity = layoutGravity ?? LayoutGravity.start;
    _mainGravity = mainGravity;
    _crossGravity = crossGravity;
    this.scrollable = scrollable ?? false;
    this.scrollingType = scrollingType ?? LayoutScrollingType.none;
    _scrollController = scrollController ?? ScrollController();
    this.children = children ?? [];
    this.onPagingListener = onPagingListener;
    return this;
  }

  MainAxisAlignment get mainGravity => _mainGravity ?? layoutGravity.main;

  CrossAxisAlignment get crossGravity => _crossGravity ?? layoutGravity.cross;

  ScrollController get scrollController {
    if (onPagingListener != null) {
      return _scrollController.paging(onListen: onPagingListener ?? (v) {});
    } else {
      return _scrollController;
    }
  }
}

enum LayoutGravity {
  center(
    main: MainAxisAlignment.center,
    cross: CrossAxisAlignment.center,
  ),
  end(
    main: MainAxisAlignment.end,
    cross: CrossAxisAlignment.end,
  ),
  start(
    main: MainAxisAlignment.start,
    cross: CrossAxisAlignment.start,
  ),
  spaceAround(
    main: MainAxisAlignment.spaceAround,
    cross: CrossAxisAlignment.center,
  ),
  spaceBetween(
    main: MainAxisAlignment.spaceBetween,
    cross: CrossAxisAlignment.center,
  ),
  spaceEvenly(
    main: MainAxisAlignment.spaceEvenly,
    cross: CrossAxisAlignment.center,
  ),
  baseline(
    main: MainAxisAlignment.center,
    cross: CrossAxisAlignment.baseline,
  ),
  stretch(
    main: MainAxisAlignment.center,
    cross: CrossAxisAlignment.stretch,
  ),
  centerVertical(
    main: MainAxisAlignment.center,
    cross: CrossAxisAlignment.start,
  ),
  centerHorizontal(
    main: MainAxisAlignment.start,
    cross: CrossAxisAlignment.center,
  );

  final MainAxisAlignment main;
  final CrossAxisAlignment cross;

  const LayoutGravity({
    required this.main,
    required this.cross,
  });
}

enum LayoutScrollingType {
  bouncing(physics: BouncingScrollPhysics()),
  page(physics: PageScrollPhysics()),
  none;

  final ScrollPhysics? physics;

  const LayoutScrollingType({this.physics});
}
