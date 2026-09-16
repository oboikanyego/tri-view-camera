import 'calibration_profile.dart';
import 'stream_session.dart';

enum StitchingEngineType { simulated, openCvNative }

enum StitchingStatus { idle, composing, ready, failed }

class StitchingInput {
  const StitchingInput({
    required this.cameraId,
    required this.stream,
    required this.calibration,
  });

  final String cameraId;
  final StreamSession stream;
  final CalibrationProfile calibration;
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

/// Deterministic simulator implementation used until native/OpenCV processing
/// and physical camera feeds are available.
class SimulatedStitchingEngine implements StitchingEngine {
  @override
  StitchingEngineType get type => StitchingEngineType.simulated;

  @override
  Future<StitchingResult> compose(List<StitchingInput> inputs) async {
    if (inputs.length < 2) {
      return StitchingResult(
        status: StitchingStatus.failed,
        engine: type,
        cameraIds: inputs.map((input) => input.cameraId).toList(growable: false),
        error: 'At least two camera streams are required for composition.',
      );
    }

    final active = inputs.where((input) => input.stream.isActive).toList(growable: false);
    if (active.length != inputs.length) {
      return StitchingResult(
        status: StitchingStatus.failed,
        engine: type,
        cameraIds: inputs.map((input) => input.cameraId).toList(growable: false),
        error: 'All camera streams must be active before composition.',
      );
    }

    final ids = active.map((input) => input.cameraId).toList(growable: false);
    return StitchingResult(
      status: StitchingStatus.ready,
      engine: type,
      cameraIds: ids,
      outputReference: 'simulated://combined/${ids.join('-')}',
    );
  }
}
