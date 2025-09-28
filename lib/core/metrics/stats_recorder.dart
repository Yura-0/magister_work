// lib/core/metrics/stats_recorder.dart
import 'package:flutter/scheduler.dart';
import 'package:magi_work/models/test_results.dart';
import 'fps_tracker.dart';
import 'latency_tracker.dart';
import 'memory_tracker.dart';
import 'widget_counter.dart';

/// Recorder, объединяющий все метрики.
/// Использование:
///  recorder.startListening(); // (опционально) чтобы ловить FrameTiming
///  recorder.reset();
///  for (i...) {
///    recorder.startFrame();
///    await test.runIteration();
///    recorder.endFrame();
///  }
///  recorder.stopListening();
///  final result = recorder.buildResult(...);
class StatsRecorder {
  final FpsTracker fpsTracker = FpsTracker();
  final LatencyTracker latencyTracker = LatencyTracker();
  final MemoryTracker memoryTracker = MemoryTracker();
  // Убираем создание нового экземпляра, используем синглтон

  // Временная метка начала итерации (microseconds)
  int? _iterationStartMicros;

  WidgetCounter get widgetCounter => WidgetCounter(); // Получаем синглтон

  // Callback для SchedulerBinding (FrameTiming)
  void _onTimings(List<FrameTiming> timings) {
    for (final t in timings) {
      // Берём build + raster как приближение полного времени рендера кадра
      final ms = (t.buildDuration + t.rasterDuration).inMicroseconds / 1000.0;
      fpsTracker.addTimingFrame(ms);
    }
  }

  /// Подписаться на FrameTiming (точные измерения билда/рейстера).
  /// Вызывать только когда Flutter Binding инициализирован (например, в экране).
  void startListening() {
    try {
      SchedulerBinding.instance.addTimingsCallback(_onTimings);
    } catch (e) {
      // В некоторых тестовых окружениях SchedulerBinding может быть отсутствующим
    }
  }

  /// Отписаться от FrameTiming.
  void stopListening() {
    try {
      SchedulerBinding.instance.removeTimingsCallback(_onTimings);
    } catch (e) {}
  }

  /// Сбросить все собранные данные
  void reset() {
    fpsTracker.clear();
    latencyTracker.clear();
    memoryTracker.clear();
    WidgetCounter().reset(); // Сбрасываем синглтон
    _iterationStartMicros = null;
  }

  /// Вызывать в начале итерации (чтобы засечь wall-clock time)
  void startFrame() {
    _iterationStartMicros = DateTime.now().microsecondsSinceEpoch;
  }

  /// Вызывать в конце итерации
  void endFrame() {
    final now = DateTime.now().microsecondsSinceEpoch;
    if (_iterationStartMicros != null) {
      final ms = (now - _iterationStartMicros!) / 1000.0;
      fpsTracker.addManualFrame(ms);
      _iterationStartMicros = null;
    }
    // Записываем память после итерации
    memoryTracker.record();
  }

  /// Записать latency (ms) вручную, если хочешь измерять отклик на действие.
  void recordLatencyMs(double ms) => latencyTracker.recordLatencyMs(ms);

  /// Построить TestResult (модель у тебя в models/test_result.dart)
  TestResult buildResult(String scenario, String manager, int iterations) {
    return TestResult(
      scenarioName: scenario,
      stateManager: manager,
      iterations: iterations,
      avgFps: fpsTracker.avgFps,
      avgFrameTimeMs: fpsTracker.avgFrameTimeMs,
      avgLatencyMs: latencyTracker.avgLatencyMs,
      ramUsageMb: memoryTracker.avgMemoryMb,
      widgetRebuilds: WidgetCounter().rebuilds, // Используем синглтон
    );
  }
}