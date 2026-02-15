import 'dart:convert';
import 'dart:io';
import 'dart:math';

const _sceneIds = <String>['S0', 'S1', 'S2', 'S3', 'S4', 'S5', 'S6'];

class RunMetrics {
  RunMetrics({
    required this.sceneId,
    required this.runId,
    required this.uiAvg,
    required this.uiP95,
    required this.uiP99,
    required this.uiWorst,
    required this.rasterAvg,
    required this.rasterP95,
    required this.rasterP99,
    required this.rasterWorst,
    required this.jank16,
    required this.jank33,
  });

  final String sceneId;
  final int runId;
  final double uiAvg;
  final double uiP95;
  final double uiP99;
  final double uiWorst;
  final double rasterAvg;
  final double rasterP95;
  final double rasterP99;
  final double rasterWorst;
  final double jank16;
  final double jank33;
}

class SceneSummary {
  SceneSummary({
    required this.sceneId,
    required this.uiAvg,
    required this.uiP95,
    required this.uiP99,
    required this.rasterAvg,
    required this.rasterP95,
    required this.rasterP99,
    required this.jank16,
    required this.jank33,
    required this.pass,
  });

  final String sceneId;
  final double uiAvg;
  final double uiP95;
  final double uiP99;
  final double rasterAvg;
  final double rasterP95;
  final double rasterP99;
  final double jank16;
  final double jank33;
  final bool pass;

  double get p99Worst => max(uiP99, rasterP99);
}

double _percentileMs(List<int> micros, double percentile) {
  if (micros.isEmpty) {
    return 0;
  }
  final sorted = List<int>.from(micros)..sort();
  final idx = ((sorted.length - 1) * percentile).round();
  return sorted[idx] / 1000.0;
}

double _median(List<double> values) {
  if (values.isEmpty) {
    return 0;
  }
  final sorted = List<double>.from(values)..sort();
  return sorted[sorted.length ~/ 2];
}

String _fmtMs(double value) => value.toStringAsFixed(2);
String _fmtPct(double value) => '${value.toStringAsFixed(2)}%';
String _delta(double value) =>
    (value >= 0 ? '+' : '') + value.toStringAsFixed(2);

Map<String, String> _parseArgs(List<String> args) {
  final out = <String, String>{};
  for (final arg in args) {
    if (!arg.startsWith('--') || !arg.contains('=')) {
      continue;
    }
    final idx = arg.indexOf('=');
    out[arg.substring(2, idx)] = arg.substring(idx + 1);
  }
  return out;
}

String _today() => DateTime.now().toIso8601String().split('T').first;

String _gitBranch() {
  final result =
      Process.runSync('git', const ['rev-parse', '--abbrev-ref', 'HEAD']);
  if (result.exitCode != 0) {
    return 'unknown';
  }
  return (result.stdout as String).trim();
}

String _gitCommit() {
  final result = Process.runSync('git', const ['rev-parse', '--short', 'HEAD']);
  if (result.exitCode != 0) {
    return 'unknown';
  }
  return (result.stdout as String).trim();
}

String _flutterVersion() {
  ProcessResult result;
  try {
    result = Process.runSync('flutter', const ['--version', '--machine']);
    if (result.exitCode != 0) {
      result = Process.runSync('flutter.bat', const ['--version', '--machine']);
    }
  } catch (_) {
    try {
      result = Process.runSync('flutter.bat', const ['--version', '--machine']);
    } catch (_) {
      return 'unknown';
    }
  }
  if (result.exitCode != 0) {
    return 'unknown';
  }
  final decoded = jsonDecode(result.stdout as String) as Map<String, dynamic>;
  return decoded['frameworkVersion']?.toString() ?? 'unknown';
}

bool _passesWeb(SceneSummary s) {
  return s.uiAvg <= 18.0 &&
      s.rasterAvg <= 18.0 &&
      s.uiP95 <= 28.0 &&
      s.rasterP95 <= 28.0 &&
      s.uiP99 <= 40.0 &&
      s.rasterP99 <= 40.0 &&
      s.jank16 < 5.0 &&
      s.jank33 < 1.0;
}

