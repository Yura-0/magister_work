// Модель для тесту анімації
import '../models/test_base.dart';

class AnimationTest extends LoadTest {
  final int elementsCount;
  final int iterations;
  void Function()? onAction;

  AnimationTest({this.elementsCount = 5, this.iterations = 300}) : super("Animation Test");

  @override
  Future<void> setup() async {}

  @override
  Future<void> runIteration() async {
    onAction?.call();
  }

  @override
  Future<void> teardown() async {}
}
