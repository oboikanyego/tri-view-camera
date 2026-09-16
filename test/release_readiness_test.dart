import 'package:flutter_test/flutter_test.dart';
import 'package:tri_view_camera/core/release/release_readiness.dart';

void main() {
  group('ReleaseReadiness', () {
    test('simulator-first release is ready before hardware validation', () {
      final readiness = ReleaseReadiness.simulatorFirst();

      expect(readiness.isSimulatorReady, isTrue);
      expect(readiness.isProductionReady, isFalse);
      expect(readiness.blockers, hasLength(1));
      expect(readiness.blockers.single.name, 'physical-camera-validation');
    });

    test('production readiness requires every gate', () {
      const readiness = ReleaseReadiness([
        ReleaseGate(name: 'ci', status: ReleaseGateStatus.ready),
        ReleaseGate(name: 'hardware', status: ReleaseGateStatus.ready),
      ]);

      expect(readiness.isSimulatorReady, isTrue);
      expect(readiness.isProductionReady, isTrue);
      expect(readiness.blockers, isEmpty);
    });
  });
}
