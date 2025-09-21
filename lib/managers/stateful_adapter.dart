import 'package:flutter/material.dart';
import 'state_manager_base.dart';

class StatefulAdapter extends StatefulWidget {
  final Widget Function(void Function()) builder;

  const StatefulAdapter({Key? key, required this.builder}) : super(key: key);

  @override
  State<StatefulAdapter> createState() => _StatefulAdapterState();
}

class _StatefulAdapterState extends State<StatefulAdapter> implements StateManagerAdapter {
  late VoidCallback _rebuild;

  @override
  void initState() {
    super.initState();
    _rebuild = () => setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(_rebuild);
  }

  @override
  String get name => "StatefulWidget";

  @override
  void bindScenario(dynamic scenario) {
    scenario.onAction = _rebuild;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
