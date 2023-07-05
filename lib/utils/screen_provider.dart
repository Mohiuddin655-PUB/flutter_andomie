part of '../utils.dart';

class ScreenProvider<T> {
  void load({
    required BuildContext context,
    required OnScreenProviderListener<T> listener,
    required List<ScreenValue<T>> values,
  }) {
    if (values.isNotEmpty) {
      for (int index = 0; index < values.length; index++) {
        final ScreenValue<T> value = values[index];

        final event = Event<T>(context, value);

        if (value.validator) {
          if (listener.onSkip(event)) break;
        } else {
          if (listener.onHold(event)) break;
        }

        if (values.length == index + 1) listener.onDefault(context);
      }
    }
  }
}

abstract class OnScreenProviderListener<T> {
  void onDefault(BuildContext context) {}

  bool onSkip(Event<T> event) => false;

  bool onHold(Event<T> event);
}

class Event<T> {
  final BuildContext context;
  late T? route;

  Event(this.context, ScreenValue<T> result) {
    route = result.route;
  }
}

class ScreenValue<T> {
  final bool validator;
  final T? route;

  const ScreenValue(this.validator, this.route);
}
