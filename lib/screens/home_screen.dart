// Головний екран
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magi_work/screens/result_screen.dart';
import 'package:magi_work/screens/select_test_screen.dart';
import 'package:magi_work/blocs/test_config_cubit.dart';
import 'package:magi_work/screens/select_manager_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TestConfigCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Benchmark Home"),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // BuildButton(
              //   label: "Обрати менеджер стану",
              //   onTap: () => Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (_) => BlocProvider.value(
              //         value: context.read<TestConfigCubit>(),
              //         child: const SelectManagerScreen(),
              //       ),
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 16),
              BuildButton(
                label: "Обрати тест",
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: context.read<TestConfigCubit>(),
                      child: const SelectTestScreen(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              BuildButton(
                label: "Результати",
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ResultsScreen(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BuildButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const BuildButton({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: const TextStyle(fontSize: 18),
        ),
        child: Text(label),
      ),
    );
  }
}
