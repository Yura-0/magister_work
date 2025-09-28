import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magi_work/screens/bloc/test_config_cubit.dart';

class StressConfigScreen extends StatelessWidget {
  const StressConfigScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Конфігурація стрес-тесту"),
        centerTitle: true,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: _StressConfigForm(),
      ),
    );
  }
}

class _StressConfigForm extends StatelessWidget {
  const _StressConfigForm();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TestConfigCubit, TestConfigState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Оберіть сценарії для одночасного запуску:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: const [
                  StressTestCheckbox(label: "ListTest", testKey: "ListTest"),
                  StressTestCheckbox(label: "FormTest", testKey: "FormTest"),
                  StressTestCheckbox(
                      label: "AnimationTest", testKey: "AnimationTest"),
                  StressTestCheckbox(label: "ApiTest", testKey: "ApiTest"),
                  StressTestCheckbox(
                      label: "SubscriptionTest", testKey: "SubscriptionTest"),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const IterationsInput(),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: state.selectedTests.isEmpty
                    ? null
                    : () {
                        // TODO: запуск стрес-тесту
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Стрес-тест запущено"),
                          ),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text("Запустити стрес-тест"),
              ),
            ),
          ],
        );
      },
    );
  }
}

class StressTestCheckbox extends StatelessWidget {
  final String label;
  final String testKey;

  const StressTestCheckbox({
    super.key,
    required this.label,
    required this.testKey,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TestConfigCubit, TestConfigState>(
      builder: (context, state) {
        final isSelected = state.selectedTests.contains(testKey);

        return CheckboxListTile(
          value: isSelected,
          title: Text(label),
          onChanged: (_) {
            context.read<TestConfigCubit>().toggleTest(testKey);
          },
        );
      },
    );
  }
}

class IterationsInput extends StatelessWidget {
  const IterationsInput({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TestConfigCubit, TestConfigState>(
      builder: (context, state) {
        final controller =
            TextEditingController(text: state.iterations.toString());

        return TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Кількість ітерацій",
          ),
          onSubmitted: (value) {
            final intValue = int.tryParse(value) ?? 1;
            context.read<TestConfigCubit>().setIterations(intValue);
          },
        );
      },
    );
  }
}
