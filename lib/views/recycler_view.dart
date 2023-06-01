part of '../widgets.dart';

class RecyclerView<T> extends YMRView<RecyclerViewController<T>> {
  final List<T> items;
  final Axis direction;
  final int? itemCount;
  final int snapCount;
  final OnViewChangeListener? onPagingListener;

  final RecyclerLayoutType layoutType;
  final Widget Function(int index, T item) builder;
  final Widget Function(int index, T item)? separator;
  final RecyclerScrollingType? scrollingType;
  final ScrollController? scrollController;

  const RecyclerView({
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
    required this.items,
    required this.builder,
    this.separator,
    this.direction = Axis.vertical,
    this.itemCount,
    this.snapCount = 1,
    this.layoutType = RecyclerLayoutType.linear,
    this.scrollingType,
    this.scrollController,
    this.onPagingListener,
  }) : super(key: key);

  @override
  RecyclerViewController<T> initController() {
    return RecyclerViewController<T>();
  }

  @override
  RecyclerViewController<T> attachController(
    RecyclerViewController<T> controller,
  ) {
    return controller.fromView(
      this,
      items: items,
      direction: direction,
      itemCount: itemCount,
      snapCount: snapCount,
      layoutType: layoutType,
      scrollingType: scrollingType,
      scrollController: scrollController,
      onPagingListener: onPagingListener,
    );
  }

  @override
  Widget? attach(BuildContext context, RecyclerViewController<T> controller) {
    return controller.visibility.isVisible
        ? controller.layoutType == RecyclerLayoutType.grid
            ? _Grid(
                controller: controller,
                builder: builder,
                separator: separator,
              )
            : _Linear(
                controller: controller,
                builder: builder,
                separator: separator,
              )
        : null;
  }

  @override
  void onDispose() {
    controller?._dispose();
    super.onDispose();
  }
}

class _Linear<T> extends StatelessWidget {
  final RecyclerViewController<T> controller;
  final Widget Function(int index, T item) builder;
  final Widget Function(int index, T item)? separator;

  const _Linear({
    Key? key,
    required this.controller,
    required this.builder,
    this.separator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return controller.direction == Axis.horizontal
        ? _Horizontal<T>(
            controller: controller,
            items: controller.items,
            itemCount: controller.itemCount,
            builder: builder,
            separator: separator,
          )
        : _Vertical<T>(
            controller: controller,
            items: controller.items,
            itemCount: controller.itemCount,
            builder: builder,
            separator: separator,
          );
  }
}

class _Grid<T> extends StatelessWidget {
  final RecyclerViewController<T> controller;
  final Widget Function(int index, T item) builder;
  final Widget Function(int index, T item)? separator;

  const _Grid({
    Key? key,
    required this.controller,
    required this.builder,
    this.separator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return controller.direction == Axis.horizontal
        ? _HorizontalGrid<T>(
            controller: controller,
            items: controller.gridItems,
            builder: builder,
            itemCount: controller.itemCount,
            snapCount: controller.snapCount,
          )
        : _VerticalGrid<T>(
            items: controller.gridItems,
            builder: builder,
            itemCount: controller.itemCount,
            snapCount: controller.snapCount,
          );
  }
}

class _Horizontal<T> extends StatelessWidget {
  final RecyclerViewController controller;
  final List<T> items;
  final int itemCount;

  final Widget Function(int index, T item) builder;
  final Widget Function(int index, T item)? separator;

  const _Horizontal({
    Key? key,
    required this.controller,
    required this.items,
    required this.builder,
    this.separator,
    required this.itemCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: controller.scrollController,
      scrollDirection: Axis.horizontal,
      physics: controller.scrollingType.physics,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: items.getRange(0, itemCount).map((item) {
          final index = items.indexOf(item);
          return _RecyclerViewBuilder(
            component: separator != null,
            builder: (value) {
              if (value) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    builder.call(
                      index,
                      item,
                    ),
                    _RecyclerViewBuilder(
                      component: items[itemCount - 1] != item,
                      builder: (value) {
                        if (value) {
                          return separator?.call(index, item);
                        } else {
                          return null;
                        }
                      },
                    ),
                  ],
                );
              } else {
                return builder.call(
                  index,
                  item,
                );
              }
            },
          );
        }).toList(),
      ),
    );
  }
}

