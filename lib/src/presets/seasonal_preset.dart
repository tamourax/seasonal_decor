import 'dart:ui';

import 'package:flutter/foundation.dart';

import '../config/decor_config.dart';
import '../config/intensity.dart';
import '../engine/particle.dart';
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

  /// Whether this preset renders nothing.
  final bool isNone;

  const SeasonalPreset._({
    required this.name,
    required this.variant,
    required this.baseConfig,
    this.isNone = false,
  });

  /// Returns a new preset with overrides applied to the base configuration.
  SeasonalPreset withOverrides({
    List<ParticleShape>? shapes,
    List<ParticleStyle>? styles,

    /// Per-shape speed multipliers for particle min/max speeds.
    Map<ParticleShape, double>? shapeSpeedMultipliers,
    DecorBackdrop? backdrop,
    List<DecorBackdrop>? backdrops,
    BackdropType? backdropType,
    Offset? backdropAnchor,
    double? backdropSizeFactor,
    Color? backdropColor,
    double? backdropOpacity,
    bool? enableFireworks,
  }) {
    var resolvedStyles = styles ?? baseConfig.styles;
    if (styles == null && shapes != null && shapes.isNotEmpty) {
      final nextStyles = <ParticleStyle>[];
      for (var i = 0; i < baseConfig.styles.length; i += 1) {
        final shape = shapes[i % shapes.length];
        nextStyles.add(baseConfig.styles[i].copyWith(shape: shape));
      }
      resolvedStyles = nextStyles;
    }

    if (shapeSpeedMultipliers != null && shapeSpeedMultipliers.isNotEmpty) {
      resolvedStyles = [
        for (final style in resolvedStyles)
          if (shapeSpeedMultipliers.containsKey(style.shape))
            style.copyWith(
              minSpeed: style.minSpeed *
                  shapeSpeedMultipliers[style.shape]!.clamp(0.0, 6.0),
              maxSpeed: style.maxSpeed *
                  shapeSpeedMultipliers[style.shape]!.clamp(0.0, 6.0),
            )
          else
            style,
      ];
    }

    DecorBackdrop? resolvedBackdrop = backdrop ?? baseConfig.backdrop;
    var resolvedBackdrops = backdrops ??
        (backdrop != null ? const <DecorBackdrop>[] : baseConfig.backdrops);

    if (backdropType != null ||
        backdropAnchor != null ||
        backdropSizeFactor != null ||
        backdropColor != null ||
        backdropOpacity != null) {
      if (resolvedBackdrops.isNotEmpty) {
        resolvedBackdrops = [
          for (final item in resolvedBackdrops)
            item.copyWith(
              type: backdropType,
              anchor: backdropAnchor,
              sizeFactor: backdropSizeFactor,
              color: backdropColor,
              opacity: backdropOpacity,
            ),
        ];
      } else if (resolvedBackdrop != null) {
        resolvedBackdrop = resolvedBackdrop.copyWith(
          type: backdropType,
          anchor: backdropAnchor,
          sizeFactor: backdropSizeFactor,
          color: backdropColor,
          opacity: backdropOpacity,
        );
      }
    }

    final updatedConfig = baseConfig.copyWith(
      styles: resolvedStyles,
      backdrop: resolvedBackdrop,
      backdrops: resolvedBackdrops,
      enableFireworks: enableFireworks,
    );

    return SeasonalPreset._(
      name: name,
      variant: variant,
      baseConfig: updatedConfig,
      isNone: isNone,
    );
  }

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

  /// No decoration preset (renders only the child).
  factory SeasonalPreset.none() {
    return SeasonalPreset._(
      name: 'None',
      variant: 'none',
      baseConfig: _emptyConfig,
      isNone: true,
    );
  }

  /// Eid preset.
  factory SeasonalPreset.eid({EidVariant? variant}) {
    final resolvedVariant = variant ?? EidVariant.fitr;
    final normalizedVariant = resolvedVariant == EidVariant.classic
        ? EidVariant.fitr
        : resolvedVariant;
    final displayName =
        normalizedVariant == EidVariant.adha ? 'Eid al-Adha' : 'Eid al-Fitr';
    return SeasonalPreset._(
      name: displayName,
      variant: normalizedVariant.name,
      baseConfig: buildEidConfig(normalizedVariant),
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

const ParticleStyle _emptyStyle = ParticleStyle(
  shape: ParticleShape.circle,
  color: Color(0x00000000),
  minSize: 1,
  maxSize: 1,
  minSpeed: 0,
  maxSpeed: 0,
  minRotationSpeed: 0,
  maxRotationSpeed: 0,
  opacity: 0,
);

const DecorConfig _emptyConfig = DecorConfig(
  particleCount: 1,
  speedMultiplier: 0,
  spawnRate: 0,
  spawnRateScale: 0,
  drift: 0,
  flow: ParticleFlow.falling,
  wrapMode: DecorWrapMode.respawn,
  styles: [_emptyStyle],
);
