// Міксин для отримання кількості збудованих виджетів
import 'package:flutter/material.dart';

class WidgetCounter {
  int _rebuilds = 0;

  WidgetCounter();

  int get rebuilds => _rebuilds;
  
  void increment() => _rebuilds++;
  
  void reset() => _rebuilds = 0;
}

class WidgetCounterScope extends InheritedWidget {
  final WidgetCounter counter;
  
  const WidgetCounterScope({
    required this.counter,
    required super.child,
    super.key,
  });
  
  static WidgetCounter of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<WidgetCounterScope>();
    assert(result != null, 'No WidgetCounterScope found in context');
    return result!.counter;
  }
  
  @override
  bool updateShouldNotify(WidgetCounterScope oldWidget) => false;
}

// ПРОСТОЙ МІКСИН - без buildWidget
mixin WidgetCounterMixin<T extends StatefulWidget> on State<T> {
  void incrementRebuild() {
    final counter = WidgetCounterScope.of(context);
    counter.increment();
  }
}