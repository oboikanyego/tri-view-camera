import 'package:flutter_test/flutter_test.dart';
import 'package:tri_view_camera/features/cameras/domain/calibration_profile.dart';

void main() {
  test('default calibration is neutral', () {
    const profile = CameraCalibrationProfile();
    expect(profile.isDefault, isTrue);
    expect(profile.scale, 1);
    expect(profile.syncDelayMs, 0);
  });

  test('copyWith updates alignment and synchronization values', () {
    const profile = CameraCalibrationProfile();
    final updated = profile.copyWith(
      horizontalOffset: 20,
      verticalOffset: -10,
      rotationDegrees: 1.5,
      scale: 1.05,
      syncDelayMs: 40,
    );

    expect(updated.isDefault, isFalse);
    expect(updated.horizontalOffset, 20);
    expect(updated.verticalOffset, -10);
    expect(updated.rotationDegrees, 1.5);
    expect(updated.scale, 1.05);
    expect(updated.syncDelayMs, 40);
  });
}
