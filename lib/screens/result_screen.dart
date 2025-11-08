// Екран результатів
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magi_work/models/test_results.dart';
import 'package:magi_work/blocs/test_config_cubit.dart';
import 'package:magi_work/screens/home_screen.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Результати тестування"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), 
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) =>
                      const HomeScreen()), 
              (Route<dynamic> route) => false, 
            );
          },
          tooltip: 'Повернутися на головний екран',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () {
              _copyResultsToClipboard(context);
            },
            tooltip: 'Копіювати результати в буфер обміну',
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              context.read<TestConfigCubit>().clearResults();
            },
            tooltip: 'Очистити результати',
          ),
        ],
      ),
      body: BlocBuilder<TestConfigCubit, TestConfigState>(
        builder: (context, state) {
          if (state.results.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.assessment, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    "Немає результатів для відображення",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Сводная статистика
              _buildSummaryCard(state.results),
              const SizedBox(height: 16),

              // Детальная таблица
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingRowColor: MaterialStateProperty.resolveWith(
                          (states) => Colors.blue[50],
                        ),
                        columns: const [
                          DataColumn(
                              label: Text("Сценарій",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text("Менеджер",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text("Ітерації",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text("FPS",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text("Frame Time (мс)",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text("±σ Frame Time",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text("95% Frame Time",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text("Jank %",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text("Latency (мс)",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text("Min/Max Latency",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text("RAM (МБ)",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text("Rebuilds",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                        ],
                        rows: state.results.map((TestResult result) {
                          return DataRow(
                            cells: [
                              DataCell(Text(result.scenarioName)),
                              DataCell(Text(result.stateManager)),
                              DataCell(Text(result.iterations.toString())),
                              DataCell(Text(result.avgFps.toStringAsFixed(1))),
                              DataCell(Text(
                                  result.avgFrameTimeMs.toStringAsFixed(2))),
                              DataCell(Text(
                                  "±${result.stdDevFrameTimeMs.toStringAsFixed(2)}")),
                              DataCell(Text(result.percentile95FrameTimeMs
                                  .toStringAsFixed(2))),
                              DataCell(Text(
                                  "${result.jankFramesPercent.toStringAsFixed(1)}%")),
                              DataCell(
                                  Text(result.avgLatencyMs.toStringAsFixed(2))),
                              DataCell(Text(
                                  "${result.minLatencyMs.toStringAsFixed(2)}/${result.maxLatencyMs.toStringAsFixed(2)}")),
                              DataCell(
                                  Text(result.ramUsageMb.toStringAsFixed(1))),
                              DataCell(Text(result.widgetRebuilds.toString())),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }

  void _copyResultsToClipboard(BuildContext context) {
    final state = context.read<TestConfigCubit>().state;
    if (state.results.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Немає результатів для копіювання')),
      );
      return;
    }

    try {
      // Создаем структурированные данные для экспорта
      final exportData = {
        'exportedAt': DateTime.now().toIso8601String(),
        'totalTests': state.results.length,
        'summary': _calculateSummary(state.results),
        'results': state.results.map((result) => result.toJson()).toList(),
      };

      // Конвертируем в красивый JSON
      const encoder = JsonEncoder.withIndent('  ');
      final jsonString = encoder.convert(exportData);

      // Копируем в буфер обмена
      Clipboard.setData(ClipboardData(text: jsonString));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Результати скопійовано в буфер обміну')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Помилка при копіюванні: $e')),
      );
    }
  }

  Map<String, dynamic> _calculateSummary(List<TestResult> results) {
    final avgFps =
        results.map((r) => r.avgFps).reduce((a, b) => a + b) / results.length;
    final avgFrameTime =
        results.map((r) => r.avgFrameTimeMs).reduce((a, b) => a + b) /
            results.length;
    final avgRam = results.map((r) => r.ramUsageMb).reduce((a, b) => a + b) /
        results.length;
    final avgLatency =
        results.map((r) => r.avgLatencyMs).reduce((a, b) => a + b) /
            results.length;
    final avgStdDev =
        results.map((r) => r.stdDevFrameTimeMs).reduce((a, b) => a + b) /
            results.length;
    final totalJankFrames =
        results.map((r) => r.jankFramesCount).reduce((a, b) => a + b);

    return {
      'averageFps': avgFps,
      'averageFrameTimeMs': avgFrameTime,
      'averageRamUsageMb': avgRam,
      'averageLatencyMs': avgLatency,
      'averageStdDevFrameTimeMs': avgStdDev,
      'totalJankFrames': totalJankFrames,
      'totalWidgetRebuilds':
          results.map((r) => r.widgetRebuilds).reduce((a, b) => a + b),
    };
  }

  Widget _buildSummaryCard(List<TestResult> results) {
    final avgFps =
        results.map((r) => r.avgFps).reduce((a, b) => a + b) / results.length;
    final avgFrameTime =
        results.map((r) => r.avgFrameTimeMs).reduce((a, b) => a + b) /
            results.length;
    final avgRam = results.map((r) => r.ramUsageMb).reduce((a, b) => a + b) /
        results.length;
    final totalJankFrames =
        results.map((r) => r.jankFramesCount).reduce((a, b) => a + b);

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Загальна статистика",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem("Середній FPS", avgFps.toStringAsFixed(1)),
                _buildStatItem(
                    "Час кадру", "${avgFrameTime.toStringAsFixed(2)} мс"),
                _buildStatItem("Пам'ять", "${avgRam.toStringAsFixed(1)} МБ"),
                _buildStatItem("Jank кадри", totalJankFrames.toString()),
                _buildStatItem("Тестів", results.length.toString()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
