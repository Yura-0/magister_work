import 'package:flutter/material.dart';
import '../tests/subscription_test.dart';

class SubscriptionTestWidget extends StatefulWidget {
  final SubscriptionTest scenario;

  const SubscriptionTestWidget({Key? key, required this.scenario}) : super(key: key);

  @override
  State<SubscriptionTestWidget> createState() => _SubscriptionTestWidgetState();
}

class _SubscriptionTestWidgetState extends State<SubscriptionTestWidget> {
  int counter = 0;

  @override
  void initState() {
    super.initState();
    widget.scenario.onAction = _updateCounter;
  }

  void _updateCounter() {
    setState(() => counter++);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Updates: $counter", style: const TextStyle(fontSize: 24)),
    );
  }
}
