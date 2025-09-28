// lib/core/metrics/fps_tracker.dart
import 'dart:math';

/// Трекер для измерения времени кадра (ms) и расчёта FPS.
/// Поддерживает два источника: manual (startFrame/endFrame) и timings (SchedulerBinding FrameTiming).
class FpsTracker {
  final List<double> _timingFrameMs = [];
  final List<double> _manualFrameMs = [];

  void addTimingFrame(double ms) => _timingFrameMs.add(ms);
  void addManualFrame(double ms) => _manualFrameMs.add(ms);

  void clear() {
    _timingFrameMs.clear();
    _manualFrameMs.clear();
  }

  /// Возвращает список всех измерений (timings + manual)
  List<double> get allFrameMs => [..._timingFrameMs, ..._manualFrameMs];

  double get avgFrameTimeMs {
    final all = allFrameMs;
    if (all.isEmpty) return 0.0;
    return all.reduce((a, b) => a + b) / all.length;
  }

  double get avgFps {
    final frameMs = avgFrameTimeMs;
    if (frameMs <= 0) return 0.0;
    return 1000.0 / frameMs;
  }

  double get minFrameTimeMs {
    final all = allFrameMs;
    if (all.isEmpty) return 0.0;
    return all.reduce(min);
  }

  double get maxFrameTimeMs {
    final all = allFrameMs;
    if (all.isEmpty) return 0.0;
    return all.reduce(max);
  }
}
