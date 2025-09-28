// Класс універсальної моделі тесту
abstract class LoadTest {
  final String name;
  final int iterations;

  LoadTest(this.name, {this.iterations = 100});

  /// підготовка до тесту
  Future<void> setup();

  /// Виконання одної ітерації тесту
  Future<void> runIteration();

  /// завершення тесту, видалення ресурсів
  Future<void> teardown();
}