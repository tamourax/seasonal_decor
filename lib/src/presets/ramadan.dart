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
        particleCount: 46,
        speedMultiplier: 0.75,
        spawnRate: 20,
        spawnRateScale: 0.8,
        drift: 6,
        flow: ParticleFlow.falling,
        wrapMode: DecorWrapMode.respawn,
        styles: const [
          ParticleStyle(
            shape: ParticleShape.lantern,
            color: Color(0xFF2E5FAE),
            minSize: 4.2,
            maxSize: 8.6,
            minSpeed: 8,
            maxSpeed: 18,
            minRotationSpeed: -0.3,
            maxRotationSpeed: 0.3,
            opacity: 0.85,
          ),
          ParticleStyle(
            shape: ParticleShape.lantern,
            color: Color(0xFF9B3A45),
            minSize: 3.8,
            maxSize: 7.6,
            minSpeed: 8,
            maxSpeed: 17,
            minRotationSpeed: -0.3,
            maxRotationSpeed: 0.3,
            opacity: 0.76,
          ),
          ParticleStyle(
            shape: ParticleShape.crescent,
            color: Color(0xFFE9F2FF),
            minSize: 2.3,
            maxSize: 3.8,
            minSpeed: 6,
            maxSpeed: 12,
            minRotationSpeed: -0.35,
            maxRotationSpeed: 0.35,
            opacity: 0.62,
          ),
          ParticleStyle(
            shape: ParticleShape.sparkle,
            color: Color(0xFFF4E6B2),
            minSize: 1.4,
            maxSize: 2.6,
            minSpeed: 4,
            maxSpeed: 8,
            minRotationSpeed: -0.25,
            maxRotationSpeed: 0.25,
            opacity: 0.45,
          ),
        ],
        backdrops: const [
          DecorBackdrop.bunting(
            layer: BackdropLayer.decorative,
            color: Color(0xFFC9DBF7),
            opacity: 0.14,
            anchor: Offset(0.5, 0.1),
            sizeFactor: 0.035,
          ),
          DecorBackdrop.crescent(
            layer: BackdropLayer.background,
            color: Color(0xFFE6EEFF),
            opacity: 0.26,
            anchor: Offset(0.84, 0.2),
            sizeFactor: 0.2,
          ),
          DecorBackdrop.mosque(
            layer: BackdropLayer.background,
            color: Color(0xFF9CB2D9),
            opacity: 0.12,
            anchor: Offset(0.5, 0.8),
            sizeFactor: 0.33,
          ),
        ],
      );
    case RamadanVariant.classic:
      return DecorConfig(
        particleCount: 58,
        speedMultiplier: 0.78,
        spawnRate: 22,
        spawnRateScale: 0.9,
        drift: 7,
        flow: ParticleFlow.falling,
        wrapMode: DecorWrapMode.respawn,
        styles: const [
          ParticleStyle(
            shape: ParticleShape.lantern,
            color: Color(0xFFD8513D),
            minSize: 4.8,
            maxSize: 9.2,
            minSpeed: 9,
            maxSpeed: 19,
            minRotationSpeed: -0.35,
            maxRotationSpeed: 0.35,
            opacity: 0.88,
          ),
          ParticleStyle(
            shape: ParticleShape.lantern,
            color: Color(0xFF2C7BAA),
            minSize: 4.2,
            maxSize: 8.2,
            minSpeed: 8,
            maxSpeed: 18,
            minRotationSpeed: -0.35,
            maxRotationSpeed: 0.35,
            opacity: 0.78,
          ),
          ParticleStyle(
            shape: ParticleShape.crescent,
            color: Color(0xFFFFE6A3),
            minSize: 2.6,
            maxSize: 4.2,
            minSpeed: 7,
            maxSpeed: 13,
            minRotationSpeed: -0.35,
            maxRotationSpeed: 0.35,
            opacity: 0.64,
          ),
          ParticleStyle(
            shape: ParticleShape.sparkle,
            color: Color(0xFFFDE7A1),
            minSize: 1.4,
            maxSize: 2.8,
            minSpeed: 4,
            maxSpeed: 8,
            minRotationSpeed: -0.25,
            maxRotationSpeed: 0.25,
            opacity: 0.48,
          ),
        ],
        backdrops: const [
          DecorBackdrop.bunting(
            layer: BackdropLayer.decorative,
            color: Color(0xFFF2D8A5),
            opacity: 0.22,
            anchor: Offset(0.5, 0.11),
            sizeFactor: 0.04,
          ),
          DecorBackdrop.crescent(
            layer: BackdropLayer.background,
            color: Color(0xFFFFE2A6),
            opacity: 0.24,
            anchor: Offset(0.84, 0.2),
            sizeFactor: 0.2,
          ),
          DecorBackdrop.mosque(
            layer: BackdropLayer.background,
            color: Color(0xFFB9C7E0),
            opacity: 0.16,
            anchor: Offset(0.5, 0.8),
            sizeFactor: 0.34,
          ),
        ],
      );
  }
}
