// Віджет моделі тесту з анімації
import 'package:flutter/material.dart';
import 'package:magi_work/core/metrics/widget_counter.dart';
import '../tests/animation_test.dart';

class AnimationTestWidget extends StatefulWidget {
  final AnimationTest scenario;

  const AnimationTestWidget({Key? key, required this.scenario}) : super(key: key);

  @override
  State<AnimationTestWidget> createState() => _AnimationTestWidgetState();
}

class _AnimationTestWidgetState extends State<AnimationTestWidget> with WidgetCounterMixin {
  bool toggled = false;

  @override
  void initState() {
    super.initState();
    widget.scenario.onAction = _toggleAnimation;
  }

  void _toggleAnimation() {
    setState(() {
      toggled = !toggled;
      incrementRebuild(); // Считаем ребилд
    });
  }

  @override
  Widget build(BuildContext context) {
     incrementRebuild();
    return Center(
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: List.generate(
          widget.scenario.elementsCount,
          (i) => AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            width: toggled ? 50 : 100,
            height: toggled ? 100 : 50,
            color: Colors.primaries[i % Colors.primaries.length],
          ),
        ),
      ),
    );
  }
}