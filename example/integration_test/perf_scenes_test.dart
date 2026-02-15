import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:seasonal_decor_example/advanced_main.dart' as app;

typedef _SceneSpec = ({String id, String label});

const List<_SceneSpec> _scenes = <_SceneSpec>[
  (id: 'S0', label: 'S0 Baseline'),
  (id: 'S1', label: 'S1 Ramadan Heavy'),
  (id: 'S2', label: 'S2 Ramadan Lights'),
  (id: 'S3', label: 'S3 Football'),
  (id: 'S4', label: 'S4 New Year'),
  (id: 'S5', label: 'S5 Text Stress'),
  (id: 'S6', label: 'S6 Backdrop Only'),
];

const String _sceneFromDefine =
    String.fromEnvironment('PERF_SCENE', defaultValue: '');
const String _reportPrefix =
    String.fromEnvironment('PERF_PREFIX', defaultValue: 'android');

const int _runsPerScene = int.fromEnvironment('PERF_RUNS', defaultValue: 3);
const Duration _warmup = Duration(
  seconds: int.fromEnvironment('PERF_WARMUP_SECONDS', defaultValue: 20),
);
const Duration _capture = Duration(
  seconds: int.fromEnvironment('PERF_CAPTURE_SECONDS', defaultValue: 45),
);
const Duration _betweenRuns = Duration(
  seconds: int.fromEnvironment('PERF_BETWEEN_SECONDS', defaultValue: 15),
);

Future<void> _sleep(Duration duration) async {
  await Future<void>.delayed(duration);
}

Future<void> _pumpFor(WidgetTester tester, Duration duration) async {
  final end = DateTime.now().add(duration);
  while (DateTime.now().isBefore(end)) {
    await tester.pump();
    await _sleep(const Duration(milliseconds: 16));
  }
}

List<_SceneSpec> _resolveScenes() {
  if (_sceneFromDefine.isEmpty) {
    return _scenes;
  }
  final normalized = _sceneFromDefine.toUpperCase();
  final match = _scenes.where((scene) => scene.id == normalized).toList();
  if (match.isEmpty) {
    throw StateError('Unknown PERF_SCENE value: $_sceneFromDefine');
  }
  return match;
}

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('collect Android scene frame timings',
      (WidgetTester tester) async {
    app.main();
    await tester.pump(const Duration(seconds: 2));

    for (final scene in _resolveScenes()) {
      // PERF_SCENE is applied by app startup. When empty, this runs all scenes
      // in their current configured state.
      await _sleep(const Duration(seconds: 1));

      for (var run = 1; run <= _runsPerScene; run += 1) {
        await _pumpFor(tester, _warmup);
        await binding.watchPerformance(
          () async {
            await _pumpFor(tester, _capture);
          },
          reportKey: '${_reportPrefix}_${scene.id}_run$run',
        );
        if (run < _runsPerScene) {
          await _pumpFor(tester, _betweenRuns);
        }
      }
    }
  });
}
