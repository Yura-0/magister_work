import 'dart:io';
import 'dart:convert';
import 'package:magi_work/models/test_results.dart';


class FileExport {
  static Future<void> saveResult(
    TestResult result, {
    String fileName = "test_results.json",
  }) async {
    final dir = Directory('./results');

    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }

    final file = File('${dir.path}/$fileName');
    final jsonData = result.toJson();

    if (!file.existsSync()) {
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
  }
}

