// Міксин для отримання кількості збудованих виджетів
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


mixin WidgetCounterMixin<T extends StatefulWidget> on State<T> {
  void incrementRebuild() {
    WidgetCounter().increment();
  }
}