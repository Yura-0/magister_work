/// Трекер для заміру FPS з детальними даними для графіків
import 'dart:math';

class FpsTracker {
  final List<double> _timingFrameMs = [];
  final List<double> _manualFrameMs = [];
  
  // НОВЕ: Детальні записи для графіків
  final List<double> _allFrameTimes = []; // Всі часи кадрів по ітераціях
  final List<double> _fpsOverTime = []; // FPS по кожному кадру
  final List<int> _frameTimestamps = []; // Таймстемпи для часової осі

  void addTimingFrame(double ms) {
    _timingFrameMs.add(ms);
    _recordDetailedData(ms);
  }
  
  void addManualFrame(double ms) {
    _manualFrameMs.add(ms);
    _recordDetailedData(ms);
  }

  void _recordDetailedData(double frameTimeMs) {
    final now = DateTime.now().millisecondsSinceEpoch;
    _allFrameTimes.add(frameTimeMs);
    _fpsOverTime.add(frameTimeMs > 0 ? 1000.0 / frameTimeMs : 0);
    _frameTimestamps.add(now);
  }

  void clear() {
    _timingFrameMs.clear();
    _manualFrameMs.clear();
    _allFrameTimes.clear();
    _fpsOverTime.clear();
    _frameTimestamps.clear();
  }

  /// Повертає список всіх замірів (timings + manual)
  List<double> get allFrameMs => [..._timingFrameMs, ..._manualFrameMs];

  // НОВЕ: Детальні дані для графіків
  List<double> get frameTimesPerIteration => _allFrameTimes;
  List<double> get fpsPerIteration => _fpsOverTime;
  List<int> get frameTimestamps => _frameTimestamps;

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

  // НОВІ МЕТРИКИ ДЛЯ СТАТИСТИЧНОГО АНАЛІЗУ
  
  /// Стандартне відхилення часу кадру
  double get stdDevFrameTimeMs {
    final all = allFrameMs;
    if (all.isEmpty) return 0.0;
    final mean = avgFrameTimeMs;
    final variance = all.map((x) => pow(x - mean, 2)).reduce((a, b) => a + b) / all.length;
    return sqrt(variance);
  }

  /// Дисперсія часу кадру
  double get varianceFrameTimeMs {
    final all = allFrameMs;
    if (all.isEmpty) return 0.0;
    final mean = avgFrameTimeMs;
    return all.map((x) => pow(x - mean, 2)).reduce((a, b) => a + b) / all.length;
  }

  /// 95-й процентиль часу кадру (для аналізу "jank")
  double get percentile95FrameTimeMs {
    final sorted = List<double>.from(allFrameMs)..sort();
    if (sorted.isEmpty) return 0.0;
    final index = (sorted.length * 0.95).floor();
    return sorted[index];
  }

  /// Кількість "jank" кадрів (час кадру > 33.33 мс для < 30 FPS)
  int get jankFramesCount => allFrameMs.where((ms) => ms > 33.33).length;

  /// Відсоток "jank" кадрів
  double get jankFramesPercent {
    final all = allFrameMs;
    if (all.isEmpty) return 0.0;
    return (jankFramesCount / all.length) * 100;
  }
}