import 'dart:ui';

import '../config/decor_config.dart';
import '../engine/particle.dart';

/// Variants for the sport event preset.
enum SportEventVariant {
  /// Global celebration palette.
  worldCup,

  /// Uses provided team colors.
  teamColors,
}

/// Builds the base configuration for sport event overlays.
DecorConfig buildSportEventConfig(
  SportEventVariant variant, {
  List<Color>? teamColors,
}) {
  final hasTeamColors =
      variant == SportEventVariant.teamColors && (teamColors?.isNotEmpty ?? false);
  final confettiColors = hasTeamColors
      ? teamColors!.take(2).toList()
      : const [Color(0xFFFFFFFF), Color(0xFFFFD166)];
  final ballPalette = hasTeamColors
      ? teamColors!
      : const [
          Color(0xFFFFFFFF),
          Color(0xFF2F3A44),
        ];
  final sparkleColor =
      hasTeamColors ? teamColors!.first : const Color(0xFFFFD166);

  final styles = <ParticleStyle>[
    for (final color in confettiColors)
      ParticleStyle(
        shape: ParticleShape.confettiRect,
        color: color,
        minSize: 2.0,
        maxSize: 3.6,
        minSpeed: 10,
        maxSpeed: 22,
        minRotationSpeed: -1.6,
        maxRotationSpeed: 1.6,
        opacity: 0.6,
      ),
    ParticleStyle(
      shape: ParticleShape.sparkle,
      color: sparkleColor,
      minSize: 2.0,
      maxSize: 3.4,
      minSpeed: 6,
      maxSpeed: 12,
      minRotationSpeed: -1.0,
      maxRotationSpeed: 1.0,
      opacity: 0.6,
    ),
    for (final color in ballPalette)
      ParticleStyle(
        shape: ParticleShape.ball,
        color: color,
        minSize: 3.8,
        maxSize: 6.6,
        minSpeed: 6,
        maxSpeed: 14,
        minRotationSpeed: -0.3,
        maxRotationSpeed: 0.3,
        opacity: 0.95,
      ),
  ];

  return DecorConfig(
    particleCount: 120,
    speedMultiplier: 0.9,
    spawnRate: 1,
    spawnRateScale: 0.2,
    drift: 10,
    flow: ParticleFlow.falling,
    wrapMode: DecorWrapMode.respawn,
    enableFireworks: false,
    enableSpotlights: true,
    activeCountCap: 6,
    styles: styles,
    backdrops: const [
      DecorBackdrop.pitch(
        color: Color(0xFF0B5D3B),
        opacity: 0.95,
        anchor: Offset(0.5, 1.0),
        sizeFactor: 0.28,
      ),
      DecorBackdrop.stadiumCrowd(
        color: Color(0xFF111827),
        opacity: 0.85,
        anchor: Offset(0.5, 0.58),
        sizeFactor: 0.18,
      ),
      DecorBackdrop.heroBall(
        color: Color(0xFFF9FAFB),
        opacity: 1.0,
        anchor: Offset(0.5, 0.55),
        sizeFactor: 0.2,
      ),
    ],
  );
}
