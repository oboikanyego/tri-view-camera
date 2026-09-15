import 'camera_models.dart';

abstract interface class CameraAdapter {
  Future<List<CameraDevice>> discover();
  Future<CameraDevice> connect(CameraDevice camera);
  Future<CameraDevice> disconnect(CameraDevice camera);
  Future<CameraCapabilities> capabilities(String cameraId);
  Future<CameraDevice> updateSettings(CameraDevice camera, CameraSettings settings);
  Future<void> startStream(String cameraId);
  Future<void> stopStream(String cameraId);
  Future<void> startRecording(String cameraId);
  Future<void> stopRecording(String cameraId);
  Future<String> snapshot(String cameraId);
}
