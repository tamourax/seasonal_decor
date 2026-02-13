import 'dart:ui';

import '../config/decor_config.dart';
import '../engine/particle.dart';

/// Variants for the Valentine preset.
enum ValentineVariant {
  /// Floating hearts with sparkles.
  hearts,

  /// Softer minimal palette with fewer sparkles.
  minimal,
}

/// Builds the base configuration for Valentine overlays.
DecorConfig buildValentineConfig(ValentineVariant variant) {
  switch (variant) {
    case ValentineVariant.minimal:
      return DecorConfig(
        particleCount: 72,
        speedMultiplier: 0.6,
        spawnRate: 24,
        spawnRateScale: 0.3,
        drift: 6,
        flow: ParticleFlow.floating,
        wrapMode: DecorWrapMode.wrap,
        styles: const [
          ParticleStyle(
            shape: ParticleShape.heart,
            color: Color(0xFFF48FB1),
            minSize: 4.0,
            maxSize: 7.0,
            minSpeed: 6,
            maxSpeed: 14,
            minRotationSpeed: -0.4,
            maxRotationSpeed: 0.4,
            opacity: 0.85,
          ),
          ParticleStyle(
            shape: ParticleShape.heart,
            color: Color(0xFFF8BBD0),
            minSize: 3.8,
            maxSize: 6.5,
            minSpeed: 6,
            maxSpeed: 12,
            minRotationSpeed: -0.35,
            maxRotationSpeed: 0.35,
            opacity: 0.8,
          ),
          ParticleStyle(
            shape: ParticleShape.sparkle,
            color: Color(0xFFFFF1F4),
            minSize: 1.8,
            maxSize: 3.0,
            minSpeed: 8,
            maxSpeed: 16,
            minRotationSpeed: -1.0,
            maxRotationSpeed: 1.0,
            opacity: 0.65,
          ),
        ],
      );
    case ValentineVariant.hearts:
      return DecorConfig(
        particleCount: 90,
        speedMultiplier: 0.7,
        spawnRate: 28,
        spawnRateScale: 0.45,
        drift: 7,
        flow: ParticleFlow.floating,
        wrapMode: DecorWrapMode.wrap,
        styles: const [
          ParticleStyle(
            shape: ParticleShape.heart,
            color: Color(0xFFF06292),
            minSize: 4.5,
            maxSize: 9.0,
            minSpeed: 6,
            maxSpeed: 16,
            minRotationSpeed: -0.5,
            maxRotationSpeed: 0.5,
            opacity: 0.9,
          ),
          ParticleStyle(
            shape: ParticleShape.heart,
            color: Color(0xFFE53935),
            minSize: 4.0,
            maxSize: 8.0,
            minSpeed: 6,
            maxSpeed: 14,
            minRotationSpeed: -0.45,
            maxRotationSpeed: 0.45,
            opacity: 0.85,
          ),
          ParticleStyle(
            shape: ParticleShape.sparkle,
            color: Color(0xFFFFF5F7),
            minSize: 2.0,
            maxSize: 3.6,
            minSpeed: 8,
            maxSpeed: 18,
            minRotationSpeed: -1.2,
            maxRotationSpeed: 1.2,
            opacity: 0.7,
          ),
        ],
      );
  }
}
