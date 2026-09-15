import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tri_view_camera/features/cameras/data/simulated_camera_adapter.dart';
import 'package:tri_view_camera/features/cameras/presentation/camera_dashboard.dart';

void main() {
  testWidgets('dashboard loads all three simulated feeds', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: CameraDashboard(adapter: SimulatedCameraAdapter())),
    );
    await tester.pumpAndSettle();

    expect(find.text('Left Camera'), findsOneWidget);

    for (final label in [
      'Centre Camera',
      'Right Camera',
      'Record all',
      'Combined view',
    ]) {
      await tester.scrollUntilVisible(
        find.text(label),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text(label), findsOneWidget);
    }
  });
}
