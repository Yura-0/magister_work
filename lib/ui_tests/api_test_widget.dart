// Віджет моделі тесту з API
import 'package:flutter/material.dart';
import 'package:magi_work/core/metrics/widget_counter.dart';
import '../tests/api_test.dart';

class ApiTestWidget extends StatefulWidget {
  final ApiTest scenario;

  const ApiTestWidget({Key? key, required this.scenario}) : super(key: key);

  @override
  State<ApiTestWidget> createState() => _ApiTestWidgetState();
}

class _ApiTestWidgetState extends State<ApiTestWidget> with WidgetCounterMixin {
  String data = "No data";

  @override
  void initState() {
    super.initState();
    widget.scenario.onAction = _loadData;
  }

  void _loadData() async {
    await Future.delayed(const Duration(milliseconds: 50));
    setState(() {
      data = "Data updated at ${DateTime.now().toIso8601String()}";
      incrementRebuild(); // Считаем ребилд
    });
  }

  @override
  Widget build(BuildContext context) {
         incrementRebuild();
    return Center(child: Text(data));
  }
}