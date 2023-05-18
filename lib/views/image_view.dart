part of '../widgets.dart';

enum ImageType {
  unknown,
  detect,
  asset,
  file,
  memory,
  network;

  factory ImageType.from(dynamic data, [ImageType type = ImageType.detect]) {
    if (type == ImageType.detect || type == ImageType.unknown) {
      if (data is String) {
        if (data.startsWith('assets/')) {
          return ImageType.asset;
        } else if (data.startsWith('https://') || data.startsWith('http://')) {
          return ImageType.network;
        } else {
          return ImageType.unknown;
        }
      } else if (data is File) {
        return ImageType.file;
      } else if (data is Uint8List) {
        return ImageType.memory;
      } else {
        return ImageType.unknown;
      }
    } else {
      return type;
    }
  }
}

class ImageView<T extends ImageViewController> extends YMRView<T> {
  final bool? cacheMode;
  final dynamic image;
  final ImageType? imageType;
  final dynamic placeholder;
  final ImageType? placeholderType;
  final BoxFit? scaleType;

  const ImageView({
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
    super.position,
    super.positionType,
    super.shadowType,
    super.shape,
    super.child,
    super.onClick,
    super.onDoubleClick,
    super.onLongClick,
    this.cacheMode,
    this.placeholder,
    this.placeholderType,
    this.scaleType,
    this.image,
    this.imageType,
  }) : super(key: key);

  @override
  T attachController() {
    return ImageViewController() as T;
  }

  @override
  T initController(T controller) => controller.attach(
        this,
        cacheMode: cacheMode,
        placeholder: placeholder,
        placeholderType: placeholderType,
        scaleType: scaleType,
        image: image,
        imageType: imageType,
      ) as T;

  @override
  Widget? attach(BuildContext context, T controller) => RawImage(
        width: controller.width,
        height: controller.height,
        cacheMode: controller.cacheMode,
        image: controller.image,
        imageType: controller.type,
        scaleType: controller.scaleType,
      );
}

class ImageViewController extends ViewController {
  bool cacheMode = true;
  dynamic _image;
  ImageType _imageType = ImageType.detect;
  dynamic placeholder;
  ImageType _placeholderType = ImageType.detect;
  BoxFit? scaleType;

  @override
  ImageViewController attach(
    YMRView<ViewController> view, {
    bool? cacheMode,
    dynamic image,
    ImageType? imageType,
    dynamic placeholder,
    ImageType? placeholderType,
    BoxFit? scaleType,
  }) {
    super.attach(view);
    this.cacheMode = cacheMode ?? this.cacheMode;
    this.placeholder = placeholder ?? this.placeholder;
    this.scaleType = scaleType ?? this.scaleType;
    _image = image ?? _image;
    _imageType = imageType ?? _imageType;
    _placeholderType = placeholderType ?? _placeholderType;
    return this;
  }

  dynamic get image => isPlaceholder ? placeholder : _image;

  ImageType get type => isPlaceholder ? placeholderType : imageType;

  bool get isPlaceholder {
    final data = _image;
    final x = data is String ? data.isEmpty : false;
    final y = imageType == ImageType.detect || imageType == ImageType.unknown;
    return x || y;
  }

  ImageType get imageType => ImageType.from(_image, _imageType);

  ImageType get placeholderType =>
      ImageType.from(placeholder, _placeholderType);
}

class RawImage extends StatelessWidget {
  final dynamic image;
  final ImageType imageType;
  final double? width, height;
  final BoxFit? scaleType;
  final bool cacheMode;

  const RawImage({
    Key? key,
    this.width,
    this.height,
    this.cacheMode = true,
    this.image,
    this.imageType = ImageType.detect,
    this.scaleType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final type = ImageType.from(image, imageType);
    if (type == ImageType.asset) {
      return Image.asset(
        "$image",
        width: width,
        height: height,
        fit: scaleType,
      );
    } else if (type == ImageType.network) {
      if (cacheMode) {
        return CachedNetworkImage(
          imageUrl: "$image",
          width: width,
          height: height,
          fit: scaleType,
        );
      } else {
        return Image.network(
          "$image",
          width: width,
          height: height,
          fit: scaleType,
        );
      }
    } else if (type == ImageType.file) {
      return Image.file(
        image,
        width: width,
        height: height,
        fit: scaleType,
      );
    } else if (type == ImageType.memory) {
      return Image.memory(
        image,
        width: width,
        height: height,
        fit: scaleType,
      );
    } else {
      return SizedBox(
        width: width,
        height: height,
      );
    }
  }
}
