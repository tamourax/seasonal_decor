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
        particleCount: 96,
        speedMultiplier: 0.85,
        spawnRate: 48,
        spawnRateScale: 1.15,
        drift: 6,
        flow: ParticleFlow.falling,
        wrapMode: DecorWrapMode.respawn,
        styles: const [
          ParticleStyle(
            shape: ParticleShape.circle,
            color: Color(0xFFFFFFFF),
            minSize: 2.0,
            maxSize: 6.0,
            minSpeed: 8,
            maxSpeed: 18,
            minRotationSpeed: 0,
            maxRotationSpeed: 0,
            opacity: 0.9,
          ),
          ParticleStyle(
            shape: ParticleShape.circle,
            color: Color(0xFFF1F5F9),
            minSize: 1.5,
            maxSize: 4.0,
            minSpeed: 6,
            maxSpeed: 14,
            minRotationSpeed: 0,
            maxRotationSpeed: 0,
            opacity: 0.85,
          ),
          ParticleStyle(
            shape: ParticleShape.ornament,
            color: Color(0xFFD72638),
            minSize: 6.0,
            maxSize: 10.0,
            minSpeed: 8,
            maxSpeed: 16,
            minRotationSpeed: -0.25,
            maxRotationSpeed: 0.25,
            opacity: 0.95,
          ),
          ParticleStyle(
            shape: ParticleShape.gift,
            color: Color(0xFF2F9E44),
            minSize: 6.0,
            maxSize: 10.0,
            minSpeed: 8,
            maxSpeed: 14,
            minRotationSpeed: -0.2,
            maxRotationSpeed: 0.2,
            opacity: 0.9,
          ),
          ParticleStyle(
            shape: ParticleShape.gift,
            color: Color(0xFFC1121F),
            minSize: 5.5,
            maxSize: 9.0,
            minSpeed: 8,
            maxSpeed: 14,
            minRotationSpeed: -0.2,
            maxRotationSpeed: 0.2,
            opacity: 0.88,
          ),
          ParticleStyle(
            shape: ParticleShape.star,
            color: Color(0xFFFFE8A3),
            minSize: 2.0,
            maxSize: 3.5,
            minSpeed: 6,
            maxSpeed: 12,
            minRotationSpeed: -0.2,
            maxRotationSpeed: 0.2,
            opacity: 0.6,
          ),
        ],
        backdrops: const [
          DecorBackdrop.candyGarland(
            color: Color(0xFFB91C1C),
            opacity: 0.65,
            anchor: Offset(0.5, 0.12),
            sizeFactor: 0.07,
          ),
          DecorBackdrop.tree(
            color: Color(0xFF1F7A50),
            opacity: 0.85,
            anchor: Offset(0.84, 0.95),
            sizeFactor: 0.58,
          ),
        ],
      );
  }
}
