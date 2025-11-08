import 'dart:math';

/// Трекер затримки кадрів у секундах з детальними даними
class LatencyTracker {
  final List<double> _latMs = [];
  
  // НОВЕ: Детальні записи для графіків
  final List<double> _latencyPerIteration = []; // Затримки по ітераціях
  final List<int> _latencyTimestamps = []; // Таймстемпи

  void recordLatencyMs(double ms) {
    _latMs.add(ms);
    _latencyPerIteration.add(ms);
    _latencyTimestamps.add(DateTime.now().millisecondsSinceEpoch);
  }

  void clear() {
    _latMs.clear();
    _latencyPerIteration.clear();
    _latencyTimestamps.clear();
  }

  // НОВЕ: Детальні дані для графіків
  List<double> get latencyPerIteration => _latencyPerIteration;
  List<int> get latencyTimestamps => _latencyTimestamps;

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
}