class _HorizontalGrid<T> extends StatefulWidget {
  final RecyclerViewController controller;
  final List<RecyclerItem<T>> items;
  final int itemCount;
  final int snapCount;

  final Widget Function(int index, T item) builder;

  const _HorizontalGrid({
    Key? key,
    required this.controller,
    required this.items,
    required this.builder,
    required this.itemCount,
    required this.snapCount,
  }) : super(key: key);

  @override
  State<_HorizontalGrid<T>> createState() => _HorizontalGridState<T>();
}

class _HorizontalGridState<T> extends State<_HorizontalGrid<T>> {
  late int endIndex = (widget.itemCount / widget.snapCount).ceil();

  int index = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: widget.controller.scrollController,
      physics: widget.controller.scrollingType.physics,
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: widget.items.getRange(0, endIndex).map((item) {
          final end = index + (widget.snapCount);
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.items.getRange(index, end).map((item) {
              index++;
              return _RecyclerViewBuilder(
                component: !item.temporary && item.data != null,
                builder: (value) => value
                    ? widget.builder.call(
                        index,
                        item.data as T,
                      )
                    : null,
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }

  @override
  void didUpdateWidget(covariant _HorizontalGrid<T> oldWidget) {
    index = 0;
    super.didUpdateWidget(oldWidget);
  }
}

class _Vertical<T> extends StatelessWidget {
  final RecyclerViewController controller;
  final List<T> items;
  final int itemCount;

  final Widget Function(int index, T item) builder;
  final Widget Function(int index, T item)? separator;

  const _Vertical({
    Key? key,
    required this.controller,
    required this.items,
    required this.builder,
    this.separator,
    required this.itemCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: controller.scrollController,
      physics: controller.scrollingType.physics,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: items.getRange(0, itemCount).map((item) {
          final index = items.indexOf(item);
          return _RecyclerViewBuilder(
            component: separator != null,
            builder: (value) {
              if (value) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    builder.call(
                      index,
                      item,
                    ),
                    _RecyclerViewBuilder(
                      component: items[itemCount - 1] != item,
                      builder: (value) {
                        if (value) {
                          return separator?.call(index, item);
                        } else {
                          return null;
                        }
                      },
                    ),
                  ],
                );
              } else {
                return builder.call(
                  index,
                  item,
                );
              }
            },
          );
        }).toList(),
      ),
    );
  }
}

class _VerticalGrid<T> extends StatefulWidget {
  final List<RecyclerItem<T>> items;
  final int itemCount;
  final int snapCount;

  final Widget Function(int index, T item) builder;

  const _VerticalGrid({
    Key? key,
    required this.items,
    required this.builder,
    required this.itemCount,
    required this.snapCount,
  }) : super(key: key);

  @override
  State<_VerticalGrid<T>> createState() => _VerticalGridState<T>();
}

