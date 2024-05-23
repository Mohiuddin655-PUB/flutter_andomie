import 'package:flutter_andomie/utils/index_provider.dart';

void main() {
  print("Auto element index provider");
  IndexProvider.init(5);
  for (int i = 0; i < 15; i++) {
    print((
      IndexProvider.i.index,
      IndexProvider.i.indexAsReverse,
    ));
  }

  print("\nCustom elements index provider");
  IndexProvider.init(10, name: "custom");
  for (int i = 0; i < 15; i++) {
    print((
      IndexProvider.indexOf("custom"),
      IndexProvider.indexAsReverseOf("custom"),
    ));
  }

  final items = [1, 2, 3, 4, 5];

  print("\nAuto element finder using extension");
  for (int i = 0; i < 15; i++) {
    print((
      items.autoElement,
      items.autoElementAsReverse,
    ));
  }

  final numbers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
  print("\nCustom element finder using extension");
  for (int i = 0; i < 15; i++) {
    print((
      numbers.getElement("numbers"),
      numbers.getElementAsReverse("numbers"),
    ));
  }
}
