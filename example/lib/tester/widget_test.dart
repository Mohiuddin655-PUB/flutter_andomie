import 'package:flutter/material.dart';
import 'package:flutter_andomie/views/button.dart';
import 'package:flutter_andomie/widgets.dart';

class ViewTest extends StatelessWidget {
  const ViewTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          Button(
            width: 120,
            height: 40,
            background: Colors.red,
            rippleColor: Colors.blue,
            icon: Icons.add,
            iconSize: 18,
            text: "Click",
            onClick: (c){

            },
          ),
          IconView(
            activated: true,
            size: 40,
            backgroundState: ValueState.active(
              inactivated: Colors.redAccent,
              activated: Colors.green,
            ),
            iconState: ValueState.active(
              inactivated: Icons.remove,
              activated: Icons.add,
            ),
            tint: Colors.white,
            pressedColor: Colors.amber.withAlpha(150),
            onClick: (c) {
              print(c);
            },
            onToggleClick: (v){
              print(v);
            },
          ),
          YMRView(
            width: 100,
            height: 40,
            borderRadius: 12,
            background: Colors.redAccent,
            backgroundState: ValueState.active(
              inactivated: Colors.redAccent,
              activated: Colors.green,
            ),
            // splashColor: Colors.green,
            // hoverColor: Colors.yellow,
            pressedColor: Colors.amber.withAlpha(150),
            rippleColor: Colors.transparent,
            onToggleClick: (c) {},
            onClick: (c) {
              print(c);
            },
          ),
          YMRView(
            width: 100,
            height: 40,
            background: Colors.grey,
            pressedColor: Colors.amber.withAlpha(150),
            onClick: (c) {
              print(c);
            },
          ),
          const YMRView(
            width: 100,
            height: 40,
            background: Colors.grey,
          ),
          const YMRView(
            width: 100,
            height: 40,
            background: Colors.grey,
          ),
        ],
      ),
    );
  }
}
