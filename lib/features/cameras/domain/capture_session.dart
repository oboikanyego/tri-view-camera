enum CaptureType { snapshot, recording }

class CaptureItem {
  const CaptureItem({
    required this.cameraId,
    required this.type,
    required this.path,
    required this.createdAt,
  });

  final String cameraId;
  final CaptureType type;
  final String path;
  final DateTime createdAt;
}

class CaptureSession {
  const CaptureSession({this.items = const <CaptureItem>[]});

  final List<CaptureItem> items;

  CaptureSession add(CaptureItem item) => CaptureSession(
        items: List<CaptureItem>.unmodifiable(<CaptureItem>[...items, item]),
      );

  List<CaptureItem> forCamera(String cameraId) =>
      items.where((item) => item.cameraId == cameraId).toList(growable: false);

  int get snapshotCount =>
      items.where((item) => item.type == CaptureType.snapshot).length;

  int get recordingCount =>
      items.where((item) => item.type == CaptureType.recording).length;
}
