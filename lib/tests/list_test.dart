// Модель для тесту списку
import '../models/test_base.dart';

class ListTest extends LoadTest {
  final int initialCount;
  final int iterations;
  void Function()? onAction;

  ListTest({this.initialCount = 100, this.iterations = 500}) : super("List Test");

  @override
  Future<void> setup() async {}

  @override
  Future<void> runIteration() async {
    // Масова модифікація списку
    onAction?.call();
  }

  @override
  Future<void> teardown() async {}
}
