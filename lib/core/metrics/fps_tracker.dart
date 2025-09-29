/// Трекер для заміру  FPS.
/// Підтримує 2 режими: manual (startFrame/endFrame) и timings (SchedulerBinding FrameTiming).
import 'dart:math';

class FpsTracker {
  final List<double> _timingFrameMs = [];
  final List<double> _manualFrameMs = [];

  void addTimingFrame(double ms) => _timingFrameMs.add(ms);
  void addManualFrame(double ms) => _manualFrameMs.add(ms);

  void clear() {
    _timingFrameMs.clear();
    _manualFrameMs.clear();
  }

  /// Повертає список всіх замірів (timings + manual)
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
