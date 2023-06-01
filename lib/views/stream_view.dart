part of '../widgets.dart';

class StreamView<T> extends YMRView<StreamViewController> {
  final Stream<T> stream;
  final OnViewBuilder<T> builder;

  const StreamView({
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
    super.onClick,
    super.onClickHandler,
    super.onDoubleClick,
    super.onDoubleClickHandler,
    super.onLongClick,
    super.onLongClickHandler,
    required this.stream,
    required this.builder,
  });

  @override
  StreamViewController initController() {
    return StreamViewController();
  }

  @override
  StreamViewController attachController(StreamViewController controller) {
    return controller.fromView(this);
  }

  @override
  Widget? attach(BuildContext context, StreamViewController controller) {
    return StreamBuilder(
      stream: stream,
      builder: (context, state) => builder(
        context,
        state.data,
      ),
    );
  }
}

class StreamViewController extends ViewController {
  @override
  StreamViewController fromView(
    YMRView<ViewController> view,
  ) {
    super.fromView(view);
    return this;
  }
}
