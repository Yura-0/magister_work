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

   factory TestResult.fromJson(Map<String, dynamic> json) {
    return TestResult(
      scenarioName: json["scenarioName"] as String,
      stateManager: json["stateManager"] as String,
      iterations: json["iterations"] as int,
      avgFps: (json["avgFps"] as num).toDouble(),
      avgFrameTimeMs: (json["avgFrameTimeMs"] as num).toDouble(),
      avgLatencyMs: (json["avgLatencyMs"] as num).toDouble(),
      ramUsageMb: (json["ramUsageMb"] as num).toDouble(),
      widgetRebuilds: json["widgetRebuilds"] as int,
      timestamp: DateTime.parse(json["timestamp"] as String),
    );
  }

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
