import 'dart:ui';

import '../config/decor_config.dart';
import '../engine/particle.dart';

/// Variants for the Halloween preset.
enum HalloweenVariant {
  /// Bats with spooky mist.
  spooky,

  /// Pumpkins with warm sparkles.
  pumpkin,
}

/// Builds the base configuration for Halloween overlays.
DecorConfig buildHalloweenConfig(HalloweenVariant variant) {
  const moonBackdrop = DecorBackdrop.crescent(
    color: Color(0xFFFFF3C1),
    opacity: 0.18,
    anchor: Offset(0.82, 0.2),
    sizeFactor: 0.23,
  );

  switch (variant) {
    case HalloweenVariant.pumpkin:
      return DecorConfig(
        particleCount: 84,
        speedMultiplier: 0.7,
        spawnRate: 28,
        spawnRateScale: 0.5,
        drift: 8,
        flow: ParticleFlow.floating,
        wrapMode: DecorWrapMode.wrap,
        styles: const [
          ParticleStyle(
            shape: ParticleShape.pumpkin,
            color: Color(0xFFF57C00),
            minSize: 4.0,
            maxSize: 8.5,
            minSpeed: 5,
            maxSpeed: 12,
            minRotationSpeed: -0.2,
            maxRotationSpeed: 0.2,
            opacity: 0.9,
          ),
          ParticleStyle(
            shape: ParticleShape.pumpkin,
            color: Color(0xFFFFA726),
            minSize: 3.8,
            maxSize: 7.5,
            minSpeed: 5,
            maxSpeed: 10,
            minRotationSpeed: -0.2,
            maxRotationSpeed: 0.2,
            opacity: 0.85,
          ),
          ParticleStyle(
            shape: ParticleShape.sparkle,
            color: Color(0xFFFFE0B2),
            minSize: 2.0,
            maxSize: 3.2,
            minSpeed: 6,
            maxSpeed: 14,
            minRotationSpeed: -1.0,
            maxRotationSpeed: 1.0,
            opacity: 0.6,
          ),
          ParticleStyle(
            shape: ParticleShape.circle,
            color: Color(0xFF4B5563),
            minSize: 6.0,
            maxSize: 12.0,
            minSpeed: 3,
            maxSpeed: 7,
            minRotationSpeed: 0,
            maxRotationSpeed: 0,
            opacity: 0.25,
          ),
        ],
        backdrops: const [moonBackdrop],
      );
    case HalloweenVariant.spooky:
      return DecorConfig(
        particleCount: 80,
        speedMultiplier: 0.75,
        spawnRate: 26,
        spawnRateScale: 0.45,
        drift: 8,
        flow: ParticleFlow.floating,
        wrapMode: DecorWrapMode.wrap,
        styles: const [
          ParticleStyle(
            shape: ParticleShape.bat,
            color: Color(0xFF1F1733),
            minSize: 4.5,
            maxSize: 9.0,
            minSpeed: 5,
            maxSpeed: 12,
            minRotationSpeed: -0.3,
            maxRotationSpeed: 0.3,
            opacity: 0.9,
          ),
          ParticleStyle(
            shape: ParticleShape.bat,
            color: Color(0xFF2F224A),
            minSize: 4.0,
            maxSize: 8.0,
            minSpeed: 5,
            maxSpeed: 11,
            minRotationSpeed: -0.3,
            maxRotationSpeed: 0.3,
            opacity: 0.85,
          ),
          ParticleStyle(
            shape: ParticleShape.circle,
            color: Color(0xFF4B5563),
            minSize: 6.0,
            maxSize: 14.0,
            minSpeed: 3,
            maxSpeed: 7,
            minRotationSpeed: 0,
            maxRotationSpeed: 0,
            opacity: 0.22,
          ),
        ],
        backdrops: const [moonBackdrop],
      );
  }
}
