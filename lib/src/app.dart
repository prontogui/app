import 'package:flutter/material.dart';
import 'waiting_for_server_view.dart';
import 'background_view.dart';
import 'top_level_coordinator.dart';

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
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
