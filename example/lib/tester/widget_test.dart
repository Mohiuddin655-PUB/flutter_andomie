import 'package:flutter/material.dart';
import 'package:flutter_andomie/widgets.dart';

class ViewTest extends StatelessWidget {
  const ViewTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextView(
            text: "Text",
          ),
          Button(
            icon: Icons.add,
            iconSize: 18,
            iconSpace: 0,
            text: "Click",
            borderRadius: 24,
            enabled: true,
            ripple: 20,
            iconColorEnabled: false,
            activated: false,
            onClick: (c) {
              print(c);
            },
          ),
          Button(
            marginTop: 12,
            icon: Icons.add,
            iconSize: 18,
            width: 200,
            text: "Google",
            centerText: false,
            borderRadius: 50,
            onClick: (c) {},
          ),
        ],
      ),
    );
  }
}
