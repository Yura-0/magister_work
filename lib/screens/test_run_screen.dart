// Екран запуску тестів
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magi_work/core/utils/file_export.dart';
import 'package:magi_work/models/test_base.dart';
import 'package:magi_work/blocs/test_config_cubit.dart';
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
import '../core/metrics/widget_counter.dart'; // Додаємо імпорт

class TestRunnerScreen extends StatefulWidget {
  const TestRunnerScreen({super.key});

  @override
  State<TestRunnerScreen> createState() => _TestRunnerScreenState();
}

class _TestRunnerScreenState extends State<TestRunnerScreen> {
  late List<LoadTest> activeTests = [];
  bool isRunning = false;
  int currentIteration = 0;
  final Map<String, StatsRecorder> _testRecorders = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeTests();
    });
  }

  @override
  void dispose() {
    // Останавливаем все рекордеры
    for (final recorder in _testRecorders.values) {
      recorder.stopListening();
    }
    super.dispose();
  }

  void _initializeTests() {
    final state = context.read<TestConfigCubit>().state;
    activeTests.clear();
    _testRecorders.clear();

    for (final testKey in state.selectedTests) {
      switch (testKey) {
        case 'AnimationTest':
          final test = AnimationTest(
            elementsCount: 5,
            iterations: state.iterations,
          );
          activeTests.add(test);
          _testRecorders[test.name] = StatsRecorder();
          break;
        case 'ApiTest':
          final test = ApiTest(iterations: state.iterations);
          activeTests.add(test);
          _testRecorders[test.name] = StatsRecorder();
          break;
        case 'FormTest':
          final test = FormTest(
            fieldsCount: 5,
            iterations: state.iterations,
          );
          activeTests.add(test);
          _testRecorders[test.name] = StatsRecorder();
          break;
        case 'ListTest':
          final test = ListTest(
            initialCount: 100,
            iterations: state.iterations,
          );
          activeTests.add(test);
          _testRecorders[test.name] = StatsRecorder();
          break;
        case 'SubscriptionTest':
          final test = SubscriptionTest(
            updatesPerSecond: 10,
            iterations: state.iterations,
          );
          activeTests.add(test);
          _testRecorders[test.name] = StatsRecorder();
          break;
      }
    }
    setState(() {});
  }

  Future<void> _runTests() async {
    if (isRunning || activeTests.isEmpty) return;

    setState(() {
      isRunning = true;
      currentIteration = 0;
    });

    // Сброс и запуск сбора метрик для каждого теста
    for (final recorder in _testRecorders.values) {
      recorder.reset();
      recorder.startListening();
    }

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

      // Начало измерения кадра для каждого теста
      for (final recorder in _testRecorders.values) {
        recorder.startFrame();
      }

      final iterationStart = DateTime.now();

      // Запускаем все тесты параллельно
      await Future.wait(
        activeTests.map((test) => test.runIteration()),
      );

      // Измеряем латенцию (время выполнения итерации)
      final iterationEnd = DateTime.now();
      final latencyMs = iterationEnd.difference(iterationStart).inMilliseconds.toDouble();

      // Записываем латенцию и завершаем кадр для каждого теста
      for (final recorder in _testRecorders.values) {
        recorder.recordLatencyMs(latencyMs);
        recorder.endFrame();
      }

      // Небольшая задержка между итерациями для визуализации
      await Future.delayed(const Duration(milliseconds: 10));
    }

    // Teardown всех тестов
    for (final test in activeTests) {
      await test.teardown();
    }

    // Остановка сбора метрик для всех тестов
    for (final recorder in _testRecorders.values) {
      recorder.stopListening();
    }

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
    
    // Создаем результат для каждого теста с его собственным рекордером
    for (final test in activeTests) {
      final recorder = _testRecorders[test.name];
      if (recorder != null) {
        final result = recorder.buildResult(
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

  void _stopTests() {
    setState(() {
      isRunning = false;
    });
    // Останавливаем все рекордеры
    for (final recorder in _testRecorders.values) {
      recorder.stopListening();
    }
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
          const _ControlPanel(),
          
          // Прогресс бар
          _ProgressBar(
            isRunning: isRunning,
            currentIteration: currentIteration,
            activeTests: activeTests,
          ),
          
          // Виджеты тестов
          _TestWidgetsList(
            activeTests: activeTests,
            testRecorders: _testRecorders,
          ),
        ],
      ),
    );
  }
}

class _ControlPanel extends StatelessWidget {
  const _ControlPanel();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TestConfigCubit, TestConfigState>(
      builder: (context, state) {
        final screenState = context.findAncestorStateOfType<_TestRunnerScreenState>();
        
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
                    'Активні тести: ${state.selectedTests.length}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Ітерації: ${screenState?.currentIteration ?? 0}/${state.iterations}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
              Row(
                children: [
                  if (screenState?.isRunning != true)
                    ElevatedButton.icon(
                      onPressed: screenState?._runTests,
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Запустити'),
                    )
                  else
                    ElevatedButton.icon(
                      onPressed: screenState?._stopTests,
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
      },
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final bool isRunning;
  final int currentIteration;
  final List<LoadTest> activeTests;

  const _ProgressBar({
    required this.isRunning,
    required this.currentIteration,
    required this.activeTests,
  });

  @override
  Widget build(BuildContext context) {
    if (activeTests.isEmpty) {
      return const SizedBox();
    }

    final totalIterations = activeTests.isNotEmpty ? activeTests.first.iterations : 0;
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
}

class _TestWidgetsList extends StatelessWidget {
  final List<LoadTest> activeTests;
  final Map<String, StatsRecorder> testRecorders;

  const _TestWidgetsList({
    required this.activeTests,
    required this.testRecorders,
  });

  @override
  Widget build(BuildContext context) {
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
          final recorder = testRecorders[test.name];
          if (recorder == null) return const SizedBox();
          
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
                      child: WidgetCounterScope(
                        counter: recorder.widgetCounter,
                        child: _TestWidget(test: test),
                      ),
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
}

class _TestWidget extends StatelessWidget {
  final LoadTest test;

  const _TestWidget({required this.test});

  @override
  Widget build(BuildContext context) {
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