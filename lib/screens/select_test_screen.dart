// Екран вибору тестів
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magi_work/blocs/test_config_cubit.dart';
import 'package:magi_work/screens/test_run_screen.dart';

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
            // Выбор менеджера состояний
            const Text(
              "Оберіть менеджер стану:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const _ManagerDropdown(),
            const SizedBox(height: 16),

            // Выбор тестов
            const Text(
              "Оберіть сценарії:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const _SelectAllButton(),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(children: const [
                TestCheckbox(label: "List Test", testKey: "ListTest"),
                TestCheckbox(label: "Form Test", testKey: "FormTest"),
                TestCheckbox(label: "Animation Test", testKey: "AnimationTest"),
                TestCheckbox(label: "API Test", testKey: "ApiTest"),
                TestCheckbox(
                    label: "Subscription Test", testKey: "SubscriptionTest"),
              ]),
            ),

            // Количество повторений
            const _RepetitionsSelector(),

            const SizedBox(height: 16),

            // Количество итераций
            const IterationsInput(),

            // // Информация о предстоящем тесте
            // if (state.selectedTests.isNotEmpty && state.selectedManager != null)
            //   const _TestInfoCard(),

            const SizedBox(height: 16),

            // Кнопка запуска
            const _StartTestButton(),
          ],
        );
      },
    );
  }
}

class _ManagerDropdown extends StatelessWidget {
  const _ManagerDropdown();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TestConfigCubit, TestConfigState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(4),
          ),
          child: DropdownButton<StateManagerType>(
            value: state.selectedManager,
            isExpanded: true,
            underline: const SizedBox(),
            hint: const Text('Оберіть менеджер стану'),
            onChanged: (value) {
              if (value != null) {
                context.read<TestConfigCubit>().selectManager(value);
              }
            },
            items: const [
              DropdownMenuItem(
                value: StateManagerType.stateful,
                child: Text('StatefulWidget'),
              ),
              DropdownMenuItem(
                value: StateManagerType.provider,
                child: Text('Provider'),
              ),
              DropdownMenuItem(
                value: StateManagerType.bloc,
                child: Text('Bloc'),
              ),
              DropdownMenuItem(
                value: StateManagerType.riverpod,
                child: Text('Riverpod'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SelectAllButton extends StatelessWidget {
  const _SelectAllButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TestConfigCubit, TestConfigState>(
      builder: (context, state) {
        final allSelected = state.selectedTests.length == 5;

        return OutlinedButton(
          onPressed: () {
           final allTests = const ["ListTest", "FormTest", "AnimationTest", "ApiTest", "SubscriptionTest"];

            if (allSelected) {
              // Очищаем все
              for (final test in allTests) {
                if (state.selectedTests.contains(test)) {
                  context.read<TestConfigCubit>().toggleTest(test);
                }
              }
            } else {
              // Выбираем все
              for (final test in allTests) {
                if (!state.selectedTests.contains(test)) {
                  context.read<TestConfigCubit>().toggleTest(test);
                }
              }
            }
          },
          child: Text(allSelected ? 'Зняти всі' : 'Обрати всі'),
        );
      },
    );
  }
}

class _RepetitionsSelector extends StatelessWidget {
  const _RepetitionsSelector();

  String _getRepetitionText(int count) {
    if (count == 1) return '';
    if (count >= 2 && count <= 4) return 'и';
    return 'ів';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TestConfigCubit, TestConfigState>(
      builder: (context, state) {
        return ListTile(
          title: const Text('Кількість повторень кожного тесту'),
          subtitle: const Text('Рекомендується 5 для статистичної значущості'),
          trailing: DropdownButton<int>(
            value: state.repetitions,
            onChanged: (value) {
              if (value != null) {
                context.read<TestConfigCubit>().setRepetitions(value);
              }
            },
            items: [1, 3, 5, 10]
                .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text('$e раз${_getRepetitionText(e)}'),
                    ))
                .toList(),
          ),
        );
      },
    );
  }
}

class _TestInfoCard extends StatelessWidget {
  const _TestInfoCard();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TestConfigCubit, TestConfigState>(
      builder: (context, state) {
        final totalTests = state.selectedTests.length;
        final totalRuns = totalTests * state.repetitions;
        final estimatedTime =
            (totalRuns * state.iterations * 0.05 / 60).toStringAsFixed(1);

        return Card(
          color: Colors.blue[50],
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Інформація про тестування:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text("• Тестів: $totalTests"),
                Text("• Повторень на тест: ${state.repetitions}"),
                Text("• Ітерацій на запуск: ${state.iterations}"),
                Text("• Всього запусків: $totalRuns"),
                Text("• Приблизний час: ~${estimatedTime} хв"),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StartTestButton extends StatelessWidget {
  const _StartTestButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TestConfigCubit, TestConfigState>(
      builder: (context, state) {
        final isEnabled =
            state.selectedTests.isNotEmpty && state.selectedManager != null;

        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isEnabled
                ? () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => BlocProvider.value(
                          value: context.read<TestConfigCubit>(),
                          child: const TestRunnerScreen(),
                        ),
                      ),
                    );
                  }
                : null,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: isEnabled ? Colors.blue : Colors.grey,
            ),
            child: isEnabled
                ? const Text(
                    "Запустити тести",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  )
                : const Text("Оберіть тести та менеджер"),
          ),
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

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: CheckboxListTile(
            value: isSelected,
            title: Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.blue : Colors.black,
              ),
            ),
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (_) {
              context.read<TestConfigCubit>().toggleTest(testKey);
            },
          ),
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
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Кількість ітерацій на тест:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller:
                  TextEditingController(text: state.iterations.toString()),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Введіть кількість ітерацій",
                hintText: "100",
              ),
              onSubmitted: (value) {
                final intValue = int.tryParse(value) ?? 100;
                if (intValue < 1) return;
                context.read<TestConfigCubit>().setIterations(intValue);
              },
            ),
            const SizedBox(height: 4),
            Text(
              "Рекомендується 100+ ітерацій для стабільних результатів",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        );
      },
    );
  }
}
