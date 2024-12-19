import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: LazyNotifierExample(),
    );
  }
}

class LazyNotifierExample extends StatefulWidget {
  const LazyNotifierExample({super.key});

  @override
  State<LazyNotifierExample> createState() => _LazyNotifierExampleState();
}

class _LazyNotifierExampleState extends State<LazyNotifierExample> {
  void _updateCounter() {
    final previousValue = LazyNotifier.value<int>("counter_notifier") ?? 0;
    LazyNotifier.notify("counter_notifier", value: previousValue + 1);
  }

  @override
  void dispose() {
    LazyNotifier.kill("counter_notifier");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lazy Notifier Example"),
      ),
      body: const Center(
        child: CounterWidget(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _updateCounter,
        child: const Icon(Icons.ads_click, color: Colors.white),
      ),
    );
  }
}

class CounterWidget extends StatelessWidget {
  const CounterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LazyNotifier.of("counter_notifier"),
      builder: (context, child) {
        final counter = LazyNotifier.value<int>("counter_notifier");
        return Text(
          counter.toString(),
          style: const TextStyle(
            fontSize: 80,
            fontWeight: FontWeight.bold,
          ),
        );
      },
    );
  }
}
