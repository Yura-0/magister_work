// Експорт результатів тестів
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:magi_work/models/test_results.dart';

class FileExport {
  static Future<File> _getLocalFile(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final resultsDir = Directory('${directory.path}/results');
    
    if (!await resultsDir.exists()) {
      await resultsDir.create(recursive: true);
    }
    
    return File('${resultsDir.path}/$fileName');
  }

  static Future<void> saveResult(
    TestResult result, {
    String fileName = "test_results.json",
  }) async {
    try {
      final file = await _getLocalFile(fileName);
      final jsonData = result.toJson();

      if (!await file.exists()) {
        await file.writeAsString(jsonEncode([jsonData]));
      } else {
        final content = await file.readAsString();
        List<dynamic> list = [];
        try {
          list = jsonDecode(content);
        } catch (_) {}
        list.add(jsonData);
        await file.writeAsString(jsonEncode(list));
      }
      
      print('Результат збережено: ${file.path}');
    } catch (e) {
      print('Помилка збереження: $e');
    }
  }

  static Future<List<TestResult>> loadResults({
    String fileName = "test_results.json",
  }) async {
    try {
      final file = await _getLocalFile(fileName);
      
      if (!await file.exists()) {
        return [];
      }
      
      final content = await file.readAsString();
      final List<dynamic> jsonList = jsonDecode(content);
      
      return jsonList.map((json) => TestResult.fromJson(json)).toList();
    } catch (e) {
      print('Помилка завантаження: $e');
      return [];
    }
  }

  static Future<void> clearResults({
    String fileName = "test_results.json",
  }) async {
    try {
      final file = await _getLocalFile(fileName);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      print('Помилка очищення: $e');
    }
  }

  static Future<String> getResultsPath() async {
    final file = await _getLocalFile("test_results.json");
    return file.path;
  }
}