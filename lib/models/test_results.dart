// Модель результату тесту з детальними даними для графіків
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

  // Статистичні метрики
  final double stdDevFrameTimeMs;
  final double percentile95FrameTimeMs;
  final int jankFramesCount;
  final double jankFramesPercent;
  final double minLatencyMs;
  final double maxLatencyMs;

  // НОВІ СТАТИСТИЧНІ МЕТРИКИ
  final double varianceFrameTimeMs;
  final double varianceLatencyMs;
  final double stdDevLatencyMs;
  final double peakMemoryMb;
  final double stdDevMemoryMb;

  // ДЕТАЛЬНІ ДАНІ ДЛЯ ГРАФІКІВ
  final List<double> frameTimesPerIteration;
  final List<double> fpsPerIteration;
  final List<int> frameTimestamps;
  final List<double> latencyPerIteration;
  final List<int> latencyTimestamps;

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
    // Нові метрики
    required this.varianceFrameTimeMs,
    required this.varianceLatencyMs,
    required this.stdDevLatencyMs,
    required this.peakMemoryMb,
    required this.stdDevMemoryMb,
    // Детальні дані
    required this.frameTimesPerIteration,
    required this.fpsPerIteration,
    required this.frameTimestamps,
    required this.latencyPerIteration,
    required this.latencyTimestamps,
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
      // Нові метрики
      varianceFrameTimeMs: (json["varianceFrameTimeMs"] as num).toDouble(),
      varianceLatencyMs: (json["varianceLatencyMs"] as num).toDouble(),
      stdDevLatencyMs: (json["stdDevLatencyMs"] as num).toDouble(),
      peakMemoryMb: (json["peakMemoryMb"] as num).toDouble(),
      stdDevMemoryMb: (json["stdDevMemoryMb"] as num).toDouble(),
      // Детальні дані
      frameTimesPerIteration: List<double>.from(json["frameTimesPerIteration"] ?? []),
      fpsPerIteration: List<double>.from(json["fpsPerIteration"] ?? []),
      frameTimestamps: List<int>.from(json["frameTimestamps"] ?? []),
      latencyPerIteration: List<double>.from(json["latencyPerIteration"] ?? []),
      latencyTimestamps: List<int>.from(json["latencyTimestamps"] ?? []),
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
        // Нові метрики
        "varianceFrameTimeMs": varianceFrameTimeMs,
        "varianceLatencyMs": varianceLatencyMs,
        "stdDevLatencyMs": stdDevLatencyMs,
        "peakMemoryMb": peakMemoryMb,
        "stdDevMemoryMb": stdDevMemoryMb,
        // Детальні дані для графіків
        "frameTimesPerIteration": frameTimesPerIteration,
        "fpsPerIteration": fpsPerIteration,
        "frameTimestamps": frameTimestamps,
        "latencyPerIteration": latencyPerIteration,
        "latencyTimestamps": latencyTimestamps,
        "timestamp": timestamp.toIso8601String(),
      };
}