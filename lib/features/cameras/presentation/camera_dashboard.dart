import 'package:flutter/material.dart';
import '../domain/camera_adapter.dart';
import '../domain/camera_models.dart';
import 'camera_settings_screen.dart';

class CameraDashboard extends StatefulWidget {
  const CameraDashboard({super.key, required this.adapter});
  final CameraAdapter adapter;
  @override State<CameraDashboard> createState() => _CameraDashboardState();
}

class _CameraDashboardState extends State<CameraDashboard> {
  List<CameraDevice> cameras = const [];
  bool loading = true;
  bool recording = false;

  @override void initState() { super.initState(); _load(); }
  Future<void> _load() async {
    final found = await widget.adapter.discover();
    final connected = <CameraDevice>[];
    for (final camera in found) { connected.add(await widget.adapter.connect(camera)); }
    if (mounted) setState(() { cameras = connected; loading = false; });
  }

  Future<void> _toggleRecording() async {
    for (final camera in cameras) {
      recording ? await widget.adapter.stopRecording(camera.id) : await widget.adapter.startRecording(camera.id);
    }
    if (mounted) setState(() => recording = !recording);
  }

  @override Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tri View Camera')),
      body: loading ? const Center(child: CircularProgressIndicator()) : ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Three-camera control centre', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),
          ...cameras.asMap().entries.map((entry) => _CameraCard(
            camera: entry.value,
            onConfigure: () async {
              final updated = await Navigator.push<CameraDevice>(context, MaterialPageRoute(builder: (_) => CameraSettingsScreen(camera: entry.value, adapter: widget.adapter)));
              if (updated != null && mounted) setState(() => cameras[entry.key] = updated);
            },
          )),
          const SizedBox(height: 8),
          FilledButton.icon(onPressed: _toggleRecording, icon: Icon(recording ? Icons.stop : Icons.fiber_manual_record), label: Text(recording ? 'Stop all recordings' : 'Record all')),
          OutlinedButton.icon(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CombinedViewScreen(cameras: cameras))), icon: const Icon(Icons.panorama), label: const Text('Combined view')),
        ],
      ),
    );
  }
}

class _CameraCard extends StatelessWidget {
  const _CameraCard({required this.camera, required this.onConfigure});
  final CameraDevice camera;
  final VoidCallback onConfigure;
  @override Widget build(BuildContext context) => Card(child: Padding(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
    Row(children: [const Icon(Icons.videocam), const SizedBox(width: 8), Expanded(child: Text(camera.name, style: Theme.of(context).textTheme.titleMedium)), const Icon(Icons.circle, size: 12), const SizedBox(width: 4), Text(camera.state.name)]),
    const SizedBox(height: 10),
    AspectRatio(aspectRatio: 16 / 9, child: DecoratedBox(decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(12)), child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.camera, size: 42), Text('${camera.settings.resolution} • ${camera.settings.fps} FPS'), Text('SIMULATED ${camera.position.name.toUpperCase()} FEED')])))),
    const SizedBox(height: 8),
    OutlinedButton(onPressed: onConfigure, child: const Text('Configure camera')),
  ])));
}

class CombinedViewScreen extends StatelessWidget {
  const CombinedViewScreen({super.key, required this.cameras});
  final List<CameraDevice> cameras;
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Combined View')), body: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
    const Text('Simulator composition preview. Native OpenCV stitching will plug into this surface.'),
    const SizedBox(height: 16),
    Expanded(child: Row(children: cameras.map((c) => Expanded(child: Card(child: Center(child: Text(c.position.name.toUpperCase()))))).toList())),
  ])));
}
