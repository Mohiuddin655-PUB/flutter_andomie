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
          Button(
            icon: "assets/icons/ic_google.svg",
            //iconSize: 24,
            height: 50,
            width: double.infinity,
            iconSpace: 0,
            paddingVertical: 8,
            iconAlignment: IconAlignment.end,
            text: "Click",
            borderRadius: 24,
            paddingHorizontal: 24,
            ripple: 20,
            textSize: 24,
            iconColorEnabled: false,
            centerText: true,
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
