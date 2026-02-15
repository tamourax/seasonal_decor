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
    required this.frames,
    required this.newGc,
    required this.oldGc,
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
  final int frames;
  final int newGc;
  final int oldGc;
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
    required this.frames,
    required this.newGc,
    required this.oldGc,
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
  final int frames;
  final int newGc;
  final int oldGc;
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
  final mid = sorted.length ~/ 2;
  if (sorted.length.isOdd) {
    return sorted[mid];
  }
  return (sorted[mid - 1] + sorted[mid]) / 2.0;
}

int _medianInt(List<int> values) {
  if (values.isEmpty) {
    return 0;
  }
  final sorted = List<int>.from(values)..sort();
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

bool _passesAndroid(SceneSummary s) {
  return s.uiAvg <= 16.7 &&
      s.rasterAvg <= 16.7 &&
      s.uiP95 <= 24.0 &&
      s.rasterP95 <= 24.0 &&
      s.uiP99 <= 33.0 &&
      s.rasterP99 <= 33.0 &&
      s.jank16 < 3.0 &&
      s.jank33 < 0.5;
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
    frames: frameCount,
    newGc: (json['new_gen_gc_count'] as num?)?.toInt() ?? -1,
    oldGc: (json['old_gen_gc_count'] as num?)?.toInt() ?? -1,
  );
}

SceneSummary _summarizeScene(String sceneId, List<RunMetrics> runs) {
  final summary = SceneSummary(
    sceneId: sceneId,
    uiAvg: _median(runs.map((e) => e.uiAvg).toList()),
    uiP95: _median(runs.map((e) => e.uiP95).toList()),
    uiP99: _median(runs.map((e) => e.uiP99).toList()),
    rasterAvg: _median(runs.map((e) => e.rasterAvg).toList()),
    rasterP95: _median(runs.map((e) => e.rasterP95).toList()),
    rasterP99: _median(runs.map((e) => e.rasterP99).toList()),
    jank16: _median(runs.map((e) => e.jank16).toList()),
    jank33: _median(runs.map((e) => e.jank33).toList()),
    frames: _medianInt(runs.map((e) => e.frames).toList()),
    newGc: _medianInt(runs.map((e) => e.newGc).toList()),
    oldGc: _medianInt(runs.map((e) => e.oldGc).toList()),
    pass: false,
  );
  return SceneSummary(
    sceneId: summary.sceneId,
    uiAvg: summary.uiAvg,
    uiP95: summary.uiP95,
    uiP99: summary.uiP99,
    rasterAvg: summary.rasterAvg,
    rasterP95: summary.rasterP95,
    rasterP99: summary.rasterP99,
    jank16: summary.jank16,
    jank33: summary.jank33,
    frames: summary.frames,
    newGc: summary.newGc,
    oldGc: summary.oldGc,
    pass: _passesAndroid(summary),
  );
}

String _buildReport({
  required String date,
  required String deviceName,
  required Map<String, SceneSummary> scenes,
  required Map<String, List<RunMetrics>> runsByScene,
}) {
  final s0 = scenes['S0']!;
  final offenders = scenes.values.toList()
    ..sort((a, b) => b.p99Worst.compareTo(a.p99Worst));
  final top3 = offenders.take(3).toList();

  final androidTable = StringBuffer();
  for (final id in _sceneIds) {
    final s = scenes[id]!;
    androidTable.writeln(
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
      '| Android | $id | ${_delta(s.uiAvg - s0.uiAvg)} ms | '
      '${_delta(s.rasterAvg - s0.rasterAvg)} ms | '
      '${_delta(p99Delta)} ms | ${_delta(jankDelta)} pp |',
    );
  }

  final offendersText = StringBuffer();
  for (final offender in top3) {
    final sceneRuns = runsByScene[offender.sceneId]!;
    sceneRuns.sort((a, b) =>
        max(b.uiWorst, b.rasterWorst).compareTo(max(a.uiWorst, a.rasterWorst)));
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

  final gcNotes = _sceneIds
      .map((id) => '$id(new:${scenes[id]!.newGc}, old:${scenes[id]!.oldGc})')
      .join(', ');

  return '''
# Performance Baseline Report

- Date: $date
- Branch / commit: ${_gitBranch()} / ${_gitCommit()}
- App target: `example/lib/advanced_main.dart`
- Flutter version: ${_flutterVersion()}
- Profiler: `integration_test.watchPerformance` (FrameTiming summary)

## Test Matrix

| Platform | Device | Renderer / OS |
| --- | --- | --- |
| Android | $deviceName | Profile mode |
| Web | Not run in this pass | N/A |

## Summary (Median Of 3 Runs)

### Android

| Scene | UI avg | UI p95 | UI p99 | Raster avg | Raster p95 | Raster p99 | >16.7ms | >33ms | Pass/Fail |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
${androidTable.toString().trimRight()}

### Web

Not measured in this run.

## Delta vs S0 Baseline

| Platform | Scene | UI avg delta | Raster avg delta | p99 delta | Jank delta |
| --- | --- | --- | --- | --- | --- |
${deltaRows.toString().trimRight()}

## Top Offenders

${offendersText.toString().trimRight()}

## Memory Notes

- Android: direct resident-memory trend is not included in `watchPerformance`; GC counters by scene: $gcNotes.
- Web: not measured.

## Recommendation Block (Actionable)

1. File/function: `lib/src/engine/decor_painter.dart`
   - Proposed optimization: simplify high-cost particle paint paths for max intensity scenes (S2/S4).
   - Expected impact: lower raster p95/p99 spikes.
2. File/function: `lib/src/widgets/seasonal_decor.dart`
   - Proposed optimization: add optional throttled ticker mode for text-heavy / backdrop-only scenarios.
   - Expected impact: lower UI jank in S5.
3. File/function: `lib/src/engine/particle_system.dart`
   - Proposed optimization: cap burst spawn per frame under sustained load.
   - Expected impact: smoother worst-frame behavior in stress scenes.

## Artifacts

- `perf_artifacts/$date/android/integration_response.json`
- `perf_artifacts/$date/android_baseline_report.md`
''';
}

void main(List<String> args) {
  final parsedArgs = _parseArgs(args);
  final date = parsedArgs['date'] ?? _today();
  final inputPath = parsedArgs['input'] ??
      'perf_artifacts/$date/android/integration_response.json';
  final outputPath =
      parsedArgs['output'] ?? 'perf_artifacts/$date/android_baseline_report.md';
  final deviceName = parsedArgs['device'] ?? 'PHW110 (emulator-5554, API 28)';

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
      final key = 'android_${sceneId}_run$run';
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
    deviceName: deviceName,
    scenes: scenes,
    runsByScene: runsByScene,
  );

  final outputFile = File(outputPath)..createSync(recursive: true);
  outputFile.writeAsStringSync(report);
  stdout.writeln('Report generated: $outputPath');
}
