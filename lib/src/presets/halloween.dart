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
        particleCount: 82,
        speedMultiplier: 0.7,
        spawnRate: 26,
        spawnRateScale: 0.45,
        drift: 7,
        flow: ParticleFlow.floating,
        wrapMode: DecorWrapMode.wrap,
        styles: const [
          ParticleStyle(
            shape: ParticleShape.pumpkin,
            color: Color(0xFFF57C00),
            minSize: 4.0,
            maxSize: 8.0,
            minSpeed: 5,
            maxSpeed: 11,
            minRotationSpeed: -0.2,
            maxRotationSpeed: 0.2,
            opacity: 0.9,
          ),
          ParticleStyle(
            shape: ParticleShape.pumpkin,
            color: Color(0xFFFFA726),
            minSize: 3.8,
            maxSize: 7.2,
            minSpeed: 5,
            maxSpeed: 10,
            minRotationSpeed: -0.2,
            maxRotationSpeed: 0.2,
            opacity: 0.85,
          ),
          ParticleStyle(
            shape: ParticleShape.sparkle,
            color: Color(0xFFFFD59E),
            minSize: 2.0,
            maxSize: 3.2,
            minSpeed: 6,
            maxSpeed: 12,
            minRotationSpeed: -1.1,
            maxRotationSpeed: 1.1,
            opacity: 0.65,
          ),
        ],
        backdrops: const [moonBackdrop],
      );
    case HalloweenVariant.spooky:
      return DecorConfig(
        particleCount: 78,
        speedMultiplier: 0.7,
        spawnRate: 24,
        spawnRateScale: 0.4,
        drift: 6,
        flow: ParticleFlow.floating,
        wrapMode: DecorWrapMode.wrap,
        styles: const [
          ParticleStyle(
            shape: ParticleShape.bat,
            color: Color(0xFF1A1127),
            minSize: 4.2,
            maxSize: 8.5,
            minSpeed: 5,
            maxSpeed: 11,
            minRotationSpeed: -0.25,
            maxRotationSpeed: 0.25,
            opacity: 0.92,
          ),
          ParticleStyle(
            shape: ParticleShape.bat,
            color: Color(0xFF2A1B3D),
            minSize: 4.0,
            maxSize: 8.0,
            minSpeed: 5,
            maxSpeed: 10,
            minRotationSpeed: -0.25,
            maxRotationSpeed: 0.25,
            opacity: 0.86,
          ),
          ParticleStyle(
            shape: ParticleShape.sparkle,
            color: Color(0xFFB388FF),
            minSize: 2.0,
            maxSize: 3.4,
            minSpeed: 6,
            maxSpeed: 12,
            minRotationSpeed: -1.2,
            maxRotationSpeed: 1.2,
            opacity: 0.35,
          ),
          ParticleStyle(
            shape: ParticleShape.circle,
            color: Color(0xFF3A2B52),
            minSize: 4.0,
            maxSize: 8.0,
            minSpeed: 2,
            maxSpeed: 5,
            minRotationSpeed: 0,
            maxRotationSpeed: 0,
            opacity: 0.06,
          ),
        ],
        backdrops: const [moonBackdrop],
      );
  }
}
