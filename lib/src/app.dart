import 'package:flutter/material.dart';
import 'waiting_for_server_view.dart';
import 'background_view.dart';
import 'top_level_coordinator.dart';

class App extends StatelessWidget {
  // Build for the local scenario, i.e., a model is hosted locally.
  App.local({super.key}) : devWidget = null {
    _builder = _buildForLocal;
  }

  // Build for the remote scenario, i.e., a model is served by a remote process
  // or server program.
  App.remote({super.key}) : devWidget = null {
    _builder = _buildForRemote;
  }

  // Build for the alternate development scenario, i.e., we are using the App
  // to develop or debug a new embodiment.
  App.altdev1({super.key}) : devWidget = null {
    _builder = _buildForAltdev1;
  }

  // Build for the alternate development scenario, i.e., we are using the App
  // to develop or debug a new embodiment.
  App.altdev2({super.key, required this.devWidget}) {
    _builder = _buildForAltdev2;
  }

  // The builder function to call based on constructed scenario.
  late Widget Function(BuildContext) _builder;

  // For alt-dev 2, the widget we are developing or debugging.
  final Widget? devWidget;

  @override
  Widget build(BuildContext context) {
    return _builder(context);
  }

  // This widget is the root of your application.
  Widget _buildForLocal(BuildContext context) {
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
  }

  // This widget is the root of your application.
  Widget _buildForRemote(BuildContext context) {
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

  // This widget is the root of your application.
  Widget _buildForAltdev1(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: '<Alt Dev 1>',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const BackgroundView(),
    );
  }

  // This widget is the root of your application.
  Widget _buildForAltdev2(BuildContext context) {
    buildDevContainer(Widget devWidget) {
      return Expanded(
          child: Container(
              color: Colors.blueGrey,
              child: Center(
                  child: SizedBox(width: 400, height: 50, child: devWidget))));
    }

    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: '<Alt Dev 2>',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(body: buildDevContainer(devWidget!)),
    );
  }
}
