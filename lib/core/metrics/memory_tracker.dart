// Трекер оперативної пам'яті з піковими значеннями
import 'dart:io';
import 'dart:math';

class MemoryTracker {
  final List<double> memoryMb = [];
  
  // НОВЕ: Пікова пам'ять
  double _peakMemoryMb = 0.0;

  void record() {
    try {
      final usedBytes = ProcessInfo.currentRss;
      final usedMb = usedBytes / (1024 * 1024);
      memoryMb.add(usedMb);
      
      // Оновлюємо пікову пам'ять
      if (usedMb > _peakMemoryMb) {
        _peakMemoryMb = usedMb;
      }
    } catch (e) {
      memoryMb.add(-1.0);
    }
  }

  void clear() {
    memoryMb.clear();
    _peakMemoryMb = 0.0;
  }

  double get avgMemoryMb {
    final valid = memoryMb.where((v) => v >= 0).toList();
    if (valid.isEmpty) return 0.0;
    return valid.reduce((a, b) => a + b) / valid.length;
  }

  // НОВЕ: Пікова пам'ять
  double get peakMemoryMb => _peakMemoryMb;

  // НОВЕ: Стандартне відхилення використання пам'яті
  double get stdDevMemoryMb {
    final valid = memoryMb.where((v) => v >= 0).toList();
    if (valid.isEmpty) return 0.0;
    final mean = avgMemoryMb;
    final variance = valid.map((x) => pow(x - mean, 2)).reduce((a, b) => a + b) / valid.length;
    return sqrt(variance);
  }
}