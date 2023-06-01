part of '../widgets.dart';

typedef OnPageChangeListener = void Function(int index);

class ViewPager extends YMRView<ViewPagerController> {
  final OnPageChangeListener? onPageChange;
  final List<Widget> items;

  const ViewPager({
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
    this.items = const [],
    this.onPageChange,
  });

  @override
  ViewPagerController initController() => ViewPagerController();

  @override
  ViewPagerController attachController(ViewPagerController controller) {
    return controller.fromView(
      this,
      items: items,
      onPageChange: onPageChange,
    );
  }

  @override
  Widget? attach(BuildContext context, ViewPagerController controller) {
    return PageView.builder(
      scrollDirection: controller.orientation,
      onPageChanged: controller.onPageChange,
      controller: controller.pager,
      itemCount: controller.size,
      itemBuilder: (context, index) {
        return controller.items[index];
      },
    );
  }
}

class ViewPagerController extends ViewController {
  int index = 0;
  Axis orientation = Axis.horizontal;
  List<Widget> items = [];
  late PageController pager;
  late TabController tab;
  OnPageChangeListener? onPageChange;

  ViewPagerController() {
    pager = PageController(initialPage: 0);
  }

  @override
  ViewPagerController fromView(
    YMRView<ViewController> view, {
    List<Widget>? items,
    OnPageChangeListener? onPageChange,
  }) {
    super.fromView(view);
    this.items = items ?? [];
    this.onPageChange = onPageChange;
    return this;
  }

  int get size => items.length;

  void setOnPageChangeListener(OnPageChangeListener listener) {
    onPageChange = listener;
  }
}
