import 'package:flutter/material.dart';
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
            icon: Icons.add,
            iconSize: 18,
            expended: true,
            text: "Click",
            borderRadius: 24,
            onClick: (c){

            },
          ),
          ToggleButton(
            width: 120,
            icon: Icons.add,
            iconSize: 18,
            expended: true,
            text: "Click",
            borderRadius: 24,
            onClick: (c){

            },
          ),
        ],
      ),
    );
  }
}
