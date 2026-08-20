import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  debugPrint('main');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Basic Seminar',
      theme: ThemeData(colorSchemeSeed: Colors.blue),
      home: const CounterPage(),
    );
  }
}

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _counter = 0;

  String get _buildMode {
    if (kDebugMode) return 'Debug';
    if (kProfileMode) return 'Profile';
    if (kReleaseMode) return 'Release';
    return 'Unknown';
  }

  @override
  void initState() {
    super.initState();
    debugPrint('initState');
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Basic Seminar')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/flutter_logo.png',
              width: 160,
            ),
            const SizedBox(height: 24),
            Text('Current mode: $_buildMode'),
            const SizedBox(height: 8),
            const Text('Current Count'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
