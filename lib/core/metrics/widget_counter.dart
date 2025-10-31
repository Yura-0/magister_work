// Міксин для отримання кількості збудованих виджетів
import 'package:flutter/material.dart';

class WidgetCounter {
  int _rebuilds = 0;

  // Простой конструктор
  WidgetCounter();

  int get rebuilds => _rebuilds;
  
  void increment() => _rebuilds++;
  
  void reset() => _rebuilds = 0;
}

mixin WidgetCounterMixin<T extends StatefulWidget> on State<T> {
  void incrementRebuild() {
    WidgetCounter().increment();
  }
}