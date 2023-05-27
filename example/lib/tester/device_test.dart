import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_andomie/widgets.dart';

class DeviceConfigTest extends StatelessWidget {
  const DeviceConfigTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var config = SizeConfig(context);
    print("Device : ${config.deviceType}");
    return const RawTextView(
      text: "Device Type",
      textColor: Colors.black,
    );
  }
}
