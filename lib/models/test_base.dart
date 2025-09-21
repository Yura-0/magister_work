// Класс універсальної моделі тесту
abstract class LoadTest {
  final String name;

  LoadTest(this.name);

  /// підготовка до тесту
  Future<void> setup();

  /// Виконання одної ітерації тесту
  Future<void> runIteration();

  /// завершення тесту, видалення ресурсів
  Future<void> teardown();
}
