import 'package:magi_work/core/metrics/stats_recorder.dart';
import 'package:magi_work/core/metrics/widget_counter.dart';
import 'package:magi_work/models/test_results.dart';

class TestRunner {
  static const int WARM_UP_ITERATIONS = 20;
  static const int MEASURED_ITERATIONS = 100;
  
  Future<TestResult> runSingleTest({
    required String scenario,
    required String manager,
    required int iterations,
  }) async {
   
    await Future.delayed(const Duration(seconds: 1));
    
    
    final recorder = StatsRecorder();
    recorder.startListening();
    
    try {
    
      for (int i = 0; i < WARM_UP_ITERATIONS; i++) {
        await _runScenario(scenario, manager, recorder.widgetCounter);
        await Future.delayed(const Duration(milliseconds: 16));
      }
      
     
      for (int i = 0; i < iterations; i++) {
        recorder.startFrame();
        await _runScenario(scenario, manager, recorder.widgetCounter);
        recorder.endFrame();
        await Future.delayed(const Duration(milliseconds: 16));
      }
      
      return recorder.buildResult(scenario, manager, iterations);
    } finally {
      recorder.stopListening();
    }
  }
  
  Future<void> _runScenario(String scenario, String manager, WidgetCounter counter) async {}
}