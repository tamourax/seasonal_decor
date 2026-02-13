import 'dart:ui';

import 'package:flutter/foundation.dart';

import '../config/decor_config.dart';
import '../config/intensity.dart';
import 'christmas.dart';
import 'eid.dart';
import 'halloween.dart';
import 'new_year.dart';
import 'ramadan.dart';
import 'sport_event.dart';
import 'valentine.dart';

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
    final resolved = baseConfig.copyWith(
      particleCount: profile.particleCount,
      speedMultiplier: baseConfig.speedMultiplier * profile.speedMultiplier,
      spawnRate: profile.spawnRate * baseConfig.spawnRateScale,
    );
    if (!baseConfig.enableFireworks) {
      return resolved;
    }
    final burstScale = profile.speedMultiplier;
    return resolved.copyWith(
      rocketSpawnRate: baseConfig.rocketSpawnRate * profile.speedMultiplier,
      sparksPerBurstMin: (baseConfig.sparksPerBurstMin * burstScale)
          .round()
          .clamp(6, 120)
          .toInt(),
      sparksPerBurstMax: (baseConfig.sparksPerBurstMax * burstScale)
          .round()
          .clamp(8, 160)
          .toInt(),
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

  /// New Year preset.
  factory SeasonalPreset.newYear({NewYearVariant? variant}) {
    final resolvedVariant = variant ?? NewYearVariant.fireworks;
    return SeasonalPreset._(
      name: 'New Year',
      variant: resolvedVariant.name,
      baseConfig: buildNewYearConfig(resolvedVariant),
    );
  }

  /// Valentine preset.
  factory SeasonalPreset.valentine({ValentineVariant? variant}) {
    final resolvedVariant = variant ?? ValentineVariant.hearts;
    return SeasonalPreset._(
      name: 'Valentine',
      variant: resolvedVariant.name,
      baseConfig: buildValentineConfig(resolvedVariant),
    );
  }

  /// Halloween preset.
  factory SeasonalPreset.halloween({HalloweenVariant? variant}) {
    final resolvedVariant = variant ?? HalloweenVariant.spooky;
    return SeasonalPreset._(
      name: 'Halloween',
      variant: resolvedVariant.name,
      baseConfig: buildHalloweenConfig(resolvedVariant),
    );
  }

  /// Sport event preset.
  factory SeasonalPreset.sportEvent({
    SportEventVariant? variant,
    List<Color>? teamColors,
  }) {
    final resolvedVariant = variant ??
        (teamColors == null
            ? SportEventVariant.worldCup
            : SportEventVariant.teamColors);
    return SeasonalPreset._(
      name: 'Sport Event',
      variant: resolvedVariant.name,
      baseConfig: buildSportEventConfig(
        resolvedVariant,
        teamColors: teamColors,
      ),
    );
  }
}
