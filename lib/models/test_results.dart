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

  // 👇 ДИСПЕРСІЇ ТА СТАНДАРТНІ ВІДХИЛЕННЯ
  final double varianceFrameTimeMs;
  final double varianceLatencyMs;
  final double stdDevLatencyMs;
  final double varianceFps;       // 👈 ДОДАНО
  final double stdDevFps;         // 👈 ДОДАНО
  
  // Пам'ять
  final double peakMemoryMb;
  final double stdDevMemoryMb;

  // 👇 АГРЕГОВАНІ ДАНІ ДЛЯ ГРАФІКІВ
  final Map<double, int> frameTimeDistribution; // {16.0: 150, 32.0: 80, ...}
  final Map<double, int> latencyDistribution;   // {10.0: 200, 20.0: 50, ...}  
  final List<double> memoryUsageOverTime;       // [125.5, 126.8, ...]

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
    required this.varianceFrameTimeMs,
    required this.varianceLatencyMs,
    required this.stdDevLatencyMs,
    required this.varianceFps,    // 👈 ДОДАНО
    required this.stdDevFps,      // 👈 ДОДАНО
    required this.peakMemoryMb,
    required this.stdDevMemoryMb,
    required this.frameTimeDistribution,
    required this.latencyDistribution,
    required this.memoryUsageOverTime,
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
      // НОВІ МЕТРИКИ
      varianceFrameTimeMs: (json["varianceFrameTimeMs"] as num).toDouble(),
      varianceLatencyMs: (json["varianceLatencyMs"] as num).toDouble(),
      stdDevLatencyMs: (json["stdDevLatencyMs"] as num).toDouble(),
      varianceFps: (json["varianceFps"] as num).toDouble(),
      stdDevFps: (json["stdDevFps"] as num).toDouble(),
      peakMemoryMb: (json["peakMemoryMb"] as num).toDouble(),
      stdDevMemoryMb: (json["stdDevMemoryMb"] as num).toDouble(),
      // АГРЕГОВАНІ ДАНІ
      frameTimeDistribution: _parseDistribution(json["frameTimeDistribution"]),
      latencyDistribution: _parseDistribution(json["latencyDistribution"]),
      memoryUsageOverTime: List<double>.from(json["memoryUsageOverTime"] ?? []),
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
        // НОВІ МЕТРИКИ
        "varianceFrameTimeMs": varianceFrameTimeMs,
        "varianceLatencyMs": varianceLatencyMs,
        "stdDevLatencyMs": stdDevLatencyMs,
        "varianceFps": varianceFps,
        "stdDevFps": stdDevFps,
        "peakMemoryMb": peakMemoryMb,
        "stdDevMemoryMb": stdDevMemoryMb,
        // АГРЕГОВАНІ ДАНІ
        "frameTimeDistribution": _distributionToJson(frameTimeDistribution),
        "latencyDistribution": _distributionToJson(latencyDistribution),
        "memoryUsageOverTime": memoryUsageOverTime,
        "timestamp": timestamp.toIso8601String(),
      };

  // Допоміжні методи для роботи з Map<double, int>
  static Map<double, int> _parseDistribution(dynamic jsonData) {
    if (jsonData == null) return {};
    
    final Map<double, int> result = {};
    final Map<String, dynamic> data = Map<String, dynamic>.from(jsonData);
    
    data.forEach((key, value) {
      result[double.parse(key)] = value as int;
    });
    
    return result;
  }

  static Map<String, int> _distributionToJson(Map<double, int> distribution) {
    final Map<String, int> result = {};
    distribution.forEach((key, value) {
      result[key.toString()] = value;
    });
    return result;
  }
}