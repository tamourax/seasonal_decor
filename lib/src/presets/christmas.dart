import 'dart:ui';

import '../config/decor_config.dart';
import '../engine/particle.dart';

/// Variants for the Christmas preset.
enum ChristmasVariant {
  /// Traditional holiday palette.
  classic,
}

/// Builds the base configuration for Christmas overlays.
DecorConfig buildChristmasConfig(ChristmasVariant variant) {
  switch (variant) {
    case ChristmasVariant.classic:
      return DecorConfig(
        particleCount: 64,
        speedMultiplier: 0.95,
        spawnRate: 36,
        spawnRateScale: 1.1,
        drift: 12,
        flow: ParticleFlow.falling,
        wrapMode: DecorWrapMode.respawn,
        styles: const [
          ParticleStyle(
            shape: ParticleShape.circle,
            color: Color(0xFFFFFFFF),
            minSize: 2.0,
            maxSize: 5.5,
            minSpeed: 12,
            maxSpeed: 28,
            minRotationSpeed: -0.3,
            maxRotationSpeed: 0.3,
            opacity: 0.85,
          ),
          ParticleStyle(
            shape: ParticleShape.star,
            color: Color(0xFFE85D5D),
            minSize: 2.0,
            maxSize: 5.0,
            minSpeed: 14,
            maxSpeed: 30,
            minRotationSpeed: -0.8,
            maxRotationSpeed: 0.8,
            opacity: 0.8,
          ),
          ParticleStyle(
            shape: ParticleShape.circle,
            color: Color(0xFF2FA567),
            minSize: 1.5,
            maxSize: 4.0,
            minSpeed: 10,
            maxSpeed: 24,
            minRotationSpeed: -0.4,
            maxRotationSpeed: 0.4,
            opacity: 0.8,
          ),
        ],
        backdrop: null,
      );
  }
}
