import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:seasonal_decor/src/config/decor_config.dart';
import 'package:seasonal_decor/src/config/intensity.dart';
import 'package:seasonal_decor/src/engine/particle.dart';
import 'package:seasonal_decor/src/engine/particle_system.dart';
import 'package:seasonal_decor/src/presets/seasonal_preset.dart';
import 'package:seasonal_decor/src/presets/sport_event.dart';
import 'package:seasonal_decor/src/presets/valentine.dart';

void main() {
  test('extraHigh and max intensity profiles scale above high', () {
    final high = DecorIntensity.high.profile;
    final extraHigh = DecorIntensity.extraHigh.profile;
    final max = DecorIntensity.max.profile;

    expect(extraHigh.particleCount, greaterThan(high.particleCount));
    expect(extraHigh.spawnRate, greaterThan(high.spawnRate));
    expect(extraHigh.speedMultiplier, greaterThan(high.speedMultiplier));

    expect(max.particleCount, greaterThan(extraHigh.particleCount));
    expect(max.spawnRate, greaterThan(extraHigh.spawnRate));
    expect(max.speedMultiplier, greaterThan(extraHigh.speedMultiplier));
  });

  test('shape speed multipliers update matching particle styles', () {
    final basePreset =
        SeasonalPreset.valentine(variant: ValentineVariant.hearts);
    final updatedPreset = basePreset.withOverrides(
      shapeSpeedMultipliers: const {
        ParticleShape.heart: 2.0,
      },
    );

    final baseHeart = basePreset.baseConfig.styles
        .firstWhere((style) => style.shape == ParticleShape.heart);
    final updatedHeart = updatedPreset.baseConfig.styles
        .firstWhere((style) => style.shape == ParticleShape.heart);
    final baseSparkle = basePreset.baseConfig.styles
        .firstWhere((style) => style.shape == ParticleShape.sparkle);
    final updatedSparkle = updatedPreset.baseConfig.styles
        .firstWhere((style) => style.shape == ParticleShape.sparkle);

    expect(updatedHeart.minSpeed, closeTo(baseHeart.minSpeed * 2.0, 0.0001));
    expect(updatedHeart.maxSpeed, closeTo(baseHeart.maxSpeed * 2.0, 0.0001));
    expect(updatedSparkle.minSpeed, closeTo(baseSparkle.minSpeed, 0.0001));
    expect(updatedSparkle.maxSpeed, closeTo(baseSparkle.maxSpeed, 0.0001));
  });

  test('particle system updates particle positions', () {
    const config = DecorConfig(
      particleCount: 1,
      speedMultiplier: 1.0,
      spawnRate: 60,
      spawnRateScale: 1.0,
      drift: 0,
      flow: ParticleFlow.falling,
      wrapMode: DecorWrapMode.wrap,
      styles: [
        ParticleStyle(
          shape: ParticleShape.circle,
          color: Color(0xFFFFFFFF),
          minSize: 2.0,
          maxSize: 2.0,
          minSpeed: 50,
          maxSpeed: 50,
          minRotationSpeed: 0,
          maxRotationSpeed: 0,
        ),
      ],
    );

    final system = ParticleSystem(
      config: config,
      size: const Size(200, 200),
      random: math.Random(1),
    );

    final particle = system.particles.first;
    final startY = particle.position.dy;
    system.update(0.5);
    expect(particle.position.dy, greaterThan(startY));
  });

  test('particle system respawns out-of-bounds particles', () {
    const config = DecorConfig(
      particleCount: 1,
      speedMultiplier: 1.0,
      spawnRate: 120,
      spawnRateScale: 1.0,
      drift: 0,
      flow: ParticleFlow.falling,
      wrapMode: DecorWrapMode.respawn,
      styles: [
        ParticleStyle(
          shape: ParticleShape.circle,
          color: Color(0xFFFFFFFF),
          minSize: 2.0,
          maxSize: 2.0,
          minSpeed: 10,
          maxSpeed: 10,
          minRotationSpeed: 0,
          maxRotationSpeed: 0,
        ),
      ],
    );

    final system = ParticleSystem(
      config: config,
      size: const Size(100, 100),
      random: math.Random(2),
    );

    final particle = system.particles.first;
    particle.position = const Offset(50, 500);

    system.update(0.1);

    expect(particle.active, isTrue);
    expect(particle.position.dy, lessThanOrEqualTo(0));
  });

  test('fireworks burst activates sparks', () {
    const config = DecorConfig(
      particleCount: 10,
      speedMultiplier: 1.0,
      spawnRate: 1,
      spawnRateScale: 1.0,
      drift: 0,
      flow: ParticleFlow.falling,
      wrapMode: DecorWrapMode.respawn,
      enableFireworks: true,
      rocketsMax: 1,
      rocketSpawnRate: 0,
      sparksPerBurstMin: 5,
      sparksPerBurstMax: 5,
      burstHeightFactor: 0.2,
      styles: [
        ParticleStyle(
          shape: ParticleShape.circle,
          color: Color(0xFFFFFFFF),
          minSize: 2.0,
          maxSize: 2.0,
          minSpeed: 0,
          maxSpeed: 0,
          minRotationSpeed: 0,
          maxRotationSpeed: 0,
        ),
      ],
    );

    final system = ParticleSystem(
      config: config,
      size: const Size(100, 100),
      random: math.Random(3),
    );

    for (final particle in system.particles) {
      particle.active = false;
    }

    final rocket = system.particles.first;
    rocket.reset(
      position: const Offset(50, 10),
      velocity: const Offset(0, -10),
      size: 3,
      rotation: 0,
      rotationSpeed: 0,
      color: const Color(0xFFFFFFFF),
      opacity: 1,
      shape: ParticleShape.circle,
      kind: ParticleKind.rocket,
      life: 1,
      maxLife: 1,
    );

    system.update(0.1);

    final sparkCount = system.particles
        .where((particle) =>
            particle.active && particle.kind == ParticleKind.spark)
        .length;
    expect(sparkCount, greaterThan(0));
  });

  test('spark life progress reflects remaining life', () {
    final particle = Particle(
      active: true,
      position: Offset.zero,
      velocity: Offset.zero,
      size: 1,
      rotation: 0,
      rotationSpeed: 0,
      color: const Color(0xFFFFFFFF),
      opacity: 1,
      shape: ParticleShape.line,
      kind: ParticleKind.spark,
      life: 0.5,
      maxLife: 1.0,
    );

    expect(particle.lifeProgress, closeTo(0.5, 0.001));
  });

  test('valentine hearts stay active within bounds', () {
    final config = buildValentineConfig(ValentineVariant.hearts).copyWith(
      particleCount: 16,
    );
    final system = ParticleSystem(
      config: config,
      size: const Size(120, 120),
      random: math.Random(4),
    );

    final hearts = system.particles
        .where((particle) =>
            particle.active && particle.shape == ParticleShape.heart)
        .toList();
    expect(hearts, isNotEmpty);

    system.update(0.2);

    for (final particle in hearts) {
      expect(particle.active, isTrue);
      final margin = particle.size * 2;
      expect(particle.position.dx, inInclusiveRange(-margin, 120 + margin));
      expect(particle.position.dy, inInclusiveRange(-margin, 120 + margin));
    }
  });

  test('sport event team colors are used in particles', () {
    const teamPalette = [
      Color(0xFF123456),
      Color(0xFF654321),
    ];
    final config = buildSportEventConfig(
      SportEventVariant.teamColors,
      teamColors: teamPalette,
    ).copyWith(particleCount: 10);
    final system = ParticleSystem(
      config: config,
      size: const Size(120, 120),
      random: math.Random(5),
    );

    for (final particle in system.particles.where((p) => p.active)) {
      expect(teamPalette.contains(particle.color), isTrue);
    }
  });

  test('spawning disabled prevents respawn', () {
    const config = DecorConfig(
      particleCount: 4,
      speedMultiplier: 1.0,
      spawnRate: 60,
      spawnRateScale: 1.0,
      drift: 0,
      flow: ParticleFlow.falling,
      wrapMode: DecorWrapMode.respawn,
      styles: [
        ParticleStyle(
          shape: ParticleShape.circle,
          color: Color(0xFFFFFFFF),
          minSize: 2.0,
          maxSize: 2.0,
          minSpeed: 10,
          maxSpeed: 10,
          minRotationSpeed: 0,
          maxRotationSpeed: 0,
        ),
      ],
    );

    final system = ParticleSystem(
      config: config,
      size: const Size(100, 100),
      random: math.Random(6),
    );

    system.setSpawningEnabled(false);
    for (final particle in system.particles) {
      particle.active = false;
    }

    system.update(0.5);

    expect(system.hasActiveParticles, isFalse);
  });

  test('wrap disabled deactivates out-of-bounds particles', () {
    const config = DecorConfig(
      particleCount: 1,
      speedMultiplier: 1.0,
      spawnRate: 0,
      spawnRateScale: 1.0,
      drift: 0,
      flow: ParticleFlow.falling,
      wrapMode: DecorWrapMode.wrap,
      styles: [
        ParticleStyle(
          shape: ParticleShape.circle,
          color: Color(0xFFFFFFFF),
          minSize: 2.0,
          maxSize: 2.0,
          minSpeed: 10,
          maxSpeed: 10,
          minRotationSpeed: 0,
          maxRotationSpeed: 0,
        ),
      ],
    );

    final system = ParticleSystem(
      config: config,
      size: const Size(100, 100),
      random: math.Random(7),
    );

    system.setWrapEnabled(false);
    final particle = system.particles.first;
    particle.position = const Offset(200, 200);

    system.update(0.1);

    expect(particle.active, isFalse);
  });
}
