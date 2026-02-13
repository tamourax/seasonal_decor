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
        particleCount: 48,
        speedMultiplier: 0.85,
        spawnRate: 24,
        spawnRateScale: 0.8,
        drift: 8,
        flow: ParticleFlow.falling,
        wrapMode: DecorWrapMode.respawn,
        styles: const [
          ParticleStyle(
            shape: ParticleShape.lantern,
            color: Color(0xFF1E4B9A),
            minSize: 4.5,
            maxSize: 9.0,
            minSpeed: 10,
            maxSpeed: 22,
            minRotationSpeed: -0.3,
            maxRotationSpeed: 0.3,
            opacity: 0.85,
          ),
          ParticleStyle(
            shape: ParticleShape.lantern,
            color: Color(0xFFB22B2B),
            minSize: 4.0,
            maxSize: 8.0,
            minSpeed: 10,
            maxSpeed: 20,
            minRotationSpeed: -0.3,
            maxRotationSpeed: 0.3,
            opacity: 0.8,
          ),
          ParticleStyle(
            shape: ParticleShape.crescent,
            color: Color(0xFFE9F2FF),
            minSize: 2.5,
            maxSize: 4.0,
            minSpeed: 8,
            maxSpeed: 16,
            minRotationSpeed: -0.4,
            maxRotationSpeed: 0.4,
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
        particleCount: 52,
        speedMultiplier: 0.9,
        spawnRate: 26,
        spawnRateScale: 0.9,
        drift: 10,
        flow: ParticleFlow.falling,
        wrapMode: DecorWrapMode.respawn,
        styles: const [
          ParticleStyle(
            shape: ParticleShape.lantern,
            color: Color(0xFFCC3B2B),
            minSize: 5.0,
            maxSize: 10.0,
            minSpeed: 12,
            maxSpeed: 24,
            minRotationSpeed: -0.35,
            maxRotationSpeed: 0.35,
            opacity: 0.9,
          ),
          ParticleStyle(
            shape: ParticleShape.lantern,
            color: Color(0xFF1F6FB2),
            minSize: 4.5,
            maxSize: 9.0,
            minSpeed: 10,
            maxSpeed: 22,
            minRotationSpeed: -0.35,
            maxRotationSpeed: 0.35,
            opacity: 0.8,
          ),
          ParticleStyle(
            shape: ParticleShape.crescent,
            color: Color(0xFFFFE9B2),
            minSize: 2.8,
            maxSize: 4.8,
            minSpeed: 10,
            maxSpeed: 18,
            minRotationSpeed: -0.4,
            maxRotationSpeed: 0.4,
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
