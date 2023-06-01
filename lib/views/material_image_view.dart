part of '../widgets.dart';

typedef MIVFrameRatioBuilder = double? Function(MIVLayer layer);

enum MIVLayer {
  singleLayer,
  doubleLayer,
  tripleLayer,
  fourthLayer,
  fifthLayer,
  sixthLayer,
  multipleLayer;

  factory MIVLayer.from(int size) {
    if (size == 1) {
      return MIVLayer.singleLayer;
    } else if (size == 2) {
      return MIVLayer.doubleLayer;
    } else if (size == 3) {
      return MIVLayer.tripleLayer;
    } else if (size == 4) {
      return MIVLayer.fourthLayer;
    } else if (size == 5) {
      return MIVLayer.fifthLayer;
    } else if (size == 6) {
      return MIVLayer.sixthLayer;
    } else {
      return MIVLayer.multipleLayer;
    }
  }
}

class MaterialImageView<T extends Object>
    extends YMRView<MaterialImageViewController<T>> {
  final double? frameRatio;
  final MIVFrameRatioBuilder? frameRatioBuilder;
  final Color? itemBackground;
  final double? itemSpace;
  final ImageType? itemType;
  final List<T>? items;
  final dynamic placeholder;
  final ImageType? placeholderType;

  const MaterialImageView({
    Key? key,
    super.controller,
    super.width,
    super.height,
    super.background,
    super.borderRadius,
    super.borderRadiusTL,
    super.borderRadiusTR,
    super.borderRadiusBL,
    super.borderRadiusBR,
    super.padding,
    super.paddingHorizontal,
    super.paddingVertical,
    super.paddingTop,
    super.paddingBottom,
    super.paddingStart,
    super.paddingEnd,
    super.margin,
    super.marginHorizontal,
    super.marginVertical,
    super.marginTop,
    super.marginBottom,
    super.marginStart,
    super.marginEnd,
    super.visibility,
    this.frameRatio,
    this.frameRatioBuilder,
    this.itemBackground,
    this.itemSpace,
    this.itemType,
    this.items,
    this.placeholder,
    this.placeholderType,
  }) : super(key: key);

  @override
  MaterialImageViewController<T> initController() {
    return MaterialImageViewController<T>();
  }

  @override
  MaterialImageViewController<T> attachController(
    MaterialImageViewController<T> controller,
  ) {
    return controller.fromView(
      this,
      frameRatio: frameRatio,
      frameBuilder: frameRatioBuilder,
      itemBackground: itemBackground,
      itemSpace: itemSpace,
      itemType: itemType,
      items: items,
      placeholder: placeholder,
      placeholderType: placeholderType,
    );
  }

  @override
  Widget? attach(
    BuildContext context,
    MaterialImageViewController<T> controller,
  ) {
    switch (controller.layer) {
      case MIVLayer.singleLayer:
        return _MIVSingleLayer<T>(controller: controller);
      case MIVLayer.doubleLayer:
        return _MIVDoubleLayer<T>(controller: controller);
      case MIVLayer.tripleLayer:
        return _MIVTripleLayer<T>(controller: controller);
      case MIVLayer.fourthLayer:
        return _MIVFourthLayer<T>(controller: controller);
      case MIVLayer.fifthLayer:
        return _MIVFifthLayer<T>(controller: controller);
      case MIVLayer.sixthLayer:
        return _MIVSixthLayer<T>(controller: controller);
      case MIVLayer.multipleLayer:
        return _MIVMultiLayer<T>(controller: controller);
    }
  }
}

class _MIVSingleLayer<T> extends StatelessWidget {
  final MaterialImageViewController<T> controller;

  const _MIVSingleLayer({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return controller.isRational
        ? _MIVBuilder(
            controller: controller,
            image: controller.items[0],
            dimension: controller.ratio,
          )
        : _MIVBuilder(
            controller: controller,
            image: controller.items[0],
            maxHeight: 500,
            resizable: true,
          );
  }
}

class _MIVDoubleLayer<T> extends StatelessWidget {
  final MaterialImageViewController<T> controller;

  const _MIVDoubleLayer({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: controller.frameRatio ?? 3 / 1.8,
      child: Flex(
        direction: Axis.horizontal,
        children: [
          _MIVBuilder(
            controller: controller,
            image: controller.items[0],
            flexible: true,
          ),
          SizedBox(
            width: controller.spaceBetween,
          ),
          _MIVBuilder(
            controller: controller,
            image: controller.items[1],
            flexible: true,
          ),
        ],
      ),
    );
  }
}

class _MIVTripleLayer<T> extends StatelessWidget {
  final MaterialImageViewController<T> controller;

