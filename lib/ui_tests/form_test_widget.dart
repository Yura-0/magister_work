import 'package:flutter/material.dart';
import '../tests/form_test.dart';

class FormTestWidget extends StatefulWidget {
  final FormTest scenario;

  const FormTestWidget({Key? key, required this.scenario}) : super(key: key);

  @override
  State<FormTestWidget> createState() => _FormTestWidgetState();
}

class _FormTestWidgetState extends State<FormTestWidget> {
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        for (var controller in controllers)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(controller: controller),
          )
      ],
    );
  }
}
