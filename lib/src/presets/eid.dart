import 'dart:ui';

import '../config/decor_config.dart';
import '../engine/particle.dart';

/// Variants for the Eid preset.
enum EidVariant {
  /// Bright celebratory palette.
  classic,
}

/// Builds the base configuration for Eid overlays.
DecorConfig buildEidConfig(EidVariant variant) {
  switch (variant) {
    case EidVariant.classic:
      return DecorConfig(
        particleCount: 120,
        speedMultiplier: 1.0,
        spawnRate: 1,
        spawnRateScale: 0.4,
        drift: 0,
        flow: ParticleFlow.falling,
        wrapMode: DecorWrapMode.respawn,
        enableFireworks: true,
        rocketsMax: 4,
        rocketSpawnRate: 1.4,
        sparksPerBurstMin: 24,
        sparksPerBurstMax: 42,
        burstHeightFactor: 0.18,
        gravityY: 90,
        rocketMinSpeed: 230,
        rocketMaxSpeed: 300,
        rocketLifeMin: 0.9,
        rocketLifeMax: 1.4,
        rocketSize: 3.2,
        rocketDrift: 28,
        sparkMinSpeed: 90,
        sparkMaxSpeed: 220,
        sparkLifeMin: 0.7,
        sparkLifeMax: 1.25,
        sparkMinSize: 6.0,
        sparkMaxSize: 13.0,
        styles: const [
          ParticleStyle(
            shape: ParticleShape.circle,
            color: Color(0xFFF9C74F),
            minSize: 2.0,
            maxSize: 4.0,
            minSpeed: 0,
            maxSpeed: 0,
            minRotationSpeed: 0,
            maxRotationSpeed: 0,
            opacity: 0.95,
          ),
          ParticleStyle(
            shape: ParticleShape.circle,
            color: Color(0xFFF94144),
            minSize: 2.0,
            maxSize: 4.0,
            minSpeed: 0,
            maxSpeed: 0,
            minRotationSpeed: 0,
            maxRotationSpeed: 0,
            opacity: 0.9,
          ),
          ParticleStyle(
            shape: ParticleShape.circle,
            color: Color(0xFF4D96FF),
            minSize: 2.0,
            maxSize: 4.0,
            minSpeed: 0,
            maxSpeed: 0,
            minRotationSpeed: 0,
            maxRotationSpeed: 0,
            opacity: 0.9,
          ),
          ParticleStyle(
            shape: ParticleShape.circle,
            color: Color(0xFF6A4C93),
            minSize: 2.0,
            maxSize: 4.0,
            minSpeed: 0,
            maxSpeed: 0,
            minRotationSpeed: 0,
            maxRotationSpeed: 0,
            opacity: 0.9,
          ),
          ParticleStyle(
            shape: ParticleShape.circle,
            color: Color(0xFF43AA8B),
            minSize: 2.0,
            maxSize: 4.0,
            minSpeed: 0,
            maxSpeed: 0,
            minRotationSpeed: 0,
            maxRotationSpeed: 0,
            opacity: 0.9,
          ),
        ],
        backdrop: null,
      );
  }
}
