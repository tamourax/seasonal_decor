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
        particleCount: 64,
        speedMultiplier: 0.85,
        spawnRate: 36,
        spawnRateScale: 1.0,
        drift: 0,
        flow: ParticleFlow.floating,
        wrapMode: DecorWrapMode.wrap,
        styles: const [
          ParticleStyle(
            shape: ParticleShape.circle,
            color: Color(0xFF1AAE9F),
            minSize: 2.0,
            maxSize: 6.0,
            minSpeed: 10,
            maxSpeed: 24,
            minRotationSpeed: -0.3,
            maxRotationSpeed: 0.3,
            opacity: 0.85,
          ),
          ParticleStyle(
            shape: ParticleShape.star,
            color: Color(0xFFF5C456),
            minSize: 2.5,
            maxSize: 5.5,
            minSpeed: 12,
            maxSpeed: 26,
            minRotationSpeed: -0.8,
            maxRotationSpeed: 0.8,
            opacity: 0.9,
          ),
          ParticleStyle(
            shape: ParticleShape.circle,
            color: Color(0xFFFA8B6C),
            minSize: 1.5,
            maxSize: 4.5,
            minSpeed: 9,
            maxSpeed: 20,
            minRotationSpeed: -0.4,
            maxRotationSpeed: 0.4,
            opacity: 0.8,
          ),
        ],
        backdrop: null,
      );
  }
}
