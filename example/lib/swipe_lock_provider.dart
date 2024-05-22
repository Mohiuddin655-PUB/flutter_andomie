import 'package:flutter/material.dart';
import 'package:flutter_andomie/utils/swipe_lock_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences _kPreferences;

// Mock implementations for reader and writer
int? mockReader(String key) {
  return _kPreferences.getInt(key);
}

void mockWriter(String key, int value) {
  _kPreferences.setInt(key, value);
}

void main() async {
  _kPreferences = await SharedPreferences.getInstance();
  SwipeLockProvider.init(
    times: 5,
    lockoutDuration: const Duration(hours: 8),
    reader: mockReader,
    writer: mockWriter,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SwipeLockExample(),
    );
  }
}

class SwipeLockExample extends StatefulWidget {
  const SwipeLockExample({super.key});

  @override
  State<SwipeLockExample> createState() => _SwipeLockExampleState();
}

class _SwipeLockExampleState extends State<SwipeLockExample> {
  @override
  void initState() {
    super.initState();
    SwipeLockProvider.i.addListener(_onLockChanged);
  }

  @override
  void dispose() {
    SwipeLockProvider.i.removeListener(_onLockChanged);
    SwipeLockProvider.i.dispose();
    super.dispose();
  }

  void _onLockChanged() {
    setState(() {});
  }

  void _handleSwipe() {
    SwipeLockProvider.i.swipe();
  }

  void _handleReset() {
    SwipeLockProvider.i.reset();
  }

  @override
  Widget build(BuildContext context) {
    bool isLocked = SwipeLockProvider.i.isLocked;
    Duration remaining = SwipeLockProvider.i.remaining;

    return Scaffold(
      appBar: AppBar(title: const Text('Swipe Lock Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              isLocked
                  ? 'Locked! Remaining time: ${remaining.inMinutes} minutes'
                  : 'You can swipe!',
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLocked ? null : _handleSwipe,
              child: const Text('Swipe'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handleReset,
              child: const Text('Reset'),
            ),
          ],
        ),
      ),
    );
  }
}
