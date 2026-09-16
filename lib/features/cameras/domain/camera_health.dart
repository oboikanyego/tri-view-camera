enum CameraHealthStatus { healthy, degraded, offline }

enum CameraDiagnosticEventType {
  connected,
  disconnected,
  reconnectAttempt,
  reconnectSucceeded,
  reconnectFailed,
  streamInterrupted,
}

class CameraDiagnosticEvent {
  const CameraDiagnosticEvent({
    required this.cameraId,
    required this.type,
    required this.occurredAt,
    this.message,
  });

  final String cameraId;
  final CameraDiagnosticEventType type;
  final DateTime occurredAt;
  final String? message;
}

class CameraHealth {
  const CameraHealth({
    required this.cameraId,
    this.status = CameraHealthStatus.offline,
    this.reconnectAttempts = 0,
    this.lastSeenAt,
    this.lastError,
  });

  final String cameraId;
  final CameraHealthStatus status;
  final int reconnectAttempts;
  final DateTime? lastSeenAt;
  final String? lastError;

  bool get shouldReconnect =>
      status != CameraHealthStatus.healthy && reconnectAttempts < 3;

  CameraHealth copyWith({
    CameraHealthStatus? status,
    int? reconnectAttempts,
    DateTime? lastSeenAt,
    String? lastError,
    bool clearError = false,
  }) {
    return CameraHealth(
      cameraId: cameraId,
      status: status ?? this.status,
      reconnectAttempts: reconnectAttempts ?? this.reconnectAttempts,
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
      lastError: clearError ? null : lastError ?? this.lastError,
    );
  }
}

class CameraDiagnostics {
  const CameraDiagnostics({this.events = const []});

  final List<CameraDiagnosticEvent> events;

  CameraDiagnostics add(CameraDiagnosticEvent event) =>
      CameraDiagnostics(events: List.unmodifiable([...events, event]));

  List<CameraDiagnosticEvent> forCamera(String cameraId) =>
      List.unmodifiable(events.where((event) => event.cameraId == cameraId));
}