  const _MIVTripleLayer({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: controller.frameRatio ?? 3 / 2.2,
      child: Flex(
        direction: Axis.horizontal,
        children: [
          _MIVBuilder(
            controller: controller,
            image: controller.items[0],
            dimension: 0.8,
          ),
          SizedBox(
            width: controller.spaceBetween,
          ),
          Expanded(
            child: Flex(
              direction: Axis.vertical,
              children: [
                _MIVBuilder(
                  controller: controller,
                  image: controller.items[1],
                  flexible: true,
                ),
                SizedBox(
                  height: controller.spaceBetween,
                ),
                _MIVBuilder(
                  controller: controller,
                  image: controller.items[2],
                  flexible: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MIVFourthLayer<T> extends StatelessWidget {
  final MaterialImageViewController<T> controller;

  const _MIVFourthLayer({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: controller.frameRatio ?? 1,
      child: Flex(
        direction: Axis.vertical,
        children: [
          Expanded(
            child: Flex(
              direction: Axis.horizontal,
              children: [
                _MIVBuilder(
                  controller: controller,
                  dimension: 1,
                  image: controller.items[0],
                ),
                SizedBox(
                  width: controller.spaceBetween,
                ),
                _MIVBuilder(
                  controller: controller,
                  dimension: 1,
                  image: controller.items[1],
                ),
              ],
            ),
          ),
          SizedBox(
            height: controller.spaceBetween,
          ),
          Expanded(
            child: Flex(
              direction: Axis.horizontal,
              children: [
                _MIVBuilder(
                  controller: controller,
                  dimension: 1,
                  image: controller.items[2],
                ),
                SizedBox(
                  width: controller.spaceBetween,
                ),
                _MIVBuilder(
                  controller: controller,
                  dimension: 1,
                  image: controller.items[3],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MIVFifthLayer<T> extends StatelessWidget {
  final MaterialImageViewController<T> controller;

  const _MIVFifthLayer({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: controller.frameRatio ?? 1,
      child: Flex(
        direction: Axis.vertical,
        children: [
          Expanded(
            child: Flex(
              direction: Axis.horizontal,
              children: [
                _MIVBuilder(
                  controller: controller,
                  image: controller.items[0],
                  flexible: true,
                ),
                SizedBox(
                  width: controller.spaceBetween,
                ),
                _MIVBuilder(
                  controller: controller,
                  image: controller.items[1],
                  flexible: true,
                ),
              ],
            ),
          ),
          SizedBox(
            height: controller.spaceBetween,
          ),
          Expanded(
            child: Flex(
              direction: Axis.horizontal,
              children: [
                _MIVBuilder(
                  controller: controller,
                  image: controller.items[2],
                  flexible: true,
                ),
                SizedBox(
                  width: controller.spaceBetween,
                ),
                _MIVBuilder(
                  controller: controller,
                  image: controller.items[3],
                  flexible: true,
                ),
                SizedBox(
                  width: controller.spaceBetween,
                ),
                _MIVBuilder(
                  controller: controller,
                  image: controller.items[4],
                  flexible: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MIVSixthLayer<T> extends StatelessWidget {
  final MaterialImageViewController<T> controller;

  const _MIVSixthLayer({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: controller.frameRatio ?? 1,
      child: Flex(
        direction: Axis.vertical,
        children: [
          Expanded(
            child: Flex(
              direction: Axis.horizontal,
              children: [
                _MIVBuilder(
                  controller: controller,
                  image: controller.items[0],
                  flexible: true,
                ),
                SizedBox(
                  width: controller.spaceBetween,
                ),
                _MIVBuilder(
                  controller: controller,
                  image: controller.items[1],
                  flexible: true,
                ),
                SizedBox(
                  width: controller.spaceBetween,
                ),
                _MIVBuilder(
                  controller: controller,
                  image: controller.items[2],
                  flexible: true,
                ),
              ],
            ),
          ),
          SizedBox(
            height: controller.spaceBetween,
          ),
          Expanded(
            child: Flex(
              direction: Axis.horizontal,
              children: [
                _MIVBuilder(
                  controller: controller,
                  image: controller.items[3],
                  flexible: true,
                ),
                SizedBox(
                  width: controller.spaceBetween,
                ),
                _MIVBuilder(
                  controller: controller,
                  image: controller.items[4],
                  flexible: true,
                ),
                SizedBox(
                  width: controller.spaceBetween,
                ),
                _MIVBuilder(
                  controller: controller,
                  image: controller.items[5],
                  flexible: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MIVMultiLayer<T> extends StatelessWidget {
  final MaterialImageViewController<T> controller;

  const _MIVMultiLayer({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: controller.frameRatio ?? 1,
      child: Flex(
        direction: Axis.vertical,
        children: [
          Expanded(
            child: Flex(
              direction: Axis.horizontal,
              children: [
                _MIVBuilder(
                  controller: controller,
                  image: controller.items[0],
                  flexible: true,
                ),
                SizedBox(
                  width: controller.spaceBetween,
                ),
                _MIVBuilder(
                  controller: controller,
                  image: controller.items[1],
                  flexible: true,
                ),
                SizedBox(
                  width: controller.spaceBetween,
                ),
                _MIVBuilder(
                  controller: controller,
                  image: controller.items[2],
                  flexible: true,
                ),
              ],
            ),
          ),
          SizedBox(
            height: controller.spaceBetween,
          ),
          Expanded(
            child: Flex(
              direction: Axis.horizontal,
              children: [
                _MIVBuilder(
                  controller: controller,
                  image: controller.items[3],
                  flexible: true,
                ),
                SizedBox(
                  width: controller.spaceBetween,
                ),
                _MIVBuilder(
                  controller: controller,
                  image: controller.items[4],
                  flexible: true,
                ),
                SizedBox(
                  width: controller.spaceBetween,
                ),
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        _MIVBuilder(
                          controller: controller,
                          image: controller.items[5],
                        ),
                        TextView(
                          width: double.infinity,
                          height: double.infinity,
                          gravity: Alignment.center,
                          text: "+${controller.invisibleItemSize}",
                          textColor: Colors.white,
                          textSize: 24,
                          fontWeight: FontWeight.bold,
                          background: Colors.black.withOpacity(0.35),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MIVBuilder<T> extends StatelessWidget {
  final MaterialImageViewController<T> controller;
  final double? maxHeight;
  final T image;
  final double? dimension;
  final bool flexible, resizable;

  const _MIVBuilder({
    Key? key,
    required this.controller,
    required this.image,
    this.flexible = false,
    this.resizable = false,
    this.maxHeight,
    this.dimension,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ImageView(
      dimensionRatio: dimension,
      flex: flexible ? 1 : null,
      width: double.infinity,
      height: resizable ? null : double.infinity,
      heightMax: maxHeight,
      background: controller.itemBackground,
      image: image,
      imageType: controller.imageType,
      placeholder: controller.placeholder,
      placeholderType: controller.placeholderType,
      scaleType: BoxFit.cover,
    );
  }
}

class MaterialImageViewController<T> extends ViewController {
  double? frameRatio;
  MIVFrameRatioBuilder? frameRatioBuilder;
  Color? itemBackground;
  double spaceBetween = 4;
  ImageType? imageType;
  List<T> items = [];
  dynamic placeholder;
  ImageType? placeholderType;

  @override
  MaterialImageViewController<T> fromView(
    YMRView<ViewController> view, {
    double? frameRatio,
    MIVFrameRatioBuilder? frameBuilder,
    Color? itemBackground,
    double? itemSpace,
    ImageType? itemType,
    List<T>? items,
    dynamic placeholder,
    ImageType? placeholderType,
  }) {
    super.fromView(view);
    this.frameRatio = frameRatio;
    this.frameRatioBuilder = frameBuilder;
    this.itemBackground = itemBackground;
    this.spaceBetween = itemSpace ?? 4;
    this.imageType = itemType;
    this.items = items ?? [];
    this.placeholder = placeholder;
    this.placeholderType = placeholderType;
    return this;
  }

  bool get isRational => ratio > 0;

  int get invisibleItemSize => items.length - 5;

  int get itemSize => items.length;

  double get ratio {
    return frameRatioBuilder?.call(MIVLayer.from(itemSize)) ?? frameRatio ?? 0;
  }

  MIVLayer get layer => MIVLayer.from(itemSize);
}
