class TestResult {
  final String scenarioName;
  final String stateManager;
  final int iterations;

  final double avgFps;
  final double avgFrameTimeMs;
  final double avgLatencyMs;
  final double ramUsageMb;
  final int widgetRebuilds;

  final DateTime timestamp;

  TestResult({
    required this.scenarioName,
    required this.stateManager,
    required this.iterations,
    required this.avgFps,
    required this.avgFrameTimeMs,
    required this.avgLatencyMs,
    required this.ramUsageMb,
    required this.widgetRebuilds,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        "scenarioName": scenarioName,
        "stateManager": stateManager,
        "iterations": iterations,
        "avgFps": avgFps,
        "avgFrameTimeMs": avgFrameTimeMs,
        "avgLatencyMs": avgLatencyMs,
        "ramUsageMb": ramUsageMb,
        "widgetRebuilds": widgetRebuilds,
        "timestamp": timestamp.toIso8601String(),
      };
}
