import 'package:flutter/foundation.dart';

/// Defines how dense and fast the decorative particles are.
enum DecorIntensity {
  /// Subtle decoration with fewer particles.
  low,

  /// Balanced density and speed.
  medium,

  /// Rich decoration with higher density and speed.
  high,
}

/// Concrete values derived from a [DecorIntensity].
@immutable
class DecorIntensityProfile {
  /// Maximum particle count before adaptive density scaling.
  final int particleCount;

  /// Global speed multiplier applied to particle velocity.
  final double speedMultiplier;

  /// Respawn budget per second for out-of-bounds particles.
  final double spawnRate;

  const DecorIntensityProfile({
    required this.particleCount,
    required this.speedMultiplier,
    required this.spawnRate,
  });
}

/// Convenience accessors for [DecorIntensity].
extension DecorIntensityX on DecorIntensity {
  /// Returns the performance profile for this intensity.
  DecorIntensityProfile get profile {
    switch (this) {
      case DecorIntensity.low:
        return const DecorIntensityProfile(
          particleCount: 32,
          speedMultiplier: 0.7,
          spawnRate: 18,
        );
      case DecorIntensity.medium:
        return const DecorIntensityProfile(
          particleCount: 64,
          speedMultiplier: 1.0,
          spawnRate: 36,
        );
      case DecorIntensity.high:
        return const DecorIntensityProfile(
          particleCount: 120,
          speedMultiplier: 1.35,
          spawnRate: 72,
        );
    }
  }
}
