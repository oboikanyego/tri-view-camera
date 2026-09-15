import 'package:flutter/material.dart';
import '../domain/camera_adapter.dart';
import '../domain/camera_models.dart';

class CameraSettingsScreen extends StatefulWidget {
  const CameraSettingsScreen({super.key, required this.camera, required this.adapter});
  final CameraDevice camera;
  final CameraAdapter adapter;
  @override State<CameraSettingsScreen> createState() => _CameraSettingsScreenState();
}

class _CameraSettingsScreenState extends State<CameraSettingsScreen> {
  late CameraSettings settings = widget.camera.settings;
  bool saving = false;
  @override Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(widget.camera.name)),
    body: ListView(padding: const EdgeInsets.all(16), children: [
      DropdownButtonFormField<String>(value: settings.resolution, decoration: const InputDecoration(labelText: 'Resolution'), items: ['1280x720','1920x1080'].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(), onChanged: (v) => setState(() => settings = settings.copyWith(resolution: v))),
      const SizedBox(height: 12),
      DropdownButtonFormField<int>(value: settings.fps, decoration: const InputDecoration(labelText: 'Frame rate'), items: [24,30,60].map((v) => DropdownMenuItem(value: v, child: Text('$v FPS'))).toList(), onChanged: (v) => setState(() => settings = settings.copyWith(fps: v))),
      const SizedBox(height: 12),
      Text('Zoom ${settings.zoom.toStringAsFixed(1)}x'),
      Slider(value: settings.zoom, min: 1, max: 4, divisions: 30, onChanged: (v) => setState(() => settings = settings.copyWith(zoom: v))),
      Text('Exposure ${settings.exposure.toStringAsFixed(1)}'),
      Slider(value: settings.exposure, min: -2, max: 2, divisions: 20, onChanged: (v) => setState(() => settings = settings.copyWith(exposure: v))),
      const SizedBox(height: 12),
      FilledButton(onPressed: saving ? null : () async { setState(() => saving = true); final updated = await widget.adapter.updateSettings(widget.camera, settings); if (context.mounted) Navigator.pop(context, updated); }, child: Text(saving ? 'Saving…' : 'Save settings')),
    ]),
  );
}
