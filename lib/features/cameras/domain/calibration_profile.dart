class CameraCalibrationProfile {
  const CameraCalibrationProfile({
    this.horizontalOffset = 0,
    this.verticalOffset = 0,
    this.rotationDegrees = 0,
    this.scale = 1,
    this.syncDelayMs = 0,
  });

  final double horizontalOffset;
  final double verticalOffset;
  final double rotationDegrees;
  final double scale;
  final int syncDelayMs;

  CameraCalibrationProfile copyWith({
    double? horizontalOffset,
    double? verticalOffset,
    double? rotationDegrees,
    double? scale,
    int? syncDelayMs,
  }) => CameraCalibrationProfile(
        horizontalOffset: horizontalOffset ?? this.horizontalOffset,
        verticalOffset: verticalOffset ?? this.verticalOffset,
        rotationDegrees: rotationDegrees ?? this.rotationDegrees,
        scale: scale ?? this.scale,
        syncDelayMs: syncDelayMs ?? this.syncDelayMs,
      );

  bool get isDefault =>
      horizontalOffset == 0 &&
      verticalOffset == 0 &&
      rotationDegrees == 0 &&
      scale == 1 &&
      syncDelayMs == 0;
}
