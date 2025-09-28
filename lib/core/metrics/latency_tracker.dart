// lib/core/metrics/latency_tracker.dart

class LatencyTracker {
  final List<double> _latMs = [];

  /// Записывает задержку в миллисекундах
  void recordLatencyMs(double ms) => _latMs.add(ms);

  void clear() => _latMs.clear();

  double get avgLatencyMs {
    if (_latMs.isEmpty) return 0.0;
    return _latMs.reduce((a, b) => a + b) / _latMs.length;
  }

  double get minLatencyMs => _latMs.isEmpty ? 0.0 : _latMs.reduce((a, b) => a < b ? a : b);
  double get maxLatencyMs => _latMs.isEmpty ? 0.0 : _latMs.reduce((a, b) => a > b ? a : b);
}
