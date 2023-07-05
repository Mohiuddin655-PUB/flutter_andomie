part of 'helpers.dart';

class DialogHelper {
  final BuildContext context;

  const DialogHelper(this.context);
}

abstract class OnValueChangeListener<T> {
  void onChange(T t);
}
