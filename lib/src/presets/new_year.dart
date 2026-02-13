import 'dart:ui';

import '../config/decor_config.dart';
import '../engine/particle.dart';

/// Variants for the New Year preset.
enum NewYearVariant {
  /// Fireworks with festive confetti.
  fireworks,

  /// Gold-forward fireworks and sparkles.
  gold,
}

/// Builds the base configuration for New Year overlays.
DecorConfig buildNewYearConfig(NewYearVariant variant) {
  switch (variant) {
    case NewYearVariant.gold:
      return DecorConfig(
        particleCount: 120,
        speedMultiplier: 1.0,
        spawnRate: 1,
        spawnRateScale: 0.2,
        drift: 12,
        flow: ParticleFlow.falling,
        wrapMode: DecorWrapMode.respawn,
        enableFireworks: true,
        rocketsMax: 6,
        rocketSpawnRate: 1.6,
        sparksPerBurstMin: 28,
        sparksPerBurstMax: 58,
        burstHeightFactor: 0.2,
        gravityY: 80,
        rocketMinSpeed: 230,
        rocketMaxSpeed: 320,
        rocketLifeMin: 1.0,
        rocketLifeMax: 1.6,
        rocketSize: 3.2,
        rocketDrift: 22,
        sparkMinSpeed: 90,
        sparkMaxSpeed: 220,
        sparkLifeMin: 0.8,
        sparkLifeMax: 1.5,
        sparkMinSize: 7.0,
        sparkMaxSize: 13.0,
        styles: const [
          ParticleStyle(
            shape: ParticleShape.confettiRect,
            color: Color(0xFFFFD166),
            minSize: 2.4,
            maxSize: 4.6,
            minSpeed: 16,
            maxSpeed: 34,
            minRotationSpeed: -2.0,
            maxRotationSpeed: 2.0,
            opacity: 0.6,
          ),
          ParticleStyle(
            shape: ParticleShape.confettiRect,
            color: Color(0xFFFFF4D6),
            minSize: 2.4,
            maxSize: 4.4,
            minSpeed: 16,
            maxSpeed: 32,
            minRotationSpeed: -1.8,
            maxRotationSpeed: 1.8,
            opacity: 0.55,
          ),
          ParticleStyle(
            shape: ParticleShape.sparkle,
            color: Color(0xFFFFF4D6),
            minSize: 2.0,
            maxSize: 3.8,
            minSpeed: 10,
            maxSpeed: 20,
            minRotationSpeed: -1.6,
            maxRotationSpeed: 1.6,
            opacity: 0.9,
          ),
        ],
        backdrops: const [],
      );
    case NewYearVariant.fireworks:
      return DecorConfig(
        particleCount: 120,
        speedMultiplier: 1.1,
        spawnRate: 1,
        spawnRateScale: 0.25,
        drift: 14,
        flow: ParticleFlow.falling,
        wrapMode: DecorWrapMode.respawn,
        enableFireworks: true,
        rocketsMax: 8,
        rocketSpawnRate: 2.0,
        sparksPerBurstMin: 32,
        sparksPerBurstMax: 70,
        burstHeightFactor: 0.18,
        gravityY: 85,
        rocketMinSpeed: 240,
        rocketMaxSpeed: 340,
        rocketLifeMin: 1.0,
        rocketLifeMax: 1.7,
        rocketSize: 3.4,
        rocketDrift: 26,
        sparkMinSpeed: 100,
        sparkMaxSpeed: 240,
        sparkLifeMin: 0.85,
        sparkLifeMax: 1.6,
        sparkMinSize: 7.0,
        sparkMaxSize: 14.0,
        styles: const [
          ParticleStyle(
            shape: ParticleShape.confettiRect,
            color: Color(0xFFFFD166),
            minSize: 2.4,
            maxSize: 4.8,
            minSpeed: 18,
            maxSpeed: 36,
            minRotationSpeed: -2.2,
            maxRotationSpeed: 2.2,
            opacity: 0.6,
          ),
          ParticleStyle(
            shape: ParticleShape.confettiRect,
            color: Color(0xFFFFFFFF),
            minSize: 2.4,
            maxSize: 4.6,
            minSpeed: 16,
            maxSpeed: 34,
            minRotationSpeed: -2.0,
            maxRotationSpeed: 2.0,
            opacity: 0.55,
          ),
          ParticleStyle(
            shape: ParticleShape.sparkle,
            color: Color(0xFFFFFFFF),
            minSize: 2.2,
            maxSize: 4.0,
            minSpeed: 12,
            maxSpeed: 22,
            minRotationSpeed: -1.6,
            maxRotationSpeed: 1.6,
            opacity: 0.9,
          ),
        ],
        backdrops: const [
          DecorBackdrop.garland(
            color: Color(0xFF145C54),
            opacity: 0.55,
            anchor: Offset(0.5, 0.1),
            sizeFactor: 0.06,
          ),
        ],
      );
  }
}