RunMetrics _parseRun(String sceneId, int runId, Map<String, dynamic> json) {
  final buildMicros =
      (json['frame_build_times'] as List<dynamic>).cast<int>().toList();
  final rasterMicros =
      (json['frame_rasterizer_times'] as List<dynamic>).cast<int>().toList();
  final frameCount = min(buildMicros.length, rasterMicros.length);
  var over16 = 0;
  var over33 = 0;
  for (var i = 0; i < frameCount; i += 1) {
    final frameMs = max(buildMicros[i], rasterMicros[i]) / 1000.0;
    if (frameMs > 16.7) {
      over16 += 1;
    }
    if (frameMs > 33.0) {
      over33 += 1;
    }
  }

  return RunMetrics(
    sceneId: sceneId,
    runId: runId,
    uiAvg: (json['average_frame_build_time_millis'] as num).toDouble(),
    uiP95: _percentileMs(buildMicros, 0.95),
    uiP99: (json['99th_percentile_frame_build_time_millis'] as num).toDouble(),
    uiWorst: (json['worst_frame_build_time_millis'] as num).toDouble(),
    rasterAvg: (json['average_frame_rasterizer_time_millis'] as num).toDouble(),
    rasterP95: _percentileMs(rasterMicros, 0.95),
    rasterP99: (json['99th_percentile_frame_rasterizer_time_millis'] as num)
        .toDouble(),
    rasterWorst: (json['worst_frame_rasterizer_time_millis'] as num).toDouble(),
    jank16: frameCount == 0 ? 0 : (over16 * 100.0 / frameCount),
    jank33: frameCount == 0 ? 0 : (over33 * 100.0 / frameCount),
  );
}

SceneSummary _summarizeScene(String sceneId, List<RunMetrics> runs) {
  final provisional = SceneSummary(
    sceneId: sceneId,
    uiAvg: _median(runs.map((e) => e.uiAvg).toList()),
    uiP95: _median(runs.map((e) => e.uiP95).toList()),
    uiP99: _median(runs.map((e) => e.uiP99).toList()),
    rasterAvg: _median(runs.map((e) => e.rasterAvg).toList()),
    rasterP95: _median(runs.map((e) => e.rasterP95).toList()),
    rasterP99: _median(runs.map((e) => e.rasterP99).toList()),
    jank16: _median(runs.map((e) => e.jank16).toList()),
    jank33: _median(runs.map((e) => e.jank33).toList()),
    pass: false,
  );
  return SceneSummary(
    sceneId: provisional.sceneId,
    uiAvg: provisional.uiAvg,
    uiP95: provisional.uiP95,
    uiP99: provisional.uiP99,
    rasterAvg: provisional.rasterAvg,
    rasterP95: provisional.rasterP95,
    rasterP99: provisional.rasterP99,
    jank16: provisional.jank16,
    jank33: provisional.jank33,
    pass: _passesWeb(provisional),
  );
}

