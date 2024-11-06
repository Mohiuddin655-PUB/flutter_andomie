import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';

class RapidClickTester extends StatefulWidget {
  const RapidClickTester({super.key});

  @override
  State<RapidClickTester> createState() => _RapidClickTesterState();
}

class _RapidClickTesterState extends State<RapidClickTester> {
  int counter = 0;

  void callback(bool rapid) {
    log(rapid ? "RAPID_CLICK" : "NORMAL_CLICK");
    setState(() => counter = RapidClick.count);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          counter.toString(),
          style: const TextStyle(
            fontSize: 80,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => RapidClick.click(callback),
        child: const Icon(Icons.ads_click, color: Colors.white),
      ),
    );
  }
}
