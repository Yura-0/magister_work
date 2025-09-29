// Трекер оперативної пам’яті
import 'dart:io';

class MemoryTracker {
  final List<double> memoryMb = [];


  void record() {
    try {
      
      final usedBytes = ProcessInfo.currentRss;
      final usedMb = usedBytes / (1024 * 1024);
      memoryMb.add(usedMb);
    } catch (e) {
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
