// Управляння станом обраних тестів та менеджерів
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magi_work/models/test_results.dart';


enum StateManagerType { stateful, provider, bloc, riverpod }

class TestConfigState {
  final StateManagerType? selectedManager;
  final List<String> selectedTests;
  final int iterations;
  final List<TestResult> results; 
  const TestConfigState({
    this.selectedManager,
    this.selectedTests = const [],
    this.iterations = 10,
    this.results = const [],
  });

  TestConfigState copyWith({
    StateManagerType? selectedManager,
    List<String>? selectedTests,
    int? iterations,
    List<TestResult>? results,
  }) {
    return TestConfigState(
      selectedManager: selectedManager ?? this.selectedManager,
      selectedTests: selectedTests ?? this.selectedTests,
      iterations: iterations ?? this.iterations,
      results: results ?? this.results,
    );
  }
}

class TestConfigCubit extends Cubit<TestConfigState> {
  TestConfigCubit() : super(const TestConfigState());

  void selectManager(StateManagerType manager) {
    emit(state.copyWith(selectedManager: manager));
  }

  void toggleTest(String testName) {
    final updated = List<String>.from(state.selectedTests);
    if (updated.contains(testName)) {
      updated.remove(testName);
    } else {
      updated.add(testName);
    }
    emit(state.copyWith(selectedTests: updated));
  }

  void setIterations(int count) {
    emit(state.copyWith(iterations: count));
  }

  void addResult(TestResult result) {
    final updated = List<TestResult>.from(state.results)..add(result);
    emit(state.copyWith(results: updated));
  }

  void clearResults() {
    emit(state.copyWith(results: []));
  }

  void reset() {
    emit(const TestConfigState());
  }
}
