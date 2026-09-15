import 'package:flutter_test/flutter_test.dart';
import 'package:tri_view_camera/features/cameras/data/simulated_camera_adapter.dart';
import 'package:tri_view_camera/features/cameras/domain/camera_models.dart';

void main() {
  test('discovers exactly three positioned simulator cameras', () async {
    final adapter = SimulatedCameraAdapter();
    final cameras = await adapter.discover();
    expect(cameras, hasLength(3));
    expect(cameras.map((c) => c.position).toSet(), {CameraPosition.left, CameraPosition.centre, CameraPosition.right});
  });

  test('connect and settings update preserve camera identity', () async {
    final adapter = SimulatedCameraAdapter();
    final camera = (await adapter.discover()).first;
    final connected = await adapter.connect(camera);
    expect(connected.state, CameraConnectionState.connected);
    final updated = await adapter.updateSettings(connected, const CameraSettings(resolution: '1280x720', fps: 60, zoom: 2));
    expect(updated.id, camera.id);
    expect(updated.settings.fps, 60);
    expect(updated.settings.zoom, 2);
  });
}
