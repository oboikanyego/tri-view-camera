import 'package:flutter_test/flutter_test.dart';
import 'package:tri_view_camera/features/cameras/domain/calibration_profile.dart';
import 'package:tri_view_camera/features/cameras/domain/camera_stream.dart';
import 'package:tri_view_camera/features/cameras/domain/stitching_engine.dart';

CameraStreamSession activeStream(String id) => CameraStreamSession(
      descriptor: CameraStreamDescriptor(
        cameraId: id,
        transport: CameraStreamTransport.simulated,
        source: 'simulated://$id',
      ),
      state: CameraStreamState.streaming,
    );

StitchingInput input(String id, {bool active = true}) => StitchingInput(
      cameraId: id,
      stream: active
          ? activeStream(id)
          : CameraStreamSession(
              descriptor: CameraStreamDescriptor(
                cameraId: id,
                transport: CameraStreamTransport.simulated,
                source: 'simulated://$id',
              ),
            ),
      calibration: const CameraCalibrationProfile(),
    );

void main() {
  final engine = SimulatedStitchingEngine();

  test('composes active camera streams behind stitching boundary', () async {
    final result = await engine.compose([input('camera-1'), input('camera-2'), input('camera-3')]);

    expect(result.status, StitchingStatus.ready);
    expect(result.engine, StitchingEngineType.simulated);
    expect(result.cameraIds, ['camera-1', 'camera-2', 'camera-3']);
    expect(result.outputReference, 'simulated://combined/camera-1-camera-2-camera-3');
  });

  test('rejects composition when fewer than two feeds are supplied', () async {
    final result = await engine.compose([input('camera-1')]);

    expect(result.status, StitchingStatus.failed);
    expect(result.error, contains('At least two'));
  });

  test('rejects composition when a stream is inactive', () async {
    final result = await engine.compose([input('camera-1'), input('camera-2', active: false)]);

    expect(result.status, StitchingStatus.failed);
    expect(result.error, contains('active'));
  });
}
