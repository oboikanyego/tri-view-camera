import 'package:flutter_test/flutter_test.dart';
import 'package:tri_view_camera/features/cameras/domain/capture_session.dart';

void main() {
  test('tracks snapshots and recordings without mutating previous session', () {
    const empty = CaptureSession();
    final snapshot = CaptureItem(
      cameraId: 'SIM-CAM-LEFT',
      type: CaptureType.snapshot,
      path: '/simulated/SIM-CAM-LEFT.jpg',
      createdAt: DateTime(2026, 9, 16),
    );
    final recording = CaptureItem(
      cameraId: 'SIM-CAM-LEFT',
      type: CaptureType.recording,
      path: '/simulated/SIM-CAM-LEFT.mp4',
      createdAt: DateTime(2026, 9, 16, 0, 1),
    );

    final withSnapshot = empty.add(snapshot);
    final complete = withSnapshot.add(recording);

    expect(empty.items, isEmpty);
    expect(withSnapshot.snapshotCount, 1);
    expect(withSnapshot.recordingCount, 0);
    expect(complete.snapshotCount, 1);
    expect(complete.recordingCount, 1);
    expect(complete.forCamera('SIM-CAM-LEFT'), hasLength(2));
    expect(complete.forCamera('SIM-CAM-CENTRE'), isEmpty);
  });
}
