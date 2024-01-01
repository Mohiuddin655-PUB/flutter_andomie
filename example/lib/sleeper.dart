import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Application());
}

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sleeper',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  SleepingTimer sleeper = SleepingTimer(const Duration(seconds: 30, minutes: 1, hours: 25));
  Duration remainingDuration = Duration.zero;

  @override
  void initState() {
    sleeper.setOnCompleteListener(() {});
    sleeper.setOnRemainingListener((value) {
      setState(() => remainingDuration = value);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              remainingDuration.text,
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: sleeper.start,
                  child: const Text("Start"),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: sleeper.stop,
                  child: const Text("Stop"),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: sleeper.reset,
                  child: const Text("Restart"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
