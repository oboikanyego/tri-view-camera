import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tri_view_camera/features/cameras/domain/calibration_profile.dart';
import 'package:tri_view_camera/features/cameras/domain/camera_models.dart';
import 'package:tri_view_camera/features/cameras/presentation/camera_dashboard.dart';

void main() {
  testWidgets('combined view renders calibration sync values', (tester) async {
    const camera = CameraDevice(
      id: 'SIM-CAM-LEFT',
      name: 'Left Camera',
      position: CameraPosition.left,
      state: CameraConnectionState.connected,
      settings: CameraSettings(),
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: CombinedViewScreen(
          cameras: [camera],
          profiles: {
            'SIM-CAM-LEFT': CameraCalibrationProfile(
              horizontalOffset: 10,
              verticalOffset: -5,
              rotationDegrees: 2,
              scale: 1.1,
              syncDelayMs: 40,
            ),
          },
        ),
      ),
    );

    expect(find.text('LEFT'), findsOneWidget);
    expect(find.text('sync 40 ms'), findsOneWidget);
    expect(find.byType(Transform), findsWidgets);
  });
}
