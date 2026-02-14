import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seasonal_decor/seasonal_decor.dart';
import 'package:seasonal_decor/src/config/decor_config.dart';
import 'package:seasonal_decor/src/engine/decor_painter.dart';
import 'package:seasonal_decor/src/engine/particle_system.dart';

void main() {
  testWidgets(
      'seasonal decor paints backdrops and particles in separate layers',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: SeasonalDecor(
          preset: SeasonalPreset.ramadan(),
          child: const SizedBox.expand(),
        ),
      ),
    );

    final painters = tester
        .widgetList<CustomPaint>(find.byType(CustomPaint))
        .map((widget) => widget.painter)
        .whereType<DecorPainter>()
        .toList();

    expect(
      painters
          .any((painter) => painter.showBackdrop && !painter.paintParticles),
      isTrue,
    );
    expect(
      painters
          .any((painter) => !painter.showBackdrop && painter.paintParticles),
      isTrue,
    );
  });

  test('empty style palette is handled without spawning particles', () {
    const config = DecorConfig(
      particleCount: 64,
      speedMultiplier: 1.0,
      spawnRate: 32,
      spawnRateScale: 1.0,
      drift: 0,
      flow: ParticleFlow.falling,
      wrapMode: DecorWrapMode.respawn,
      styles: [],
    );

    final system = ParticleSystem(
      config: config,
      size: const Size(360, 640),
      random: math.Random(9),
    );

    expect(system.hasActiveParticles, isFalse);
    for (var i = 0; i < 120; i += 1) {
      system.update(1 / 60);
    }
    expect(system.hasActiveParticles, isFalse);
  });

  test('empty shape override produces backdrop-only style config', () {
    final config = SeasonalPreset.ramadan().withOverrides(
        shapes: const <ParticleShape>[]).resolve(DecorIntensity.medium);
    expect(config.styles, isEmpty);
  });

  test('particle update loop stays inside coarse budget', () {
    const config = DecorConfig(
      particleCount: 260,
      speedMultiplier: 1.0,
      spawnRate: 155,
      spawnRateScale: 1.0,
      drift: 16,
      flow: ParticleFlow.falling,
      wrapMode: DecorWrapMode.respawn,
      styles: [
        ParticleStyle(
          shape: ParticleShape.circle,
          color: Color(0xFFFFFFFF),
          minSize: 2.0,
          maxSize: 5.0,
          minSpeed: 20,
          maxSpeed: 60,
          minRotationSpeed: -0.6,
          maxRotationSpeed: 0.6,
          opacity: 0.9,
        ),
      ],
    );

    final system = ParticleSystem(
      config: config,
      size: const Size(1080, 1920),
      random: math.Random(11),
    );

    final watch = Stopwatch()..start();
    for (var i = 0; i < 600; i += 1) {
      system.update(1 / 60);
    }
    watch.stop();

    expect(watch.elapsedMilliseconds, lessThan(1200));
  });
}
