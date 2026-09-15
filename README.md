# Tri View Camera

A cross-platform mobile application for connecting, configuring, synchronizing, and combining three tripod-mounted camera feeds into a unified real-time view.

## Product vision

Tri View Camera acts as a mobile control centre for a three-camera setup. An operator will be able to discover and pair cameras, assign them to Left/Centre/Right positions, view all three streams, configure supported camera settings, capture media, calibrate the setup, and generate a combined view.

## Target platforms

- Android / Google Play
- iOS / Apple App Store

## Proposed stack

- Flutter + Dart — cross-platform mobile application
- WebRTC / RTSP / camera vendor SDK — live camera transport, selected after hardware validation
- REST / WebSocket / vendor SDK — camera configuration and control
- OpenCV + native C++ — calibration, perspective correction and image stitching
- Node.js + TypeScript — optional backend for authentication, device registration, configuration and telemetry

## MVP capabilities

1. Discover and pair three supported cameras.
2. Assign cameras as Left, Centre and Right.
3. Display three simultaneous live previews.
4. Configure supported settings per camera, including resolution, FPS, quality/bitrate, zoom, focus, exposure, white balance and orientation where the hardware supports them.
5. Show camera connection and error states.
6. Start/stop streams and recordings.
7. Capture snapshots.
8. Save camera/setup configuration.
9. Synchronize and calibrate feeds.
10. Produce a combined view from the three perspectives.

## Delivery roadmap

| Phase | Scope | Indicative duration |
| --- | --- | --- |
| 0 | Discovery and camera hardware/API validation | 1 week |
| 1 | Flutter mobile foundation | 1 week |
| 2 | Single-camera streaming/control proof of concept | 1 week |
| 3 | Three-camera pairing and multi-view | 1–2 weeks |
| 4 | Per-camera configuration | 1–2 weeks |
| 5 | Recording, snapshots and resilience | 1 week |
| 6 | Synchronization and calibration | 1–2 weeks |
| 7 | Combined view / stitching | 2 weeks |
| 8 | Performance and quality hardening | 1–2 weeks |
| 9 | QA, UAT and app-store release | 1–2 weeks |

The first major technical gate is validating the exact camera hardware. Camera controls cannot be guaranteed until the selected cameras expose the required SDK/API capabilities.

## Planned Flutter structure

```text
lib/
  app/
  core/
    errors/
    networking/
    theme/
  features/
    camera_discovery/
    camera_control/
    camera_view/
    calibration/
    combined_view/
    recording/
  shared/
    models/
    widgets/
```

The camera integration will be abstracted behind interfaces so that the application is not tightly coupled to one camera manufacturer.

## Development status

**Phase 0 — Discovery & Hardware Validation**

Before implementing the streaming layer, confirm:

- camera manufacturer and model;
- camera connectivity method;
- available SDK/API;
- supported remote controls;
- supported streaming protocols;
- simultaneous-stream constraints;
- target Android/iOS devices;
- whether “combined view” means panorama stitching or another composition.

## License

License to be confirmed before production release.
