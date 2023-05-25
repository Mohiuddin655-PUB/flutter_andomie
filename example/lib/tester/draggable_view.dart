import 'package:flutter/material.dart';

class DraggableView extends StatefulWidget {
  final bool keepScreen;

  const DraggableView({
    Key? key,
    this.keepScreen = true,
  }) : super(key: key);

  @override
  State<DraggableView> createState() => _DraggableViewState();
}

class _DraggableViewState extends State<DraggableView> {
  Offset? _offset;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        children: [
          Positioned(
            left: _offset?.dx,
            top: _offset?.dy,
            child: LongPressDraggable(
              feedback: Container(
                width: 200,
                height: 200,
                color: Colors.green,
              ),
              child: Container(
                width: 200,
                height: 200,
                color: Colors.red,
              ),
              onDragEnd: (value) {
                print(value.offset);
                setState(() {
                  final size = MediaQuery.of(context).size;
                  final adjustment = size.height - constraints.maxHeight;
                  _offset = Offset(
                    value.offset.dx,
                    value.offset.dy - adjustment,
                  );
                });
              },
            ),
          ),
        ],
      );
    });
  }
}
