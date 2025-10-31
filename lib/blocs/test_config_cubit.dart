// Управляння станом обраних тестів та менеджерів
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magi_work/blocs/test_runner.dart';
import 'package:magi_work/models/test_results.dart';

enum StateManagerType { stateful, provider, bloc, riverpod }

// Новый класс для конфигурации теста
class TestConfig {
  final String scenario;
  final String manager;
  
  const TestConfig(this.scenario, this.manager);
}

// Новый статус тестирования
enum TestStatus { idle, running, completed }

class TestConfigState {
  final StateManagerType? selectedManager;
  final List<String> selectedTests;
  final int iterations;
  final int repetitions; // НОВОЕ: количество повторностей
  final List<TestResult> results;
  final TestStatus testStatus; // НОВОЕ: статус тестирования
  final double progress; // НОВОЕ: прогресс тестирования
  
  const TestConfigState({
    this.selectedManager,
    this.selectedTests = const [],
    this.iterations = 100, // Увеличил по умолчанию
    this.repetitions = 5, // НОВОЕ: 5 повторностей по умолчанию
    this.results = const [],
    this.testStatus = TestStatus.idle, // НОВОЕ
    this.progress = 0.0, // НОВОЕ
  });

  TestConfigState copyWith({
    StateManagerType? selectedManager,
    List<String>? selectedTests,
    int? iterations,
    int? repetitions,
    List<TestResult>? results,
    TestStatus? testStatus,
    double? progress,
  }) {
    return TestConfigState(
      selectedManager: selectedManager ?? this.selectedManager,
      selectedTests: selectedTests ?? this.selectedTests,
      iterations: iterations ?? this.iterations,
      repetitions: repetitions ?? this.repetitions,
      results: results ?? this.results,
      testStatus: testStatus ?? this.testStatus,
      progress: progress ?? this.progress,
    );
  }
}

class TestConfigCubit extends Cubit<TestConfigState> {
  TestConfigCubit() : super(const TestConfigState());

  // НОВОЕ: Список всех доступных менеджеров для удобства
  static const List<String> allManagers = [
    'stateful',
    'provider', 
    'bloc',
    'riverpod'
  ];

  // НОВОЕ: Список всех доступных тестов
  static const List<String> allTests = [
    'List Test',
    'Form Test',
    'Animation Test',
    'API Test',
    'Subscription Test'
  ];

  void selectManager(StateManagerType manager) {
    emit(state.copyWith(selectedManager: manager));
  }

  void toggleTest(String testName) {
    final updated = List<String>.from(state.selectedTests);
    if (updated.contains(testName)) {
      updated.remove(testName);
    } else {
      updated.add(testName);
    }
    emit(state.copyWith(selectedTests: updated));
  }

  void setIterations(int count) {
    emit(state.copyWith(iterations: count));
  }

  // НОВОЕ: Установка количества повторностей
  void setRepetitions(int count) {
    emit(state.copyWith(repetitions: count));
  }

  // НОВОЕ: Выбор всех менеджеров
  void selectAllManagers() {
    // Для упрощения - используем строковые идентификаторы
    // StateManagerType оставляем для UI, а для тестов используем строки
  }

  // НОВОЕ: Выбор всех тестов
  void selectAllTests() {
    emit(state.copyWith(selectedTests: List<String>.from(allTests)));
  }

  void addResult(TestResult result) {
    final updated = List<TestResult>.from(state.results)..add(result);
    emit(state.copyWith(results: updated));
  }

  void clearResults() {
    emit(state.copyWith(results: []));
  }

  void reset() {
    emit(const TestConfigState());
  }

  // НОВОЕ: Основной метод запуска тестов
  Future<void> runAllTests() async {
    if (state.selectedTests.isEmpty) {
      throw Exception('Оберіть хоча б один тест');
    }

    // Определяем выбранные менеджеры
    final selectedManagers = _getSelectedManagers();
    if (selectedManagers.isEmpty) {
      throw Exception('Оберіть хоча б один менеджер стану');
    }

    emit(state.copyWith(
      testStatus: TestStatus.running,
      progress: 0.0,
      results: [], // Очищаем предыдущие результаты
    ));

    final results = <TestResult>[];
    final testRunner = TestRunner();
    
    // Генерируем все комбинации тестов и перемешиваем
    final testCombinations = _generateTestCombinations(selectedManagers)..shuffle();
    final totalTests = testCombinations.length * state.repetitions;
    var completedTests = 0;

    try {
      for (final config in testCombinations) {
        for (int repetition = 0; repetition < state.repetitions; repetition++) {
          // Запускаем один тест
          final result = await testRunner.runSingleTest(
            scenario: config.scenario,
            manager: config.manager,
            iterations: state.iterations,
          );
          
          results.add(result);
          completedTests++;
          
          // Обновляем прогресс
          final progress = completedTests / totalTests;
          emit(state.copyWith(
            results: List<TestResult>.from(results),
            progress: progress,
          ));
          
          // Пауза между повторностями (кроме последней)
          if (repetition < state.repetitions - 1) {
            await Future.delayed(const Duration(seconds: 2));
          }
        }
        
        // Пауза между разными конфигурациями
        await Future.delayed(const Duration(seconds: 1));
      }
      
      emit(state.copyWith(
        testStatus: TestStatus.completed,
        progress: 1.0,
      ));
      
    } catch (e) {
      emit(state.copyWith(
        testStatus: TestStatus.idle,
      ));
      rethrow;
    }
  }

  // НОВОЕ: Получаем выбранные менеджеры в строковом формате
  List<String> _getSelectedManagers() {
    if (state.selectedManager == null) return [];
    
    switch (state.selectedManager!) {
      case StateManagerType.stateful:
        return ['stateful'];
      case StateManagerType.provider:
        return ['provider'];
      case StateManagerType.bloc:
        return ['bloc'];
      case StateManagerType.riverpod:
        return ['riverpod'];
    }
  }

  // НОВОЕ: Генерация всех комбинаций тестов
  List<TestConfig> _generateTestCombinations(List<String> managers) {
    return [
      for (final scenario in state.selectedTests)
        for (final manager in managers)
          TestConfig(scenario, manager),
    ];
  }

  // НОВОЕ: Остановка тестов
  void stopTests() {
    emit(state.copyWith(
      testStatus: TestStatus.idle,
    ));
  }
}