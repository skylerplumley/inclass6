import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';

void main() {
  setupWindow();
  runApp(
// Provide the model to all widgets within the app. We're using
// ChangeNotifierProvider because that's a simple way to rebuild
// widgets when a model changes. We could also just use
// Provider, but then we would have to listen to Counter ourselves.
//
// Read Provider's docs to learn about all the available providers.
    ChangeNotifierProvider(
// Initialize the model in the builder. That way, Provider
// can own Counter's lifecycle, making sure to call `dispose`
// when not needed anymore.
      create: (context) => Counter(),
      child: const MyApp(),
    ),
  );
}

const double windowWidth = 360;
const double windowHeight = 640;

void setupWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    setWindowTitle('Provider Counter');
    setWindowMinSize(const Size(windowWidth, windowHeight));
    setWindowMaxSize(const Size(windowWidth, windowHeight));
    getCurrentScreen().then((screen) {
      setWindowFrame(Rect.fromCenter(
        center: screen!.frame.center,
        width: windowWidth,
        height: windowHeight,
      ));
    });
  }
}

/// Simplest possible model, with just one field.
///
/// [ChangeNotifier] is a class in `flutter:foundation`. [Counter] does
/// _not_ depend on Provider.
class Counter with ChangeNotifier {
  int age = 0;

  void increment() {
    age += 1;
    notifyListeners();
  }

  void decrement() {
    age -= 1;
    notifyListeners();
  }

  void setage(double ages) {
    age = ages.toInt();
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  Color backgroundchange(int age) {
    if (age <= 12) {
      return Colors.lightBlue;
    } else if (age <= 19) {
      return Colors.lime;
    } else if (age <= 30) {
      return Colors.yellow;
    } else if (age <= 50) {
      return Colors.orange;
    } else {
      return Colors.grey;
    }
  }

  Color slidercolor(int age) {
    if (age <= 33) {
      return Colors.green;
    } else if (age <= 67) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }

  String message(int age) {
    if (age <= 12) {
      return "You're a child!";
    } else if (age <= 19) {
      return "Teenager time!";
    } else if (age <= 30) {
      return "You're a young adult!";
    } else if (age <= 50) {
      return "You're an adult now!";
    } else {
      return "Golden years!";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Age Counter'),
        backgroundColor: Colors.blue,
      ),
      body: Consumer<Counter>(
        builder: (context, counter, child) => Container(
          color: backgroundchange(counter.age),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  message(counter.age),
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  'I am ${counter.age} years old',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 30),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FloatingActionButton.large(
                      onPressed: () => context.read<Counter>().increment(),
                      tooltip: 'Increase Age',
                      child: const Text('Increase Age'),
                    ),
                    const SizedBox(height: 30),
                    FloatingActionButton.large(
                      onPressed: () => context.read<Counter>().decrement(),
                      tooltip: 'Decrease Age',
                      child: const Text('Decrease Age'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Slider(
                  value: counter.age.toDouble(),
                  min: 0,
                  max: 99,
                  activeColor: slidercolor(counter.age),
                  onChanged: (value) {
                    context.read<Counter>().setage(value);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
