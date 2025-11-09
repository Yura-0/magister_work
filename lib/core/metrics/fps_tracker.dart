/// Трекер для заміру FPS з детальними даними для графіків
import 'dart:math';

class FpsTracker {
  final List<double> _timingFrameMs = [];
  final List<double> _manualFrameMs = [];
  
  // 👇 ЗАМІСТЬ детальних даних зберігаємо тільки агреговані
  final List<double> _allFrameTimes = [];

  void addTimingFrame(double ms) {
    _timingFrameMs.add(ms);
    _allFrameTimes.add(ms);
  }
  
  void addManualFrame(double ms) {
    _manualFrameMs.add(ms);
    _allFrameTimes.add(ms);
  }

  void clear() {
    _timingFrameMs.clear();
    _manualFrameMs.clear();
    _allFrameTimes.clear();
  }

  List<double> get allFrameMs => [..._timingFrameMs, ..._manualFrameMs];

  // 👇 НОВІ МЕТОДИ ДЛЯ АГРЕГАЦІЇ ДАНИХ
  Map<double, int> getAggregatedFrameTimes(int buckets) {
    if (_allFrameTimes.isEmpty) return {};
    
    final maxTime = _allFrameTimes.reduce((a, b) => a > b ? a : b);
    final bucketSize = maxTime / buckets;
    
    Map<double, int> distribution = {};
    for (double time in _allFrameTimes) {
      double bucket = (time / bucketSize).floor() * bucketSize;
      distribution[bucket] = (distribution[bucket] ?? 0) + 1;
    }
    
    return distribution;
  }

  // 👇 ОСНОВНІ МЕТРИКИ
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

  // 👇 ДИСПЕРСІЯ FPS (НОВА МЕТРИКА)
  double get varianceFps {
    final allFps = _allFrameTimes.map((ms) => ms > 0 ? 1000.0 / ms : 0).toList();
    if (allFps.isEmpty) return 0.0;
    
    final mean = avgFps;
    return allFps.map((fps) => pow(fps - mean, 2)).reduce((a, b) => a + b) / allFps.length;
  }

  // 👇 СТАНДАРТНЕ ВІДХИЛЕННЯ FPS (НОВА МЕТРИКА)
  double get stdDevFps => sqrt(varianceFps);

  // 👇 ДИСПЕРСІЯ ЧАСУ КАДРІВ
  double get varianceFrameTimeMs {
    final all = allFrameMs;
    if (all.isEmpty) return 0.0;
    final mean = avgFrameTimeMs;
    return all.map((x) => pow(x - mean, 2)).reduce((a, b) => a + b) / all.length;
  }

  double get stdDevFrameTimeMs => sqrt(varianceFrameTimeMs);

  // Інші методи залишаються незмінними...
  double get percentile95FrameTimeMs {
    final sorted = List<double>.from(allFrameMs)..sort();
    if (sorted.isEmpty) return 0.0;
    final index = (sorted.length * 0.95).floor();
    return sorted[index];
  }

  int get jankFramesCount => allFrameMs.where((ms) => ms > 33.33).length;

  double get jankFramesPercent {
    final all = allFrameMs;
    if (all.isEmpty) return 0.0;
    return (jankFramesCount / all.length) * 100;
  }
}