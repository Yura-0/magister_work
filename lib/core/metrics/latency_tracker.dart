import 'dart:math';

/// Трекер затримки кадрів у секундах з детальними даними

class LatencyTracker {
  final List<double> _latMs = [];
  
  void recordLatencyMs(double ms) {
    _latMs.add(ms);
  }

  void clear() {
    _latMs.clear();
  }

  double get avgLatencyMs {
    if (_latMs.isEmpty) return 0.0;
    return _latMs.reduce((a, b) => a + b) / _latMs.length;
  }

  /// Дисперсія затримки
  double get varianceLatencyMs {
    if (_latMs.isEmpty) return 0.0;
    final mean = avgLatencyMs;
    return _latMs.map((x) => pow(x - mean, 2)).reduce((a, b) => a + b) / _latMs.length;
  }

  /// Стандартне відхилення затримки
  double get stdDevLatencyMs => sqrt(varianceLatencyMs);

  double get minLatencyMs => _latMs.isEmpty ? 0.0 : _latMs.reduce((a, b) => a < b ? a : b);
  double get maxLatencyMs => _latMs.isEmpty ? 0.0 : _latMs.reduce((a, b) => a > b ? a : b);

  // 👇 НОВИЙ МЕТОД ДЛЯ АГРЕГОВАНИХ ДАНИХ
  Map<double, int> getAggregatedLatencies(int buckets) {
    if (_latMs.isEmpty) return {};
    
    final maxLatency = _latMs.reduce((a, b) => a > b ? a : b);
    final bucketSize = maxLatency / buckets;
    
    Map<double, int> distribution = {};
    for (double latency in _latMs) {
      double bucket = (latency / bucketSize).floor() * bucketSize;
      distribution[bucket] = (distribution[bucket] ?? 0) + 1;
    }
    
    return distribution;
  }
}