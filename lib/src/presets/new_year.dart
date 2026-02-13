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
        speedMultiplier: 0.95,
        spawnRate: 1,
        spawnRateScale: 0.35,
        drift: 14,
        flow: ParticleFlow.falling,
        wrapMode: DecorWrapMode.respawn,
        enableFireworks: true,
        rocketsMax: 5,
        rocketSpawnRate: 1.1,
        sparksPerBurstMin: 22,
        sparksPerBurstMax: 40,
        burstHeightFactor: 0.22,
        gravityY: 80,
        rocketMinSpeed: 220,
        rocketMaxSpeed: 300,
        rocketLifeMin: 0.9,
        rocketLifeMax: 1.5,
        rocketSize: 3.0,
        rocketDrift: 22,
        sparkMinSpeed: 70,
        sparkMaxSpeed: 190,
        sparkLifeMin: 0.7,
        sparkLifeMax: 1.3,
        sparkMinSize: 6.0,
        sparkMaxSize: 12.0,
        styles: const [
          ParticleStyle(
            shape: ParticleShape.confettiRect,
            color: Color(0xFFFFD166),
            minSize: 3.0,
            maxSize: 5.5,
            minSpeed: 18,
            maxSpeed: 40,
            minRotationSpeed: -2.2,
            maxRotationSpeed: 2.2,
            opacity: 0.9,
          ),
          ParticleStyle(
            shape: ParticleShape.confettiRect,
            color: Color(0xFFFFC857),
            minSize: 2.8,
            maxSize: 5.0,
            minSpeed: 16,
            maxSpeed: 36,
            minRotationSpeed: -2.0,
            maxRotationSpeed: 2.0,
            opacity: 0.85,
          ),
          ParticleStyle(
            shape: ParticleShape.sparkle,
            color: Color(0xFFFFF4D6),
            minSize: 2.0,
            maxSize: 3.6,
            minSpeed: 10,
            maxSpeed: 20,
            minRotationSpeed: -1.6,
            maxRotationSpeed: 1.6,
            opacity: 0.8,
          ),
        ],
        backdrops: const [],
      );
    case NewYearVariant.fireworks:
      return DecorConfig(
        particleCount: 120,
        speedMultiplier: 1.05,
        spawnRate: 1,
        spawnRateScale: 0.6,
        drift: 18,
        flow: ParticleFlow.falling,
        wrapMode: DecorWrapMode.respawn,
        enableFireworks: true,
        rocketsMax: 6,
        rocketSpawnRate: 1.5,
        sparksPerBurstMin: 28,
        sparksPerBurstMax: 52,
        burstHeightFactor: 0.2,
        gravityY: 85,
        rocketMinSpeed: 230,
        rocketMaxSpeed: 320,
        rocketLifeMin: 0.9,
        rocketLifeMax: 1.5,
        rocketSize: 3.2,
        rocketDrift: 26,
        sparkMinSpeed: 80,
        sparkMaxSpeed: 210,
        sparkLifeMin: 0.7,
        sparkLifeMax: 1.35,
        sparkMinSize: 6.0,
        sparkMaxSize: 12.0,
        styles: const [
          ParticleStyle(
            shape: ParticleShape.confettiRect,
            color: Color(0xFFFFD166),
            minSize: 3.0,
            maxSize: 6.0,
            minSpeed: 20,
            maxSpeed: 46,
            minRotationSpeed: -2.4,
            maxRotationSpeed: 2.4,
            opacity: 0.9,
          ),
          ParticleStyle(
            shape: ParticleShape.confettiRect,
            color: Color(0xFF4D96FF),
            minSize: 2.6,
            maxSize: 5.4,
            minSpeed: 18,
            maxSpeed: 42,
            minRotationSpeed: -2.0,
            maxRotationSpeed: 2.0,
            opacity: 0.85,
          ),
          ParticleStyle(
            shape: ParticleShape.confettiRect,
            color: Color(0xFFFF6FAE),
            minSize: 2.6,
            maxSize: 5.0,
            minSpeed: 18,
            maxSpeed: 40,
            minRotationSpeed: -2.0,
            maxRotationSpeed: 2.0,
            opacity: 0.85,
          ),
          ParticleStyle(
            shape: ParticleShape.sparkle,
            color: Color(0xFFFFFFFF),
            minSize: 2.0,
            maxSize: 3.6,
            minSpeed: 12,
            maxSpeed: 24,
            minRotationSpeed: -1.6,
            maxRotationSpeed: 1.6,
            opacity: 0.8,
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
