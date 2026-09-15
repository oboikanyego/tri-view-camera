# Tri View Camera — Initial Architecture

## Architecture goals

- Support exactly three cameras in the MVP while keeping the integration extensible.
- Separate camera control from video transport.
- Avoid coupling UI code directly to a specific camera vendor SDK.
- Keep computationally expensive stitching outside normal Flutter UI logic.
- Fail gracefully when one camera disconnects.

## Logical architecture

```text
                     Tri View Camera Mobile App

  Presentation
  ├── Camera discovery / pairing
  ├── Three-camera dashboard
  ├── Individual camera configuration
  ├── Recording / snapshot controls
  ├── Calibration
  └── Combined view
              │
              ▼
  Application / Domain
  ├── CameraManager
  ├── CameraControlService
  ├── StreamManager
  ├── CalibrationService
  ├── RecordingService
  └── StitchingService
              │
       ┌──────┴──────┐
       ▼             ▼
 Camera Control   Video Transport
 REST/WebSocket   WebRTC/RTSP/SDK
       │             │
       └──────┬──────┘
              ▼
      Camera Adapter Layer
       │      │      │
       ▼      ▼      ▼
     LEFT   CENTRE  RIGHT

Video frames -> Synchronization -> Calibration -> OpenCV/native stitching -> Combined view
```

## Camera abstraction

The application should expose a common camera contract regardless of manufacturer. A vendor-specific adapter will translate that contract into the camera SDK/API.

Example responsibilities:

- discover devices;
- connect/disconnect;
- query capabilities;
- read current settings;
- update supported settings;
- start/stop video stream;
- start/stop recording where supported;
- report connection/health state.

## Camera capability model

Do not assume every camera supports every control. Each connected camera should expose capabilities such as:

- supported resolutions;
- supported FPS values;
- zoom range;
- focus modes/range;
- exposure controls;
- white-balance controls;
- orientation controls;
- PTZ support;
- recording support;
- available stream protocols.

The UI should enable only controls advertised by the camera.

## Streaming

The transport will be selected after hardware validation. Preferred order:

1. WebRTC when the hardware/vendor supports low-latency WebRTC.
2. Vendor SDK when it provides reliable mobile streaming and controls.
3. RTSP when supported and appropriate for the target mobile platforms.

## Stitching

Flutter will own the application UX, state and orchestration. Computational image processing should be implemented through a native boundary using OpenCV/C++ where necessary.

Pipeline:

```text
Camera frames
    ↓
Timestamp / synchronize
    ↓
Lens correction
    ↓
Calibration
    ↓
Feature/overlap matching
    ↓
Perspective transformation
    ↓
Blending
    ↓
Combined output
```

## Phase 0 technical spike

Before committing to the final implementation, validate one physical target camera and document:

- manufacturer/model;
- firmware version;
- mobile SDK/API;
- authentication/pairing mechanism;
- control endpoints/capabilities;
- streaming protocol;
- achievable resolution/FPS;
- measured local-network latency;
- whether three cameras can stream concurrently;
- Android and iOS SDK restrictions.

This spike determines the concrete dependencies used by the Flutter project.