String _buildReport({
  required String date,
  required String browserName,
  required Map<String, SceneSummary> scenes,
  required Map<String, List<RunMetrics>> runsByScene,
}) {
  final s0 = scenes['S0']!;
  final offenders = scenes.values.toList()
    ..sort((a, b) => b.p99Worst.compareTo(a.p99Worst));
  final top3 = offenders.take(3).toList();

  final webTable = StringBuffer();
  for (final id in _sceneIds) {
    final s = scenes[id]!;
    webTable.writeln(
      '| $id | ${_fmtMs(s.uiAvg)} | ${_fmtMs(s.uiP95)} | ${_fmtMs(s.uiP99)} | '
      '${_fmtMs(s.rasterAvg)} | ${_fmtMs(s.rasterP95)} | ${_fmtMs(s.rasterP99)} | '
      '${_fmtPct(s.jank16)} | ${_fmtPct(s.jank33)} | ${s.pass ? "PASS" : "FAIL"} |',
    );
  }

  final deltaRows = StringBuffer();
  for (final id in _sceneIds.where((e) => e != 'S0')) {
    final s = scenes[id]!;
    final p99Delta = s.p99Worst - s0.p99Worst;
    final jankDelta = s.jank16 - s0.jank16;
    deltaRows.writeln(
      '| Web | $id | ${_delta(s.uiAvg - s0.uiAvg)} ms | '
      '${_delta(s.rasterAvg - s0.rasterAvg)} ms | '
      '${_delta(p99Delta)} ms | ${_delta(jankDelta)} pp |',
    );
  }

  final offendersText = StringBuffer();
  for (final offender in top3) {
    final sceneRuns = runsByScene[offender.sceneId]!;
    sceneRuns.sort(
      (a, b) => max(b.uiWorst, b.rasterWorst)
          .compareTo(max(a.uiWorst, a.rasterWorst)),
    );
    final worstRun = sceneRuns.first;
    offendersText.writeln('1. Scene ${offender.sceneId}');
    offendersText
        .writeln('   - Timestamp window: N/A (FrameTiming summary only)');
    offendersText.writeln(
      '   - Thread: ${worstRun.uiWorst >= worstRun.rasterWorst ? "UI" : "Raster"}',
    );
    offendersText.writeln(
      '   - Symptom: run ${worstRun.runId} worst frame '
      '${_fmtMs(max(worstRun.uiWorst, worstRun.rasterWorst))}ms',
    );
  }

  return '''
# Performance Baseline Report (Web)

- Date: $date
- Branch / commit: ${_gitBranch()} / ${_gitCommit()}
- App target: `example/lib/advanced_main.dart`
- Flutter version: ${_flutterVersion()}
- Profiler: `integration_test.watchPerformance` (FrameTiming summary)

## Test Matrix

| Platform | Device | Renderer / OS |
| --- | --- | --- |
| Android | Not run in this pass | N/A |
| Web | $browserName | Chrome + CanvasKit (profile) |

## Summary (Median Of 3 Runs)

### Web

| Scene | UI avg | UI p95 | UI p99 | Raster avg | Raster p95 | Raster p99 | >16.7ms | >33ms | Pass/Fail |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
${webTable.toString().trimRight()}

## Delta vs S0 Baseline

| Platform | Scene | UI avg delta | Raster avg delta | p99 delta | Jank delta |
| --- | --- | --- | --- | --- | --- |
${deltaRows.toString().trimRight()}

## Top Offenders

${offendersText.toString().trimRight()}

## Notes

- Web thresholds used: avg<=18ms, p95<=28ms, p99<=40ms, >16.7ms<5%, >33ms<1%.
- Critical scenes for gate rules: S2, S4, S5.

## Artifacts

- `perf_artifacts/$date/web/integration_response.json`
- `perf_artifacts/$date/web_baseline_report.md`
''';
}

void main(List<String> args) {
  final parsedArgs = _parseArgs(args);
  final date = parsedArgs['date'] ?? _today();
  final inputPath = parsedArgs['input'] ??
      'perf_artifacts/$date/web/integration_response.json';
  final outputPath =
      parsedArgs['output'] ?? 'perf_artifacts/$date/web_baseline_report.md';
  final browserName =
      parsedArgs['browser'] ?? 'Chrome (web) --web-renderer canvaskit';

  final inputFile = File(inputPath);
  if (!inputFile.existsSync()) {
    stderr.writeln('Input not found: $inputPath');
    exit(1);
  }

  final decoded =
      jsonDecode(inputFile.readAsStringSync()) as Map<String, dynamic>;
  final runsByScene = <String, List<RunMetrics>>{
    for (final id in _sceneIds) id: <RunMetrics>[],
  };

  for (final sceneId in _sceneIds) {
    for (var run = 1; run <= 3; run += 1) {
      final key = 'web_${sceneId}_run$run';
      final data = decoded[key];
      if (data is Map<String, dynamic>) {
        runsByScene[sceneId]!.add(_parseRun(sceneId, run, data));
      }
    }
  }

  final missing = runsByScene.entries.where((e) => e.value.length < 3).toList();
  if (missing.isNotEmpty) {
    stderr.writeln(
      'Missing runs: ${missing.map((e) => '${e.key}:${e.value.length}/3').join(', ')}',
    );
    exit(2);
  }

  final scenes = <String, SceneSummary>{
    for (final id in _sceneIds) id: _summarizeScene(id, runsByScene[id]!),
  };
  final report = _buildReport(
    date: date,
    browserName: browserName,
    scenes: scenes,
    runsByScene: runsByScene,
  );

  final outputFile = File(outputPath)..createSync(recursive: true);
  outputFile.writeAsStringSync(report);
  stdout.writeln('Report generated: $outputPath');
}
