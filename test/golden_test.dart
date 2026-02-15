@Tags(['golden'])
library;

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seasonal_decor/seasonal_decor.dart';

/// Fixed surface size for all golden tests.
const _surfaceSize = Size(390, 844);

/// Number of frames to pump before snapshot to reach visual steady state.
const _settleFrames = 30;

/// Duration per frame (16ms ≈ 60fps).
const _frameDuration = Duration(milliseconds: 16);

/// Pumps [count] frames at 60fps to let the particle system settle.
Future<void> _pumpFrames(WidgetTester tester, int count) async {
  for (var i = 0; i < count; i += 1) {
    await tester.pump(_frameDuration);
  }
}

/// Wraps a SeasonalDecor widget in a standard test harness.
Widget _harness(Widget child) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      body: SizedBox.expand(child: child),
    ),
  );
}

void main() {
  setUp(() {
    // Use a tolerant comparator for particle-based scenes which are
    // inherently non-deterministic (Random-driven particle positions).
    // 2% pixel tolerance avoids false failures from slight variations.
    final defaultComparator = goldenFileComparator as LocalFileComparator;
    goldenFileComparator = _TolerantGoldenComparator(defaultComparator.basedir);
  });
  group('Golden snapshots', () {
    testWidgets('S0 – Baseline (none preset)', (tester) async {
      tester.view.physicalSize = _surfaceSize;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_harness(
        SeasonalDecor(
          preset: SeasonalPreset.none(),
          child: const Center(
            child: Text('Hello', style: TextStyle(fontSize: 24)),
          ),
        ),
      ));
      await _pumpFrames(tester, _settleFrames);

      await expectLater(
        find.byType(SeasonalDecor),
        matchesGoldenFile('goldens/s0_baseline_none.png'),
      );
    });

    testWidgets('S1 – Ramadan Heavy', (tester) async {
      tester.view.physicalSize = _surfaceSize;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_harness(
        SeasonalDecor(
          preset: SeasonalPreset.ramadan(),
          intensity: DecorIntensity.high,
          child: const SizedBox.expand(),
        ),
      ));
      await _pumpFrames(tester, _settleFrames);

      await expectLater(
        find.byType(SeasonalDecor),
        matchesGoldenFile('goldens/s1_ramadan_heavy.png'),
      );
    });

    testWidgets('S2 – Ramadan Lights', (tester) async {
      tester.view.physicalSize = _surfaceSize;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_harness(
        SeasonalDecor(
          preset:
              SeasonalPreset.ramadan(variant: RamadanVariant.hangingLanterns),
          child: const SizedBox.expand(),
        ),
      ));
      await _pumpFrames(tester, _settleFrames);

      await expectLater(
        find.byType(SeasonalDecor),
        matchesGoldenFile('goldens/s2_ramadan_lights.png'),
      );
    });

    testWidgets('S3 – Football', (tester) async {
      tester.view.physicalSize = _surfaceSize;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_harness(
        SeasonalDecor(
          preset: SeasonalPreset.football(),
          child: const SizedBox.expand(),
        ),
      ));
      await _pumpFrames(tester, _settleFrames);

      await expectLater(
        find.byType(SeasonalDecor),
        matchesGoldenFile('goldens/s3_football.png'),
      );
    });

    testWidgets('S4 – New Year Fireworks', (tester) async {
      tester.view.physicalSize = _surfaceSize;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_harness(
        SeasonalDecor(
          preset: SeasonalPreset.newYear(),
          child: const SizedBox.expand(),
        ),
      ));
      await _pumpFrames(tester, _settleFrames);

      await expectLater(
        find.byType(SeasonalDecor),
        matchesGoldenFile('goldens/s4_new_year_fireworks.png'),
      );
    });

    testWidgets('S5 – Text Stress', (tester) async {
      tester.view.physicalSize = _surfaceSize;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_harness(
        SeasonalDecor(
          preset: SeasonalPreset.ramadan(),
          text: 'Ramadan Kareem',
          child: const SizedBox.expand(),
        ),
      ));
      await _pumpFrames(tester, _settleFrames);

      await expectLater(
        find.byType(SeasonalDecor),
        matchesGoldenFile('goldens/s5_text_stress.png'),
      );
    });

    testWidgets('S6 – Backdrop Only', (tester) async {
      tester.view.physicalSize = _surfaceSize;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_harness(
        SeasonalDecor(
          preset: SeasonalPreset.ramadan(),
          presetShapes: const [],
          child: const SizedBox.expand(),
        ),
      ));
      await _pumpFrames(tester, _settleFrames);

      await expectLater(
        find.byType(SeasonalDecor),
        matchesGoldenFile('goldens/s6_backdrop_only.png'),
      );
    });
  });
}

/// A golden file comparator that tolerates up to [_kTolerance] pixel
/// difference. This is necessary because particle positions are random
/// and vary between runs, causing small pixel differences.
class _TolerantGoldenComparator extends LocalFileComparator {
  _TolerantGoldenComparator(super.testFile);

  /// Maximum allowed pixel difference percentage (2%).
  static const double _kTolerance = 0.02;

  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden) async {
    final result = await GoldenFileComparator.compareLists(
      imageBytes,
      await getGoldenBytes(golden),
    );
    if (!result.passed && result.diffPercent <= _kTolerance) {
      return true;
    }
    if (!result.passed) {
      final error = await generateFailureOutput(result, golden, basedir);
      throw FlutterError(error);
    }
    return result.passed;
  }
}
