import 'package:flutter_test/flutter_test.dart';
import 'package:tri_view_camera/features/cameras/domain/camera_stream.dart';

void main() {
  const descriptor = CameraStreamDescriptor(
    cameraId: 'SIM-CAM-LEFT',
    transport: CameraStreamTransport.simulated,
    source: 'sim://left',
  );

  test('simulated source opens and closes a stream session', () async {
    const source = SimulatedCameraStreamSource();

    final opened = await source.open(descriptor);
    expect(opened.state, CameraStreamState.streaming);
    expect(opened.isActive, isTrue);

    final closed = await source.close(opened);
    expect(closed.state, CameraStreamState.stopped);
    expect(closed.isActive, isFalse);
  });

  test('recordFrame tracks frame count and latest timestamp immutably', () {
    const initial = CameraStreamSession(descriptor: descriptor);
    final timestamp = DateTime.utc(2026, 9, 16, 3);

    final updated = initial.recordFrame(timestamp);

    expect(initial.frameCount, 0);
    expect(updated.frameCount, 1);
    expect(updated.lastFrameAt, timestamp);
    expect(updated.state, CameraStreamState.streaming);
  });

  test('simulated source rejects a non-simulated descriptor', () async {
    const source = SimulatedCameraStreamSource();
    const rtspDescriptor = CameraStreamDescriptor(
      cameraId: 'CAM-1',
      transport: CameraStreamTransport.rtsp,
      source: 'rtsp://camera/stream',
    );

    expect(
      () => source.open(rtspDescriptor),
      throwsA(isA<ArgumentError>()),
    );
  });
}
