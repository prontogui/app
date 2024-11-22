import 'package:flutter/material.dart';
import 'waiting_for_server_view.dart';
import 'background_view.dart';
import 'top_level_coordinator.dart';

class App extends StatelessWidget {
  const App.local({super.key}) : _isLocal = true;
  const App.remote({super.key}) : _isLocal = false;

  final bool _isLocal;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    if (_isLocal) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ProntoGUI Editor',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const TopLevelCoordinator(
          backgroundView: BackgroundView(),
        ),
      );
    } else {
      return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'ProntoGUI',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const WaitingForServerView(
            operatingView: TopLevelCoordinator(
              backgroundView: BackgroundView(),
            ),
          ));
    }
  }
}
