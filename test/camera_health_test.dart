import 'package:flutter_test/flutter_test.dart';
import 'package:tri_view_camera/features/cameras/domain/camera_health.dart';

void main() {
  test('offline camera requests reconnect while retry budget remains', () {
    const health = CameraHealth(cameraId: 'SIM-CAM-LEFT');

    expect(health.status, CameraHealthStatus.offline);
    expect(health.shouldReconnect, isTrue);
  });

  test('reconnect budget stops after three attempts', () {
    const health = CameraHealth(
      cameraId: 'SIM-CAM-LEFT',
      status: CameraHealthStatus.degraded,
      reconnectAttempts: 3,
    );

    expect(health.shouldReconnect, isFalse);
  });

  test('diagnostics remain immutable and filter per camera', () {
    const diagnostics = CameraDiagnostics();
    final event = CameraDiagnosticEvent(
      cameraId: 'SIM-CAM-CENTRE',
      type: CameraDiagnosticEventType.streamInterrupted,
      occurredAt: DateTime(2026, 9, 16),
      message: 'Simulated stream interruption',
    );

    final updated = diagnostics.add(event);

    expect(diagnostics.events, isEmpty);
    expect(updated.events, hasLength(1));
    expect(updated.forCamera('SIM-CAM-CENTRE'), hasLength(1));
    expect(updated.forCamera('SIM-CAM-RIGHT'), isEmpty);
  });

  test('successful recovery can clear previous error', () {
    const health = CameraHealth(
      cameraId: 'SIM-CAM-RIGHT',
      status: CameraHealthStatus.degraded,
      reconnectAttempts: 1,
      lastError: 'Stream unavailable',
    );

    final recovered = health.copyWith(
      status: CameraHealthStatus.healthy,
      reconnectAttempts: 0,
      lastSeenAt: DateTime(2026, 9, 16),
      clearError: true,
    );

    expect(recovered.status, CameraHealthStatus.healthy);
    expect(recovered.reconnectAttempts, 0);
    expect(recovered.lastError, isNull);
    expect(recovered.shouldReconnect, isFalse);
  });
}
