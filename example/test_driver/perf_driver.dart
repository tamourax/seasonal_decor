import 'dart:convert';
import 'dart:io';

import 'package:integration_test/integration_test_driver.dart';

Future<void> main() async {
  final today = DateTime.now().toIso8601String().split('T').first;
  final perfDate = Platform.environment['PERF_DATE'] ?? today;
  final perfPlatform = Platform.environment['PERF_PLATFORM'] ?? 'android';
  final outDir = Platform.environment['PERF_OUT_DIR'] ??
      '../perf_artifacts/$perfDate/$perfPlatform';
  final outputDirectory = Directory(outDir)..createSync(recursive: true);

  await integrationDriver(
    responseDataCallback: (Map<String, dynamic>? data) async {
      if (data == null) {
        return;
      }
      final jsonFile =
          File('${outputDirectory.path}/integration_response.json');
      Map<String, dynamic> merged = <String, dynamic>{};
      if (jsonFile.existsSync()) {
        final existing = jsonDecode(jsonFile.readAsStringSync());
        if (existing is Map<String, dynamic>) {
          merged = Map<String, dynamic>.from(existing);
        }
      }
      merged.addAll(data);
      const encoder = JsonEncoder.withIndent('  ');
      jsonFile.writeAsStringSync(encoder.convert(merged));
    },
  );
}
