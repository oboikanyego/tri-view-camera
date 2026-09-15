import '../domain/camera_adapter.dart';
import '../domain/camera_models.dart';

class SimulatedCameraAdapter implements CameraAdapter {
  static const _delay = Duration(milliseconds: 120);

  @override
  Future<List<CameraDevice>> discover() async {
    await Future<void>.delayed(_delay);
    return const [
      CameraDevice(id: 'SIM-CAM-LEFT', name: 'Left Camera', position: CameraPosition.left),
      CameraDevice(id: 'SIM-CAM-CENTRE', name: 'Centre Camera', position: CameraPosition.centre),
      CameraDevice(id: 'SIM-CAM-RIGHT', name: 'Right Camera', position: CameraPosition.right),
    ];
  }

  @override
  Future<CameraDevice> connect(CameraDevice camera) async { await Future<void>.delayed(_delay); return camera.copyWith(state: CameraConnectionState.connected); }
  @override
  Future<CameraDevice> disconnect(CameraDevice camera) async { await Future<void>.delayed(_delay); return camera.copyWith(state: CameraConnectionState.disconnected); }
  @override
  Future<CameraCapabilities> capabilities(String cameraId) async => const CameraCapabilities(resolutions: ['1280x720', '1920x1080'], frameRates: [24, 30, 60]);
  @override
  Future<CameraDevice> updateSettings(CameraDevice camera, CameraSettings settings) async { await Future<void>.delayed(_delay); return camera.copyWith(settings: settings); }
  @override
  Future<void> startStream(String cameraId) async => Future<void>.delayed(_delay);
  @override
  Future<void> stopStream(String cameraId) async => Future<void>.delayed(_delay);
  @override
  Future<void> startRecording(String cameraId) async => Future<void>.delayed(_delay);
  @override
  Future<void> stopRecording(String cameraId) async => Future<void>.delayed(_delay);
  @override
  Future<String> snapshot(String cameraId) async { await Future<void>.delayed(_delay); return 'simulated://$cameraId/${DateTime.now().millisecondsSinceEpoch}.jpg'; }
}
