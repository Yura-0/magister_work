abstract class StateManagerAdapter {
  /// Назва менеджеру
  String get name;

  /// Запуск: підключення сценарію
  void bindScenario(dynamic scenario);

  /// Очищення після тесту
  void dispose();
}
