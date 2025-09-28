// lib/core/metrics/widget_counter.dart

class WidgetCounter {
  int rebuilds = 0;

  void increment() => rebuilds++;
  void reset() => rebuilds = 0;
}
