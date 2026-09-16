import 'calibration_profile.dart';
import 'camera_stream.dart';

enum StitchingEngineType { simulated, openCvNative }

enum StitchingStatus { idle, composing, ready, failed }

class StitchingInput {
  const StitchingInput({
    required this.cameraId,
    required this.stream,
    required this.calibration,
  });

  final String cameraId;
  final CameraStreamSession stream;
  final CameraCalibrationProfile calibration;
}

class StitchingResult {
  const StitchingResult({
    required this.status,
    required this.engine,
    required this.cameraIds,
    this.outputReference,
    this.error,
  });

  final StitchingStatus status;
  final StitchingEngineType engine;
  final List<String> cameraIds;
  final String? outputReference;
  final String? error;
}

abstract interface class StitchingEngine {
  StitchingEngineType get type;

  Future<StitchingResult> compose(List<StitchingInput> inputs);
}

/// Deterministic composition used until native/OpenCV processing and physical
/// camera feeds are available. The contract deliberately hides native details.
class SimulatedStitchingEngine implements StitchingEngine {
  @override
  StitchingEngineType get type => StitchingEngineType.simulated;

  @override
  Future<StitchingResult> compose(List<StitchingInput> inputs) async {
    final ids = inputs.map((input) => input.cameraId).toList(growable: false);
    if (inputs.length < 2) {
      return StitchingResult(
        status: StitchingStatus.failed,
        engine: type,
        cameraIds: ids,
        error: 'At least two camera streams are required for composition.',
      );
    }

    if (inputs.any((input) => !input.stream.isActive)) {
      return StitchingResult(
        status: StitchingStatus.failed,
        engine: type,
        cameraIds: ids,
        error: 'All camera streams must be active before composition.',
      );
    }

    return StitchingResult(
      status: StitchingStatus.ready,
      engine: type,
      cameraIds: ids,
      outputReference: 'simulated://combined/${ids.join('-')}',
    );
  }
}
