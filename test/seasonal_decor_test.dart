import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:seasonal_decor/src/config/decor_config.dart';
import 'package:seasonal_decor/src/config/intensity.dart';
import 'package:seasonal_decor/src/engine/particle.dart';
import 'package:seasonal_decor/src/engine/particle_system.dart';
import 'package:seasonal_decor/src/presets/ramadan.dart';
import 'package:seasonal_decor/src/presets/seasonal_preset.dart';
import 'package:seasonal_decor/src/presets/football.dart';
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

  test('withOverrides accepts typed shapes, styles, maps, and backdrops', () {
    final preset = SeasonalPreset.ramadan().withOverrides(
      shapes: const <ParticleShape>[
        ParticleShape.lantern,
        ParticleShape.crescent,
      ],
      styles: const <ParticleStyle>[
        ParticleStyle(
          shape: ParticleShape.lantern,
          color: Color(0xFFFFD166),
          minSize: 3.0,
          maxSize: 6.0,
          minSpeed: 12.0,
          maxSpeed: 20.0,
          minRotationSpeed: 0.0,
          maxRotationSpeed: 0.0,
          opacity: 0.9,
        ),
      ],
      shapeSpeedMultipliers: const <ParticleShape, double>{
        ParticleShape.lantern: 1.5,
      },
      backdrops: const <DecorBackdrop>[
        DecorBackdrop.crescent(
          color: Color(0x22FFFFFF),
          opacity: 0.25,
          anchor: Offset(0.8, 0.2),
          sizeFactor: 0.3,
        ),
      ],
    );

    expect(preset.baseConfig.styles, hasLength(1));
    expect(preset.baseConfig.styles.first.shape, ParticleShape.lantern);
    expect(preset.baseConfig.styles.first.minSpeed, closeTo(18.0, 0.0001));
    expect(preset.baseConfig.styles.first.maxSpeed, closeTo(30.0, 0.0001));
    expect(preset.baseConfig.backdrops, hasLength(1));
    expect(preset.baseConfig.backdrops.first.type, BackdropType.crescent);
  });

  test(
      'ramadan hanging lanterns variant has one decorative and one background backdrop',
      () {
    final preset = SeasonalPreset.ramadan(
      variant: RamadanVariant.hangingLanterns,
    );
    final backdrops = preset.baseConfig.backdrops;
    final decorative = backdrops
        .where((backdrop) => backdrop.layer == BackdropLayer.decorative)
        .toList();
    final background = backdrops
        .where((backdrop) => backdrop.layer == BackdropLayer.background)
        .toList();

    expect(preset.variant, RamadanVariant.hangingLanterns.name);
    expect(backdrops, hasLength(2));
    expect(decorative, hasLength(1));
    expect(background, hasLength(1));
    expect(decorative.single.type, BackdropType.ramadanLights);
    expect(background.single.type, BackdropType.lantern);
  });

  test('ramadan classic uses traditional ramadan bunting backdrop', () {
    final preset = SeasonalPreset.ramadan(variant: RamadanVariant.classic);
    final decorative = preset.baseConfig.backdrops
        .where((backdrop) => backdrop.layer == BackdropLayer.decorative)
        .toList();

    expect(decorative, isNotEmpty);
    expect(decorative.first.type, BackdropType.ramadanBunting);
  });

  test('ramadan classic and night variants do not include mosque backdrop', () {
    final classic = SeasonalPreset.ramadan(variant: RamadanVariant.classic);
    final night = SeasonalPreset.ramadan(variant: RamadanVariant.night);

    expect(
      classic.baseConfig.backdrops
          .any((backdrop) => backdrop.type == BackdropType.mosque),
      isFalse,
    );
    expect(
      night.baseConfig.backdrops
          .any((backdrop) => backdrop.type == BackdropType.mosque),
      isFalse,
    );
  });

  test('halloween preset uses pumpkin backdrop instead of crescent', () {
    final preset = SeasonalPreset.halloween();

    expect(preset.baseConfig.backdrops, isNotEmpty);
    expect(preset.baseConfig.backdrops.first.type, BackdropType.pumpkin);
  });

  test('football preset uses football backdrop', () {
    final preset = SeasonalPreset.football();

    expect(preset.baseConfig.backdrops, isNotEmpty);
    expect(preset.baseConfig.backdrops.first.type, BackdropType.football);
  });

  test('football preset has fireworks disabled', () {
    final preset = SeasonalPreset.football();

    expect(preset.baseConfig.enableFireworks, isFalse);
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

  test('football preset particles use classic black and white palette', () {
    const classicPalette = [
      Color(0xFFFFFFFF),
      Color(0xFF111827),
    ];
    final config = buildFootballConfig(
      FootballVariant.worldCup,
    ).copyWith(particleCount: 10);
    final system = ParticleSystem(
      config: config,
      size: const Size(120, 120),
      random: math.Random(5),
    );

    for (final particle in system.particles.where((p) => p.active)) {
      expect(classicPalette.contains(particle.color), isTrue);
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
