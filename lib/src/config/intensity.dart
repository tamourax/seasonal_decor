import 'package:flutter/foundation.dart';

/// Defines how dense and fast the decorative particles are.
enum DecorIntensity {
  /// Subtle decoration with fewer particles.
  low,

  /// Balanced density and speed.
  medium,

  /// Rich decoration with higher density and speed.
  high,

  /// Very rich decoration for festive screens.
  extraHigh,

  /// Maximum density and speed profile.
  max,
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
      case DecorIntensity.extraHigh:
        return const DecorIntensityProfile(
          particleCount: 180,
          speedMultiplier: 1.7,
          spawnRate: 105,
        );
      case DecorIntensity.max:
        return const DecorIntensityProfile(
          particleCount: 260,
          speedMultiplier: 2.1,
          spawnRate: 155,
        );
    }
  }
}
