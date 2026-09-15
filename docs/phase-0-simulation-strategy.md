# Phase 0 — Hardware-Independent Development Strategy

## Decision

Physical camera hardware is not currently available. Development will therefore continue using a simulator-first architecture rather than blocking the product.

The application must treat cameras as external devices behind a stable `CameraAdapter` contract. Development and automated tests will use simulated adapters. Real camera vendors can later be integrated by implementing the same contract without rewriting application screens or business logic.

## What can be completed without hardware

- Flutter application and navigation.
- Camera domain models and capability model.
- Left/Centre/Right camera assignment.
- Discovery/pairing workflows using simulated devices.
- Connection/disconnection/reconnection state machines.
- Three concurrent simulated video feeds.
- Per-camera settings UI and control commands.
- Recording/snapshot workflows at application level.
- Calibration UX and configuration model.
- Combined-view UX.
- Error states and diagnostics.
- Automated unit/widget/integration tests against simulated cameras.

## What remains hardware-validation work

The following cannot be truthfully certified until physical target hardware is selected:

- vendor SDK/API compatibility;
- actual optical zoom/focus/exposure behaviour;
- measured camera-to-phone latency;
- physical three-camera bandwidth/thermal performance;
- real lens distortion/calibration values;
- real-world panorama/stitching quality;
- final Android/iOS vendor SDK compatibility.

These are tracked as hardware validation rather than blockers to application development.

## Simulator requirements

The simulator should expose three devices:

- `SIM-CAM-LEFT`
- `SIM-CAM-CENTRE`
- `SIM-CAM-RIGHT`

Each device should support configurable capabilities, connection delay, simulated disconnects/errors and settings changes. Video can initially be represented by deterministic animated/mock feed surfaces and later by local sample videos.

## Adapter boundary

Application code depends on a common camera interface, conceptually:

```dart
abstract interface class CameraAdapter {
  Future<List<CameraDevice>> discover();
  Future<void> connect(String cameraId);
  Future<void> disconnect(String cameraId);
  Future<CameraCapabilities> getCapabilities(String cameraId);
  Future<CameraSettings> getSettings(String cameraId);
  Future<CameraSettings> updateSettings(String cameraId, CameraSettings settings);
  Stream<CameraConnectionEvent> connectionEvents(String cameraId);
  Future<void> startStream(String cameraId);
  Future<void> stopStream(String cameraId);
}
```

Vendor adapters will implement this interface later.

## Development gate

Phase 1 application development may start using the simulator. Hardware-validation tickets remain open/blocked where physical measurements are required. They must be revisited before production release and before claiming compatibility with a specific camera.