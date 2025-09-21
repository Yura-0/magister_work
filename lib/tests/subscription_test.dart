// Модель для тесту підписки
import '../models/test_base.dart';

class SubscriptionTest extends LoadTest {
  final int updatesPerSecond;
  final int iterations;
  void Function()? onAction;

  SubscriptionTest({this.updatesPerSecond = 10, this.iterations = 200}) : super("Subscription Test");

  @override
  Future<void> setup() async {}

  @override
  Future<void> runIteration() async {
    onAction?.call();
  }

  @override
  Future<void> teardown() async {}
}

