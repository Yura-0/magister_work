import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magi_work/core/utils/file_export.dart';
import 'package:magi_work/models/test_base.dart';
import 'package:magi_work/screens/bloc/test_config_cubit.dart';
import 'package:magi_work/screens/result_screen.dart';
import 'package:magi_work/ui_tests/animation_test_widget.dart';
import 'package:magi_work/ui_tests/api_test_widget.dart';
import 'package:magi_work/ui_tests/form_test_widget.dart';
import 'package:magi_work/ui_tests/list_test_widget.dart';
import 'package:magi_work/ui_tests/subscription_test_widget.dart';
import '../tests/animation_test.dart';
import '../tests/api_test.dart';
import '../tests/form_test.dart';
import '../tests/list_test.dart';
import '../tests/subscription_test.dart';
import '../core/metrics/stats_recorder.dart';


class TestRunnerScreen extends StatefulWidget {
  const TestRunnerScreen({super.key});

  @override
  State<TestRunnerScreen> createState() => _TestRunnerScreenState();
}

class _TestRunnerScreenState extends State<TestRunnerScreen> {
  late List<LoadTest> activeTests = [];
  bool isRunning = false;
  int currentIteration = 0;
  late StatsRecorder statsRecorder;

  @override
  void initState() {
    super.initState();
    statsRecorder = StatsRecorder();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeTests();
    });
  }

  @override
  void dispose() {
    statsRecorder.stopListening();
    super.dispose();
  }

  void _initializeTests() {
    final state = context.read<TestConfigCubit>().state;
    activeTests.clear();

    for (final testKey in state.selectedTests) {
      switch (testKey) {
        case 'AnimationTest':
          activeTests.add(AnimationTest(
            elementsCount: 5,
            iterations: state.iterations,
          ));
          break;
        case 'ApiTest':
          activeTests.add(ApiTest(iterations: state.iterations));
          break;
        case 'FormTest':
          activeTests.add(FormTest(
            fieldsCount: 5,
            iterations: state.iterations,
          ));
          break;
        case 'ListTest':
          activeTests.add(ListTest(
            initialCount: 100,
            iterations: state.iterations,
          ));
          break;
        case 'SubscriptionTest':
          activeTests.add(SubscriptionTest(
            updatesPerSecond: 10,
            iterations: state.iterations,
          ));
          break;
      }
    }
    setState(() {});
  }

 // Обнови метод _runTests в TestRunnerScreen
Future<void> _runTests() async {
  if (isRunning) return;

  setState(() {
    isRunning = true;
    currentIteration = 0;
  });

  // Сброс и запуск сбора метрик
  statsRecorder.reset();
  statsRecorder.startListening();

  // Setup всех тестов
  for (final test in activeTests) {
    await test.setup();
  }

  // Запуск итераций
  final totalIterations = activeTests.isNotEmpty ? activeTests.first.iterations : 0;
  
  for (int i = 0; i < totalIterations; i++) {
    if (!mounted) break;
    
    setState(() {
      currentIteration = i + 1;
    });

    // Начало измерения кадра и латенции
    statsRecorder.startFrame();
    final iterationStart = DateTime.now();

    // Запускаем все тесты параллельно
    await Future.wait(
      activeTests.map((test) => test.runIteration()),
    );

    // Измеряем латенцию (время выполнения итерации)
    final iterationEnd = DateTime.now();
    final latencyMs = iterationEnd.difference(iterationStart).inMilliseconds.toDouble();
    statsRecorder.recordLatencyMs(latencyMs);

    // Конец измерения кадра
    statsRecorder.endFrame();

    // Небольшая задержка между итерациями для визуализации
    await Future.delayed(const Duration(milliseconds: 10));
  }

  // Teardown всех тестов
  for (final test in activeTests) {
    await test.teardown();
  }

  // Остановка сбора метрик
  statsRecorder.stopListening();

  if (mounted) {
    setState(() {
      isRunning = false;
    });
    
    // Сохранение результатов и переход на экран результатов
    await _saveResults();
    _navigateToResults();
  }
}
  Future<void> _saveResults() async {
    final cubit = context.read<TestConfigCubit>();
    final state = cubit.state;
    
    // Создаем результат для каждого теста
    for (final test in activeTests) {
      final result = statsRecorder.buildResult(
        test.name,
        state.selectedManager?.toString().split('.').last ?? 'unknown',
        state.iterations,
      );
      
      // Сохраняем в кубит
      cubit.addResult(result);
      
      // Сохраняем в файл
      await FileExport.saveResult(result);
    }
  }

  void _navigateToResults() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: context.read<TestConfigCubit>(),
          child: const ResultsScreen(),
        ),
      ),
    );
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Тести завершено'),
        content: Text('Успішно виконано $currentIteration ітерацій для ${activeTests.length} тестів'),
        actions: [
          TextButton(
            onPressed: () => _navigateToResults(),
            child: const Text('Перейти до результатів'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Закрити'),
          ),
        ],
      ),
    );
  }

  void _stopTests() {
    setState(() {
      isRunning = false;
    });
    statsRecorder.stopListening();
  }

  void _goBack() {
    if (isRunning) {
      _stopTests();
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Запуск тестів'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _goBack,
        ),
      ),
      body: Column(
        children: [
          // Панель управления
          _buildControlPanel(),
          
          // Прогресс бар
          _buildProgressBar(),
          
          // Виджеты тестов
          _buildTestWidgets(),
        ],
      ),
    );
  }

  Widget _buildControlPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[100],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Активні тести: ${activeTests.length}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                'Ітерації: ${currentIteration}/${activeTests.isNotEmpty ? activeTests.first.iterations : 0}',
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
          Row(
            children: [
              if (!isRunning)
                ElevatedButton.icon(
                  onPressed: _runTests,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Запустити'),
                )
              else
                ElevatedButton.icon(
                  onPressed: _stopTests,
                  icon: const Icon(Icons.stop),
                  label: const Text('Зупинити'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    if (activeTests.isEmpty) {
      return const SizedBox();
    }

    final totalIterations = activeTests.first.iterations;
    final progress = totalIterations > 0 ? currentIteration / totalIterations : 0.0;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Ітерація: $currentIteration / $totalIterations',
            textAlign: TextAlign.center,
          ),
        ),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(
            isRunning ? Colors.blue : Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildTestWidgets() {
    if (activeTests.isEmpty) {
      return const Expanded(
        child: Center(
          child: Text('Немає активних тестів'),
        ),
      );
    }

    return Expanded(
      child: ListView(
        children: activeTests.map((test) {
          return Card(
            margin: const EdgeInsets.all(8),
            child: SizedBox(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      test.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: _buildTestWidget(test),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTestWidget(LoadTest test) {
    switch (test.runtimeType) {
      case AnimationTest:
        return AnimationTestWidget(scenario: test as AnimationTest);
      case ApiTest:
        return ApiTestWidget(scenario: test as ApiTest);
      case FormTest:
        return FormTestWidget(scenario: test as FormTest);
      case ListTest:
        return ListTestWidget(scenario: test as ListTest);
      case SubscriptionTest:
        return SubscriptionTestWidget(scenario: test as SubscriptionTest);
      default:
        return Center(
          child: Text('Не підтримуваний тип тесту: ${test.runtimeType}'),
        );
    }
  }
}