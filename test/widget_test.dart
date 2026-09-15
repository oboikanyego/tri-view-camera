import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tri_view_camera/features/cameras/data/simulated_camera_adapter.dart';
import 'package:tri_view_camera/features/cameras/presentation/camera_dashboard.dart';

void main() {
  testWidgets('dashboard loads all three simulated feeds', (tester) async {
    await tester.pumpWidget(MaterialApp(home: CameraDashboard(adapter: SimulatedCameraAdapter())));
    await tester.pumpAndSettle();
    expect(find.text('Left Camera'), findsOneWidget);
    expect(find.text('Centre Camera'), findsOneWidget);
    expect(find.text('Right Camera'), findsOneWidget);
    expect(find.text('Record all'), findsOneWidget);
    expect(find.text('Combined view'), findsOneWidget);
  });
}
