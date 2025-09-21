import 'package:flutter/material.dart';
import '../tests/list_test.dart';

class ListTestWidget extends StatefulWidget {
  final ListTest scenario;

  const ListTestWidget({super.key, required this.scenario});

  @override
  State<ListTestWidget> createState() => _ListTestWidgetState();
}

class _ListTestWidgetState extends State<ListTestWidget> {
  late List<int> items;

  @override
  void initState() {
    super.initState();
    items = List.generate(widget.scenario.initialCount, (i) => i);

    widget.scenario.onAction = _modifyList;
  }

  void _modifyList() {
    setState(() {
      if (items.length % 2 == 0) {
        items.add(items.length + 1);
      } else {
        if (items.isNotEmpty) items.removeAt(0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (_, i) => ListTile(title: Text("Item ${items[i]}")),
    );
  }
}
