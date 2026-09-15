import 'package:flutter/material.dart';
import '../domain/camera_adapter.dart';
import '../domain/camera_models.dart';
import 'camera_settings_screen.dart';

class CameraDashboard extends StatefulWidget {
  const CameraDashboard({super.key, required this.adapter});
  final CameraAdapter adapter;
  @override
  State<CameraDashboard> createState() => _CameraDashboardState();
}

class _CameraDashboardState extends State<CameraDashboard> {
  List<CameraDevice> cameras = const [];
  bool loading = true;
  bool recording = false;
  final Set<String> busyCameraIds = {};

  @override
  void initState() {
    super.initState();
    _discover();
  }

  Future<void> _discover() async {
    setState(() => loading = true);
    final found = await widget.adapter.discover();
    if (mounted) setState(() { cameras = found; loading = false; });
  }

  Future<void> _toggleConnection(int index) async {
    final camera = cameras[index];
    setState(() => busyCameraIds.add(camera.id));
    try {
      final updated = camera.state == CameraConnectionState.connected
          ? await widget.adapter.disconnect(camera)
          : await widget.adapter.connect(camera);
      if (mounted) setState(() => cameras[index] = updated);
    } finally {
      if (mounted) setState(() => busyCameraIds.remove(camera.id));
    }
  }

  Future<void> _connectAll() async {
    for (var i = 0; i < cameras.length; i++) {
      if (cameras[i].state != CameraConnectionState.connected) {
        await _toggleConnection(i);
      }
    }
  }

  Future<void> _takeSnapshot(CameraDevice camera) async {
    if (camera.state != CameraConnectionState.connected) return;
    final path = await widget.adapter.snapshot(camera.id);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Snapshot captured: $path')),
    );
  }

  Future<void> _toggleRecording() async {
    final connected = cameras.where(
      (camera) => camera.state == CameraConnectionState.connected,
    );
    for (final camera in connected) {
      recording
          ? await widget.adapter.stopRecording(camera.id)
          : await widget.adapter.startRecording(camera.id);
    }
    if (mounted) setState(() => recording = !recording);
  }

  @override
  Widget build(BuildContext context) {
    final connectedCount = cameras
        .where((camera) => camera.state == CameraConnectionState.connected)
        .length;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tri View Camera'),
        actions: [
          IconButton(
            tooltip: 'Discover cameras',
            onPressed: loading ? null : _discover,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  'Three-camera control centre',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Text('$connectedCount/${cameras.length} cameras connected'),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: connectedCount == cameras.length ? null : _connectAll,
                  icon: const Icon(Icons.link),
                  label: const Text('Connect all cameras'),
                ),
                const SizedBox(height: 12),
                ...cameras.asMap().entries.map(
                  (entry) => _CameraCard(
                    camera: entry.value,
                    busy: busyCameraIds.contains(entry.value.id),
                    onConnectionToggle: () => _toggleConnection(entry.key),
                    onSnapshot: () => _takeSnapshot(entry.value),
                    onConfigure: entry.value.state == CameraConnectionState.connected
                        ? () async {
                            final updated = await Navigator.push<CameraDevice>(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CameraSettingsScreen(
                                  camera: entry.value,
                                  adapter: widget.adapter,
                                ),
                              ),
                            );
                            if (updated != null && mounted) {
                              setState(() => cameras[entry.key] = updated);
                            }
                          }
                        : null,
                  ),
                ),
                const SizedBox(height: 8),
                FilledButton.icon(
                  onPressed: connectedCount == 0 ? null : _toggleRecording,
                  icon: Icon(recording ? Icons.stop : Icons.fiber_manual_record),
                  label: Text(recording ? 'Stop all recordings' : 'Record all'),
                ),
                OutlinedButton.icon(
                  onPressed: connectedCount == 0
                      ? null
                      : () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CombinedViewScreen(
                                cameras: cameras
                                    .where((camera) => camera.state == CameraConnectionState.connected)
                                    .toList(),
                              ),
                            ),
                          ),
                  icon: const Icon(Icons.panorama),
                  label: const Text('Combined view'),
                ),
              ],
            ),
    );
  }
}

class _CameraCard extends StatelessWidget {
  const _CameraCard({
    required this.camera,
    required this.busy,
    required this.onConnectionToggle,
    required this.onSnapshot,
    required this.onConfigure,
  });
  final CameraDevice camera;
  final bool busy;
  final VoidCallback onConnectionToggle;
  final VoidCallback onSnapshot;
  final VoidCallback? onConfigure;

  @override
  Widget build(BuildContext context) {
    final connected = camera.state == CameraConnectionState.connected;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(Icons.videocam),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    camera.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                const Icon(Icons.circle, size: 12),
                const SizedBox(width: 4),
                Text(camera.state.name),
              ],
            ),
            const SizedBox(height: 10),
            AspectRatio(
              aspectRatio: 16 / 9,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: connected
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.camera, size: 42),
                            Text('${camera.settings.resolution} • ${camera.settings.fps} FPS'),
                            Text('SIMULATED ${camera.position.name.toUpperCase()} FEED'),
                          ],
                        )
                      : const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.videocam_off, size: 42),
                            Text('Camera disconnected'),
                          ],
                        ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.tonalIcon(
                  onPressed: busy ? null : onConnectionToggle,
                  icon: busy
                      ? const SizedBox.square(
                          dimension: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Icon(connected ? Icons.link_off : Icons.link),
                  label: Text(connected ? 'Disconnect' : 'Connect'),
                ),
                OutlinedButton.icon(
                  onPressed: connected ? onSnapshot : null,
                  icon: const Icon(Icons.photo_camera),
                  label: const Text('Snapshot'),
                ),
                OutlinedButton(
                  onPressed: onConfigure,
                  child: const Text('Configure camera'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CombinedViewScreen extends StatelessWidget {
  const CombinedViewScreen({super.key, required this.cameras});
  final List<CameraDevice> cameras;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Combined View')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                'Simulator composition preview. Native OpenCV stitching will plug into this surface.',
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Row(
                  children: cameras
                      .map(
                        (camera) => Expanded(
                          child: Card(
                            child: Center(
                              child: Text(camera.position.name.toUpperCase()),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      );
}
