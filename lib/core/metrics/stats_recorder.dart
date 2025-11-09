// Універсальний рекордер параметрів з детальними даними
import 'package:flutter/scheduler.dart';
import 'package:magi_work/models/test_results.dart';
import 'fps_tracker.dart';
import 'latency_tracker.dart';
import 'memory_tracker.dart';
import 'widget_counter.dart';

class StatsRecorder {
  final FpsTracker fpsTracker;
  final LatencyTracker latencyTracker;
  final MemoryTracker memoryTracker;
  final WidgetCounter widgetCounter;

  int? _iterationStartMicros;

  StatsRecorder()
      : fpsTracker = FpsTracker(),
        latencyTracker = LatencyTracker(),
        memoryTracker = MemoryTracker(),
        widgetCounter = WidgetCounter() {
    reset(); 
  }

  void _onTimings(List<FrameTiming> timings) {
    for (final t in timings) {
      final ms = (t.buildDuration + t.rasterDuration).inMicroseconds / 1000.0;
      fpsTracker.addTimingFrame(ms);
    }
  }

  void startListening() {
    try {
      SchedulerBinding.instance.addTimingsCallback(_onTimings);
    } catch (e) {
      // Обробка помилок
    }
  }

  void stopListening() {
    try {
      SchedulerBinding.instance.removeTimingsCallback(_onTimings);
    } catch (e) {}
  }

  void reset() {
    fpsTracker.clear();
    latencyTracker.clear();
    memoryTracker.clear();
    widgetCounter.reset(); 
    _iterationStartMicros = null;
  }

  void startFrame() {
    _iterationStartMicros = DateTime.now().microsecondsSinceEpoch;
  }

  void endFrame() {
    final now = DateTime.now().microsecondsSinceEpoch;
    if (_iterationStartMicros != null) {
      final ms = (now - _iterationStartMicros!) / 1000.0;
      fpsTracker.addManualFrame(ms);
      _iterationStartMicros = null;
    }

    memoryTracker.record();
  }

  void recordLatencyMs(double ms) => latencyTracker.recordLatencyMs(ms);

  TestResult buildResult(String scenario, String manager, int iterations) {
    return TestResult(
      scenarioName: scenario,
      stateManager: manager,
      iterations: iterations,
      
      // ОСНОВНІ МЕТРИКИ
      avgFps: fpsTracker.avgFps,
      avgFrameTimeMs: fpsTracker.avgFrameTimeMs,
      avgLatencyMs: latencyTracker.avgLatencyMs,
      ramUsageMb: memoryTracker.avgMemoryMb,
      widgetRebuilds: widgetCounter.rebuilds,
      
      // СТАТИСТИЧНІ МЕТРИКИ
      stdDevFrameTimeMs: fpsTracker.stdDevFrameTimeMs,
      percentile95FrameTimeMs: fpsTracker.percentile95FrameTimeMs,
      jankFramesCount: fpsTracker.jankFramesCount,
      jankFramesPercent: fpsTracker.jankFramesPercent,
      minLatencyMs: latencyTracker.minLatencyMs,
      maxLatencyMs: latencyTracker.maxLatencyMs,
      
      // ДИСПЕРСІЇ ТА СТАНДАРТНІ ВІДХИЛЕННЯ
      varianceFrameTimeMs: fpsTracker.varianceFrameTimeMs,
      varianceLatencyMs: latencyTracker.varianceLatencyMs,
      stdDevLatencyMs: latencyTracker.stdDevLatencyMs,
      varianceFps: fpsTracker.varianceFps, //  ДОДАНО ДИСПЕРСІЮ FPS
      stdDevFps: fpsTracker.stdDevFps,     //  ДОДАНО СТАНДАРТНЕ ВІДХИЛЕННЯ FPS
      
      // ПАМ'ЯТЬ
      peakMemoryMb: memoryTracker.peakMemoryMb,
      stdDevMemoryMb: memoryTracker.stdDevMemoryMb,
      
      // АГРЕГОВАНІ ДАНІ ДЛЯ ГРАФІКІВ (замість детальних)
      frameTimeDistribution: fpsTracker.getAggregatedFrameTimes(15), // 15 бакетів
      latencyDistribution: latencyTracker.getAggregatedLatencies(15), // 15 бакетів
      memoryUsageOverTime: memoryTracker.getMemorySamples(20), // 20 точок
    );
  }
}