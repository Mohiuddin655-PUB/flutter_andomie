import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';

void main() async {
  /// SEPARATOR:
  /// '/'=> home/profile/details
  /// '>'=> home>profile>details
  RouteManager.separator = '/';

  /// FILTER:
  /// filter mode=> //home/profile/details///
  /// normal mode=> home/profile/details
  RouteManager.allowFilter = true;

  /// MULTIPLE:
  /// enabled=> home/details/details/details
  /// disabled=> home/details
  RouteManager.allowMultiple = true;
  // RouteManager.ignorableRoutes = ['/notification']; // OPTIONAL
  // RouteManager.supportedRoutes = ['/home', 'profile']; // OPTIONAL
  // RouteManager.initialRoutes = 'home/'; // OPTIONAL
  RouteManager.listen((value) {
    log("ROUTE_MANAGER: $value");
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: "/main",
      routes: {
        '/main': (context) => const Home(),
        "/details": (context) => const DetailsPage(),
      },
      navigatorObservers: [RouteMonitor()],
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  int currentIndex = 0;

  void _change(int index) {
    final previous = ['home', 'notification', 'profile'][currentIndex];
    final current = ['home', 'notification', 'profile'][index];
    RouteManager.replace(current, previous);
    setState(() => currentIndex = index);
  }

  @override
  void initState() {
    super.initState();
    RouteManager.push("home");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ROUTE MANAGER"),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: _change,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: "Notification",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
      body: IndexedStack(
        index: currentIndex,
        children: List.generate(3, (index) {
          return Center(
            child: Text(
              "TAB-${index + 1}\n${RouteManager.routes}",
              textAlign: TextAlign.center,
            ),
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/details'),
        child: const Icon(Icons.ads_click, color: Colors.white),
      ),
    );
  }
}

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Details Page"),
      ),
      body: Container(
        padding: const EdgeInsets.all(32),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "DETAILS\n${RouteManager.routes}",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/details'),
              child: const Text("See details"),
            ),
          ],
        ),
      ),
    );
  }
}
