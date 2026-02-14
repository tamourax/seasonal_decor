import 'dart:ui';

import 'package:flutter/foundation.dart';

/// Defines the scene energy profile.
enum SeasonalMode {
  /// Calm, subtle atmospheric visuals.
  ambient,

  /// Richer and more lively visuals.
  festive,
}

/// Programmatic short-lived visual moments.
enum SeasonalMoment {
  /// Friendly celebration burst.
  greetingBurst,

  /// Positive confirmation burst.
  successBurst,

  /// High-energy firework-like burst.
  fireworksBurst,

  /// Calm sparkle pulse.
  subtleSparkle,
}

/// Extra options for a triggered [SeasonalMoment].
@immutable
class SeasonalMomentOptions {
  /// Relative strength in range 0..1.
  final double intensity;

  /// Optional normalized origin in the viewport (0..1, 0..1).
  final Offset? origin;

  /// Optional custom duration for the burst.
  final Duration? durationOverride;

  const SeasonalMomentOptions({
    this.intensity = 1.0,
    this.origin,
    this.durationOverride,
  });

  SeasonalMomentOptions copyWith({
    double? intensity,
    Offset? origin,
    Duration? durationOverride,
  }) {
    return SeasonalMomentOptions(
      intensity: intensity ?? this.intensity,
      origin: origin ?? this.origin,
      durationOverride: durationOverride ?? this.durationOverride,
    );
  }
}
