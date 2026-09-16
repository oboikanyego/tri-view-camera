import 'package:flutter/material.dart';
import '../domain/calibration_profile.dart';
import '../domain/camera_models.dart';

class CalibrationScreen extends StatefulWidget {
  const CalibrationScreen({
    super.key,
    required this.cameras,
    this.initialProfiles = const <String, CameraCalibrationProfile>{},
  });

  final List<CameraDevice> cameras;
  final Map<String, CameraCalibrationProfile> initialProfiles;

  @override
  State<CalibrationScreen> createState() => _CalibrationScreenState();
}

class _CalibrationScreenState extends State<CalibrationScreen> {
  late final Map<String, CameraCalibrationProfile> profiles = {
    for (final camera in widget.cameras)
      camera.id: widget.initialProfiles[camera.id] ?? const CameraCalibrationProfile(),
  };

  void _update(String id, CameraCalibrationProfile profile) {
    setState(() => profiles[id] = profile);
  }

  void _save() {
    Navigator.pop(context, Map<String, CameraCalibrationProfile>.of(profiles));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Calibration & Sync')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Align the simulated Left, Centre and Right feeds. These values form the calibration boundary that a real camera/OpenCV adapter can consume later.',
            ),
            const SizedBox(height: 12),
            for (final camera in widget.cameras)
              _CalibrationCard(
                camera: camera,
                profile: profiles[camera.id]!,
                onChanged: (profile) => _update(camera.id, profile),
              ),
            FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save),
              label: const Text('Save calibration'),
            ),
          ],
        ),
      );
}

class _CalibrationCard extends StatelessWidget {
  const _CalibrationCard({
    required this.camera,
    required this.profile,
    required this.onChanged,
  });

  final CameraDevice camera;
  final CameraCalibrationProfile profile;
  final ValueChanged<CameraCalibrationProfile> onChanged;

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(camera.name, style: Theme.of(context).textTheme.titleMedium),
              Text('Horizontal ${profile.horizontalOffset.toStringAsFixed(0)} px'),
              Slider(
                value: profile.horizontalOffset,
                min: -100,
                max: 100,
                divisions: 40,
                onChanged: (value) => onChanged(profile.copyWith(horizontalOffset: value)),
              ),
              Text('Vertical ${profile.verticalOffset.toStringAsFixed(0)} px'),
              Slider(
                value: profile.verticalOffset,
                min: -100,
                max: 100,
                divisions: 40,
                onChanged: (value) => onChanged(profile.copyWith(verticalOffset: value)),
              ),
              Text('Rotation ${profile.rotationDegrees.toStringAsFixed(1)}°'),
              Slider(
                value: profile.rotationDegrees,
                min: -10,
                max: 10,
                divisions: 40,
                onChanged: (value) => onChanged(profile.copyWith(rotationDegrees: value)),
              ),
              Text('Scale ${profile.scale.toStringAsFixed(2)}x'),
              Slider(
                value: profile.scale,
                min: 0.8,
                max: 1.2,
                divisions: 40,
                onChanged: (value) => onChanged(profile.copyWith(scale: value)),
              ),
              Text('Sync delay ${profile.syncDelayMs} ms'),
              Slider(
                value: profile.syncDelayMs.toDouble(),
                min: -250,
                max: 250,
                divisions: 50,
                onChanged: (value) => onChanged(profile.copyWith(syncDelayMs: value.round())),
              ),
            ],
          ),
        ),
      );
}
