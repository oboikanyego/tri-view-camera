import 'package:flutter/material.dart';
import '../features/cameras/data/simulated_camera_adapter.dart';
import '../features/cameras/presentation/camera_dashboard.dart';

class TriViewApp extends StatelessWidget {
  const TriViewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tri View Camera',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: CameraDashboard(adapter: SimulatedCameraAdapter()),
    );
  }
}