class _VerticalGridState<T> extends State<_VerticalGrid<T>> {
  late int endIndex = (widget.itemCount / widget.snapCount).ceil();

  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: widget.items.getRange(0, endIndex).map((item) {
        final end = index + (widget.snapCount);
        return Row(
          children: widget.items.getRange(index, end).map((item) {
            index++;
            return Expanded(
              child: _RecyclerViewBuilder(
                component: !item.temporary && item.data != null,
                builder: (value) => value
                    ? widget.builder.call(
                        index,
                        item.data as T,
                      )
                    : null,
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }

  @override
  void didUpdateWidget(covariant _VerticalGrid<T> oldWidget) {
    index = 0;
    super.didUpdateWidget(oldWidget);
  }
}

class RecyclerItem<T> {
  final T? data;
  final bool temporary;

  const RecyclerItem({
    this.data,
    this.temporary = false,
  });
}

enum RecyclerLayoutType { linear, grid }

enum RecyclerScrollingType {
  bouncing(physics: BouncingScrollPhysics()),
  page(physics: PageScrollPhysics()),
  none;

  final ScrollPhysics? physics;

  const RecyclerScrollingType({this.physics});
}

class _RecyclerViewBuilder<T> extends StatelessWidget {
  final T component;
  final Widget? Function(T value) builder;

  const _RecyclerViewBuilder({
    Key? key,
    required this.component,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return builder.call(component) ?? const SizedBox();
  }
}

class RecyclerViewController<T> extends ViewController {
  List<T> items = [];
  Axis direction = Axis.vertical;
  int? _itemCount;
  int snapCount = 1;
  RecyclerLayoutType layoutType = RecyclerLayoutType.linear;
  RecyclerScrollingType scrollingType = RecyclerScrollingType.none;

  OnViewChangeListener? onPagingListener;

  ScrollController _scrollController = ScrollController();

  ScrollController get scrollController {
    if (onPagingListener != null) {
      return _scrollController.paging(onListen: onPagingListener ?? (v) {});
    } else {
      return _scrollController;
    }
  }

  @override
  RecyclerViewController<T> fromView(
    YMRView<ViewController> view, {
    Axis? direction,
    List<T>? items,
    int? itemCount,
    int? snapCount,
    RecyclerLayoutType? layoutType,
    RecyclerScrollingType? scrollingType,
    OnViewChangeListener? onPagingListener,
    ScrollController? scrollController,
  }) {
    super.fromView(view);
    _itemCount = itemCount;
    this.items = items ?? [];
    this.direction = direction ?? Axis.vertical;
    this.layoutType = layoutType ?? RecyclerLayoutType.linear;
    this.snapCount = snapCount ?? 1;
    this.scrollingType = scrollingType ?? RecyclerScrollingType.none;
    this.onPagingListener = onPagingListener;
    _scrollController = scrollController ?? ScrollController();
    return this;
  }

  int get size => items.length;

  int get itemCount => min(_itemCount ?? (items.length + 1), size);

  int get missingCount {
    final line = (itemCount / snapCount).ceil();
    final require = line * snapCount;
    final missing = require - itemCount;
    return missing.abs();
  }

  List<RecyclerItem<T>> get gridItems {
    List<RecyclerItem<T>> list = [];
    if (items.isNotEmpty) {
      list = items
          .getRange(0, itemCount)
          .map((e) => RecyclerItem(data: e))
          .toList();
      if (missingCount > 0) {
        for (int i = 0; i < missingCount; i++) {
          list.add(RecyclerItem<T>(temporary: true));
        }
      }
    }
    return list;
  }

  T? getItem(int index) => size > 0 && size > index ? items[index] : null;

  ScrollController paging({required Function() func}) {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels != 0) {
          func.call();
        }
      }
    });
    return scrollController;
  }

  void setItem(T value, [int? index]) {
    if (index != null && items.length >= index) {
      items.insert(index, value);
    } else {
      items.add(value);
    }
  }

  void removeItem(T? item) {
    if (item != null) {
      items.remove(item);
      _notify;
    }
  }

  void removeAt(int index) {
    if (index >= 0 && index < items.length) {
      items.removeAt(index);
      _notify;
    }
  }

  void setItems(List<T> value) {
    items = value;
    _notify;
  }

  void setDirection(Axis value) {
    direction = value;
    _notify;
  }

  void setItemCount(int value) {
    _itemCount = value;
    _notify;
  }

  void setSnapCount(int value) {
    snapCount = value;
    _notify;
  }

  void setRecyclerType(RecyclerLayoutType value) {
    layoutType = value;
    _notify;
  }

  void _dispose() {
    scrollController.dispose();
  }
}
