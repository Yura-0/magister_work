// lib/core/metrics/widget_counter.dart

// widget_counter.dart
import 'package:flutter/material.dart';

class WidgetCounter {
  static final WidgetCounter _instance = WidgetCounter._internal();
  int rebuilds = 0;

  factory WidgetCounter() {
    return _instance;
  }

  WidgetCounter._internal();

  void increment() => rebuilds++;
  void reset() => rebuilds = 0;
}


// widget_counter_mixin.dart
mixin WidgetCounterMixin<T extends StatefulWidget> on State<T> {
  void incrementRebuild() {
    WidgetCounter().increment();
  }
}