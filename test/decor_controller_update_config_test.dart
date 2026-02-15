import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:seasonal_decor/src/config/decor_config.dart';
import 'package:seasonal_decor/src/engine/decor_controller.dart';
import 'package:seasonal_decor/src/engine/particle.dart';

const DecorConfig _baseConfig = DecorConfig(
  particleCount: 24,
  speedMultiplier: 1.0,
  spawnRate: 18,
  spawnRateScale: 1.0,
  drift: 10,
  flow: ParticleFlow.falling,
  wrapMode: DecorWrapMode.respawn,
  styles: [
    ParticleStyle(
      shape: ParticleShape.circle,
      color: Color(0xFFFFFFFF),
      minSize: 2.0,
      maxSize: 3.5,
      minSpeed: 12,
      maxSpeed: 28,
      minRotationSpeed: 0,
      maxRotationSpeed: 0,
      opacity: 0.9,
    ),
  ],
);

void main() {
  test('soft config update keeps the particle system instance', () {
    final controller = DecorController(
      vsync: const TestVSync(),
      config: _baseConfig,
    );
    addTearDown(controller.dispose);

    controller.updateBounds(const Size(360, 640));
    final initialSystem = controller.system;
    final updated = _baseConfig.copyWith(
      spawnRate: 30,
      speedMultiplier: 1.35,
    );

    controller.updateConfig(updated);

    expect(identical(controller.system, initialSystem), isTrue);
    expect(controller.system.particles.length, _baseConfig.particleCount);
    expect(controller.system.config.spawnRate, updated.spawnRate);
    expect(controller.system.config.speedMultiplier, updated.speedMultiplier);
  });

  test('hard config update rebuilds pool but keeps system instance', () {
    final controller = DecorController(
      vsync: const TestVSync(),
      config: _baseConfig,
    );
    addTearDown(controller.dispose);

    controller.updateBounds(const Size(360, 640));
    final initialSystem = controller.system;
    final updated = _baseConfig.copyWith(particleCount: 40);

    controller.updateConfig(updated);

    expect(identical(controller.system, initialSystem), isTrue);
    expect(controller.system.config.particleCount, 40);
    expect(controller.system.particles.length, 40);
  });

  test('shape palette update respawns active particles', () {
    final controller = DecorController(
      vsync: const TestVSync(),
      config: _baseConfig,
    );
    addTearDown(controller.dispose);

    controller.updateBounds(const Size(360, 640));
    final updated = _baseConfig.copyWith(
      styles: const [
        ParticleStyle(
          shape: ParticleShape.ball,
          color: Color(0xFFFFFFFF),
          minSize: 2.0,
          maxSize: 3.5,
          minSpeed: 12,
          maxSpeed: 28,
          minRotationSpeed: 0,
          maxRotationSpeed: 0,
          opacity: 0.9,
        ),
      ],
    );

    controller.updateConfig(updated);

    final activeParticles =
        controller.system.particles.where((particle) => particle.active);
    expect(activeParticles, isNotEmpty);
    for (final particle in activeParticles) {
      expect(particle.shape, ParticleShape.ball);
    }
  });

  test('identical config skips update (no notifyListeners)', () {
    var notifyCount = 0;
    final controller = DecorController(
      vsync: const TestVSync(),
      config: _baseConfig,
    );
    addTearDown(controller.dispose);

    controller.updateBounds(const Size(360, 640));
    controller.addListener(() => notifyCount++);

    // Create a logically identical config (separate instance).
    final identicalConfig = _baseConfig.copyWith();

    // Store the system state before update.
    final systemBefore = controller.system;
    final configBefore = controller.system.config;

    controller.updateConfig(identicalConfig);

    // System should be untouched.
    expect(identical(controller.system, systemBefore), isTrue);
    expect(identical(controller.system.config, configBefore), isTrue,
        reason: 'Config should not be reassigned for identical values');
    expect(notifyCount, 0,
        reason: 'notifyListeners should not be called for identical config');
  });
}
