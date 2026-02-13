import 'package:flutter/foundation.dart';

import '../config/decor_config.dart';
import '../config/intensity.dart';
import 'christmas.dart';
import 'eid.dart';
import 'ramadan.dart';

/// A ready-to-use decorative preset.
@immutable
class SeasonalPreset {
  /// Display name.
  final String name;

  /// Variant label, if any.
  final String variant;

  /// Base configuration before intensity scaling.
  final DecorConfig baseConfig;

  const SeasonalPreset._({
    required this.name,
    required this.variant,
    required this.baseConfig,
  });

  /// Returns the fully resolved configuration for the given [intensity].
  DecorConfig resolve(DecorIntensity intensity) {
    final profile = intensity.profile;
    return baseConfig.copyWith(
      particleCount: profile.particleCount,
      speedMultiplier: baseConfig.speedMultiplier * profile.speedMultiplier,
      spawnRate: profile.spawnRate * baseConfig.spawnRateScale,
    );
  }

  /// Ramadan preset.
  factory SeasonalPreset.ramadan({RamadanVariant? variant}) {
    final resolvedVariant = variant ?? RamadanVariant.classic;
    return SeasonalPreset._(
      name: 'Ramadan',
      variant: resolvedVariant.name,
      baseConfig: buildRamadanConfig(resolvedVariant),
    );
  }

  /// Eid preset.
  factory SeasonalPreset.eid({EidVariant? variant}) {
    final resolvedVariant = variant ?? EidVariant.classic;
    return SeasonalPreset._(
      name: 'Eid',
      variant: resolvedVariant.name,
      baseConfig: buildEidConfig(resolvedVariant),
    );
  }

  /// Christmas preset.
  factory SeasonalPreset.christmas({ChristmasVariant? variant}) {
    final resolvedVariant = variant ?? ChristmasVariant.classic;
    return SeasonalPreset._(
      name: 'Christmas',
      variant: resolvedVariant.name,
      baseConfig: buildChristmasConfig(resolvedVariant),
    );
  }
}
