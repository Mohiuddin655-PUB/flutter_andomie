part of '../widgets.dart';

enum FlexPosition {
  centerX(left: 0, right: 0),
  centerY(top: 0, bottom: 0),
  start(left: 0, top: 0, bottom: 0),
  end(right: 0, top: 0, bottom: 0),
  above(top: 0, left: 0, right: 0),
  down(bottom: 0, left: 0, right: 0);

  final double? top, bottom, left, right;

  const FlexPosition({
    this.top,
    this.bottom,
    this.left,
    this.right,
  });
}

enum FlexVisibleType { front, back }

class FlexibleView extends YMRView<FlexibleViewController> {
  final Widget? flexible;
  final FlexPosition flexPosition;
  final FlexVisibleType type;

  const FlexibleView({
    Key? key,
    super.controller,
    super.flex,
    super.dimensionRatio,
    super.width,
    super.height,
    super.background,
    super.borderRadius = 0,
    super.borderRadiusTL,
    super.borderRadiusTR,
    super.borderRadiusBL,
    super.borderRadiusBR,
    super.padding = 0,
    super.paddingHorizontal,
    super.paddingVertical,
    super.paddingTop,
    super.paddingBottom,
    super.paddingStart,
    super.paddingEnd,
    super.margin = 0,
    super.marginHorizontal,
    super.marginVertical,
    super.marginTop,
    super.marginBottom,
    super.marginStart,
    super.marginEnd,
    super.visibility = true,
    super.child,
    this.flexible,
    this.flexPosition = FlexPosition.start,
    this.type = FlexVisibleType.front,
  }) : super(key: key);

  @override
  FlexibleViewController attachController() {
    return FlexibleViewController();
  }

  @override
  FlexibleViewController initController(FlexibleViewController controller) {
    return controller.attach(
      this,
      flexible: flexible,
      flexPosition: flexPosition,
      visibleType: type,
    );
  }

  @override
  Widget? attach(BuildContext context, FlexibleViewController controller) {
    return StackLayout(
      layoutGravity: Alignment.center,
      children: [
        controller.isBack
            ? Positioned(
                left: controller.flexPosition.left,
                right: controller.flexPosition.right,
                top: controller.flexPosition.top,
                bottom: controller.flexPosition.bottom,
                child: controller.flexible,
              )
            : controller.child,
        controller.isFront
            ? Positioned(
                left: controller.flexPosition.left,
                right: controller.flexPosition.right,
                top: controller.flexPosition.top,
                bottom: controller.flexPosition.bottom,
                child: controller.flexible,
              )
            : controller.child,
      ],
    );
  }
}

class FlexibleViewController extends ViewController {
  Widget flexible = const SizedBox();
  FlexPosition flexPosition = FlexPosition.start;
  FlexVisibleType visibleType = FlexVisibleType.front;

  @override
  Widget get child => super.child ?? const SizedBox();

  bool get isBack => visibleType == FlexVisibleType.back;

  bool get isFront => visibleType == FlexVisibleType.front;

  @override
  FlexibleViewController attach(
    YMRView<ViewController> view, {
    Widget? flexible,
    FlexPosition? flexPosition,
    FlexVisibleType? visibleType,
  }) {
    super.attach(view);
    this.flexible = flexible ?? this.flexible;
    this.flexPosition = flexPosition ?? this.flexPosition;
    this.visibleType = visibleType ?? this.visibleType;
    return this;
  }
}
