// Модель результату тесту
// Модель результату тесту
class TestResult {
  final String scenarioName;
  final String stateManager;
  final int iterations;

  // Основні метрики
  final double avgFps;
  final double avgFrameTimeMs;
  final double avgLatencyMs;
  final double ramUsageMb;
  final int widgetRebuilds;

  // Нові метрики для статистичного аналізу
  final double stdDevFrameTimeMs;
  final double percentile95FrameTimeMs;
  final int jankFramesCount;
  final double jankFramesPercent;
  final double minLatencyMs;
  final double maxLatencyMs;

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
    required this.stdDevFrameTimeMs,
    required this.percentile95FrameTimeMs,
    required this.jankFramesCount,
    required this.jankFramesPercent,
    required this.minLatencyMs,
    required this.maxLatencyMs,
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
      stdDevFrameTimeMs: (json["stdDevFrameTimeMs"] as num).toDouble(),
      percentile95FrameTimeMs: (json["percentile95FrameTimeMs"] as num).toDouble(),
      jankFramesCount: json["jankFramesCount"] as int,
      jankFramesPercent: (json["jankFramesPercent"] as num).toDouble(),
      minLatencyMs: (json["minLatencyMs"] as num).toDouble(),
      maxLatencyMs: (json["maxLatencyMs"] as num).toDouble(),
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
        "stdDevFrameTimeMs": stdDevFrameTimeMs,
        "percentile95FrameTimeMs": percentile95FrameTimeMs,
        "jankFramesCount": jankFramesCount,
        "jankFramesPercent": jankFramesPercent,
        "minLatencyMs": minLatencyMs,
        "maxLatencyMs": maxLatencyMs,
        "timestamp": timestamp.toIso8601String(),
      };
}