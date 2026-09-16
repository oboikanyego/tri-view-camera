enum CameraStreamState { idle, starting, streaming, interrupted, stopped, failed }

enum CameraStreamTransport { simulated, localMedia, webRtc, rtsp, vendorSdk }

class CameraStreamDescriptor {
  const CameraStreamDescriptor({
    required this.cameraId,
    required this.transport,
    required this.source,
    this.width = 1920,
    this.height = 1080,
    this.framesPerSecond = 30,
  });

  final String cameraId;
  final CameraStreamTransport transport;
  final String source;
  final int width;
  final int height;
  final int framesPerSecond;
}

class CameraStreamSession {
  const CameraStreamSession({
    required this.descriptor,
    this.state = CameraStreamState.idle,
    this.frameCount = 0,
    this.lastFrameAt,
    this.error,
  });

  final CameraStreamDescriptor descriptor;
  final CameraStreamState state;
  final int frameCount;
  final DateTime? lastFrameAt;
  final String? error;

  bool get isActive =>
      state == CameraStreamState.starting ||
      state == CameraStreamState.streaming;

  CameraStreamSession copyWith({
    CameraStreamState? state,
    int? frameCount,
    DateTime? lastFrameAt,
    String? error,
    bool clearError = false,
  }) {
    return CameraStreamSession(
      descriptor: descriptor,
      state: state ?? this.state,
      frameCount: frameCount ?? this.frameCount,
      lastFrameAt: lastFrameAt ?? this.lastFrameAt,
      error: clearError ? null : (error ?? this.error),
    );
  }

  CameraStreamSession recordFrame(DateTime timestamp) => copyWith(
        state: CameraStreamState.streaming,
        frameCount: frameCount + 1,
        lastFrameAt: timestamp,
        clearError: true,
      );
}

abstract interface class CameraStreamSource {
  CameraStreamTransport get transport;

  Future<CameraStreamSession> open(CameraStreamDescriptor descriptor);

  Future<CameraStreamSession> close(CameraStreamSession session);
}

class SimulatedCameraStreamSource implements CameraStreamSource {
  const SimulatedCameraStreamSource();

  @override
  CameraStreamTransport get transport => CameraStreamTransport.simulated;

  @override
  Future<CameraStreamSession> open(CameraStreamDescriptor descriptor) async {
    if (descriptor.transport != transport) {
      throw ArgumentError('Descriptor transport must be simulated.');
    }
    return CameraStreamSession(
      descriptor: descriptor,
      state: CameraStreamState.streaming,
    );
  }

  @override
  Future<CameraStreamSession> close(CameraStreamSession session) async =>
      session.copyWith(state: CameraStreamState.stopped);
}
