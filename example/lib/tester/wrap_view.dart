import 'package:example/tester/draggable_view.dart';
import 'package:flutter/material.dart';

class WrapViewTest extends StatelessWidget {
  const WrapViewTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const WrapView(
      items: [
        "",
        "",
      ],
    );
  }
}

class WrapView<T> extends StatelessWidget {
  final List<T> items;

  const WrapView({
    Key? key,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //return const DraggableView();
    var size = MediaQuery.of(context).size;
    return Flex(
      direction: Axis.vertical,
      children: <Widget>[
        Flexible(
          flex: 1,
          child: Container(
            color: Colors.red,
            height: 100,
          ),
        ),
        Flexible(
          flex: 2,
          child: Container(
            color: Colors.blue,
            height: 100,
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            color: Colors.green,
            height: 100,
          ),
        ),
      ],
    );
  }
}
