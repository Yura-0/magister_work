import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magi_work/models/test_results.dart';
import 'package:magi_work/screens/bloc/test_config_cubit.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Результати тестування"),
        actions: [
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
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: MaterialStateProperty.resolveWith(
                        (states) => Colors.blue[50],
                      ),
                      columns: const [
                        DataColumn(label: Text("Сценарій", style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text("Менеджер", style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text("Ітерації", style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text("FPS", style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text("Frame Time (мс)", style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text("Latency (мс)", style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text("RAM (МБ)", style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text("Rebuilds", style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                      rows: state.results.map((TestResult result) {
                        return DataRow(
                          cells: [
                            DataCell(Text(result.scenarioName)),
                            DataCell(Text(result.stateManager)),
                            DataCell(Text(result.iterations.toString())),
                            DataCell(Text(result.avgFps.toStringAsFixed(2))),
                            DataCell(Text(result.avgFrameTimeMs.toStringAsFixed(2))),
                            DataCell(Text(result.avgLatencyMs.toStringAsFixed(2))),
                            DataCell(Text(result.ramUsageMb.toStringAsFixed(2))),
                            DataCell(Text(result.widgetRebuilds.toString())),
                          ],
                        );
                      }).toList(),
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

  Widget _buildSummaryCard(List<TestResult> results) {
    final avgFps = results.map((r) => r.avgFps).reduce((a, b) => a + b) / results.length;
    final avgFrameTime = results.map((r) => r.avgFrameTimeMs).reduce((a, b) => a + b) / results.length;
    final avgRam = results.map((r) => r.ramUsageMb).reduce((a, b) => a + b) / results.length;

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
                _buildStatItem("Середній FPS", avgFps.toStringAsFixed(2)),
                _buildStatItem("Час кадру", "${avgFrameTime.toStringAsFixed(2)} мс"),
                _buildStatItem("Пам'ять", "${avgRam.toStringAsFixed(2)} МБ"),
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
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}