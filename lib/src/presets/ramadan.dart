import 'dart:ui';

import '../config/decor_config.dart';
import '../engine/particle.dart';

/// Variants for the Ramadan preset.
enum RamadanVariant {
  /// Classic golden tones.
  classic,

  /// Cooler night palette with softer motion.
  night,
}

/// Builds the base configuration for Ramadan overlays.
DecorConfig buildRamadanConfig(RamadanVariant variant) {
  switch (variant) {
    case RamadanVariant.night:
      return DecorConfig(
        particleCount: 64,
        speedMultiplier: 0.8,
        spawnRate: 36,
        spawnRateScale: 0.9,
        drift: 10,
        flow: ParticleFlow.falling,
        wrapMode: DecorWrapMode.respawn,
        styles: const [
          ParticleStyle(
            shape: ParticleShape.star,
            color: Color(0xFFB7C7FF),
            minSize: 2.0,
            maxSize: 4.5,
            minSpeed: 12,
            maxSpeed: 26,
            minRotationSpeed: -0.8,
            maxRotationSpeed: 0.8,
            opacity: 0.85,
          ),
          ParticleStyle(
            shape: ParticleShape.circle,
            color: Color(0xFF2C9EA8),
            minSize: 1.5,
            maxSize: 4.0,
            minSpeed: 10,
            maxSpeed: 22,
            minRotationSpeed: -0.5,
            maxRotationSpeed: 0.5,
            opacity: 0.8,
          ),
          ParticleStyle(
            shape: ParticleShape.crescent,
            color: Color(0xFFE9F2FF),
            minSize: 3.0,
            maxSize: 6.0,
            minSpeed: 12,
            maxSpeed: 24,
            minRotationSpeed: -0.6,
            maxRotationSpeed: 0.6,
            opacity: 0.7,
          ),
        ],
        backdrop: const DecorBackdrop.crescent(
          color: Color(0xFFCAD6FF),
          opacity: 0.32,
          anchor: Offset(0.82, 0.22),
          sizeFactor: 0.24,
        ),
      );
    case RamadanVariant.classic:
      return DecorConfig(
        particleCount: 64,
        speedMultiplier: 0.9,
        spawnRate: 36,
        spawnRateScale: 1.0,
        drift: 14,
        flow: ParticleFlow.falling,
        wrapMode: DecorWrapMode.respawn,
        styles: const [
          ParticleStyle(
            shape: ParticleShape.star,
            color: Color(0xFFF6D365),
            minSize: 2.0,
            maxSize: 5.0,
            minSpeed: 14,
            maxSpeed: 30,
            minRotationSpeed: -0.9,
            maxRotationSpeed: 0.9,
            opacity: 0.9,
          ),
          ParticleStyle(
            shape: ParticleShape.circle,
            color: Color(0xFF1BB8A3),
            minSize: 1.5,
            maxSize: 4.5,
            minSpeed: 12,
            maxSpeed: 26,
            minRotationSpeed: -0.5,
            maxRotationSpeed: 0.5,
            opacity: 0.8,
          ),
          ParticleStyle(
            shape: ParticleShape.crescent,
            color: Color(0xFFFFE9B2),
            minSize: 3.0,
            maxSize: 6.5,
            minSpeed: 12,
            maxSpeed: 28,
            minRotationSpeed: -0.6,
            maxRotationSpeed: 0.6,
            opacity: 0.8,
          ),
        ],
        backdrop: const DecorBackdrop.crescent(
          color: Color(0xFFFFE1A1),
          opacity: 0.35,
          anchor: Offset(0.8, 0.2),
          sizeFactor: 0.26,
        ),
      );
  }
}
