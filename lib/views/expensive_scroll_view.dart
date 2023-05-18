part of '../widgets.dart';

enum ScrollingType {
  always(physics: AlwaysScrollableScrollPhysics()),
  bouncing(physics: BouncingScrollPhysics()),
  clamping(physics: ClampingScrollPhysics()),
  fixed(physics: FixedExtentScrollPhysics()),
  never(physics: NeverScrollableScrollPhysics()),
  page(physics: PageScrollPhysics()),
  range(physics: RangeMaintainingScrollPhysics()),
  none;

  final ScrollPhysics? physics;

  const ScrollingType({this.physics});
}

class ExpensiveScrollView extends YMRView<ExpensiveScrollViewController> {
  final Axis? orientation;
  final ScrollingType? scrollingType;

  const ExpensiveScrollView({
    Key? key,
    super.controller,
    super.flex,
    super.activated,
    super.enabled,
    super.visibility,
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
    super.onDoubleClick,
    super.onLongClick,
    super.child,
    this.orientation,
    this.scrollingType,
  }) : super(key: key);

  @override
  ExpensiveScrollViewController attachController() {
    return ExpensiveScrollViewController();
  }

  @override
  ExpensiveScrollViewController initController(
      ExpensiveScrollViewController controller) {
    return controller.attach(
      this,
      orientation: orientation,
      scrollingType: scrollingType,
    );
  }

  @override
  Widget build(
    BuildContext context,
    ExpensiveScrollViewController controller,
    Widget parent,
  ) {
    return SingleChildScrollView(
      physics: controller.scrollingType.physics,
      scrollDirection: controller.orientation,
      child: parent,
    );
  }
}

class ExpensiveScrollViewController extends ViewController {
  Axis orientation = Axis.vertical;
  ScrollingType scrollingType = ScrollingType.none;

  @override
  ExpensiveScrollViewController attach(
    YMRView<ViewController> view, {
    Axis? orientation,
    ScrollingType? scrollingType,
  }) {
    super.attach(view);
    this.orientation = orientation ?? this.orientation;
    this.scrollingType = scrollingType ?? this.scrollingType;
    return this;
  }
}
