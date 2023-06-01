part of '../widgets.dart';

typedef SIVIndexing<T> = bool Function(T item);
typedef SIVCounterBuilder<T> = Widget Function(
  BuildContext context,
  int index,
  T item,
);
typedef SIVChangedHandler<T> = Function(
  int index,
  T item,
);

class SlideImageView<T> extends YMRView<SlideImageViewController<T>> {
  final double? frameRatio;
  final Color? itemBackground;
  final BoxFit? itemScaleType;
  final ImageType? itemType;
  final List<T>? items;
  final dynamic placeholder;
  final ImageType? placeholderType;
  final SIVChangedHandler<T>? changedHandler;
  final SIVCounterBuilder<T>? counterBuilder;
  final ViewPositionType? counterPosition;
  final bool? counterVisibility;
  final int? selectionIndex;
  final SIVIndexing<T>? selectionIndexBuilder;

  const SlideImageView({
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
    super.child,
    this.frameRatio,
    this.itemBackground,
    this.itemScaleType,
    this.itemType,
    this.items,
    this.placeholder,
    this.placeholderType,
    this.changedHandler,
    this.counterBuilder,
    this.counterPosition,
    this.counterVisibility,
    this.selectionIndex,
    this.selectionIndexBuilder,
  }) : super(key: key);

  @override
  SlideImageViewController<T> initController() {
    return SlideImageViewController<T>();
  }

  @override
  SlideImageViewController<T> attachController(
    SlideImageViewController<T> controller,
  ) {
    return controller.fromView(
      this,
      counterBuilder: counterBuilder,
      counterPosition: counterPosition,
      counterVisibility: counterVisibility,
      frameRatio: frameRatio,
      itemBackground: itemBackground,
      itemScaleType: itemScaleType,
      itemType: itemType,
      items: items,
      placeholder: placeholder,
      placeholderType: placeholderType,
      selectionIndex: selectionIndex,
      selectionIndexBuilder: selectionIndexBuilder,
    );
  }

  @override
  Widget? attach(BuildContext context, SlideImageViewController<T> controller) {
    return _SIVChild(controller: controller);
  }
}

class _SIVChild<T> extends StatefulWidget {
  final SlideImageViewController<T> controller;

  const _SIVChild({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<_SIVChild<T>> createState() => _SIVChildState<T>();
}

class _SIVChildState<T> extends State<_SIVChild<T>> {
  late PageController pager;
  late TextViewController counter;
  late SlideImageViewController<T> controller;

  @override
  void initState() {
    controller = widget.controller;
    pager = controller.pager;
    counter = controller.counter;
    super.initState();
  }

  @override
  void dispose() {
    controller._dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final index = controller.index;
    final items = controller.items;
    final size = controller.size;
    return AspectRatio(
      aspectRatio: 1,
      child: StackLayout(
        width: double.infinity,
        height: double.infinity,
        layoutGravity: Alignment.center,
        children: [
          PageView.builder(
            controller: pager,
            itemCount: size,
            itemBuilder: (context, index) {
              final item = items[index];
              return ImageView(
                width: double.infinity,
                height: double.infinity,
                scaleType: controller.itemScaleType,
                placeholder: controller.placeholder,
                placeholderType: controller.placeholderType,
                image: item,
                imageType: controller.itemType,
              );
            },
            onPageChanged: (index) {
              if (controller.changedHandler != null) {
                controller.changedHandler?.call(index, items[index]);
              }
              if (controller.counterBuilder != null) {
                controller._setCounterNotifier(index);
              } else {
                counter.setText(controller.countingTextBuilder(
                  index + 1,
                  size,
                ));
              }
            },
          ),
          YMRView(
            visibility: controller.counterVisibility
                ? ViewVisibility.visible
                : ViewVisibility.gone,
            positionType: controller.counterPosition,
            child: controller.counterBuilder != null
                ? ViewNotifier(
                    controller: controller.notifyCounter,
                    onNotify: (context) {
                      return controller.counterBuilder?.call(
                        context,
                        controller.index,
                        controller.item,
                      );
                    },
                  )
                : TextView(
                    gravity: Alignment.center,
                    controller: counter,
                    background: Colors.black.withOpacity(0.75),
                    borderRadius: 25,
                    margin: 12,
                    paddingVertical: 8,
                    paddingHorizontal: 12,
                    text: controller.countingTextBuilder(index + 1, size),
                    textColor: Colors.white,
                    textSize: 12,
                    maxLines: 1,
                    visibility:
                        size > 1 ? ViewVisibility.visible : ViewVisibility.gone,
                  ),
          ),
        ],
      ),
    );
  }
}

class SlideImageViewController<T> extends ViewController {
  late PageController pager;
  late TextViewController counter;
  late NotifierViewController notifyCounter;

  double? frameRatio;
  Color? itemBackground;
  BoxFit itemScaleType = BoxFit.cover;
  ImageType itemType = ImageType.detect;
  List<T> items = [];
  dynamic placeholder;
  ImageType placeholderType = ImageType.detect;
  SIVChangedHandler<T>? changedHandler;
  SIVCounterBuilder<T>? counterBuilder;
  ViewPositionType counterPosition = ViewPositionType.topEnd;
  bool counterVisibility = true;
  int selectionIndex = 0;
  SIVIndexing<T>? selectionIndexBuilder;

  int index = 0;

  @override
  SlideImageViewController<T> fromView(
    YMRView<ViewController> view, {
    SIVChangedHandler<T>? changedHandler,
    SIVCounterBuilder<T>? counterBuilder,
    ViewPositionType? counterPosition,
    bool? counterVisibility,
    double? frameRatio,
    Color? itemBackground,
    BoxFit? itemScaleType,
    ImageType? itemType,
    List<T>? items,
    dynamic placeholder,
    ImageType? placeholderType,
    int? selectionIndex,
    SIVIndexing<T>? selectionIndexBuilder,
  }) {
    this.changedHandler = changedHandler;
    this.counterBuilder = counterBuilder;
    this.counterPosition = counterPosition ?? ViewPositionType.topEnd;
    this.counterVisibility = counterVisibility ?? true;
    this.frameRatio = frameRatio;
    this.itemBackground = itemBackground;
    this.itemScaleType = itemScaleType ?? BoxFit.cover;
    this.itemType = itemType ?? ImageType.detect;
    this.items = items ?? [];
    this.placeholder = placeholder;
    this.placeholderType = placeholderType ?? ImageType.detect;
    this.selectionIndex = selectionIndex ?? 0;
    this.selectionIndexBuilder = selectionIndexBuilder;
    this.index = _selectionIndex;
    this.pager = PageController(initialPage: index);
    this.counter = TextViewController();
    this.notifyCounter = NotifierViewController();
    super.fromView(view);
    return this;
  }

  T get item => items[index];

  int get _selectionIndex {
    var value = selectionIndex;
    if (selectionIndexBuilder != null) {
      value = items.indexWhere((item) {
        return selectionIndexBuilder?.call(item) ?? false;
      });
    }
    return value > -1 && value < size ? value : 0;
  }

  int get size => items.length;

  void _setCounterNotifier(int value) {
    index = value;
    notifyCounter.onNotify();
  }

  String countingTextBuilder(
    int current,
    int total, [
    String separator = "/",
  ]) {
    return "$current$separator$total";
  }

  void _dispose() {
    pager.dispose();
  }
}
