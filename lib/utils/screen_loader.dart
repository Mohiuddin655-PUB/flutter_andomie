import 'package:flutter/material.dart';

import 'singleton.dart';

abstract class OnScreenLoaderInterface<T> {
  void onDefault(BuildContext context) {}

  void onHold(ScreenLoaderEvent<T> event);

  void onSkip(ScreenLoaderEvent<T> event) {}
}

mixin OnScreenLoaderMixin<T> implements OnScreenLoaderInterface<T> {
  @override
  void onDefault(BuildContext context) {}

  @override
  void onSkip(ScreenLoaderEvent event) {}
}

class ScreenLoader<T> {
  final BuildContext context;
  final bool holdable;
  final OnScreenLoaderMixin<T> mixin;
  final List<ScreenLoaderItem<T>> loaders;

  const ScreenLoader._({
    required this.context,
    this.holdable = true,
    required this.mixin,
    required this.loaders,
  });

  static ScreenLoader<T> getInstance<T>({
    required BuildContext context,
    bool holdable = true,
    required OnScreenLoaderMixin<T> mixin,
    required List<ScreenLoaderItem<T>> loaders,
  }) {
    return Singleton.instanceOf(() {
      return ScreenLoader<T>._(
        context: context,
        holdable: holdable,
        mixin: mixin,
        loaders: loaders,
      );
    });
  }

  Future call([BuildContext? context]) async {
    if (loaders.isNotEmpty) {
      for (int index = 0; index < loaders.length; index++) {
        ScreenLoaderItem<T> loader = loaders[index];

        ScreenLoaderEvent<T> event = ScreenLoaderEvent(
          context ?? this.context,
          loader.value,
        );

        if (await loader.validation(context ?? this.context)) {
          mixin.onHold(event);
          if (holdable) break;
        } else {
          mixin.onSkip(event);
        }
        if (loaders.length == index + 1) {
          mixin.onDefault(context ?? this.context);
        }
      }
    } else {
      mixin.onDefault(context ?? this.context);
    }
  }

  void load([BuildContext? context]) => call(context);
}

class ScreenLoaderEvent<T> {
  final BuildContext context;
  final T value;

  const ScreenLoaderEvent(this.context, this.value);
}

class ScreenLoaderItem<T> {
  final T value;
  final Future<bool> Function(BuildContext context) validation;

  const ScreenLoaderItem({
    required this.value,
    required this.validation,
  });
}
