import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:seasonal_decor/seasonal_decor.dart';
import 'package:seasonal_decor/src/config/decor_config.dart';
import 'package:seasonal_decor/src/engine/particle_system.dart';

void main() {
  final baseStyle = ParticleStyle(
    shape: ParticleShape.circle,
    color: const Color(0xFFFF0000),
    minSize: 2,
    maxSize: 6,
    minSpeed: 10,
    maxSpeed: 30,
    minRotationSpeed: 0.1,
    maxRotationSpeed: 0.5,
  );

  DecorConfig makeConfig({List<ParticleStyle>? styles}) {
    return DecorConfig(
      particleCount: 50,
      speedMultiplier: 1.0,
      spawnRate: 8.0,
      drift: 0.0,
      flow: ParticleFlow.falling,
      wrapMode: DecorWrapMode.respawn,
      spawnRateScale: 1.0,
      styles: styles ?? [],
    );
  }

  group('Spawn accumulator reset', () {
    test('empty→non-empty styles resets accumulator (no burst)', () {
      final system = ParticleSystem(
        config: makeConfig(styles: []),
        size: const Size(390, 844),
      );

      // Simulate time passing to accumulate spawn debt.
      system.update(0.5);

      // Now switch from empty to non-empty.
      system.setConfig(makeConfig(styles: [baseStyle]), respawn: false);

      // After transition, update for a single small frame.
      system.update(0.016);

      // Count active particles – should be a small number, not a burst.
      final active = system.particles.where((p) => p.active).length;
      expect(active, lessThanOrEqualTo(5),
          reason: 'Should not burst-spawn after empty→non-empty transition');
    });

    test('non-empty→non-empty does NOT reset accumulator', () {
      final system = ParticleSystem(
        config: makeConfig(styles: [baseStyle]),
        size: const Size(390, 844),
      );

      // Run a few frames to build up some particles.
      for (var i = 0; i < 10; i++) {
        system.update(0.016);
      }
      final beforeCount = system.particles.where((p) => p.active).length;

      // Update config with non-empty styles (same but a new list).
      system.setConfig(
        makeConfig(styles: [baseStyle]),
        respawn: false,
      );

      system.update(0.016);
      final afterCount = system.particles.where((p) => p.active).length;

      // Should continue smoothly, not restart from zero.
      expect(afterCount, greaterThanOrEqualTo(beforeCount - 2));
    });

    test('rebuildPool resets accumulator', () {
      final system = ParticleSystem(
        config: makeConfig(styles: [baseStyle]),
        size: const Size(390, 844),
      );

      for (var i = 0; i < 20; i++) {
        system.update(0.016);
      }

      // Rebuild pool (this should always reset).
      system.rebuildPool(
        makeConfig(styles: [baseStyle]).copyWith(particleCount: 100),
      );

      system.update(0.016);

      // After pool rebuild, particle count should match new count.
      expect(system.particles.length, equals(100));
    });
  });
}
