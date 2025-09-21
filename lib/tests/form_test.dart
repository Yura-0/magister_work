// Модель для тесту форм
import '../models/test_base.dart';

class FormTest extends LoadTest {
  final int fieldsCount;
  final int iterations;
  void Function()? onAction;

  FormTest({this.fieldsCount = 5, this.iterations = 200}) : super("Form Test");

  @override
  Future<void> setup() async {}

  @override
  Future<void> runIteration() async {
    onAction?.call();
  }

  @override
  Future<void> teardown() async {}
}

