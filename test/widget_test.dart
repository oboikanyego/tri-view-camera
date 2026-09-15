import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tri_view_camera/features/cameras/data/simulated_camera_adapter.dart';
import 'package:tri_view_camera/features/cameras/presentation/camera_dashboard.dart';

void main() {
  testWidgets('dashboard discovers cameras disconnected and can connect them', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: CameraDashboard(adapter: SimulatedCameraAdapter())),
    );
    await tester.pumpAndSettle();

    expect(find.text('0/3 cameras connected'), findsOneWidget);
    expect(find.text('Left Camera'), findsOneWidget);
    expect(find.text('Camera disconnected'), findsWidgets);
    expect(find.text('Connect all cameras'), findsOneWidget);

    await tester.tap(find.text('Connect all cameras'));
    await tester.pumpAndSettle();

    expect(find.text('3/3 cameras connected'), findsOneWidget);
    expect(find.text('Disconnect'), findsWidgets);

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
