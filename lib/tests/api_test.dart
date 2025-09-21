// Модель для тесту API
import '../models/test_base.dart';

class ApiTest extends LoadTest {
  final int iterations;
  void Function()? onAction;

  ApiTest({this.iterations = 100}) : super("API Test");

  @override
  Future<void> setup() async {}

  @override
  Future<void> runIteration() async {
    // імітація "нового запроса"
    onAction?.call();
  }

  @override
  Future<void> teardown() async {}
}
