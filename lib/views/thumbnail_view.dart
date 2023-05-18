part of '../widgets.dart';

class ThumbnailView extends YMRView<ThumbnailViewController> {
  final dynamic placeholder;
  final ImageType? placeholderType;
  final String? url;
  final BoxFit? scaleType;

  const ThumbnailView({
    Key? key,
    super.controller,
    super.dimensionRatio = 4 / 3,
    super.background,
    super.foreground,
    super.borderRadius,
    super.borderRadiusBL,
    super.borderRadiusBR,
    super.borderRadiusTL,
    super.borderRadiusTR,
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
    super.gravity,
    this.placeholder,
    this.placeholderType,
    this.url,
    this.scaleType,
  }) : super(key: key);

  @override
  ThumbnailViewController attachController() {
    return ThumbnailViewController();
  }

  @override
  ThumbnailViewController initController(ThumbnailViewController controller) {
    return controller.attach(
      this,
      placeholder: placeholder,
      placeholderType: placeholderType,
      scaleType: scaleType,
      url: url,
    );
  }

  @override
  Widget? attach(BuildContext context, ThumbnailViewController controller) {
    return StackLayout(
      width: double.infinity,
      height: double.infinity,
      layoutGravity: controller.gravity ?? Alignment.center,
      children: [
        ImageView(
          width: double.infinity,
          height: double.infinity,
          borderRadius: controller.borderRadius,
          scaleType: controller.scaleType,
          foreground: controller.foreground,
          placeholder: controller.placeholder,
          placeholderType: controller.placeholderType,
          imageType: ImageType.network,
          image: controller.url,
        ),
        FloatingActionButton(
          backgroundColor: Colors.black.withOpacity(0.65),
          splashColor: Colors.transparent,
          elevation: 0,
          onPressed: () => onClick?.call(context),
          child: const RawIcon(
            icon: Icons.play_arrow_rounded,
            size: 32,
            tint: Colors.white,
          ),
        ),
      ],
    );
  }
}

class ThumbnailViewController extends ViewController {
  dynamic placeholder;
  ImageType placeholderType = ImageType.asset;
  String? url;
  BoxFit? scaleType;

  @override
  ThumbnailViewController attach(
    YMRView<ViewController> view, {
    dynamic placeholder,
    ImageType? placeholderType,
    BoxFit? scaleType,
    String? url,
  }) {
    super.attach(view);
    this.placeholder = placeholder ?? this.placeholder;
    this.placeholderType = placeholderType ?? this.placeholderType;
    this.scaleType = scaleType ?? this.scaleType;
    this.url = url ?? this.url;
    return this;
  }
}
