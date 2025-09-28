import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magi_work/screens/bloc/test_config_cubit.dart';
import 'package:magi_work/screens/result_screen.dart';

import 'screens/home_screen.dart';
import 'screens/select_manager_screen.dart';
import 'screens/select_test_screen.dart';


class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TestConfigCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'State Managers Benchmark',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
          '/select_manager': (context) => const SelectManagerScreen(),
          '/select_tests': (context) => const SelectTestScreen(),
          '/results': (context) => const ResultsScreen(),
        },
      ),
    );
  }
}
