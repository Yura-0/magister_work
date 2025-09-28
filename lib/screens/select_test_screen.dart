import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magi_work/screens/bloc/test_config_cubit.dart';

class SelectTestScreen extends StatelessWidget {
  const SelectTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Вибір сценаріїв тестування"),
        centerTitle: true,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: _TestSelectionForm(),
      ),
    );
  }
}

class _TestSelectionForm extends StatelessWidget {
  const _TestSelectionForm();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TestConfigCubit, TestConfigState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Оберіть сценарії:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: const [
                  TestCheckbox(label: "ListTest", testKey: "ListTest"),
                  TestCheckbox(label: "FormTest", testKey: "FormTest"),
                  TestCheckbox(label: "AnimationTest", testKey: "AnimationTest"),
                  TestCheckbox(label: "ApiTest", testKey: "ApiTest"),
                  TestCheckbox(
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
                        // TODO: перейти на екран запуску тестів
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Тести запущені"),
                          ),
                        );
                      },
                child: const Text("Запустити тести"),
              ),
            ),
          ],
        );
      },
    );
  }
}

class TestCheckbox extends StatelessWidget {
  final String label;
  final String testKey;

  const TestCheckbox({
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
