// Віджет моделі тесту з формами
import 'package:flutter/material.dart';
import 'package:magi_work/core/metrics/widget_counter.dart';
import '../tests/form_test.dart';

class FormTestWidget extends StatefulWidget {
  final FormTest scenario;

  const FormTestWidget({Key? key, required this.scenario}) : super(key: key);

  @override
  State<FormTestWidget> createState() => _FormTestWidgetState();
}

class _FormTestWidgetState extends State<FormTestWidget> with WidgetCounterMixin {
  late List<TextEditingController> controllers;

  @override
  void initState() {
    super.initState();
    controllers = List.generate(widget.scenario.fieldsCount, (_) => TextEditingController());
    widget.scenario.onAction = _simulateInput;
  }

  void _simulateInput() {
    setState(() {
      for (int i = 0; i < controllers.length; i++) {
        controllers[i].text += String.fromCharCode(97 + (i % 26));
      }
      incrementRebuild(); // Считаем ребилд
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: controllers.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(controller: controllers[index]),
        );
      },
    );
  }
}