// Екран вибору менеджера стану
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magi_work/blocs/test_config_cubit.dart';


class SelectManagerScreen extends StatelessWidget {
  const SelectManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Вибір менеджера стану"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            ManagerButton(
              label: "StatefulWidget",
              managerType: StateManagerType.stateful,
            ),
            SizedBox(height: 16),
            ManagerButton(
              label: "Provider",
              managerType: StateManagerType.provider,
            ),
            SizedBox(height: 16),
            ManagerButton(
              label: "Bloc",
              managerType: StateManagerType.bloc,
            ),
            SizedBox(height: 16),
            ManagerButton(
              label: "Riverpod",
              managerType: StateManagerType.riverpod,
            ),
          ],
        ),
      ),
    );
  }
}

class ManagerButton extends StatelessWidget {
  final String label;
  final StateManagerType managerType;

  const ManagerButton({
    super.key,
    required this.label,
    required this.managerType,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TestConfigCubit, TestConfigState>(
      builder: (context, state) {
        final isSelected = state.selectedManager == managerType;

        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              context.read<TestConfigCubit>().selectManager(managerType);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Вибрано: $label"),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              textStyle: const TextStyle(fontSize: 18),
              backgroundColor:
                  isSelected ? Colors.blueAccent : const Color.fromARGB(255, 242, 242, 242),
            ),
            child: Text(label),
          ),
        );
      },
    );
  }
}
