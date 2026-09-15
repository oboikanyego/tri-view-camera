enum CameraPosition { left, centre, right }
enum CameraConnectionState { disconnected, connecting, connected, error }

class CameraCapabilities {
  const CameraCapabilities({required this.resolutions, required this.frameRates, this.canZoom = true, this.canFocus = true, this.canExpose = true, this.canRecord = true});
  final List<String> resolutions;
  final List<int> frameRates;
  final bool canZoom;
  final bool canFocus;
  final bool canExpose;
  final bool canRecord;
}

class CameraSettings {
  const CameraSettings({this.resolution = '1920x1080', this.fps = 30, this.zoom = 1, this.exposure = 0});
  final String resolution;
  final int fps;
  final double zoom;
  final double exposure;

  CameraSettings copyWith({String? resolution, int? fps, double? zoom, double? exposure}) => CameraSettings(
    resolution: resolution ?? this.resolution,
    fps: fps ?? this.fps,
    zoom: zoom ?? this.zoom,
    exposure: exposure ?? this.exposure,
  );
}

class CameraDevice {
  const CameraDevice({required this.id, required this.name, required this.position, this.state = CameraConnectionState.disconnected, this.settings = const CameraSettings()});
  final String id;
  final String name;
  final CameraPosition position;
  final CameraConnectionState state;
  final CameraSettings settings;

  CameraDevice copyWith({CameraConnectionState? state, CameraSettings? settings}) => CameraDevice(id: id, name: name, position: position, state: state ?? this.state, settings: settings ?? this.settings);
}
