// Віджет моделі тесту з підписками
import 'package:flutter/material.dart';
import 'package:magi_work/core/metrics/widget_counter.dart';
import '../tests/subscription_test.dart';

class SubscriptionTestWidget extends StatefulWidget {
  final SubscriptionTest scenario;

  const SubscriptionTestWidget({Key? key, required this.scenario}) : super(key: key);

  @override
  State<SubscriptionTestWidget> createState() => _SubscriptionTestWidgetState();
}

class _SubscriptionTestWidgetState extends State<SubscriptionTestWidget> with WidgetCounterMixin {
  int counter = 0;

  @override
  void initState() {
    super.initState();
    widget.scenario.onAction = _updateCounter;
  }

  void _updateCounter() {
    setState(() {
      counter++;
      incrementRebuild(); // Считаем ребилд
    });
  }

  @override
  Widget build(BuildContext context) {
         incrementRebuild();
    return Center(
      child: Text("Updates: $counter", style: const TextStyle(fontSize: 24)),
    );
  }
}