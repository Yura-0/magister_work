// lib/core/metrics/memory_tracker.dart
import 'dart:io';

class MemoryTracker {
  final List<double> memoryMb = [];

  /// Попытка получить используемую память процесса (current RSS)
  /// Возвращаем значения в мегабайтах.
  void record() {
    try {
      // ProcessInfo.currentRss возвращает байты (в Dart VM)
      final usedBytes = ProcessInfo.currentRss;
      final usedMb = usedBytes / (1024 * 1024);
      memoryMb.add(usedMb);
    } catch (e) {
      // fallback: если ProcessInfo недоступен — добавляем -1 как маркер
      memoryMb.add(-1.0);
    }
  }

  void clear() => memoryMb.clear();

  double get avgMemoryMb {
    final valid = memoryMb.where((v) => v >= 0).toList();
    if (valid.isEmpty) return 0.0;
    return valid.reduce((a, b) => a + b) / valid.length;
  }
}
