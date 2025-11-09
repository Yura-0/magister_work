// Трекер оперативної пам'яті з піковими значеннями
import 'dart:io';
import 'dart:math';

class MemoryTracker {
  final List<double> memoryMb = [];
  
  double _peakMemoryMb = 0.0;

  void record() {
    try {
      final usedBytes = ProcessInfo.currentRss;
      final usedMb = usedBytes / (1024 * 1024);
      memoryMb.add(usedMb);
      
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

  double get peakMemoryMb => _peakMemoryMb;

  double get stdDevMemoryMb {
    final valid = memoryMb.where((v) => v >= 0).toList();
    if (valid.isEmpty) return 0.0;
    final mean = avgMemoryMb;
    final variance = valid.map((x) => pow(x - mean, 2)).reduce((a, b) => a + b) / valid.length;
    return sqrt(variance);
  }

  // 👇 НОВИЙ МЕТОД ДЛЯ АГРЕГОВАНИХ ДАНИХ
  List<double> getMemorySamples(int sampleCount) {
    final valid = memoryMb.where((v) => v >= 0).toList();
    if (valid.isEmpty) return [];
    
    List<double> samples = [];
    final step = valid.length ~/ sampleCount;
    
    for (int i = 0; i < valid.length; i += step) {
      if (i < valid.length) {
        samples.add(valid[i]);
      }
      if (samples.length >= sampleCount) break;
    }
    
    // Додаємо останнє значення, якщо ще є місце
    if (samples.length < sampleCount && valid.isNotEmpty) {
      samples.add(valid.last);
    }
    
    return samples;
  }
}