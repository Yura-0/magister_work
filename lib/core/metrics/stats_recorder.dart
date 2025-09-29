// Універсальний рекордер параметрів
import 'package:flutter/scheduler.dart';
import 'package:magi_work/models/test_results.dart';
import 'fps_tracker.dart';
import 'latency_tracker.dart';
import 'memory_tracker.dart';
import 'widget_counter.dart';


class StatsRecorder {
  final FpsTracker fpsTracker = FpsTracker();
  final LatencyTracker latencyTracker = LatencyTracker();
  final MemoryTracker memoryTracker = MemoryTracker();

  int? _iterationStartMicros;

  WidgetCounter get widgetCounter => WidgetCounter();

  
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
    WidgetCounter().reset(); 
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
      avgFps: fpsTracker.avgFps,
      avgFrameTimeMs: fpsTracker.avgFrameTimeMs,
      avgLatencyMs: latencyTracker.avgLatencyMs,
      ramUsageMb: memoryTracker.avgMemoryMb,
      widgetRebuilds: WidgetCounter().rebuilds,
    );
  }
}