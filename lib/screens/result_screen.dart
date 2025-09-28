import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magi_work/models/test_results.dart';
import 'package:magi_work/screens/bloc/test_config_cubit.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TestConfigCubit, TestConfigState>(
      builder: (context, state) {
        if (state.results.isEmpty) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Результати"),
            ),
            body: const Center(
              child: Text("Немає результатів для відображення"),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text("Результати"),
          ),
          body: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text("Сценарій")),
                DataColumn(label: Text("Менеджер")),
                DataColumn(label: Text("Ітерації")),
                DataColumn(label: Text("FPS")),
                DataColumn(label: Text("Frame Time (мс)")),
                DataColumn(label: Text("Latency (мс)")),
                DataColumn(label: Text("RAM (МБ)")),
                DataColumn(label: Text("Rebuilds")),
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
        );
      },
    );
  }
}
