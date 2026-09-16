enum ReleaseGateStatus { ready, blocked }

class ReleaseGate {
  const ReleaseGate({
    required this.name,
    required this.status,
    this.reason,
  });

  final String name;
  final ReleaseGateStatus status;
  final String? reason;
}

class ReleaseReadiness {
  const ReleaseReadiness(this.gates);

  final List<ReleaseGate> gates;

  bool get isSimulatorReady =>
      gates.where((gate) => gate.name != 'physical-camera-validation').every(
            (gate) => gate.status == ReleaseGateStatus.ready,
          );

  bool get isProductionReady =>
      gates.every((gate) => gate.status == ReleaseGateStatus.ready);

  List<ReleaseGate> get blockers => gates
      .where((gate) => gate.status == ReleaseGateStatus.blocked)
      .toList(growable: false);

  factory ReleaseReadiness.simulatorFirst() => const ReleaseReadiness([
        ReleaseGate(
          name: 'static-analysis-and-tests',
          status: ReleaseGateStatus.ready,
        ),
        ReleaseGate(
          name: 'android-build',
          status: ReleaseGateStatus.ready,
        ),
        ReleaseGate(
          name: 'simulated-three-camera-flow',
          status: ReleaseGateStatus.ready,
        ),
        ReleaseGate(
          name: 'physical-camera-validation',
          status: ReleaseGateStatus.blocked,
          reason: 'Requires physical camera hardware and vendor transport validation.',
        ),
      ]);
}
