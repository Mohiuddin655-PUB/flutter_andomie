import 'package:flutter/material.dart';

import 'singleton.dart';

abstract class OnScreenLoaderInterface<T> {
  void onDefault(BuildContext context) {}

  void onHold(ProviderEvent<T> event);

  void onSkip(ProviderEvent<T> event) {}
}

mixin OnScreenLoaderMixin<T> implements OnScreenLoaderInterface<T> {
  @override
  void onDefault(BuildContext context) {}

  @override
  void onSkip(ProviderEvent event) {}
}

class ScreenLoader<T> {
  final BuildContext context;
  final bool holdable;
  final OnScreenLoaderMixin<T> mixin;
  final List<Loader<T>> loaders;

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
    required List<Loader<T>> loaders,
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
        Loader<T> loader = loaders[index];

        ProviderEvent<T> event = ProviderEvent(
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

class ProviderEvent<T> {
  final BuildContext context;
  final T value;

  const ProviderEvent(this.context, this.value);
}

class Loader<T> {
  final T value;
  final Future<bool> Function(BuildContext context) validation;

  const Loader({
    required this.value,
    required this.validation,
  });
}
