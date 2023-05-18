part of '../widgets.dart';

class StackLayout extends YMRView<StackLayoutController> {
  final Alignment? layoutGravity;

  final List<Widget>? children;

  const StackLayout({
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
    super.position,
    super.positionType,
    super.shape,
    super.child,
    super.onClick,
    super.onClickHandle,
    super.onDoubleClick,
    super.onDoubleClickHandle,
    super.onLongClick,
    super.onLongClickHandle,
    this.layoutGravity,
    this.children,
  }) : super(key: key);

  @override
  StackLayoutController attachController() {
    return StackLayoutController();
  }

  @override
  StackLayoutController initController(StackLayoutController controller) {
    return controller.attach(
      this,
      layoutGravity: layoutGravity,
      children: children,
    );
  }

  @override
  Widget? attach(BuildContext context, StackLayoutController controller) {
    return Stack(
      alignment: controller.layoutGravity,
      children: controller.children,
    );
  }
}

class StackLayoutController extends ViewController {
  Alignment layoutGravity = Alignment.center;
  List<Widget> children = [];

  @override
  StackLayoutController attach(
    YMRView<ViewController> view, {
    Alignment? layoutGravity,
    List<Widget>? children,
  }) {
    super.attach(view);
    this.layoutGravity = layoutGravity ?? this.layoutGravity;
    this.children = children ?? this.children;
    return this;
  }
}
